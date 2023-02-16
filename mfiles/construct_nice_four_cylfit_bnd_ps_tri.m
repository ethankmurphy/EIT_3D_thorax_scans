%-------------------------------------------------------------------------------
%
% Construct a nice set of boundary points (constructed from the smooth surface
% fit) and a nice triangulation from these points. 
%
%-------------------------------------------------------------------------------
function [bnd_pts, trib] = construct_nice_four_cylfit_bnd_ps_tri(bnd_pts,rbf4ps)

%-------------------------------------------------------------------------------
% Evaluate the smooth suface at fixed set of points
zs       = linspace(ceil(min(bnd_pts(:,3))),floor(max(bnd_pts(:,3))),24);
ts       = linspace(-pi,pi,48+1)'; 
ts       = ts(1:end-1);
bnd_pts  = [];
for n = 1:length(zs)
    bfitxyzs = eval_four_cylfit([ts zs(n)*ones(size(ts,1),1)],rbf4ps);
    bnd_pts  = [bnd_pts; bfitxyzs];
end

%-------------------------------------------------------------------------------
% figure
% plot3(bnd_pts(:,1),bnd_pts(:,2),bnd_pts(:,3),'.k','markersize',12)
% size(unique(bnd_pts,'rows'))
trib = manu_tribnd(bnd_pts);