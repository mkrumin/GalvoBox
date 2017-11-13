function logCameraFrame(obj)

timeStamp = datenum(clock);
frame = getsnapshot(obj.vid);
binning = 4;
frame = imresize(frame, 1/binning);

obj.nCameraFrames = obj.nCameraFrames + 1;
obj.cameraLog(obj.nCameraFrames).timeStamp = timeStamp;
obj.cameraLog(obj.nCameraFrames).iTrial = obj.iTrial;
obj.cameraLog(obj.nCameraFrames).cameraFrame = frame;
obj.cameraLog(obj.nCameraFrames).binning = binning;
