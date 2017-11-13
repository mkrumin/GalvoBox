function stopExperiment(obj)

% stop stimuation if still running
obj.stopZapping;

% save the data and the object (for different needs) locally
[folder, filename] = dat.expPath(obj.ExpRef, 'main', 'local');
filenameData = [filename, '_zapData.mat'];
filenameObj = [filename, '_zapObject.mat'];
zap = struct;
zap.ExpRef = obj.ExpRef;
zap.rig = hostname;
zap.mm2pxScaling = obj.mm2pxScaling; 
zap.px2vTf = obj.px2vTf;
zap.mm2pxTf = obj.mm2pxTf;
zap.cameraFOV = obj.cameraFOV;
zap.laserLUT = obj.laserLUT;
zap.UDPLog = obj.UDPLog;
zap.cameraLog = obj.cameraLog;

if ~exist(folder, 'dir')
    mkdir(folder);
end
save(fullfile(folder, filenameData), 'zap');
warning('off', 'MATLAB:Figure:FigureSavedToMATFile');
save(fullfile(folder, filenameObj), 'obj');

% clean the logs befor the next possible experiment
obj.UDPLog = struct('timeStamp', [], 'msg', '');
obj.nUDPs = 0;
obj.cameraLog = struct('timeStamp', [], 'iTrial', [], 'cameraFrame', []);
obj.nCameraFrames = 0;
obj.ExpRef = '';
