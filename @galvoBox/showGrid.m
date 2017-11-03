function showGrid(obj)

% remove old grid if was already there
delete(obj.hGrid);

% These coordinates should span the whole FOV (and even more)
[xx , yy] = meshgrid(-5:5, -8:2);
coords = [xx(:), yy(:), ones(size(xx(:)))];
pxGrid = coords * obj.mm2pxTf;
pxBregma = [0 0 1] * obj.mm2pxTf;
gridX = reshape(pxGrid(:,1), size(xx));
gridY = reshape(pxGrid(:,2), size(yy));

% plotting the mm grid, and marking the bregma location
obj.hGrid = plot(obj.hCameraAxis, gridX, gridY, 'c:', gridX', gridY', 'c:', pxBregma(1), pxBregma(2), 'ro');

% raise the preview window
preview(obj.vid);

