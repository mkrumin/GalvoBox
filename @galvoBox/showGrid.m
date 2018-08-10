function showGrid(obj)

% remove old grid if was already there
delete(obj.hGrid);

% These coordinates should span the whole FOV (and even more)
[xx , yy] = meshgrid(0, 0);
coords = [xx(:), yy(:), ones(size(xx(:)))];
pxGrid = coords * obj.mm2pxTf;
pxBregma = [0 0 1] * obj.mm2pxTf;
gridX = reshape(pxGrid(:,1), size(xx));
gridY = reshape(pxGrid(:,2), size(yy));

% plotting the mm grid, and marking the bregma location
% obj.hGrid = plot(obj.hCameraAxis, gridX, gridY, 'c--', gridX', gridY', 'c--', pxBregma(1), pxBregma(2), 'ro');
obj.hGrid = plot(obj.hCameraAxis, gridX, gridY, 'co', 'MarkerSize', 4);
hTmp = plot(pxBregma(1), pxBregma(2), 'ro', 'MarkerSize', 8);
obj.hGrid = [obj.hGrid; hTmp];

% add 'minor' grid
[xx , yy] = meshgrid(-5:5, -6:3);
coords = [xx(:), yy(:), ones(size(xx(:)))];
pxGrid = coords * obj.mm2pxTf;
gridX = reshape(pxGrid(:,1), size(xx));
gridY = reshape(pxGrid(:,2), size(yy));
% plotting the mm grid, and marking the bregma location
hTmp = plot(obj.hCameraAxis, gridX, gridY, 'c.', 'MarkerSize', 4);
obj.hGrid = [obj.hGrid; hTmp];

for i=1:length(obj.hGrid)
    obj.hGrid(i).LineWidth = 0.25;
end

% raise the preview window
preview(obj.vid);

