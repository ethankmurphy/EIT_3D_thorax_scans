%--------------------------------------------------------------------------
%
% Make a best fitting smooth and simple boundary
%
%--------------------------------------------------------------------------
function [bmsh,bndfit] = constr_best_fit(colobj,elecs,tri,dbg_flg)

%--------------------------------------------------------------------------
elecs = elecs*1000; % Convert to mm

%--------------------------------------------------------------------------
% Make a best fitting RBF/fourier cylinder
is   = randsample(size(colobj.Location,1),30000);
ps   = double(colobj.Location(is,:))*100;
Nf   = 12;
Nzc  = 7;
sigz = 10;

%--------------------------------------------------------------------------
% Compute a fit to a RBF-eliptical cylinder
[pfits, rbf4ps]  = four_cylfit(ps,Nf,Nzc,sigz);
[bnd_pts, trib] = construct_nice_four_cylfit_bnd_ps_tri(ps,rbf4ps);
bnd_pts = bnd_pts*10;

%--------------------------------------------------------------------------
if dbg_flg == 1
    figure; hold on
    plot_colobj_tri(colobj,tri)
    trisurf(trib,bnd_pts(:,1)/1000,bnd_pts(:,2)/1000,bnd_pts(:,3)/1000,'facecolor','cyan','linestyle','none', ...
        'facealpha',0.5)
    plot3(1.01*elecs(:,1)/1000,1.01*elecs(:,2)/1000,1.01*elecs(:,3)/1000,'.m','markersize',20)
    axis equal
    for n = 1:size(elecs,1)
        text(1.03*elecs(n,1)/1000,1.03*elecs(n,2)/1000,1.03*elecs(n,3)/1000, ...
            num2str(n), ...
            'color','yellow')
    end
    view([10 6])
end
% saveas(gcf,'figs/cropped_labeled_reduced_simple_trisurf','png')

%--------------------------------------------------------------------------
% Output the 
bmsh.node = bnd_pts/1000;   % Output mesh nodes in meters
bmsh.tri  = trib;
bndfit.rbf4ps = rbf4ps;
bndfit.Nf     = Nf;
bndfit.Nzc    = Nzc;
bndfit.sigz   = sigz;
