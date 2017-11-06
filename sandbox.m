% the script to test galvo inactivation rig functionality

o = galvoBox;

o.calibrateGalvos;
o.calibrateStereotax;

o.showGrid
%%
msg.instruction = 'ZapPrepare'; % one of {'hello', 'ExpStart', 'ExpEnd', 'ExpInterrupt'...
% 'ZapPrepare', 'ZapStart', 'ZapStop'}
msg.ExpRef = 'default';
msg.maxDuration = 45; % [sec] maximum duration of the stimulation (used for pre-generating the waveforms)
msg.ML = [-1.7, 1.7]; % [mm] ML positions
msg.AP = [-2, -2]; % [mm] AP positions
msg.power = [10, 10]; % [mW] peak power

dataOut = savejson('msg', msg);
fwrite(o.testUDP, dataOut);


msg.instruction = 'ZapStart'; % one of {'hello', 'ExpStart', 'ExpEnd', 'ExpInterrupt'...
dataOut = savejson('msg', msg);
fwrite(o.testUDP, dataOut);

pause(5)
msg.instruction = 'ZapStop'; % one of {'hello', 'ExpStart', 'ExpEnd', 'ExpInterrupt'...
dataOut = savejson('msg', msg);
fwrite(o.testUDP, dataOut);
