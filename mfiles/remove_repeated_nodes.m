function [t,p,p2] = remove_repeated_nodes(t,p,p2)

%--------------------------------------------------------------------------
% 1. Relabel triangles to those of the unique nodes
[p,ia,ib] = unique(p,'rows');
for k = 1:3
    t(:,k) = ib(t(:,k));
end
if nargin == 3
    p2 = p2(ia,:);
end

%--------------------------------------------------------------------------
% 2. Remove unused nodes
[t,p,used_nds] = remove_unused_nodes(t,p);
if nargin == 3
    p2 = p2(used_nds,:);
else
    p2 = [];
end

