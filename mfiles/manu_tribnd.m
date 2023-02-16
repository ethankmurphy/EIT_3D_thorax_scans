%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------
function trib = manu_tribnd(ps,wrap_flg)

if nargin < 2
    wrap_flg = 1;
end
%-------------------------------------------------------------------------------
% Get the unique angles and zs
ts  = round(atan2(ps(:,2),ps(:,1)),6);
zs  = ps(:,3);
uts = unique(ts);
uzs = unique(ps(:,3));

%-------------------------------------------------------------------------------
% tri1 = zeros(length(uzs)*length(uts),3);
% tri2 = zeros(length(uzs)*length(uts),3);
tri1 = zeros((length(uzs)-1)*(length(uts)),3);
tri2 = zeros((length(uzs)-1)*(length(uts)),3);
p    = 1;
for n = 1:(length(uzs)-1)
    for k = 1:(length(uts)-1)
        %------------------------------------------------------------------
        % Get the points
        i1 = find( (ts == uts(k  )) & (zs == uzs(n  )) );
        i2 = find( (ts == uts(k+1)) & (zs == uzs(n  )) );
        i3 = find( (ts == uts(k+1)) & (zs == uzs(n+1)) );
        i4 = find( (ts == uts(k  )) & (zs == uzs(n+1)) );
        %------------------------------------------------------------------        
        tri1(p,:) = [i1 i2 i4];
        tri2(p,:) = [i2 i3 i4];
        p = p+1;
    end
    if wrap_flg == 1
        %------------------------------------------------------------------
        % Get the points
        i1 = find( (ts == uts(end)) & (zs == uzs(n  )) );
        i2 = find( (ts == uts(1  )) & (zs == uzs(n  )) );
        i3 = find( (ts == uts(1  )) & (zs == uzs(n+1)) );
        i4 = find( (ts == uts(end)) & (zs == uzs(n+1)) );
        %------------------------------------------------------------------
        tri1(p,:) = [i1 i2 i4];
        tri2(p,:) = [i2 i3 i4];
        p = p+1;
    end
end
tri1 = tri1(1:p-1,:);
tri2 = tri2(1:p-1,:);
%-----
trib = [tri1; tri2];