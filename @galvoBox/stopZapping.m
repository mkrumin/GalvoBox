function stopZapping(obj)

% This function will stop the optical stimulation, park the mirrors outside
% of the brain, and put a certain value to the laser (typically 0)

% stop the current analog output waveform 
% (might be unnecessary because of the next command)
stop(obj.hw.s);
wait(obj.hw.s);
% park mirrors outside and laser to zero
obj.parkGalvos;
% reset the digital channel used as a trigger
obj.hw.tr.outputSingleScan(0);