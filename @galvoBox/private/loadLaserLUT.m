function lut = loadLaserLUT

% this is an appoximate laser calibration curve
lut.v = 0:1e-3:4; % control voltage in Volts
% it is piecewise linear, with a 'knee' at v=2.5V
% lut.pow is in [mW], 0mW for v=0, 1mW for v=2.5, and 13mW for v=4;
lut.pow = 1/2.5*lut.v.*(lut.v<=2.5) + (1+(lut.v-2.5)*(12/1.5)).*(lut.v>2.5);
