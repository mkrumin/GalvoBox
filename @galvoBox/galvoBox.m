classdef galvoBox < handle
    properties
        hw
        px2vTf
        mm2pxTf
        cameraFOV
        laserLUT
        galvoUDP
        testUDP
    end
    methods 
        function obj = galvoBox(varargin)
            obj.px2vTf = eye(3);
            obj.mm2pxTf = eye(3);
            obj.cameraFOV = 8; % [mm]
            obj.laserLUT = loadLaserLUT;
            obj.galvoUDP = startGalvoListener;
            obj.testUDP = startTestUDP;
        end
    end
end