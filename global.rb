require 'config'
require 'sqlite3'

@db = nil
@transaction_open = false

def connect_to_db
  return if @db
  fn = CONFIG[:sqlite_file]
  if File.exist?(fn)
    @db = SQLite3::Database.new(fn)
    return
  end
  @db = SQLite3::Database.new(fn)
  sql = <<EOF
CREATE TABLE IF NOT EXISTS nodes (
  ipv4 INT NOT NULL,
  port INT NOT NULL DEFAULT 9301,
  last_check INT DEFAULT NULL,
  accepts_incoming INT NOT NULL DEFAULT 0,
  version INT DEFAULT NULL,
  subversion CHARACTER VARYING DEFAULT NULL,
  last_seen INT NOT NULL,
  first_up INT DEFAULT NULL,
  PRIMARY KEY (ipv4,port)
);
CREATE INDEX IF NOT EXISTS last_seen ON nodes(last_seen);
CREATE INDEX IF NOT EXISTS last_check ON nodes(last_check);
CREATE INDEX IF NOT EXISTS ipv4_port ON nodes(ipv4, port);
EOF
  @db.execute(sql) do |data|
p data
  end
end

def start_db_transaction
  connect_to_db
  return if @transaction_open
  @db.transaction
  @transaction_open = true
end

def commit_db_transaction
  connect_to_db
  return unless @transaction_open
  @db.commit
  @transaction_open = false
end

def ip2long(ip)
  ip.split('.').map(&:to_i).pack('C*').unpack('N')[0]
end

def add_node_to_dns(ip, port, version, subversion = '')
  connect_to_db
  if ip2long(ip) != 0 && port != 0 && version > 0
    now = Time.now.to_i
    sql = <<EOF
INSERT INTO nodes (ipv4, port, accepts_incoming, last_check, version,
  subversion, last_seen, first_up) VALUES (?, ?, 1, ?, ?, ?, ?, ?);
EOF
    params = [ip2long(ip), port, now, version, subversion, now, now]
    begin
      @db.execute(sql, params) do |data|
p data
      end
    rescue => x
p x
    end
    sql = <<EOF
UPDATE nodes SET
  accepts_incoming = 1, last_check = ?, version = ?, subversion = ?,
  last_seen = ?, first_up = CASE WHEN first_up > 0 THEN first_up ELSE ? END
  WHERE ipv4 = ? AND port = ?;
EOF
    params = [now, version, subversion, now, now, ip2long(ip), port]
    @db.execute(sql, params) do |data|
p data
    end
  end
end

def add_untested_node(ip, port)
  connect_to_db
  if ip2long(ip) != 0 && port != 0
    now = Time.now.to_i
    sql = <<EOF
INSERT INTO nodes (ipv4, port, last_seen) VALUES (?, ?, ?);
EOF
    params = [ip2long(ip), port, now]
p params
    begin
      @db.execute(sql, params) do |data|
p data
      end
    rescue => x
p x
    end
    sql = <<EOF
UPDATE nodes SET last_seen = ? WHERE ipv4 = ? AND port = ?;
EOF
    params = [now, ip2long(ip), port]
    @db.execute(sql, params) do |data|
p data
    end
  end
end

def remove_node(ip, port)
  connect_to_db
  if ip2long(ip) != 0 && port != 0
    now = Time.now.to_i
    sql = <<EOF
UPDATE nodes SET
  last_check = ?, accepts_incoming = 0 WHERE ipv4 = ? AND port = ?;
EOF
    params = [now, ip2long(ip), port]
    @db.execute(sql, params) do |data|
p data
    end
  end
end

def scan_node(ip, port)
  # TODO
  exec("nohup ./bitcoin-scan.rb #{long2ip(ip)}:#{port}")
end

def query_unchecked
  # TODO execute? query? prepare?
  @db.query("SELECT ipv4, port FROM nodes WHERE last_check IS NULL;")
end

def query_unaccepting
  now = Time.now.to_i
  check_time = now - CONFIG[:unaccep_check_rate]
  if CONFIG[:min_up_time_to_check] != 0
    up_time = now - CONFIG[:min_up_time_to_check]
    sql = <<EOF
SELECT ipv4, port FROM nodes WHERE last_check < ? AND
  accepts_incoming = 0 AND first_up <= ? ORDER BY last_check ASC;
EOF
    # TODO execute? query? prepare?
    @db.query(sql, [check_time, up_time])
  else
    sql = <<EOF
SELECT ipv4, port FROM nodes WHERE last_check < ? AND
  accepts_incoming = 0 ORDER BY last_check ASC;
EOF
    # TODO execute? query? prepare?
    @db.query(sql, [check_time])
  end
end

def query_accepting
  now = Time.now.to_i
  current_time = now - CONFIG[:accep_check_rate]
  sql = <<EOF
SELECT ipv4, port FROM nodes WHERE last_check < ? AND
  accepts_incoming = 1 ORDER BY last_check ASC;
EOF
  @db.query(sql, [current_time])
end

def get_count_of_results(result)
  count(result)
end

def get_assoc_result_row(&result) # TODO
  array_shift(result)
end

def prune_nodes
  now = Time.now.to_i
  current_time = now - CONFIG[:purge_age]
  sql = <<EOF
DELETE FROM nodes WHERE last_seen < ? AND accepts_incoming = 0;
EOF
  @db.execute(sql, [current_time])
end

def get_list_of_nodes_for_dns
  sql = <<EOF
SELECT ipv4 FROM nodes WHERE
  accepts_incoming = 1 AND port = 9301 AND version >= ?
  AND subversion IN (?) ORDER BY last_check DESC LIMIT 20;
EOF
  @db.query(sql, [CONFIG[:min_version], CONFIG[:subversions]])
end

def query_version_count
  @db.execute <<EOF
SELECT COUNT(*), subversion AS version FROM nodes WHERE
  accepts_incoming = 1 AND port = 9301 GROUP BY subversion ORDER BY subversion;
EOF
end

def query_dns_total
# TODO
=begin
  sql = <<EOF
SELECT COUNT(*) FROM nodes WHERE accepts_incoming = 1 AND 
  port = 9301 AND version >= ? AND subversion IN (?);
EOF
  @db.get_first_value(sql, [CONFIG[:min_version], CONFIG[:subversions]])
=end
  sql = <<EOF
SELECT COUNT(*) FROM nodes WHERE accepts_incoming = 1 AND 
  port = 9301 AND version >= ?;
EOF
  @db.get_first_value(sql, [CONFIG[:min_version]])
end

def query_total
  @db.get_first_value("SELECT COUNT(*) FROM nodes;")
end
