function galvoUDP = startGalvoListener(o)

% we will listen to port 1002, to not interfere with the mpep default port 1001
% the remote will be listening on port 1103
galvoUDP = udp('ZCAMP3', 1103, 'LocalPort', 1002);
set(galvoUDP, 'DatagramReceivedFcn', {@galvoCallback, o});
fopen(galvoUDP);

% galvoCalibrate;