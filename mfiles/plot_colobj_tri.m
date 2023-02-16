%--------------------------------------------------------------------------
%
% Plot the point cloud as a surface that is
%
%--------------------------------------------------------------------------
function plot_colobj_tri(colobj,tri,facealpha)
if nargin < 3
    facealpha = 1;
end

locs     = double(colobj.Location);
col_nds  = double(colobj.Color)/255;
col_face = zeros(1,size(tri,1),3);
col_face(1,:,1) = 1/3*( col_nds(tri(:,1),1)+col_nds(tri(:,2),1)+col_nds(tri(:,3),1) );
col_face(1,:,2) = 1/3*( col_nds(tri(:,1),2)+col_nds(tri(:,2),2)+col_nds(tri(:,3),2) );
col_face(1,:,3) = 1/3*( col_nds(tri(:,1),3)+col_nds(tri(:,2),3)+col_nds(tri(:,3),3) );
patch( ...
    [locs(tri(:,1),1) locs(tri(:,2),1) locs(tri(:,3),1)]', ...
    [locs(tri(:,1),2) locs(tri(:,2),2) locs(tri(:,3),2)]', ...
    [locs(tri(:,1),3) locs(tri(:,2),3) locs(tri(:,3),3)]', ...
    col_face,'linestyle','none','facealpha',facealpha)
