function stopZapping(hw)

% This function will stop the optical stimulation, park the mirrors outside
% of the brain, and put a certain value to the laser (typically 0)

stop(hw.s);
hw.s.outputSingleScan([5 5 0]);
hw.tr.outputSingleScan(0);