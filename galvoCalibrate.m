function galvoCalibrate

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

FOV = 8; %[mm] this is the field of view of the camera's full frame

hw = prepareHardware;
vLaser  = 0.1;
vRangeX = -2:0.5:2;
vRangeY = -2:0.5:2;
[V.x, V.y] = meshgrid(vRangeX, vRangeY);
pos = struct('x', nan(size(V.x)), 'y', nan(size(V.y)));

nPoints = numel(V.x);
for iPoint = 1:nPoints
    hw.s.outputSingleScan([V.x(iPoint) V.y(iPoint) vLaser])
    pause(0.01); % wait until the galvos actually move (might be unnecessary)
    frame = getsnapshot(vid);
    [pos.x(iPoint), pos.y(iPoint)] = findSpot(frame);
end

p2vTransfrom = getTransform(pos, V);