testUDP = udp('ZCAMP3', 1002, 'LocalPort', 1103);
set(testUDP, 'DatagramReceivedFcn', @testUDPCallback);
fopen(testUDP);
