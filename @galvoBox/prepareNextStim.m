function prepareNextStim(obj, info)

% This function will precompute the waveforms for the mirrors and the
% laser, load them on the boards and arm the DAQ session
% the session will then be waiting for a trigger to start

%% for debugging
% stimParams.nPoints = 2;
% stimParams.stimDuration = 0.1;
% stimParams.ML = [-1.7 1.7 2.5];
% stimParams.AP = [-2 -2.1 -3.5];
% stimParams.stimPower = [0.8 1 0.5];
% hw.s.Rate = 20e3;

%%
f = 40; % [Hz] basic frequency of stimulation, each point will be visited f times per second
flightTime = 1e-3; % [sec] Time that takes galvo mirrors to hop from one point to another
% During this time the laser should be shut down

% define the time axis of the stimulus
dt = 1/obj.hw.s.Rate;
t = dt:dt:info.maxDuration;
t = t(:);

cycleDuration = 1/f;
nPoints = length(info.power);
locationDuration = cycleDuration/nPoints;

locIdxVector = mod(ceil(t/locationDuration)-1, nPoints)+1;

fSine = 1/(locationDuration-flightTime);
tCycle = mod(t, locationDuration);
laserPower = (-cos(2*pi*fSine*(tCycle-flightTime))+1)/2.*...
    (tCycle>=flightTime).*(tCycle<=locationDuration);
laserPowerMultiplier = info.power(locIdxVector)';
laserPower = laserPower.*laserPowerMultiplier;

coords = [info.ML(locIdxVector)', info.AP(locIdxVector)', ones(numel(locIdxVector), 1)];

% plot(t, laserPower, t, locIdxVector/3, t, coords)

laserWaveform = obj.laserVoltage(laserPower);
galvoWaveform = coords * obj.mm2pxTf * obj.px2vTf;
galvoWaveform = galvoWaveform(:, 1:2);

stop(obj.hw.s);
wait(obj.hw.s);
obj.hw.s.queueOutputData([galvoWaveform, laserWaveform; obj.parkingState]);
obj.hw.s.startBackground;

% show crosses where the stimulation will occur

targets = [info.ML', info.AP', ones(nPoints, 1)] * obj.mm2pxTf;
obj.hSpots.XData = targets(:, 1);
obj.hSpots.YData = targets(:, 2);
obj.hSpots.Marker = 'x';

