function openCamera(obj)

obj.vid = videoinput('winvideo', 2, 'Y800_640x480');
obj.vid.FramesPerTrigger = 1;
figure;
obj.hPreview = imagesc(randn(obj.vid.VideoResolution));
preview(obj.vid, obj.hPreview);
obj.hCameraAxis = get(obj.hPreview, 'Parent');
axis(obj.hCameraAxis, 'equal');
obj.hCameraAxis.XLim = obj.hPreview.XData;
obj.hCameraAxis.YLim = obj.hPreview.YData;

set(obj.hPreview, 'CDataMapping', 'scaled');
set(obj.hCameraAxis, 'CLim', [0 255]);

frameSize = obj.vid.VideoResolution;
obj.mm2pxScaling = max(frameSize)/obj.cameraFOV; % here we assume square sensor and uniform scaling

% set the orientation of the camera (rig-dependent)
[~, hostname] = system('hostname');
hostname = hostname(1:end-1);
switch upper(hostname)
    case 'ZCAMP3'
        set(obj.hCameraAxis, 'XDir', 'reverse');
    case 'ZOOPHILE'
        set(obj.hCameraAxis, 'CameraUpVector',[-1 0 0]);
        set(obj.hCameraAxis, 'YDir', 'normal');
        set(obj.vid.Source, 'Exposure', -6);
        set(obj.vid.Source, 'FrameRate', '30.0000');
    otherwise
end

set(obj.hCameraAxis, 'NextPlot', 'add');
obj.hSpots = plot(obj.hCameraAxis, ...
    frameSize(1)/2, frameSize(2)/2, 'rx');
