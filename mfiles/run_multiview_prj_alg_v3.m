%--------------------------------------------------------------------------
%
% Run the projection algorithm
%
%--------------------------------------------------------------------------
function [mrk_ps,unlab_ps] = run_multiview_prj_alg_v3(colobj,tri,mrk_ps,unlab_ps)

%--------------------------------------------------------------------------
% Select azimuth and elevation angles for the projects directions
nazs  = 6;
azs   = linspace(0,2*pi,nazs+1);
azels = [azs(1:end-1)' -pi/2*ones(nazs,1)];


%--------------------------------------------------------------------------
% Initialize the plot
figure
set_fig_relsiz(0.8)
handles.newp   = [];
locs0          = double(colobj.Location);
handles.colobj = colobj;
for n = 1:nazs
    subplot(2,3,n);
    [colobj_prj{n},isks{n},tri_prj{n},newp_prj] = update_ply_state(handles,tri,azels(n,:));
    plot_colobj_tri(colobj_prj{n},tri_prj{n})
    azel_strs{n} = ['Az=',num2str(round(azels(n,1)*180/pi)),' El=',num2str(round(azels(n,2)*180/pi))];
    title(azel_strs{n})
    view(2);axis off
    drawnow
    
end

%--------------------------------------------------------------------------
% Click on the labeled stickers
if isempty(mrk_ps)
    clc_instructs = {'Pink (32)','Green (27)', ...
        'Purple (22)','Yellow (17)','Blue (12)','Orange(7)'};
    mrk_ps = zeros(6,3);
    n = 1;
    while n <= 6
        %----------------------------------------------------------------------
        sgtitle(['Click on ',clc_instructs{n}])
        [x,y]   = ginputWhite(1);
        ttl_inf = get(gca,'title');
        iax = find( strcmp(azel_strs,ttl_inf.String)==1 );
        
        %----------------------------------------------------------------------
        % Get index of the closest point in the point cloud
        locs_prc    = double(colobj_prj{iax}.Location(:,1:2));
        [~,i0]    = min( (locs_prc(:,1)-x).^2 + (locs_prc(:,2)-y).^2 );
        mrk_ps(n,:) = locs0(isks{iax}(i0),:);
        
        %----------------------------------------------------------------------
        % Update the plots with the points
        for k = 1:nazs
            subplot(2,3,k);hold on
            mrk_ps_prj = update_p(mrk_ps(n,:),azels(k,:));
            if ~isempty(mrk_ps_prj)
                plot3(mrk_ps_prj(1),mrk_ps_prj(2),mrk_ps_prj(3),'.r','markersize',16)
            end
        end
        drawnow
        
        %----------------------------------------------------------------------
        % Verify that the point is good.
        sgtitle([clc_instructs{n},': Is the Point Good? (Yes=Left click/No = Right click)'])
        [~,~,butt] = ginputWhite(1);
        if butt == 1
            n = n+1;
        else
            for k = 1:nazs
                subplot(2,3,k);
                cla
                hold on
                plot_colobj_tri(colobj_prj{k},tri_prj{k})
                if n > 1
                    mrk_ps_prj = update_p(mrk_ps(1:n-1,:),azels(k,:));
                    if ~isempty(mrk_ps_prj)
                        plot3(mrk_ps_prj(:,1),mrk_ps_prj(:,2),mrk_ps_prj(:,3),'.r','markersize',16)
                    end
                end
                title(azel_strs{k})
                view(2);axis off
                drawnow
                
            end
        end
    end
end

%--------------------------------------------------------------------------
% Click on the rest of the stickers
if isempty(unlab_ps)    
    unlab_ps = zeros(32,3);
    cnt      = 1;
else
    cnt      = size(unlab_ps,1)+1;
    for k = 1:nazs
        subplot(2,3,k);
        cla
        hold on
        plot_colobj_tri(colobj_prj{k},tri_prj{k})
        mrk_ps_prj = update_p(mrk_ps,azels(k,:));
        if ~isempty(mrk_ps_prj)
            plot3(mrk_ps_prj(:,1),mrk_ps_prj(:,2),mrk_ps_prj(:,3),'.r','markersize',16)
        end
        unlab_ps_prj = update_p(unlab_ps(1:cnt-1,:),azels(k,:));
        if ~isempty(mrk_ps_prj)
            plot3(unlab_ps_prj(:,1),unlab_ps_prj(:,2),unlab_ps_prj(:,3),'.g','markersize',16)
        end
        title(azel_strs{k})
        view(2);axis off
        drawnow
    end
end

butt     = 1;
while butt ~= 2
    %----------------------------------------------------------------------
    sgtitle({'(Left) Click on Unlabeled Electrodes, Middle Click when done, Right Click for Prior-point mistake', ...
        'In the example scans, there Electrodes 1-5 are ''hidden'' under the clasp on the sternum'})
    [x,y,butt] = ginputWhite(1);
    ttl_inf    = get(gca,'title');
    iax        = find( strcmp(azel_strs,ttl_inf.String)==1 );
    
    %----------------------------------------------------------------------
    %----------------------------------------------------------------------
    % Get index of the closest point in the point cloud
    locs_prc        = double(colobj_prj{iax}.Location(:,1:2));
    [~,i0]          = min( (locs_prc(:,1)-x).^2 + (locs_prc(:,2)-y).^2 );
    unlab_ps(cnt,:) = locs0(isks{iax}(i0),:);
    
    %----------------------------------------------------------------------
    % Update the plots with the points
    if butt == 1
        for k = 1:nazs
            subplot(2,3,k);hold on
            unlab_ps_prj = update_p(unlab_ps(cnt,:),azels(k,:));
            if ~isempty(unlab_ps_prj)
                plot3(unlab_ps_prj(1),unlab_ps_prj(2),unlab_ps_prj(3),'.g','markersize',16)
            end
        end
        drawnow
        cnt = cnt+1;
        
    elseif butt == 3
        cnt = cnt-1;
        for k = 1:nazs
            subplot(2,3,k);
            cla
            hold on
            plot_colobj_tri(colobj_prj{k},tri_prj{k})
            mrk_ps_prj = update_p(mrk_ps,azels(k,:));
            if ~isempty(mrk_ps_prj)
                plot3(mrk_ps_prj(:,1),mrk_ps_prj(:,2),mrk_ps_prj(:,3),'.r','markersize',16)
            end
            unlab_ps_prj = update_p(unlab_ps(1:cnt-1,:),azels(k,:));
            if ~isempty(mrk_ps_prj)
                plot3(unlab_ps_prj(:,1),unlab_ps_prj(:,2),unlab_ps_prj(:,3),'.g','markersize',16)
            end
            title(azel_strs{k})
            view(2);axis off
            drawnow
        end
    end
end
unlab_ps = unlab_ps(1:cnt-1,:);


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Update the figure
function [colobj,isk,tri,newp] = update_ply_state(handles,tri,azels2)

%--------------------------------------------------------------------------
% Load the surface and stop if there is no STL
colobj = handles.colobj;
newp   = handles.newp;
locs   = colobj.Location;
cols   = colobj.Color;



%--------------------------------------------------------------------------
% Rotate the STL to the temporary frame
az2   = azels2(1);
el2   = azels2(2);
Rz    = Rotz(az2);
Rx    = Rotx(el2);
locs  = (Rx*Rz*(locs'))';
if ~isempty(newp)
    newp  = (Rx*Rz*(newp'))';
end
%--------------------------------------------------------------------------
% If the plot plane flag is selected, we don't actually plot a plane,
% because its a point cloud and not a surface triangulation it messes up
% the visualization. So, instead we remove all points below the plane,
% which is just about like plotting an invisible wall..
z0          = 0;
ris         = find( locs(:,3) < z0);
isk         = 1:size(locs,1);
% locs(ris,:) = [];
% cols(ris,:) = [];
[locs,tri]   = update_tris_due_to_rmvnodes(locs,tri,ris);
cols(ris,:)  = [];
isk(ris)     = [];

if ~isempty(newp)
    ris         = find( newp(:,3) < z0);
    newp(ris,:) = [];
end
%---------------------------------------------------------------------------
colobj        = pointCloud(locs, 'Color', cols);


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Update the figure
function [outp] = update_p(inp,azels2)

%---------------------------------------------------------------------------
% Rotate the STL to the temporary frame
az2   = azels2(1);
el2   = azels2(2);
Rz    = Rotz(az2);
Rx    = Rotx(el2);
outp  = (Rx*Rz*(inp'))';

%---------------------------------------------------------------------------
% If the plot plane flag is selected, we don't actually plot a plane,
% because its a point cloud and not a surface triangulation it messes up
% the visualization. So, instead we remove all points below the plane,
% which is just about like plotting an invisible wall..
z0          = 0;
ris         = find( outp(:,3) < z0);
outp(ris,:) = [];


