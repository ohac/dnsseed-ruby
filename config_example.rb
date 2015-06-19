CONFIG = {
  :sakuracoin => {
    # :bootstrap => 'http://example.com/bootstrap.dat.torrent',
    :port => 9301,
    :magic => ["fbc0b6db"].pack('H*'),
    :min_version => 70002,
    :subversions => [
      'Satoshi:0.8.6.1',
      'Satoshi:0.8.6.2',
    ],
    :unaccep_check_rate => 36 * 60 * 60,
    :min_up_time_to_check => 7 * 24 * 60 * 60,
    :purge_age => 48 * 60 * 60,
    :accep_check_rate => 4 * 60 * 60,
    :min_last_seen => 24 * 60 * 60,
    :seed_nodes => [
      ['127.0.0.1', 9301],
      ["110.1.232.231", 9301],
      ["111.216.229.84", 9301],
      ["113.146.68.251", 9301],
      ["114.134.156.167", 9301],
      ["114.167.137.98", 9301],
      ["114.187.80.23", 9301],
      ["115.30.140.102", 9301],
      ["116.80.228.82", 9301],
      ["116.82.210.220", 9301],
      ["116.82.39.49", 9301],
      ["118.10.103.53", 9301],
      ["118.240.80.7", 9301],
      ["121.80.239.209", 9301],
      ["122.210.183.100", 9301],
      ["123.227.4.174", 9301],
      ["125.192.249.209", 9301],
      ["125.55.155.2", 9301],
      ["133.202.101.184", 9301],
      ["133.242.10.41", 9301],
      ["134.175.16.46", 9301],
      ["140.225.115.153", 9301],
      ["153.120.3.72", 9301],
      ["153.121.57.18", 9301],
      ["182.163.78.67", 9301],
      ["182.168.94.15", 9301],
      ["182.236.19.64", 9301],
      ["195.219.5.64", 9301],
      ["202.212.20.51", 9301],
      ["202.70.211.222", 9301],
      ["219.94.248.221", 9301],
      ["222.158.43.13", 9301],
      ["222.7.109.99", 9301],
      ["27.96.51.14", 9301],
      ["31.6.70.133", 9301],
      ["36.2.132.153", 9301],
      ["49.241.107.237", 9301],
      ["58.190.222.135", 9301],
      ["58.191.173.168", 9301],
      ["59.84.150.98", 9301],
      ["60.36.250.191", 9301],
      ["61.44.127.57", 9301],
      ["61.45.197.150", 9301],
      ["73.87.161.240", 9301],
      ["80.94.252.226", 9301],
    ]
  },
  :sha1coin => {
    :port => 9513,
    :magic => ["fbc0b6db"].pack('H*'),
    :min_version => 70002,
    :subversions => [
      'Satoshi:0.8.6.1',
      'Satoshi:0.8.6.2',
    ],
    :seed_nodes => [
      ['127.0.0.1', 9513],
      ["60.33.13.81", 9513],
      ["111.227.255.9", 9513],
      ["5.9.85.11", 9513],
      ["36.2.132.153", 9513],
      ["153.120.3.72", 9513],
      ["60.237.15.147", 9513],
      ["5.9.74.3", 9513],
      ["31.6.70.133", 9513],
      ["157.7.209.139", 9513],
      ["134.175.13.62", 9513],
      ["5.9.158.79", 9513],
      ["121.80.242.193", 9513],
      ["133.202.101.184", 9513],
      ["47.72.224.41", 9513],
      ["88.172.65.144", 9513],
      ["125.55.155.2", 9513],
      ["254.167.87.127", 9513],
      ["219.94.248.221", 9513],
      ["27.96.51.14", 9513],
    ]
  },
  :yaycoin => {
    :port => 8484,
    :magic => ["fbc0b6db"].pack('H*'),
    :min_version => 70002,
    :subversions => [
      'Satoshi:0.8.6.1',
      'Satoshi:0.8.6.2',
    ],
    :seed_nodes => [
      ['127.0.0.1', 8484],
      ["221.121.207.215", 8484],
      ["64.139.47.106", 8484],
      ["202.13.166.125", 8484],
      ["36.2.132.153", 8484],
      ["119.230.16.139", 8484],
      ["119.63.161.97", 8484],
      ["180.32.43.8", 8484],
      ["106.188.103.130", 8484],
      ["219.94.235.89", 8484],
      ["218.217.142.222", 8484],
      ["34.134.48.40", 8484],
      ["180.61.105.111", 8484],
      ["180.44.81.243", 8484],
      ["219.94.248.221", 8484],
      ["172.245.240.81", 8484],
      ["223.217.169.235", 8484],
      ["133.242.203.117", 8484],
      ["153.120.3.72", 8484],
    ]
  },
  :sayacoin => {
    :port => 8666,
    :magic => ["53415941"].pack('H*'),
    :min_version => 70002,
    :subversions => [
      'Satoshi:0.8.6.1',
      'Satoshi:0.8.6.2',
    ],
    :seed_nodes => [
      ['127.0.0.1', 8666],
    ]
  },
  :monacoin => {
    :port => 9401,
    :magic => ["fbc0b6db"].pack('H*'),
    :min_version => 70002,
    :subversions => [
      'Satoshi:0.8.6.1',
      'Satoshi:0.8.6.2',
    ],
    :seed_nodes => [
      ['127.0.0.1', 9401],
    ]
  },
  :ringo => {
    :port => 9393,
    :magic => ["70352205"].pack('H*'),
    :min_version => 70002,
    :subversions => [
      'Satoshi:0.8.6.1',
      'Satoshi:0.8.6.2',
    ],
    :seed_nodes => [
      ['127.0.0.1', 9393],
    ]
  },
  :kumacoin => {
    :port => 7586,
    :magic => ["c3d4d2fe"].pack('H*'),
    :ts => true,
    :min_version => 60007,
    :subversions => [
      'Satoshi:0.8.6.1',
      'Satoshi:0.8.6.2',
    ],
    :seed_nodes => [
      ['127.0.0.1', 7586],
    ]
  },
  :bitzeny => {
    :port => 9253,
    :magic => ["daa5bef9"].pack('H*'),
    :min_version => 1010000,
    :subversions => [
      'Satoshi:1.1.0',
    ],
    :seed_nodes => [
      ['153.120.5.171', 9253], # seed.bitzeny.org
      ["54.68.124.6", 9253],
      ["153.204.184.135", 9253],
      ["125.54.144.246", 9253],
      ["58.70.178.98", 9253],
      ["116.70.225.107", 9253],
    ]
  },
}
AMAZON = {
  :name => 'sighash.info.',
  :coins => {
    :sakuracoin => 'skrseed',
    :sha1coin => 'shaseed',
    :yaycoin => 'yayseed',
    :monacoin => 'monaseed',
    :sayacoin => 'sayaseed',
    :ringo => 'rinseed',
    :kumacoin => 'kumaseed',
  },
}
