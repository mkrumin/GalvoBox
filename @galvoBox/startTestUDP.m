function startTestUDP(obj)

obj.testUDP = udp('ZCAMP3', 1002, 'LocalPort', 1103);
set(obj.testUDP, 'DatagramReceivedFcn', @testUDPCallback);
fopen(obj.testUDP);
