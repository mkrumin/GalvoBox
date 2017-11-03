function releaseHardware(hw)

% Thie function will release all the hardware, so that it will be available
% for next experiments

fprintf('Releasing NI harware..');
if isvalid(hw.s) % check that was not released already
    release(hw.s);
end
delete(hw.s);
if isvalid(hw.tr) % check that was not released already
    release(hw.tr);
end
delete(hw.tr);
fprintf('.done\n');
