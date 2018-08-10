function startTestUDP(obj)

obj.testUDP = udp('ZOOPHILE', 1002, 'LocalPort', 1103);
set(obj.testUDP, 'DatagramReceivedFcn', {@testUDPCallback, obj});
fopen(obj.testUDP);
