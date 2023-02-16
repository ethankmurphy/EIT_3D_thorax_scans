%--------------------------------------------------------------------------
%
% Given a triangulation (p=points,t=triangles) and indices of points that
% are to be removed (ris), we want to remove these points and update the 
% triangle matrix so it is still properly labeled.
% 
%--------------------------------------------------------------------------
function [p,t,told] = update_tris_due_to_rmvnodes(p,t,ris,dbg_flg)

if nargin < 4
    dbg_flg = 0;
end

isk = setdiff(1:size(p,1),ris); % Index to keep
if dbg_flg == 1
    tic
    disp(['p and t make sense: ',num2str([size(p,1) max(t(:)) max(ris)])])
end
cnv_iold_2_inew = zeros(size(p,1),1);
for n = 1:length(isk)
    cnv_iold_2_inew(isk(n)) = n;
end
if dbg_flg == 1
    toc
end

if size(t,2) == 3
    %     %----------------------------------------------------------------------
    %     % Find the triangles that need to be removed, i.e. any triangle that
    %     % involves any node that will be removed.
    %     [tmp,ia1]  = intersect(t(:,1),ris);
    %     [tmp,ia2]  = intersect(t(:,2),ris);
    %     [tmp,ia3]  = intersect(t(:,3),ris);
    %     ris_t      = [ia1; ia2; ia3];
    %     t(ris_t,:) = [];
    %----------------------------------------------------------------------
    % Find the triangles that need to be removed, i.e. any triangle that
    % involves any node that will be removed.
    ia1 = 1;ia2 = 1;ia3 = 1;
    count = 0;
    while (isempty(ia1) == 0) || (isempty(ia2) == 0) || (isempty(ia3) == 0) 
        if dbg_flg == 1
            disp(['Removal steps: ',num2str(count)])
        end
        [tmp,ia1]  = intersect(t(:,1),ris);
        [tmp,ia2]  = intersect(t(:,2),ris);
        [tmp,ia3]  = intersect(t(:,3),ris);
        ris_t      = [ia1; ia2; ia3];
        t(ris_t,:) = [];
        count = count+1;
    end
    told = t;

    %----------------------------------------------------------------------
    for k = 1:3
        t(:,k) = cnv_iold_2_inew(t(:,k));
    end

elseif size(t,2) == 4
    %----------------------------------------------------------------------
    % Find the triangles that need to be removed, i.e. any triangle that
    % involves any node that will be removed.
    ia1 = 1;ia2 = 1;ia3 = 1;ia4 = 1;
    count = 0;
    while (isempty(ia1) == 0) || (isempty(ia2) == 0) || (isempty(ia3) == 0) || (isempty(ia4) == 0)
        if dbg_flg == 1
            disp(['Removal steps: ',num2str(count)])
        end
        [tmp,ia1]  = intersect(t(:,1),ris);
        [tmp,ia2]  = intersect(t(:,2),ris);
        [tmp,ia3]  = intersect(t(:,3),ris);
        [tmp,ia4]  = intersect(t(:,4),ris);
        ris_t      = [ia1; ia2; ia3; ia4];
        t(ris_t,:) = [];
        count = count+1;
    end
    told = t;
   
    %----------------------------------------------------------------------
    for k = 1:4
        t(:,k) = cnv_iold_2_inew(t(:,k));
    end
    
    
end
p(ris,:) = [];
