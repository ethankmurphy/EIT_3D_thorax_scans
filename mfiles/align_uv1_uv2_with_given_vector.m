%-------------------------------------------------------------------------------
%
% Get a rotation matrix and translation to the coordinate frame that has a 
% z-axis perpendicular to the plane that best fits the input points.
%
%-------------------------------------------------------------------------------
function [uv1,uv2] = align_uv1_uv2_with_given_vector(uv1,uv2,vec)

%-------------------------------------------------------------------------------
% Rotate the uv1 vector so its most aligned with the x-axis
bestt         = fminbnd( @(t) rot_uv1basis_align(t,uv1,uv2,vec),0,2*pi);
[tmp,uv1,uv2] = rot_uv1basis_align(bestt,uv1,uv2,vec);


%-------------------------------------------------------------------------------
%
% rot_uv1basis_align
%
%-------------------------------------------------------------------------------
function [delt,uv1r,uv2r] = rot_uv1basis_align(t,uv1,uv2,vec)

%-------------------------------------------------------------------------------
% Rotate a vector representing 100% in the uv1 direction to be some angle
% off from this
R   = [cos(t) -sin(t); sin(t) cos(t)];
vr1 = R*[1;0];
vr2 = R*[0;1];

%-------------------------------------------------------------------------------
% Get the rotated vectors
uv1r = vr1(1) * uv1 + vr1(2)*uv2;
uv2r = vr2(1) * uv1 + vr2(2)*uv2;
% [norm(uv1r) norm(uv2r) dot(uv1r,uv2r)]
%-------------------------------------------------------------------------------
% Calculate the angle between uv1r and [1 0 0];
delt = abs( acos(dot(uv1r,vec)) );