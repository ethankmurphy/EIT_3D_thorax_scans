%-------------------------------------------------------------------------------
% 
% Get the normal vector from a set of points P x D, where P is the number
% of samples and D is the dimension of each point.
% 
%-------------------------------------------------------------------------------
function [nvec,cent,long_ax,shrt_ax,svec] = get_nrmal_vec(pts)

%-------------------------------------------------------------------------------
cent = mean(pts,1);

%-------------------------------------------------------------------------------
% From: Shakarji, Craig M. "Least-squares fitting algorithms of the NIST 
% algorithm testing system." Journal of research of the National Institute of 
% Standards and Technology 103.6 (1998): 633. 
%-------------------------------------------------------------------------------
% CVmat = zeros(3);
% for k = 1:size(pts,1)
%     dvec  = ( pts(k,:) - cent )';
%     CVmat = CVmat + dvec*dvec';
% end
% [V,D]     = eig(CVmat,'vector');
% [tmp,i]   = min(abs(D));
% nvec     = V(:,i);

%-------------------------------------------------------------------------------
% From: Hartov, Alex, et al. "Adaptive spatial calibration of a 3D ultrasound 
% system." Medical physics 37.5 (2010): 2121-2130.
M       = pts - repmat(cent,size(pts,1),1);
% [U,S,V] = svd(M);
% nvec    = V(:,3);
% long_ax = V(:,1);
% shrt_ax = V(:,2);


[U,S,V] = svd(M'*M);
nvec    = V(:,3);
long_ax = V(:,1);
shrt_ax = V(:,2);
svec    = sqrt(diag(S));
