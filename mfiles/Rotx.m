%-------------------------------------------------------------------------------
% 
% A rotation matrix about the x-axis of angle t (deg)
% 
% I just use the one from https://en.wikipedia.org/wiki/Rotation_matrix. It
% seems to be the standard def.
% 
%-------------------------------------------------------------------------------
function R = Rotx(t)

R = [1 0 0; 0 cos(t) -sin(t); 0 sin(t) cos(t)];