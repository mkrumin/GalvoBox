function calibrateGalvos(obj)

% This function will make the voltage-to-position calibration of the system

% open the camera

% this is specific to the ZCAMP3 rig
vid = videoinput('ni', 1, 'img0');
vid.FramesPerTrigger = 1;
hPreview = preview(vid);
hAxis = get(hPreview, 'Parent');

set(hPreview, 'CDataMapping', 'scaled');
set(hAxis, 'CLim', [0 255]);

% this is also specific to ZCAMP3
set(hAxis, 'XDir', 'reverse');
set(hAxis, 'NextPlot', 'add');
hSpot = plot(hAxis, 512, 512, 'ro');

frameSize = vid.VideoResolution;
obj.mm2pxScaling = frameSize(1)/obj.cameraFOV; % here we assume square sensor and uniform scaling

obj.vid = vid;
obj.hPreview = hPreview;
obj.previewAxis = hAxis;
obj.prepareHardware;
obj.parkGalvos;

vLaser  = laserPow2V(obj, 1); % 1mW
vRangeX = -1:1;
vRangeY = -1:1;
[V.x, V.y] = meshgrid(vRangeX, vRangeY);
pos = struct('x', nan(size(V.x)), 'y', nan(size(V.y)));

nPoints = numel(V.x);
for iPoint = 1:nPoints
    obj.gotoV([V.x(iPoint) V.y(iPoint) vLaser])
    pause(0.2); % wait until the galvos actually move (might be unnecessary)
    frame = getsnapshot(obj.vid);
    [pos.x(iPoint), pos.y(iPoint)] = findSpot(frame);
    hSpot.XData = pos.x(iPoint);
    hSpot.YData = pos.y(iPoint);
    pause(0.1);
    %     [pos.x(iPoint), pos.y(iPoint)] = findSpot(hAxis);
end

obj.px2vTf = getTransform(pos, V);

% park the mirrors, switch off the laser
obj.parkGalvos;
