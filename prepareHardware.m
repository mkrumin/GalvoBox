function hw = prepareHardware

% This function will prepare the NI board(s

adaptorVendor = 'ni';
galvoDeviceID = 'Dev1';
xChID = 'ao0';
yChID = 'ao1';
sampleRate = 20e3;
laserDeviceID = 'Dev2';
laserChannelID = 'ao0';


s = daq.createSession(adaptorVendor);
mirrorXChannel = s.addAnalogOutputChannel(galvoDeviceID, xChID, 'Voltage');
mirrorYChannel = s.addAnalogOutputChannel(galvoDeviceID, yChID, 'Voltage');

laserChannel = s.addAnalogOutputChannel(laserDeviceID, laserChannelID, 'Voltage');

s.SampleRate = sampleRate;

hw.s = s;
