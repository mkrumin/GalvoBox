function tf = getTransform(coordsIn, coordsOut)

nPoints = length(coordsIn.x(:));

cIn = [coordsIn.x(:), coordsIn.y(:), ones(nPoints, 1)];
cOut = [coordsOut.x(:), coordsOut.y(:)];

% we need to find tf that solves this equation: cIn*tf=cOut

tf = pinv(cIn)*cOut;
% add third column, so that the output will be of the form [xOut, yOut, 1]
% this way you can apply several transforms in a single command
tf = cat(2, tf, [0 0 1]');