function startExperiment(obj, ExpRef)

obj.ExpRef = ExpRef;
% doing some cleanup, in case the previous experiment didn't end with ExpEnd
obj.iTrial = 0;
% only keep the last UDP, which should be ExpStart...
obj.UDPLog = obj.UDPLog(end); 
obj.nUDPs = 1;
obj.cameraLog = struct('timeStamp', [], 'iTrial', [], 'cameraFrame', []);
obj.nCameraFrames = 0;

try
    if ~isvalid(obj.hw.s)
        obj.prepareHardware;
    end
catch e
    fprintf('\nHardware initialization failed with the following message:\n');
    fprintf('%s\n', e.message);
end
