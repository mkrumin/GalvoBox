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

FOV = 8; %[mm] this is the field of view of the camera's full frame

hw = prepareHardware;
hw.s.outputSingleScan([0 0 0]);
pause(1);
backFrame = fliplr(getsnapshot(vid));

vLaser  = 2.5;
vRangeX = -1:1;
vRangeY = -1:1;
[V.x, V.y] = meshgrid(vRangeX, vRangeY);
pos = struct('x', nan(size(V.x)), 'y', nan(size(V.y)));

nPoints = numel(V.x);
for iPoint = 1:nPoints
    hw.s.outputSingleScan([V.x(iPoint) V.y(iPoint) vLaser])
    pause(2); % wait until the galvos actually move (might be unnecessary)
    frame = getsnapshot(vid);
    [pos.x(iPoint), pos.y(iPoint)] = findSpot(fliplr(frame));
%     [pos.x(iPoint), pos.y(iPoint)] = findSpot(hAxis);
end

p2vTransform = getTransform(pos, V);

% vEst = [pos.x(:), pos.y(:), ones(nPoints, 1)] * p2vTransform;
% figure;
% plot(V.x(:), V.y(:), 'o', vEst(:,1), vEst(:, 2), 'x')

%% testing calibration
% h = figure;
% im = imagesc(backFrame);
% for iPoint = 1:5
%     im.CData = backFrame;
%     axis equal tight;
%     x = ceil(rand*1024);
%     y = ceil(rand*1024);
%     hold on;
%     plot(x, y, 'ro');
%     vxy = [x y 1]*p2vTransform;
%     hw.s.outputSingleScan([vxy, vLaser])
%     pause(3); % wait until the galvos actually move (might be unnecessary)
%     frame = fliplr(getsnapshot(vid));
%     im.CData = frame;
%     pause(3);
% end
% 
% 
