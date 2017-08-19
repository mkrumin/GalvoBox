function releaseHardware(hw)

% Thie function will release all the hardware, so that it will be available
% for next experiments

release(hw.s);
delete(hw.s);
release(hw.tr);
delete(hw.tr);