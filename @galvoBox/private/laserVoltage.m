function volts = laserVoltage(o, vGalvo, power)

%LASERVOLTAGE Summary of this function goes here
%    this function will map laser power to voltages using o.laserLUT look-up table
%   Detailed explanation goes here

minP = 0;
maxP = o.laserLUT.maxPower;
% correcting for the galvo position (if outside of the calibration range - set to 1)
correction = interp2(o.laserLUT.vX, o.laserLUT.vY, 1./o.laserLUT.pXY, vGalvo(:,1), vGalvo(:,2), 'linear', 1);
powerCorrected = power.*correction;

if any(powerCorrected(:)>maxP)
    str = sprintf('Some of the required laser power values are ABOVE the MAX possible value of %d mW', maxP);
    str = strcat(str, sprintf('\nClipping laser power at %d mW', maxP));
    warning(str);
    powerCorrected = min(powerCorrected, maxP);
end
if any(powerCorrected(:)<minP)
    str = sprintf('Some of the required laser power values are BELOW the MIN possible value of %d mW', minP);
    str = strcat(str, sprintf('\nClipping laser power at %d mW', minP));
    warning(str);
    powerCorrected = max(powerCorrected, minP);
end

% calibration coefficient between the photodiode measurement (in a.u.) and
% actual laser power (in mW)
phdMultiplier = o.laserLUT.maxPower/max(o.laserLUT.pLD);
volts = interp1(o.laserLUT.pLD*phdMultiplier, o.laserLUT.vLD, powerCorrected, 'linear');

end

