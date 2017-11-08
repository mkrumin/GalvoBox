function startExperiment(obj, ExpRef)

obj.ExpRef = ExpRef;
try
    if ~isvalid(obj.hw.s)
        obj.prepareHardware;
    end
catch e
    fprintf('\nHardware initialization failed with the following message:\n');
    fprintf('%s\n', e.message);
end
