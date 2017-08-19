function startZapping(hw)

% This function will trigger the stimulation
% It is as simple as flipping a single digital channel, which is wired
% to the boards to the channel defined to be the trigger

hw.tr.outputSingleScan(1);