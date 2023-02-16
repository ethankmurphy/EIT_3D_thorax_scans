%--------------------------------------------------------------------------
%
% 
%
%--------------------------------------------------------------------------
clear
clc
close all

%--------------------------------------------------------------------------
% Set parameters
repo_pth = [];      % Path of where processed data will be saved/loaded
dbg_flg  = 1;       % Debug flag

%--------------------------------------------------------------------------
% Add paths
addpath mfiles


%--------------------------------------------------------------------------
% Set the scan name and path to be analyzed
if dbg_flg == 0
    [file,path] = uigetfile('*.PLY');   % Select the file of interest
else    % Debugging
    path = 'example';
    % file = '1668006712.5371242.ply';
    file = '1675357621.1471639.ply';
end
if isempty(repo_pth)
    repo_pth = path;
end

%--------------------------------------------------------------------------
% Load the selec scan
tic
ply_matnam = [ifdec(file(1:end-4)),'_crop'];
if filechecker(repo_pth,[ply_matnam,'.mat']) == 0
    %----------------------------------------------------------------------
    % Read in the ply file
    [colobj0,tri,locs,cols] = read_Heges_ply_v2(path,file,0);
    %----------------------------------------------------------------------
    % Remove the black points
    ris          = find( sum(double(colobj0.Color),2) < 2);
    [locs,tri]   = update_tris_due_to_rmvnodes(locs,tri,ris);
    cols(ris,:)  = [];    
    %----------------------------------------------------------------------
    colobj1 = pointCloud(locs, 'Color', uint8(cols(:,1:3)));
    %----------------------------------------------------------------------
    % Make sure we only are considering unique nodes in the raw scan
    locs            = round(double(locs),6);
    [tri,locs,cols] = remove_repeated_nodes(tri,locs,cols);    
    colobj          = pointCloud(locs, 'Color', uint8(cols(:,1:3)));

    %----------------------------------------------------------------------
    % Crop the image
    [colobj,tri] = crop_scan(colobj,tri,dbg_flg);
    locs         = colobj.Location;
    %----------------------------------------------
    % Rotate so Z is in the axial direction
    Rx           = Rotx(pi/2);
    locs         = (Rx*(locs'))';        
    %----------------------------------------------
    % Demean
    cent0  = mean(locs,1);
    locs   = locs - repmat(cent0,size(locs,1),1);
    colobj = pointCloud(locs, 'Color',colobj.Color);
    %----------------------------------------------------------------------
    % Save the data
    load_crop_time = toc
    eval(['save ',repo_pth,'/',ply_matnam,' colobj tri load_crop_time'])
else
    %----------------------------------------------------------------------
    % Load the data

    eval(['load ',repo_pth,'/',ply_matnam,' colobj tri load_crop_time'])
end


%--------------------------------------------------------------------------
% Debugging
if dbg_flg == 1
    figure;
    plot_colobj_tri(colobj,tri)
    view(3)
    axis equal;camlight headlight
end

%--------------------------------------------------------------------------
% Run the multiview project algorithm, which shows several view of the 
% scan a user can relatively quickly click on all the electrodes        
ply_matnam = [ifdec(file(1:end-4)),'_segps'];        
if filechecker(repo_pth,[ply_matnam,'.mat']) == 0
    %---------------------------------------------------------------------- 
    tic
    elecs    = NaN*ones(32,3);
    emiss    = find(isnan(elecs(:,1))==1);
    mrk_ps   = [];
    unlab_ps = [];
    while ~isempty(emiss)
        %------------------------------------------------------------------
        [mrk_ps,unlab_ps] = run_multiview_prj_alg_v3(colobj,tri,mrk_ps,unlab_ps);
                
        %------------------------------------------------------------------
        % Order the electrodes
        elecs = ord_elecs(mrk_ps,unlab_ps,0);
        emiss = find(isnan(elecs(:,1))==1);
        if ~isempty(emiss)
            % error('stop: unlabeled electrodes')
            warning(['unlabeled electrodes: ',num2str(emiss')])
        else
            disp('All electrodes found')
        end
    end
    %----------------------------------------------------------------------
    % Save the data
    click_time = toc
    eval(['save ',repo_pth,'/',ply_matnam,' elecs mrk_ps unlab_ps click_time'])
else
    %----------------------------------------------------------------------
    % Load the data
    eval(['load ',repo_pth,'/',ply_matnam,' elecs mrk_ps unlab_ps click_time'])
    if exist('elecs','var') == 0
        % error('stop: re-run electrode finding function')
        try
            ply_matnam     = [ifdec(file(1:end-4)),'_boundmesh_elecs'];
            eval(['load ',repo_pth,'/',ply_matnam,' elecs colobj tri bndfit',  ...
                ' total_time order_fit_time click_time load_crop_time'])
        catch
            disp('Need to re-run elec finding function')
        end
    end
end

%--------------------------------------------------------------------------
% Level the scan and electrodes
tic
[colobj,elecs,tri] = level_elecs_scans(colobj,elecs,tri);

%--------------------------------------------------------------------------
% Make a best fitting smooth and simple boundary
[bmsh,bndfit]  = constr_best_fit(colobj,elecs,tri,0);
ply_matnam     = [ifdec(file(1:end-4)),'_boundmesh_elecs'];
order_fit_time = toc;
total_time     = order_fit_time + click_time + load_crop_time; 
eval(['save ',repo_pth,'/',ply_matnam,' bmsh elecs colobj tri bndfit',  ...
    ' total_time order_fit_time click_time load_crop_time'])

disp([' Load/Crop time: ',num2str(round(load_crop_time,1)),' s'])
disp(['Elec Click time: ',num2str(round(click_time,1)),' s'])  
disp(['Elec Order time: ',num2str(round(order_fit_time,1)),' s'])
disp(['     Total time: ',num2str(round(total_time,1)),' s'])


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Save a final summary figure
%-------------------------------------
figure; hold on
plot_colobj_tri(colobj,tri)
trisurf(bmsh.tri,bmsh.node(:,1),bmsh.node(:,2),bmsh.node(:,3),'facecolor','cyan','linestyle','none', ...
    'facealpha',0.5)
plot3(1.01*elecs(:,1),1.01*elecs(:,2),1.01*elecs(:,3),'.m','markersize',20)
axis equal
for n = 1:size(elecs,1)
    text(1.03*elecs(n,1),1.03*elecs(n,2),1.03*elecs(n,3), ...
        num2str(n), ...
        'color','yellow')
end
title(['Example scan: ',file])
view([10 6])
saveas(gcf,'example_3Dscan_processed','png')

