function hw = prepareHardware

% This function will prepare the NI boards

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

s.addTriggerConnection('external', 'Dev1/PFI0', 'StartTrigger');
s.addTriggerConnection('external', 'Dev2/PFI0', 'StartTrigger');
s.addClockConnection('Dev1/PFI1', 'Dev2/PFI1', 'ScanClock');

hw.s = s;
