function [t,p,used_nds] = remove_unused_nodes(t,p)

%-------------------------------------------------------------------------------
% Remove unused nodes
if size(t,2) == 3
    [used_nds,tmp,uis] = unique([t(:,1); t(:,2); t(:,3)]);
    p = p(used_nds,:);
    
    %---------------------------------------------------------------------------
    % Relabel the mesh elements (second method)
    ne         = size(t,1);
    elnew      = t;
    elnew(:,1) = uis(       1:ne);
    elnew(:,2) = uis((  ne+1):2*ne);
    elnew(:,3) = uis((2*ne+1):3*ne);
    t          = elnew;
    
    
elseif size(t,2) == 4
    [used_nds,tmp,uis] = unique([t(:,1); t(:,2); t(:,3); t(:,4)]);
    p = p(used_nds,:);
    
    %---------------------------------------------------------------------------
    % Relabel the mesh elements (second method)
    ne         = size(t,1);
    elnew      = t;
    elnew(:,1) = uis(       1:ne);
    elnew(:,2) = uis((  ne+1):2*ne);
    elnew(:,3) = uis((2*ne+1):3*ne);
    elnew(:,4) = uis((3*ne+1):4*ne);
    t          = elnew;
    
    
end