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
hSpot = plot(hAxis, 512, 512, 'ro');

FOV = 8; %[mm] this is the field of view of the camera's full frame
frameSize = vid.VideoResolution;
mm2px = frameSize(1)/FOV; % here we assume square sensor and uniform scaling

hw = prepareHardware;
hw.s.outputSingleScan([5 5 0]);

vLaser  = 2.5;
vRangeX = -1:1;
vRangeY = -1:1;
[V.x, V.y] = meshgrid(vRangeX, vRangeY);
pos = struct('x', nan(size(V.x)), 'y', nan(size(V.y)));

nPoints = numel(V.x);
for iPoint = 1:nPoints
    hw.s.outputSingleScan([V.x(iPoint) V.y(iPoint) vLaser])
    pause(0.2); % wait until the galvos actually move (might be unnecessary)
    frame = getsnapshot(vid);
    [pos.x(iPoint), pos.y(iPoint)] = findSpot(frame);
    hSpot.XData = pos.x(iPoint);
    hSpot.YData = pos.y(iPoint);
    pause(0.1);
    %     [pos.x(iPoint), pos.y(iPoint)] = findSpot(hAxis);
end

px2vTransform = getTransform(pos, V);

% vEst = [pos.x(:), pos.y(:), ones(nPoints, 1)] * p2vTransform;
% figure;
% plot(V.x(:), V.y(:), 'o', vEst(:,1), vEst(:, 2), 'x')

%% testing calibration

for iPoint = 1:5
    x = ceil(rand*750)+125;
    y = ceil(rand*750)+125;
    hSpot.XData = x;
    hSpot.YData = y;
    hSpot.Marker = 'x';
    %     hSpot.MarkerSize = 10;
    %     pause(0.2)
    vxy = [x y 1]*px2vTransform;
    hw.s.outputSingleScan([vxy(1:2), vLaser])
    pause(0.5); % wait until the galvos actually move (might be unnecessary)
end

% park the mirrors, switch off the laser
hw.s.outputSingleScan([5 5 0]);

%% alignment to bregma-lambda axis

pause(0.2);
frame = getsnapshot(vid);
h = figure;
imagesc(frame);
colormap jet;
axis equal tight;
set(gca, 'XDir', 'reverse');
title('Click on Bregma');
[bregma.x, bregma.y] = ginput(1);
title('Click on Lambda');
[lambda.x, lambda.y] = ginput(1);
title('Click somewhere on the right hemisphere');
[right.x, right.y] = ginput(1);
close(h)
mm2pxTransform = alignToStereo(bregma, lambda, right, mm2px);

pxRightPPC = [1.7, -2, 1] * mm2pxTransform;
pxLeftPPC = [-1.7, -2, 1] * mm2pxTransform;
vXY_RightPPC = pxRightPPC * px2vTransform;
vXY_LeftPPC = pxLeftPPC * px2vTransform;
x = [bregma.x, lambda.x];
y = [bregma.y, lambda.y];
hSpot.XData = x;
hSpot.YData = y;
hSpot.Marker = 'o';

[xx , yy] = meshgrid(-4:4, -5:1);
coords = [xx(:), yy(:), ones(size(xx(:)))];
pxGrid = coords * mm2pxTransform;
plot(hAxis, pxGrid(:,1), pxGrid(:, 2), 'c.');

plot(hAxis, pxRightPPC(1), pxRightPPC(2), 'rx', pxLeftPPC(1), pxLeftPPC(2), 'cx');
hw.s.outputSingleScan([vXY_RightPPC(1:2), vLaser])
pause(3); % wait until the galvos actually move (might be unnecessary)
hw.s.outputSingleScan([vXY_LeftPPC(1:2), vLaser])
pause(3); % wait until the galvos actually move (might be unnecessary)
hw.s.outputSingleScan([5 5 0]);


