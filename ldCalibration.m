% Laser Diode calibration script
% Michael Krumin

% daq.getDevices
s = daq.createSession('ni');
LDCurrentMonitor = s.addAnalogInputChannel('Dev1', 'ai5', 'Voltage');
Photodiode = s.addAnalogInputChannel('Dev1', 'ai6', 'Voltage');
LDCurrentMonitor.TerminalConfig = 'SingleEnded';
Photodiode.TerminalConfig = 'SingleEnded';
LDControlSignal = s.addAnalogOutputChannel('Dev1', 'ao1', 'Voltage');

s.Rate = 100e3;
LDCurrentConversion = -50; % [mA/V]
% slow calibration
vMin = -3;
vMax = 2;

singleSwipeDur = 10;
nSamplesSwipe = singleSwipeDur*s.Rate;
waitDur = 10;
nSamplesWait = waitDur*s.Rate;
singleSwipeUp = linspace(vMin, vMax, nSamplesSwipe);
singleSwipeDown = linspace(vMax, vMin, nSamplesSwipe);

singleCycle = [ones(nSamplesWait, 1) * vMax;...
    singleSwipeDown(:);...
    ones(nSamplesWait, 1) * vMin;...
    singleSwipeUp(:)];

nCycles = 5;
figure;
for iCycle = 1:nCycles

s.outputSingleScan(vMax);
pause(waitDur);
s.queueOutputData(singleSwipeDown(:));
% s.prepare;
dataDown{iCycle} = s.startForeground;

plot(singleSwipeDown, dataDown{iCycle}(:,2));
hold on;
xlabel('Control Voltage [V]');
ylabel('Photodiode [a.u.]');

% s.outputSingleScan(vMin);
% pause(waitDur);
% 
% s.queueOutputData(singleSwipeUp(:));
% s.prepare;
% dataUp{iCycle} = s.startForeground;
% 
% plot(singleSwipeUp, dataUp{iCycle}(:,2));
% hold on;
% xlabel('Control Voltage [V]');
% ylabel('Photodiode [a.u.]');

end

%%

N = round(s.Rate*0.03);
phData = cell2mat(dataDown);
phData = flipud(phData);
V = flipud(singleSwipeDown(:));
phData = mean(phData(:,2:2:end), 2);
phBias = mean(phData(V<(min(V)+0.1)));
phData = phData - phBias;

dph = gradient(filtfilt(ones(N, 1), 1, phData), 1);
d2ph = gradient(dph);

phMin = min(phData);
phMax = max(phData);
phRange = phMax - phMin;

idx = find(phData<phMin+0.1*phRange);
[~, mLoc] = max(d2ph(idx));
vMin = V(idx(mLoc));
phMin = phData(idx(mLoc));

idx = find(phData>phMax-0.1*phRange);
[~, mLoc] = min(d2ph(idx));
vMax = V(idx(mLoc));
phMax = phData(idx(mLoc));

%%
figure
plot(V, phData, 'r', 'LineWidth', 2)
hold on;
% plot(V, dph, 'c:', 'LineWidth', 1)
% plot(V, d2ph, 'b')
plot(vMin, phData(V==vMin), 'oc');
plot(vMax, phData(V==vMax), 'oc');
xlim([vMin - 0.1, vMax + 0.1])
xlabel('Control Voltage [V]');
ylabel('Laser Intensity [a.u.]');
title('Laser diode calibration');
str{1} = sprintf('Laser Max = %4.3f', phMax);
str{2} = sprintf('Laser Min = %4.3f', phMin);
str{3} = sprintf('Extinction coeff. = %3.1f', phMax/phMin);
text(vMin, phMax, str, 'VerticalAlign', 'Cap', 'HorizontalAlign', 'Left');


%% fast modulation tests
s.outputSingleScan(vMin);
pause(5);

%%
% 40 Hz sinewave
stimType = 'square'; % one of {'sine', 'square'}
holdMeanV = false; % do we hold the laser power on mean between the stimulation epochs?
nPoints = 2;
iPoint = 1;
f = 40; % [Hz]
stimDuration = 1.5; %[sec]
gapDuration = 2.5;
nCycles = 5;
nSamplesGap = gapDuration*s.Rate;
tt = 0:1/s.Rate:stimDuration;
cycleDur = 1/nPoints/f;
cycleCounter = ceil(tt/cycleDur);
valid = ~mod(cycleCounter-iPoint, nPoints);
switch stimType
    case 'sine'
        stimSignal = (1-cos(2*pi*f*nPoints*tt))/2.*valid;
    case 'square'
        stimSignal = valid;
    otherwise
        error('stimType unknown');
end
stimSignal = stimSignal*(vMax-vMin)+vMin;

if holdMeanV
    vStart = mean(stimSignal);
else
    vStart = vMin;
end
vEnd = vStart;

dataOut = [vStart*ones(nSamplesGap, 1); stimSignal(:); vEnd*ones(nSamplesGap, 1)];
s.queueOutputData(repmat(dataOut, nCycles, 1));

[data, timeStamps] = s.startForeground;

figure
plot(timeStamps - gapDuration, data(:, 2)-phBias)
xlabel('Time [sec]');
ylabel('Laser Intensity [a.u.]');

return
%%
s.release;
s.wait;
s.delete;
% clear s;