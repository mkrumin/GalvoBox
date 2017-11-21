function lut = loadLaserLUT

% calibration values, measured on 2017-11-20
% for vGalvos = [0 0];
% polarizer at galvo laser at 100 (just tiny bit above, maybe)
% this makes max power at 4V (200mA) = 4mW
% lut.v = [0 1     2     2.4  2.45 2.5  2.6  2.8  3    3.25 3.5 3.75 4];
% lut.pow = [0 0.004 0.013 0.03 0.18 0.35 0.52 0.86 1.37 2.06 2.7 3.43 4];

d = load ('ldLUT.mat');
lut = d.lut;
