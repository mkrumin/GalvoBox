function prepareNextStim(hw, stimParams)

% This function will precompute the waveforms for the mirrors and the
% laser, load them on the boards and arm the DAQ session
% the session will then be waiting for a trigger to start

%% for debugging
stimParams.nPoints = 3;
stimParams.stimDuration = 0.1;
stimParams.ML = [-1.7 1.7 2.5];
stimParams.AP = [-2 -2 -3.5];
stimParams.stimPower = [0.8 1 0.5];
hw.s.sampleRate = 20e3;

%%
f = 40; % [Hz] basic frequency of stimulation, each point will be visited f times per second
flightTime = 2e-3; % [sec] Time that takes galvo mirrors to hop from one point to another
% During this time the laser should be shut down

% define the time axis of the stimulus
dt = 1/hw.s.sampleRate;
t = dt:dt:stimParams.stimDuration;

cycleDuration = 1/f;
locationDuration = cycleDuration/stimParams.nPoints;

locIdxVector = mod(ceil(t/locationDuration)-1, stimParams.nPoints)+1;

fSine = 1/(locationDuration-flightTime);
tCycle = mod(t, locationDuration);
laserPower = (-cos(2*pi*fSine*(tCycle-flightTime))+1)/2.*...
    (tCycle>=flightTime).*(tCycle<=locationDuration);
laserPowerMultiplier = stimParams.stimPower(locIdxVector);
laserPower = laserPower.*laserPowerMultiplier;

plot(t, laserPower, t, locIdxVector/3)