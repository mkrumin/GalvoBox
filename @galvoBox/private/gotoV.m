function gotoV(o, vv)
%GOTOV Summary of this function goes here
% send these voltages to the boards (mirrors and laser)
% vv should be a 1x3 vector of [vX, vY, vLaser]
%   Detailed explanation goes here

o.hw.s.outputSingleScan(vv);

end

