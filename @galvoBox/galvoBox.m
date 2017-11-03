classdef galvoBox < handle
    properties
        hw
        vid
        hPreview
        hCameraAxis
        hSpots
        mm2pxScaling 
        px2vTf
        mm2pxTf
        cameraFOV
        laserLUT
        galvoUDP
        testUDP
    end
    
    properties (Access = 'private')
        cleanup
    end
    
    methods
        function obj = galvoBox()
            obj.px2vTf = eye(3);
            obj.mm2pxTf = eye(3);
            obj.cameraFOV = 8; % [mm]
            obj.laserLUT = loadLaserLUT;
            obj.startGalvoListener;
            obj.startTestUDP;
            obj.prepareHardware;
            obj.openCamera;
            obj.cleanup = onCleanup({@delete, obj});
        end
        
        function delete(obj)
            obj.releaseHardware;
            if isvalid(obj.vid)
                closepreview(obj.vid);
                delete(obj.vid);
            end
            fclose(obj.galvoUDP);
            delete(obj.galvoUDP);
            fclose(obj.testUDP);
            delete(obj.testUDP);
        end
    end
end