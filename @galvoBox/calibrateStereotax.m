function calibrateStereotax(obj)

pause(0.2)
frame = getsnapshot(obj.vid);
h = figure;
imagesc(frame);
colormap jet;
axis equal tight;
set(gca, 'XDir', 'reverse');
title('Click on Bregma');
[bregma.x, bregma.y] = ginput(1);
title('Click on Lambda');
[lambda.x, lambda.y] = ginput(1);
title('Click somewhere on the right hemisphere');
[right.x, right.y] = ginput(1);
close(h)
obj.mm2pxTf = alignToStereo(bregma, lambda, right, obj.mm2pxScaling);

% pxRightPPC = [1.7, -2, 1] * mm2pxTransform;
% pxLeftPPC = [-1.7, -2, 1] * mm2pxTransform;
% vXY_RightPPC = pxRightPPC * px2vTransform;
% vXY_LeftPPC = pxLeftPPC * px2vTransform;
% x = [bregma.x, lambda.x];
% y = [bregma.y, lambda.y];
% hSpot.XData = x;
% hSpot.YData = y;
% hSpot.Marker = 'o';
% 

obj.parkGalvos;


