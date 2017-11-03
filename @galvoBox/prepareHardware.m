function prepareHardware(obj)

% This function will prepare the NI boards

fprintf('Initializing the NI hardware..');

adaptorVendor = 'ni';
galvoDeviceID = 'Dev2';
xChID = 'ao0';
yChID = 'ao1';
sampleRate = 20e3;
laserDeviceID = 'Dev1';
laserChannelID = 'ao0';

s = daq.createSession(adaptorVendor);
mirrorXChannel = s.addAnalogOutputChannel(galvoDeviceID, xChID, 'Voltage');
mirrorYChannel = s.addAnalogOutputChannel(galvoDeviceID, yChID, 'Voltage');

laserChannel = s.addAnalogOutputChannel(laserDeviceID, laserChannelID, 'Voltage');

s.Rate = sampleRate;

s.addTriggerConnection('external', 'Dev1/PFI0', 'StartTrigger');
s.addTriggerConnection('external', 'Dev2/PFI0', 'StartTrigger');
% clock connection is probably unnecessary for short duration outputs we
% will typically have
% s.addClockConnection('Dev2/PFI1', 'Dev1/PFI1', 'ScanClock');

s.ExternalTriggerTimeout = Inf;

tr = daq.createSession('ni');
tr.addDigitalChannel('Dev2', 'Port0/Line0', 'OutputOnly');
tr.outputSingleScan(0);

% this is the daq session for the galvos and the laser
obj.hw.s = s;
% this is the daq session of the trigger
obj.hw.tr = tr;

fprintf('.done\n');
