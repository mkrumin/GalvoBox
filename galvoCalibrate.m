function p2vTransform = galvoCalibrate

% This function will make the voltage-to-position calibration of the system

% open the camera

% this is specific to the ZCAMP3 rig
vid = videoinput('ni', 1, 'img0');
src = getselectedsource(vid);
vid.FramesPerTrigger = 1;
hPreview = preview(vid);
hAxis = get(hPreview, 'Parent');

set(hPreview, 'CDataMapping', 'scaled');
set(hAxis, 'CLim', [0 255]);

% this is also specific to ZCAMP3
set(hAxis, 'XDir', 'reverse');
set(hAxis, 'NextPlot', 'add');
hSpot = plot(hAxis, 1, 1, 'ro');

FOV = 8; %[mm] this is the field of view of the camera's full frame

hw = prepareHardware;
hw.s.outputSingleScan([0 0 0]);
pause(1);
backFrame = fliplr(getsnapshot(vid));

vLaser  = 2.5;
vRangeX = -2:2;
vRangeY = -2:3;
[V.x, V.y] = meshgrid(vRangeX, vRangeY);
pos = struct('x', nan(size(V.x)), 'y', nan(size(V.y)));

nPoints = numel(V.x);
for iPoint = 1:nPoints
    hw.s.outputSingleScan([V.x(iPoint) V.y(iPoint) vLaser])
    pause(0.3); % wait until the galvos actually move (might be unnecessary)
    frame = getsnapshot(vid);
    [pos.x(iPoint), pos.y(iPoint)] = findSpot(frame);
    hSpot.XData = pos.x(iPoint);
    hSpot.YData = pos.y(iPoint);
    pause(0.8);
%     [pos.x(iPoint), pos.y(iPoint)] = findSpot(hAxis);
end

p2vTransform = getTransform(pos, V);

% vEst = [pos.x(:), pos.y(:), ones(nPoints, 1)] * p2vTransform;
% figure;
% plot(V.x(:), V.y(:), 'o', vEst(:,1), vEst(:, 2), 'x')

%% testing calibration

for iPoint = 1:20
    x = ceil(rand*800)+100;
    y = ceil(rand*800)+100;
    hSpot.XData = x;
    hSpot.YData = y;
    hSpot.Marker = 'x';
%     hSpot.MarkerSize = 10;
    pause(0.5)
    vxy = [x y 1]*p2vTransform;
    hw.s.outputSingleScan([vxy, vLaser])
    pause(1); % wait until the galvos actually move (might be unnecessary)
end

% park the mirrors, switch off the laser
hw.s.outputSingleScan([5 5 0]);

