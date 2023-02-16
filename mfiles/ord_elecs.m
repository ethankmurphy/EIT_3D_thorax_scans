%--------------------------------------------------------------------------
function elecs = ord_elecs(mrk_ps,unlab_ps,dbg_flg)

%--------------------------------------------------------------------------
mark_ord = [32 27 22 17 12 7]';
ords     = [mark_ord; NaN*unlab_ps(:,1)];
elecs    = [mrk_ps; unlab_ps];
ts       = atan2(elecs(:,2),elecs(:,1));

%--------------------------------------------------------------------------
% Set elec 32 to 0
delt   = 0 - ts(1);
ts     = ts + delt;
is     = find( ts < 0-1e-6); % find( ts > 2*pi+1e-6)
% ts(is) = ts(is) - 2*pi;
ts(is) = ts(is) + 2*pi;

%--------------------------------------------------------------------------
[ts,sid] = sort(ts);
elecs    = elecs(sid,:);
ords     = ords(sid,:);
if dbg_flg == 1
    [elecs ts ords]
end

%--------------------------------------------------------------------------
% Loop through the labeled electrodes and label them
for n = 1:length(mark_ord)-1
    i1 = find( mark_ord(n)   == ords );
    i2 = find( mark_ord(n+1) == ords );
    is = (i1+1):(i2-1);
    if dbg_flg == 1
        [length(is) (mark_ord(n) - mark_ord(n+1)-1) mark_ord(n:n+1)']
    end

    for i = 1:length(is)
        ords(is(i)) = mark_ord(n)-i;
    end
end
%--------------------------------------------------------------------------
% Label the last electrodes
i0 = find( ords == mark_ord(end) );
for i = (i0+1):size(ords,1)
    ords(i) = mark_ord(end)-(i-i0);
end

if dbg_flg == 1
    [elecs ts ords]
end

%--------------------------------------------------------------------------
% Do a final reorder, based on their prescribed order
elecs_out         = NaN*ones(max(ords),3);
elecs_out(ords,:) = elecs;
elecs             = elecs_out;

%--------------------------------------------------------------------------


