% script startGalvoListener

% we will listen to port 1002, to not interfere with the mpep default port 1001
% the remote will be listening on port 1103
u = udp('ZMAZE', 1103, 'LocalPort', 1002);
set(u, 'DatagramReceivedFcn', 'galvoCallback(u);');
fopen(u);

galvoCalibrate;