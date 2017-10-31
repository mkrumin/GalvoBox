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
% [xx , yy] = meshgrid(-4:4, -5:1);
% coords = [xx(:), yy(:), ones(size(xx(:)))];
% pxGrid = coords * mm2pxTransform;
% plot(hAxis, pxGrid(:,1), pxGrid(:, 2), 'c.');
% 
% plot(hAxis, pxRightPPC(1), pxRightPPC(2), 'rx', pxLeftPPC(1), pxLeftPPC(2), 'cx');
% obj.gotoV([vXY_RightPPC(1:2), vLaser])
% pause(3); % wait until the galvos actually move (might be unnecessary)
% obj.gotoV([vXY_LeftPPC(1:2), vLaser])
% pause(3); % wait until the galvos actually move (might be unnecessary)

obj.parkGalvos;


