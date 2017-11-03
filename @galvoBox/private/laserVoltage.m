function volts = laserVoltage(o, power)

%LASERVOLTAGE Summary of this function goes here
%    this function will map laser power to voltages using o.laserLUT look-up table
%   Detailed explanation goes here

minP = min(o.laserLUT.pow(:));
maxP = max(o.laserLUT.pow(:));
if any(power(:)>maxP)
    str = sprintf('Some of the required laser power values are ABOVE the MAX possible value of %d mW', maxP);
    str = strcat(str, sprintf('\nClipping laser power at %d mW', maxP));
    warning(str);
    power = min(power, maxP);
end
if any(power(:)<minP)
    str = sprintf('Some of the required laser power values are BELOW the MIN possible value of %d mW', minP);
    str = strcat(str, sprintf('\nClipping laser power at %d mW', minP));
    warning(str);
    power = max(power, minP);
end

volts = interp1(o.laserLUT.pow, o.laserLUT.v, power);

end

