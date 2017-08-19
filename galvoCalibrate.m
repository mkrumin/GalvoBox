function galvoCalibrate

% This function will make the voltage to position calibration of the system

% open the camera

cam = VideoInput('ni', 'img0');
preview(cam);
FOV = 4; %[mm] this is the field of view of the camera's full frame

hw = prepareHardware;
vLaser  = 0.1;

for iPoint = 1:nPoints
    hw.s.outputSingleScan([V.x(iPoint) V.y(iPoint) vLaser])
    frame = getsnapshot(cam);
    [x(iPoint) y(iPoint)] = findSpot(frame);
end