% the script to test galvo inactivation rig functionality

o = galvoBox;
%%
o.calibrateGalvos;
%%
o.calibrateStereotax;
o.showGrid;
%%
o.hideGrid;
%%
msg.instruction = 'ExpStart'; % one of {'hello', 'ExpStart', 'ExpEnd', 'ExpInterrupt'...
msg.ExpRef = '2017-11-11_1_default';
dataOut = savejson('msg', msg);
fwrite(o.testUDP, dataOut);
%%
msg.instruction = 'ZapPrepare'; % one of {'hello', 'ExpStart', 'ExpEnd', 'ExpInterrupt'...
% 'ZapPrepare', 'ZapStart', 'ZapStop'}
msg.ExpRef = '2017-11-11_1_default';
msg.maxDuration = 4; % [sec] maximum duration of the stimulation (used for pre-generating the waveforms)
msg.ML = [-1.7, 1.7]; % [mm] ML positions
msg.AP = [-2, -2]; % [mm] AP positions
msg.power = [4, 4]; % [mW] peak power
msg.iTrial = 1;

dataOut = savejson('msg', msg);
fwrite(o.testUDP, dataOut);

%%
msg.instruction = 'ZapStart'; % one of {'hello', 'ExpStart', 'ExpEnd', 'ExpInterrupt'...
dataOut = savejson('msg', msg);
fwrite(o.testUDP, dataOut);

pause(5)
msg.instruction = 'ZapStop'; % one of {'hello', 'ExpStart', 'ExpEnd', 'ExpInterrupt'...
dataOut = savejson('msg', msg);
fwrite(o.testUDP, dataOut);

%%
msg.instruction = 'ExpEnd'; % one of {'hello', 'ExpStart', 'ExpEnd', 'ExpInterrupt'...
dataOut = savejson('msg', msg);
fwrite(o.testUDP, dataOut);
