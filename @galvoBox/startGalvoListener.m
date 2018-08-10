function startGalvoListener(obj)

% we will listen to port 1002, to not interfere with the mpep default port 1001
% the remote will be listening on port 1103
obj.galvoUDP = udp('ZOOPHILE', 1103, 'LocalPort', 1002);
set(obj.galvoUDP, 'DatagramReceivedFcn', {@galvoCallback, obj});
fopen(obj.galvoUDP);
