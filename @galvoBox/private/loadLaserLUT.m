function lut = loadLaserLUT

% this is an appoximate laser calibration curve
lut.v = 0:1e-3:4; % control voltage in Volts
% it is piecewise linear, with a 'knee' at v=2.4V
% lut.pow is in [mW], 0mW for v=0, 0.1mW for v=2.4, and 13mW for v=4;
kneeV = 2.4;
kneeP = 0.1;
maxV = 4;
maxP = 12.5;
lut.pow = kneeP/kneeV*lut.v.*(lut.v<=kneeV) + ...
    (kneeP+(lut.v-kneeV)*((maxP-kneeP)/(maxV-kneeV))).*(lut.v>kneeV);
