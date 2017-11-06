function testUDPCallback(src, event, obj)

timeStamp = datestr(clock, 'yyyy-mm-dd HH:MM:SS.FFF');
ip=src.DatagramAddress;
port=src.DatagramPort;
data=fread(src);
str=char(data');
info = parseMessage(str);
fprintf('[testUDP] [%s] Received ''%s...'' from %s:%d\n', timeStamp, info.instruction, ip, port);
