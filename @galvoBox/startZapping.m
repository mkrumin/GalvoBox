function startZapping(obj)

% This function will trigger the stimulation
% It is as simple as flipping a single digital channel, which is wired
% to the boards to the channel defined to be the trigger

obj.hw.tr.outputSingleScan(1);
% wait a bit and flip it back to 0
% otherwise, the next time there will be no rising edge
pause(0.01);
obj.hw.tr.outputSingleScan(0);