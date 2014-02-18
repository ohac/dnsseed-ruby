require 'socket'
require 'digest/sha2'

class BitcoinNode

  def initialize(host, port = 9301, timeout = 5)
    @version = 0
    @queue = []
    @sock = TCPSocket.open(host, port) # TODO timeout
    @myself = [rand(0x80000000), rand(0x80000000)].pack('NN')
    pkt = _makeVersionPacket(70002)
    @sock.write(pkt)
    while !@sock.eof? && @version == 0
      pkt = readPacket
      case pkt['type']
      when 'version'
        raise 'Got version packet twice!' if @version != 0
        _decodeVersionPayload(pkt['payload'])
      else
        raise pkt['type']
      end
    end
  end

  def getAddr
    @sock.write(_makePacket('getaddr', ''))
    pkt = nil
    loop do
      pkt = readPacket(true)
      if pkt['type'] != 'addr'
        @queue << pkt
        next
      end
      break
    end
    payload = pkt['payload']
    payload, count = _getVarInt(payload)
    res = []
    size = 30
    return [] if count * 26 > payload.size # something is wrong
    # decode payload
    count.times do |i|
      addr = payload[i * size, size]
      # no timestamp, add something to not die
      addr = "\x00\x00\x00\x00" + addr if size == 26
      info = addr.unpack('V3')
      next if info[1] > 3
      next if info[2] != 0
      info2 = {}
      info2[:ipv4] = addr[24, 4].unpack('C4').join('.')
      info2[:port] = addr[28, 2].unpack('n')[0]
      info2[:timestamp] = info[0]
      info2[:services] = [info[1], info[2]]
      res << info2
    end
    res
  end

  def checkOrder
    # send a fake transaction to see if remote host supports ip transaction
    @sock.write(_makePacket('checkorder', 'blah'))
  end

  def getVersion
    @version
  end

  def getSubversion
    @subversion
  end

  def getVersionStr
    v = @version
    if v > 10000
      rem = v / 100
      proto = v - rem * 100
      v = rem
    else
      proto = 0
    end
    h = {}
    [:revision, :minor, :major].each do |type|
      rem = v / 100
      h[type] = (v - rem * 100).to_s
      v = rem
    end
    h[:major] + '.' + h[:minor] + '.' + h[:revision] + '[.' + proto + ']'
  end

  def _decodeVersionPayload(data)
    ar = data.unpack('V5a26a26V2C')
    @version = ar[0]
    @version = 300 if @version == 10300
    @subversion = data[81, ar[-1]]
    ar2 = data[(81 + ar[-1])..-1].unpack('V')
    @start_height = ar2[0]
    # send verack?
    @sock.write(_makePacket('verack', '')) if @version >= 209
  end

  def readPacket(noqueue = false)
    return @queue.shift if !noqueue && !@queue.empty?
    data = @sock.read(20)
    raise 'Failed to read from peer' if !data
    raise 'unexpected fragmentation' if data.size != 20
    raise 'Corrupted stream' if data[0, 4] != "\xfb\xc0\xb6\xdb"
    type = data[4, 12]
    type_pos = type.index("\0")
    type = type[0, type_pos] if type_pos
    len = data[16, 4].unpack('V')[0]
    if @version >= 209 || @version == 0
      checksum = @sock.read(4)
      payload = ''
      while payload.size < len do
        payload += @sock.read(len - payload.size)
      end
      local = _checksum(payload)
      raise 'Received corrupted data' if local != checksum
    else
# TODO
p :foo
      payload = ''
      while payload.size < len do
        payload += @sock.read(len - payload.size)
      end
    end

    {
      'type' => type,
      'payload' => payload
    }
  end

  def _makeVersionPacket(version, nServices = 0, timestamp = nil, str = ".0",
      nBestHeight = 0)
    timestamp ||= Time.now.to_i
    data = [version].pack('V')
    data += [(nServices >> 32) & 0xffffffff, nServices & 0xffffffff].pack('VV')
    data += [(timestamp >> 32) & 0xffffffff, timestamp & 0xffffffff].pack('VV')
    data += _address(@sock.addr, nServices)
    data += _address(@sock.peeraddr, nServices)
    data += @myself
    data += _string(str)
    data += [nBestHeight].pack('V')
    _makePacket('version', data)
  end

  def _address(addr, nServices)
    port = addr[1]
    ip = addr[3]
    data = [(nServices >> 32) & 0xffffffff, nServices & 0xffffffff].pack('VV')
    data += "\0" * 12 # reserved, probably for ipv6
    data += ip.split('.').map(&:to_i).pack('CCCC')
    data + [port].pack('n')
  end

  def _string(str)
    _int(str.size) + str
  end

  def _int(i)
    return i.chr if i < 253
    return 253.chr + [i].pack('v') if i < 0xffff
    return 254.chr + [i].pack('V') if i < 0xffffffff
    255.chr + [(i >> 32) & 0xffffffff, i & 0xffffffff].pack('VV')
  end

  def _makePacket(type, data)
    packet = "\xfb\xc0\xb6\xdb" # magic header
    packet += type + "\0" * (12 - type.size)
    packet += [data.size].pack('V')
    if data && (@version > 0x209 || @version == 0)
      packet += _checksum(data)
    end
    packet + data
  end

  def _checksum(data)
    Digest::SHA256.digest(Digest::SHA256.digest(data))[0, 4]
  end

  def _getVarInt(str)
    v = str[0, 1].ord
    if v < 0xfd
      str = str[1..-1]
      return [str, v]
    end
    case v
    when 0xfd
      res = str[1, 2].unpack('v')
      str = str[3..-1]
      return [str, res[0]]
    when 0xfe
      res = str[1, 4].unpack('V')
      str = str[5..-1]
      return [str, res[0]]
    when 0xff
      res = str[1, 8].unpack('VV')
      str = str[9..-1]
      return [str, (res[0] << 32) | res[1]]
    end
  end

end
