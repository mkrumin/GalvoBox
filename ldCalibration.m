% Laser Diode calibration script
% Michael Krumin

%% setting up the DAQ session
% daq.getDevices
s = daq.createSession('ni');

Photodiode = s.addAnalogInputChannel('Dev2', 'ai0', 'Voltage');
Photodiode.TerminalConfig = 'SingleEnded';
% LDCurrentMonitor = s.addAnalogInputChannel('Dev1', 'ai5', 'Voltage');
% LDCurrentMonitor.TerminalConfig = 'SingleEnded';
Galvo = s.addAnalogOutputChannel('Dev2', {'ao0', 'ao1'}, 'Voltage');
LDControlSignal = s.addAnalogOutputChannel('Dev1', 'ao0', 'Voltage');

s.Rate = 5e3;
% LDCurrentConversion = -50; % [mA/V]

s.addTriggerConnection('external', 'Dev1/PFI0', 'StartTrigger');
s.addTriggerConnection('external', 'Dev2/PFI0', 'StartTrigger');
s.ExternalTriggerTimeout = Inf;

s.addlistener('DataAvailable', @logData);

tr = daq.createSession('ni');
tr.addDigitalChannel('Dev2', 'Port0/Line0', 'OutputOnly');


%% laser voltage to power calibration
laserVMin = 0;
laserVMax = 4;
laserVforXY = 4;

singleStepDur = 0.5;
nRepeats = 5;
nSamplesStep = singleStepDur*s.Rate;
laserV = repmat(laserVMin:0.05:laserVMax, 1, nRepeats);
laserV = laserV(randperm(length(laserV)));
laserWaveform = repmat(laserV, nSamplesStep, 1);
laserWaveform = laserWaveform(:);
galvoWaveform = zeros(length(laserWaveform), 2);

tr.outputSingleScan(0);

%%
% pre-heat the laser
fprintf('Pre-heating the laser\n');
s.outputSingleScan([0 0 laserVMax]);
pause(10);

%%
s.queueOutputData([galvoWaveform, laserWaveform]);
s.NotifyWhenDataAvailableExceeds = length(laserWaveform);
% s.prepare;
s.startBackground;

pause(1);

fprintf('[%s], will run for %2.0f seconds\n', datestr(now), length(laserWaveform)/s.Rate);
tr.outputSingleScan(1);
pause(0.01);
tr.outputSingleScan(0);

wait(s);
fprintf('[%s], stopped running\n', datestr(now));
s.outputSingleScan([0 0 0]);

%% plotting
global t phd
figure
plot(t, phd, 'b', t, laserWaveform, 'r');
hold on;

power = reshape(phd, nSamplesStep, []);
power = power(nSamplesStep/2:end-10, :);
power = mean(power);
[laserVSorted, ind] = sort(laserV, 'ascend');
laserVSorted = laserVSorted(1:nRepeats:end);
power = mean(reshape(power(ind), nRepeats, []));
power = power - min(power);

if any(diff(power)<0)
    warning('Calibration data not monotonic');
end

figure;
plot(laserVSorted, power, 'o');
xlabel('Control Voltage [V]');
ylabel('Photodiode [a.u.]');

return

%% Calibrating position tuning of the laser power
x = -2:0.2:2;
y = -2:0.2:2;
nRepeats = 5;
[XX, YY] = meshgrid(x, y);
[ny, nx] = size(XX);

timePerLoc = 0.1;
nSamplesPerLoc = timePerLoc * s.Rate;
vX = repmat(XX(:)', nSamplesPerLoc, 1);
vY = repmat(YY(:)', nSamplesPerLoc, 1);
vX = vX(:);
vY = vY(:);
vX = repmat(vX, nRepeats, 1);
vY = repmat(vY, nRepeats, 1);
vLas = laserVMax*ones(size(vX));

%%
fprintf('Pre-heating the laser\n');
s.outputSingleScan([0 0 laserVMax]);
pause(10);

s.queueOutputData([vX, vY, vLas]);
s.NotifyWhenDataAvailableExceeds = length(vX);
% s.prepare;
s.startBackground;

pause(1);

fprintf('Calibrating position-dependent laser power\n');
fprintf('[%s], will run for %2.0f seconds\n', datestr(now), length(vX)/s.Rate);
tr.outputSingleScan(1);
pause(0.01);
tr.outputSingleScan(0);

wait(s);
fprintf('[%s], stopped running\n', datestr(now));
s.outputSingleScan([0 0 0]);

%% plotting
global t phd
figure
plot(t, phd, 'b', t, vY, 'r');
hold on;

% cutting out the first 10ms (just in case, 0.5ms shoud be enough)
validSamples = 0.01*s.Rate:nSamplesPerLoc;
power = reshape(phd, nSamplesPerLoc, []);
power = mean(power(validSamples, :));
power = reshape(power, ny, nx, nRepeats);
power = median(power, 3);

powerAtCenter = power(y==0, x==0);
power = power/powerAtCenter;

figure;
surf(XX, YY, power);
xlabel('X-Galvo Voltage [V]');
ylabel('Y-Galvo Voltage [V]');
zlabel('Power, normalized to [x,y] = [0,0]');

return


