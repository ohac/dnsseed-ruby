CONFIG = {
  :sqlite_file => "sakuracoin.sqlite",
  :bind_header_file => "./db.dnsseed.sakuracoin.info.header",
  :bind_record_file => "./db.dnsseed.sakuracoin.info",
  :domain_name => "sakuracoin.info",
  :record_ttl => "60",
  :min_version => 70002,
  :subversions => "(" +
      [
        "'/Satoshi:0.8.5.1/'",
        "'/Satoshi:0.8.5.2/'",
        "'/Satoshi:0.8.5.3/'",
        "'/Satoshi:0.8.6.1/'",
      ].join(", ") +
      ")",
  :connect_timeout => 7,
  :unaccep_check_rate => 36 * 60 * 60,
  :min_up_time_to_check => 7 * 24 * 60 * 60,
  :purge_age => 48 * 60 * 60,
  :accep_check_rate => 4 * 60 * 60,
  :sleep_between_connect => 500 * 1000,
  :min_last_seen => 24 * 60 * 60,
}
