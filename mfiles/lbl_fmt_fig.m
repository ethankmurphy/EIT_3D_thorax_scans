%--------------------------------------------------------------------------
%
%  lbl_fmt_fig(xlab,ylab,titl,lgd,zlab,FS)
%
%--------------------------------------------------------------------------
function lbl_fmt_fig(xlab,ylab,titl,lgd,zlab,FS)
grid on
box on
if (nargin <= 3)
    FS = 16;
elseif (nargin == 6)
    if isempty(FS) == 1
        FS = 16;
    end
end
xlabel(xlab,'fontsize',FS,'FontName','times')
ylabel(ylab,'fontsize',FS,'FontName','times')
title(titl,'fontsize',FS,'FontName','times')
if (nargin > 3)
    if length(lgd) > 0
        legend(lgd)
    end
end
if (nargin > 4)
    if length(zlab) > 0
        zlabel(zlab,'fontsize',FS,'FontName','times')
    end
end
set(gca,'FontSize',FS,'FontName','times')
