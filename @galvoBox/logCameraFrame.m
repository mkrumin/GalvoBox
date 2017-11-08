function logCameraFrame(obj)

timeStamp = datenum(clock);
frame = getsnapshot(obj.vid);

obj.nCameraFrames = obj.nCameraFrames + 1;
obj.cameraLog(obj.nCameraFrames).timeStamp = timeStamp;
obj.cameraLog(obj.nCameraFrames).cameraFrame = frame;
