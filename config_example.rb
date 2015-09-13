CONFIG = {
  :sakuracoin => {
    # :bootstrap => 'http://example.com/bootstrap.dat.torrent',
    :port => 9301,
    :magic => ["fbc0b6db"].pack('H*'),
    :min_version => 70002,
    :unaccep_check_rate => 36 * 60 * 60,
    :min_up_time_to_check => 7 * 24 * 60 * 60,
    :purge_age => 48 * 60 * 60,
    :accep_check_rate => 4 * 60 * 60,
    :min_last_seen => 24 * 60 * 60,
    :seed_nodes => [
      ['127.0.0.1', 9301],
      ['191.233.32.153', 9301],
      ['125.0.39.12', 9301],
      ['219.94.248.221', 9301],
      ['117.6.130.233', 9301],
    ]
  },
  :sha1coin => {
    :port => 9513,
    :magic => ["fbc0b6db"].pack('H*'),
    :min_version => 70002,
    :seed_nodes => [
      ['127.0.0.1', 9513],
      ['219.94.248.221', 9513],
      ['126.3.195.242', 9513],
      ['191.233.32.153', 9513],
      ['180.197.55.20', 9513],
      ['126.8.6.184', 9513],
      ['124.44.174.62', 9513],
    ]
  },
  :yaycoin => {
    :port => 8484,
    :magic => ["fbc0b6db"].pack('H*'),
    :min_version => 70002,
    :seed_nodes => [
      ['127.0.0.1', 8484],
      ['222.15.33.156', 8484],
      ['121.86.222.160', 8484],
      ['191.233.32.153', 8484],
      ['221.121.200.206', 8484],
      ['36.55.234.37', 8484],
      ['5.165.169.3', 8484],
    ]
  },
  :sayacoin => {
    :port => 8666,
    :magic => ["53415941"].pack('H*'),
    :min_version => 70001,
    :seed_nodes => [
      ['127.0.0.1', 8666],
      ['182.163.86.26', 8666],
      ['36.55.238.28', 8666],
      ['108.61.242.92', 8666],
      ['191.233.32.153', 8666],
      ['160.16.88.8', 8666],
      ['210.145.102.247', 8666],
    ]
  },
  :monacoin => {
    :port => 9401,
    :magic => ["fbc0b6db"].pack('H*'),
    :min_version => 70002,
    :subversion => 100202,
    :seed_nodes => [
      ['127.0.0.1', 9401],
      ['219.94.248.221', 9401],
      ['157.7.154.134', 9401],
      ['202.181.101.205', 9401],
      ['133.242.237.216', 9401],
      ['110.135.87.98', 9401],
      ['113.159.31.157', 9401],
      ['54.68.124.6', 9401],
      ['144.76.185.69', 9401],
      ['153.120.3.72', 9401],
      ['153.120.63.28', 9401],
      ['219.94.248.61', 9401],
      ['36.55.226.160', 9401],
      ['124.39.4.146', 9401],
      ['133.242.232.80', 9401],
      ['111.89.180.104', 9401],
      ['54.65.7.240', 9401],
      ['160.16.76.211', 9401],
      ['37.187.114.205', 9401],
      ['157.7.170.150', 9401],
      ['122.249.125.226', 9401],
      ['123.57.15.153', 9401],
    ],
    :special_nodes => {
      '153.120.39.89' => { :name => 'dnsseed.monacoin.org (Monacoin Core)' },
      '49.212.167.79' => { :name => 'www13305uf.sakura.ne.jp (Monacoin Core)' },
      '195.154.223.134' => {:name => '195-154-223-134.rev.poneytelecom.eu (Monacoin Core)' },
      '59.157.5.163' => { :name => 'v-59-157-5-163.ub-freebit.net (Monacoin Core)' },
      '104.156.238.203' => { :name => '104.156.238.203.vultr.com (Monacoin Core)' },
      '195.20.47.205' => { :name => 'seed.givememona.tk (MonacoinJ)' },
      '191.233.32.153' => { :name => 'api.monaco-ex.org (MonacoinJ)' },
    ]
  },
  :ringo => {
    :port => 9393,
    :magic => ["70352205"].pack('H*'),
    :min_version => 60013,
    :seed_nodes => [
      ['127.0.0.1', 9393],
      ['106.173.76.190', 9393],
      ['124.214.179.254', 9393],
      ['118.86.11.85', 9393],
      ['122.132.248.4', 9393],
      ['106.160.38.97', 9393],
      ['110.5.53.29', 9393],
      ['222.15.33.156', 9393],
      ['126.1.115.208', 9393],
      ['221.118.7.48', 9393],
      ['118.15.177.243', 9393],
      ['119.47.40.235', 9393],
      ['113.151.218.212', 9393],
      ['121.86.222.160', 9393],
      ['153.232.68.129', 9393],
      ['118.109.204.199', 9393],
      ['126.3.195.242', 9393],
      ['191.233.32.153', 9393],
      ['126.50.8.83', 9393],
      ['54.65.209.34', 9393],
      ['202.224.243.189', 9393],
      ['182.171.151.149', 9393],
    ]
  },
  :kumacoin => {
    :port => 7586,
    :magic => ["c3d4d2fe"].pack('H*'),
    :ts => true,
    :min_version => 60007,
    :seed_nodes => [
      ['127.0.0.1', 7586],
      ['118.1.221.114', 7586],
      ['219.210.132.3', 7586],
      ['123.217.154.64', 7586],
      ['182.171.151.149', 7586],
      ['121.86.222.160', 7586],
      ['119.228.96.233', 7586],
      ['126.1.115.208', 7586],
      ['218.219.50.108', 7586],
      ['110.2.21.21', 7586],
      ['27.133.141.53', 7586],
      ['60.236.176.62', 7586],
      ['110.93.107.162', 7586],
      ['61.27.79.119', 7586],
      ['122.133.5.244', 7586],
      ['180.145.149.245', 7586],
      ['210.145.102.247', 7586],
      ['113.151.218.212', 7586],
      ['60.34.16.104', 7586],
      ['222.15.33.156', 7586],
      ['133.218.47.116', 7586],
      ['59.147.77.156', 7586],
      ['106.160.38.97', 7586],
    ]
  },
  :bitzeny => {
    :port => 9253,
    :magic => ["daa5bef9"].pack('H*'),
    :min_version => 70006,
    :seed_nodes => [
      ['153.120.5.171', 9253], # seed.bitzeny.org
      ["54.68.124.6", 9253],
      ["153.204.184.135", 9253],
      ["125.54.144.246", 9253],
      ["58.70.178.98", 9253],
      ["116.70.225.107", 9253],
    ]
  },
  :futcoin => {
    :port => 2345,
    :magic => ["70352205"].pack('H*'),
    :ts => true,
    :min_version => 70113,
    :seed_nodes => [
      ['54.64.113.221', 2345], # 0xdd714036
      ['54.172.223.229', 2345], # 0xe5dfac36
      ['54.77.253.218', 2345], # 0xdafd4d36
      ['123.225.149.133', 2345],
      ['42.144.218.32', 2345],
      ['153.191.148.90', 2345],
      ['211.3.235.64', 2345],
      ['106.173.76.190', 2345],
      ['126.94.87.253', 2345],
      ['157.7.170.150', 2345],
      ['116.70.225.107', 2345],
      ['61.89.191.66', 2345],
      ['160.16.100.45', 2345],
      ['85.25.201.216', 2345],
      ['114.168.2.192', 2345],
      ['153.232.68.129', 2345],
      ['126.227.147.185', 2345],
      ['125.54.171.180', 2345],
      ['180.18.76.113', 2345],
    ]
  },
  :fujicoin => {
    :port => 3777,
    :magic => ["66756a69"].pack('H*'),
    :min_version => 70002,
    :seed_nodes => [
      ['54.186.207.129', 3777], # seed2.fujicoin.org 0x81CFBA36
      ['54.69.108.71', 3777], # seed1.fujicoin.org
      ['128.199.255.227', 3777],
      ['188.165.82.229', 3777],
      ['85.25.201.216', 3777],
      ['191.233.32.153', 3777],
    ]
  },
  :likecoin => {
    :port => 50884,
    :magic => ["fcd9b7dd"].pack('H*'),
    :min_version => 60001,
    :seed_nodes => [
#     ['113.203.253.46', 50884], # 0x2EFDCB71
#     ['214.58.27.204', 50884], # 0xCC1B3AD6
#     ['73.113.167.173', 50884], # 0xADA77149
      ['219.94.248.221', 50884],
      ['191.233.32.153', 50884],
      ['160.16.88.8', 50884],
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
    :bitzeny => 'znyseed',
    :futcoin => 'futseed',
    :fujicoin => 'fujiseed',
  },
}
