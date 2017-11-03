function testUDPCallback(src, event)

timeStamp = datestr(clock, 'yyyy-mm-dd HH:MM:SS.FFF');
ip=src.DatagramAddress;
port=src.DatagramPort;
data=fread(src);
str=char(data');
fprintf('[testUDP] [%s] Received ''%s'' from %s:%d\n', timeStamp, str, ip, port);
