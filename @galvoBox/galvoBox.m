classdef galvoBox < handle
    properties
        hw
        vid
        hPreview
        previewAxis
        mm2pxScaling 
        px2vTf
        mm2pxTf
        cameraFOV
        laserLUT
        galvoUDP
        testUDP
        cleanup
    end
    methods 
        function obj = galvoBox(varargin)
            obj.px2vTf = eye(3);
            obj.mm2pxTf = eye(3);
            obj.cameraFOV = 8; % [mm]
            obj.laserLUT = loadLaserLUT;
            obj.startGalvoListener;
            obj.startTestUDP;
            obj.prepareHardware;
            obj.cleanup = onCleanup({@delete, obj});
        end
        
        function delete(obj)
            obj.releaseHardware;
            fclose(obj.galvoUDP);
            delete(obj.galvoUDP);
            fclose(obj.testUDP);
            delete(obj.testUDP);
        end
    end
end