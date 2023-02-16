%--------------------------------------------------------------------------
%
% Level the scan and electrodes: Here we level the scan based on the the
% plane the best fits to the electrodes (should be the horizontal plane)
%
%--------------------------------------------------------------------------
function [colobj,elecs,tri] = level_elecs_scans(colobj,elecs,tri)

%--------------------------------------------------------------------------
[nvec,cent,long_ax,shrt_ax,svec] = get_nrmal_vec(elecs);
[shrt_ax,long_ax] = align_uv1_uv2_with_given_vector(shrt_ax,long_ax,[0 1 0]);
R                 = [long_ax shrt_ax nvec];
% Demean 
elecs = elecs - repmat(cent,size(elecs,1),1);
pts   = double(colobj.Location) - repmat(cent,size(colobj.Location,1),1);
%--------------------------------------------------------------------------
% And rotate
elecs  = ( (R')*(elecs'))';
pts    = ( (R')*(pts'))';

%--------------------------------------------------------------------------
% We want to crop the triangulation so its level... A reasonable way to do
% this would be to angularly discretize the surface and find the maximum
% and mininum at all the angular intervals. Then for the top we want to
% take the minimum of all the maxima and vice versa for the minima. After
% that we'll just adjust the triangulation so everything is copacetic
angs  = linspace(-pi,pi,33);angs = angs(1:end-1);
maxzs = zeros(length(angs)-1,1);
minzs = zeros(length(angs)-1,1);
ts    = atan2(pts(:,2),pts(:,1));
for n = 1:length(angs)-1
    is = find( (angs(n) <= ts) & (ts <= angs(n+1)) );
    maxzs(n) = max(pts(is,3));
    minzs(n) = min(pts(is,3));
end
%------------------------------
% Crop
ris         = find( (pts(:,3) > min(maxzs)) | (pts(:,3) < max(minzs)) );
[pts,tri]   = update_tris_due_to_rmvnodes(pts,tri,ris);
cols        = colobj.Color;
cols(ris,:) = [];

%--------------------------------------------------------------------------
colobj = pointCloud(pts, 'Color', cols );



