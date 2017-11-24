function calibrateStereotax(obj)

figure(obj.hCameraAxis.Parent)
obj.hCameraAxis.Parent.Pointer = 'crosshair';
t = title(obj.hCameraAxis, 'Where is Bregma?');
t.Visible = 'on';
gotBregma = false;
while ~gotBregma
    w = waitforbuttonpress;
    if w == 0
        click = obj.hCameraAxis.CurrentPoint;
        x = click(1, 1);
        y = click(1, 2);
        if prod(sign(obj.hCameraAxis.XLim - x))==-1 && ...
            prod(sign(obj.hCameraAxis.YLim - y))==-1
            bregma.x = x;
            bregma.y = y;
            gotBregma = true;
        else
            continue;
        end
    else
        continue;
    end
end

t = title('Where is Lambda?');
gotLambda = false;
while ~gotLambda
    w = waitforbuttonpress;
    if w == 0
        click = obj.hCameraAxis.CurrentPoint;
        x = click(1, 1);
        y = click(1, 2);
        if prod(sign(obj.hCameraAxis.XLim - x))==-1 && ...
            prod(sign(obj.hCameraAxis.YLim - y))==-1
            lambda.x = x;
            lambda.y = y;
            gotLambda = true;
        else
            continue;
        end
    else
        continue;
    end
end

t = title('Click somewhere on the right hemisphere');
gotRight = false;
while ~gotRight
    w = waitforbuttonpress;
    if w == 0
        click = obj.hCameraAxis.CurrentPoint;
        x = click(1, 1);
        y = click(1, 2);
        if prod(sign(obj.hCameraAxis.XLim - x))==-1 && ...
            prod(sign(obj.hCameraAxis.YLim - y))==-1
            right.x = x;
            right.y = y;
            gotRight = true;
        else
            continue;
        end
    else
        continue;
    end
end

obj.mm2pxTf = alignToStereo(bregma, lambda, right, obj.mm2pxScaling);

t.Visible = 'off';
obj.hCameraAxis.Parent.Pointer = 'arrow';

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


