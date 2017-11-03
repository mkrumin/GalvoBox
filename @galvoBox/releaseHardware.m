function releaseHardware(obj)

% Thie function will release all the hardware, so that it will be available
% for next experiments

fprintf('Releasing NI harware..');
if isvalid(obj.hw.s) % check that was not released already
    release(obj.hw.s);
end
delete(obj.hw.s);
if isvalid(obj.hw.tr) % check that was not released already
    release(obj.hw.tr);
end
delete(obj.hw.tr);
fprintf('.done\n');
