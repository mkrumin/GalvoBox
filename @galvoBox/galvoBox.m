classdef galvoBox < handle
    properties
        ExpRef
        iTrial
        hw
        parkingState
        vid
        hPreview
        hCameraAxis
        hSpots
        hGrid
        mm2pxScaling 
        px2vTf
        mm2pxTf
        cameraFOV
        laserLUT
        galvoUDP
        testUDP
        UDPLog
        nUDPs
        cameraLog
        nCameraFrames
    end
    
    properties (Access = 'private')
        cleanup
    end
    
    methods
        function obj = galvoBox()
            obj.ExpRef = '';
            obj.iTrial = 0;
            obj.px2vTf = eye(3);
            obj.mm2pxTf = eye(3);
            obj.cameraFOV = 7.5; % [mm]
            obj.laserLUT = loadLaserLUT;
            obj.UDPLog = struct('timeStamp', [], 'msg', '');
            obj.nUDPs = 0;
            obj.cameraLog = struct('timeStamp', [], 'iTrial', [], 'cameraFrame', []);
            obj.nCameraFrames = 0;
            obj.startGalvoListener;
            obj.startTestUDP;
            obj.prepareHardware;
            obj.parkingState = [6 6 0];
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