function tf = alignToStereo(br, lam, rh, pxPerMm)

% this function will calculate the transform required to go from steretoxic
% coordinates to pixels on the camera
% br - bregma coordinates in pixels
% lam - lambda coordinates in pixels
% rh - coordinates of a location on the right hemisphere in pixels
% pxPerMm - scaling of camera pixels to real world mm

% tf - a 3-by-2 matrix, [mmX, mmY, 1]*tf = [pxX, pxY]

% Derivation of the solution:
% tf = [a b; c d; e f]
% Use bregma coordinates: [0 0 1]*tf=[br.x br.y] ==> [e f]=[br.x br.y]
% Use lambda coordinates: [0 y 1]*tf=[lam.x lam.y] ==> 
%       ==>[y*c+e y*d+f]=[lam.x lam.y]
%       ==> [y*c y*d]=[lam.x-br.x lam.y-br.y] 
%       ==> (y*c)/(y*d)=(lam.x-br.x)/(lam.y-br.y) 
%       ==> c=d*(lam.x-br.x)/(lam.y-br.y)
%       also, y is negative, so sign(d) = -sign(lam.y-br.y)
% 
% Use scaling factor:
% [0 1 1]*tf = [c+e d+f]; it is one mm from bregma ==> 
% ==> norm([c+e-br.x d+f-br.y]) = pxPerMm
% ==> norm([c d]) = pxPerMM
% ==> c^2+d^2 = pxPerMm^2
% ==> d^2 = pxPerMm^2/((lam.x-br.x)^2/(lam.y-br.y)^2 + 1)
% and use sign(d) = -sign(lam.y-br.y) from before

% [1 0 1]*tf = [a+e b+f]; it is one mm from bregma ==> 
% ==> norm([a+e-br.x b+f-br.y]) = pxPerMm
% ==> norm([a b]) = pxPerMM
% ==> a^2+b^2 = pxPerMm^2
% also [a+e b+f]-bregm ahould be orthogonal to lambda - bregma:
% a*(lam.x-br.x)+b*(lam.y-br.y) = 0
% ==> a = -b*(lam.y-br.y)/(lam.x-br.x);
% ==> b^2 = pxPerMm^2/((lam.y-br.y)^2/(lam.x-br.x)^2+1)

% Use rh point: 
% take cross-product between vectors from lam to rh, and from lam to br 
% the sign of the z component shoud be the same as if the rh was [1 0]
% from cross([rh.x-lam.x, rh.y-lam.y, 0], [br.x-lam.x, br.y-lam.y, 0])
% z component: z1=(rh.x-lam.x)*(br.y-lam.y)-(rh.y-lam.y)*(br.x-lam.x);
% from cross([a+br.x-lam.x, b+br.y-lam.y, 0], [br.x-lam.x, br.y-lam.y, 0])
% z component: z2=(a+br.x-lam.x)*(br.y-lam.y)-(b+br.y-lam.y)*(br.x-lam.x);
% check two solutions for [a,b], and pick one that gives the right result:
% sign(z1) == sign(z2)

e = br.x;
f = br.y;
d = pxPerMm / sqrt(((lam.x - e)^2 / (lam.y - f)^2 + 1));
d = d * sign(f - lam.y);
c=d*(lam.x - e)/(lam.y - f);
b = pxPerMm/sqrt(((lam.y-f)^2/(lam.x-e)^2+1));
a = -b*(lam.y-f)/(lam.x-e);
z1=(rh.x-lam.x)*(f-lam.y)-(rh.y-lam.y)*(e-lam.x)
z2=(a+e-lam.x)*(f-lam.y)-(b+f-lam.y)*(e-lam.x)
if sign(z1)~=sign(z2)
    a = -a;
    b = -b;
end
tf = [a b; c d; e f];