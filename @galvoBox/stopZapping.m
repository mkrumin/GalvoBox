function stopZapping(hw)

% This function will stop the optical stimulation, park the mirrors outside
% of the brain, and put a certain value to the laser (typically 0)

% stop the current analog output waveform 
% (might be unnecessary because of the next command)
stop(hw.s);
% park mirrors outside and laser to zero
hw.s.outputSingleScan([5 5 0]);
% reset the digital channel used as a trigger
hw.tr.outputSingleScan(0);