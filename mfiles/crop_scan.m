%--------------------------------------------------------------------------
%
% Crop the scan to the area of interest. 
%
%--------------------------------------------------------------------------
function [colobj,tri] = crop_scan(colobj,tri,dbg_flg)

%--------------------------------------------------------------------------
% Downsample the ply data, it plots quickly
Ns        = min([20000 round(0.2*size(colobj.Location,1))]);
i_ds      = randsample(size(colobj.Location,1),Ns);
colobj_ds = pointCloud(colobj.Location(i_ds,:), 'Color', colobj.Color(i_ds,:) );

%--------------------------------------------------------------------------
% Crop the scans
figure;set_fig_relsiz(0.8)
hold on
pcshow(colobj,'Markersize',100);
axis equal;camlight left
lbl_fmt_fig('X (m)','Y (m)','Pick 4 points Clockwise from Top Right','','Z (m)',12)
view(2)
%--------------------------------------------------------------------------
% Select the cropping points
select_flag=1;
pt_count=1;
label_cnt=1;
for n = 1:4
    select = drawpoint;    
    if isempty(select.Position)==0
        centers(pt_count, :)=select.Position;
        %disp([num2str(pt_count),' point(s) recorded in this sub scan!'])
        pt_count=pt_count+1;
        plot(select.Position(1), select.Position(2), 'r.', 'MarkerSize', 30)
        plot(centers(:,1),centers(:,2),'-y')
    else
        select_flag=0;
    end
end
plot([centers(:,1); centers(1,1)],[centers(:,2); centers(1,2)],'-y')

%--------------------------------------------------------------------------
% Crop Points 
xmin = min(centers(:,1));
ymin = min(centers(:,2));
xmax = max(centers(:,1));
ymax = max(centers(:,2));
isk  = find( (colobj.Location(:,1) >= xmin) & (colobj.Location(:,1) <= xmax) & ...
    (colobj.Location(:,2) >= ymin) & (colobj.Location(:,2) <= ymax) );
ris  = setdiff(1:size(colobj.Location,1),isk);
%--------------------------
[locs,tri]   = update_tris_due_to_rmvnodes(colobj.Location,tri,ris);
cols         = colobj.Color;
cols(ris,:)  = [];

%--------------------------------------------------------------------------
% Reconstruct the point cloud object
colobj = pointCloud(locs, 'Color', uint8(cols(:,1:3)));
whos
%--------------------------------------------------------------------------
% Debugging
if dbg_flg == 1
    figure;
    plot_colobj_tri(colobj,tri)
    axis equal;camlight left
    view(2)
end
