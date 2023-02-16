%-------------------------------------------------------------------------------
% 
% A rotation matrix about the z-axis of angle t (deg)
% 
% I just use the one from https://en.wikipedia.org/wiki/Rotation_matrix. It
% seems to be the standard def.
% 
%-------------------------------------------------------------------------------
function R = Rotz(t)

R = [cos(t) -sin(t) 0; sin(t) cos(t) 0; 0 0 1];