function openCamera(obj)

obj.vid = videoinput('ni', 1, 'img0');
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

% this is also specific to ZCAMP3
set(obj.hCameraAxis, 'XDir', 'reverse');
set(obj.hCameraAxis, 'NextPlot', 'add');
obj.hSpots = plot(obj.hCameraAxis, 512, 512, 'rx');

frameSize = obj.vid.VideoResolution;
obj.mm2pxScaling = frameSize(1)/obj.cameraFOV; % here we assume square sensor and uniform scaling

