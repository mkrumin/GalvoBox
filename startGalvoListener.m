function galvoUDP = startGalvoListener

% we will listen to port 1002, to not interfere with the mpep default port 1001
% the remote will be listening on port 1103
galvoUDP = udp('ZMAZE', 1103, 'LocalPort', 1002);
set(galvoUDP, 'DatagramReceivedFcn', @galvoCallback);
fopen(galvoUDP);

% galvoCalibrate;