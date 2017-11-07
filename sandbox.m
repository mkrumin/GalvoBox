% the script to test galvo inactivation rig functionality

o = galvoBox;

o.calibrateGalvos;
o.calibrateStereotax;

o.showGrid;
%%
msg.instruction = 'ZapPrepare'; % one of {'hello', 'ExpStart', 'ExpEnd', 'ExpInterrupt'...
% 'ZapPrepare', 'ZapStart', 'ZapStop'}
msg.ExpRef = 'default';
msg.maxDuration = 4; % [sec] maximum duration of the stimulation (used for pre-generating the waveforms)
msg.ML = [-1.7, 1.7, 2.5, -2.5]; % [mm] ML positions
msg.AP = [-2, -2, -3.5, -4]; % [mm] AP positions
msg.power = [12, 12, 12, 12]; % [mW] peak power

dataOut = savejson('msg', msg);
fwrite(o.testUDP, dataOut);


msg.instruction = 'ZapStart'; % one of {'hello', 'ExpStart', 'ExpEnd', 'ExpInterrupt'...
dataOut = savejson('msg', msg);
fwrite(o.testUDP, dataOut);

pause(5)
msg.instruction = 'ZapStop'; % one of {'hello', 'ExpStart', 'ExpEnd', 'ExpInterrupt'...
dataOut = savejson('msg', msg);
fwrite(o.testUDP, dataOut);
