function calibrateGalvos(obj)

% This function will make the voltage-to-position calibration of the system

obj.parkGalvos;

power = 1; % [mW]
vLaser  = laserVoltage(obj, power); % 1mW
vRangeX = -1:1;
vRangeY = -1:1;
[V.x, V.y] = meshgrid(vRangeX, vRangeY);
pos = struct('x', nan(size(V.x)), 'y', nan(size(V.y)));

nPoints = numel(V.x);
% raise the window with the camera preview
preview(obj.vid);
for iPoint = 1:nPoints
    obj.gotoV([V.x(iPoint) V.y(iPoint) vLaser])
    pause(0.2); % wait until the galvos actually move (might be unnecessary)
    frame = getsnapshot(obj.vid);
    [pos.x(iPoint), pos.y(iPoint)] = findSpot(frame);
    obj.hSpots.XData = pos.x(iPoint);
    obj.hSpots.YData = pos.y(iPoint);
    obj.hSpots.Marker = 'o';
    pause(0.1);
    %     [pos.x(iPoint), pos.y(iPoint)] = findSpot(hAxis);
end

obj.px2vTf = getTransform(pos, V);

% let's put the marker at the location that corresponds to Vxy = [0 0]
galvoZero = [0 0 1] *inv(obj.px2vTf);
obj.hSpots.XData = galvoZero(1);
obj.hSpots.YData = galvoZero(2);
obj.hSpots.Marker = 'x';

% park the mirrors, switch off the laser
obj.parkGalvos;
