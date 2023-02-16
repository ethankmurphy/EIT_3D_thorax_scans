%--------------------------------------------------------------------------
%  
% Set the size of a figured in terms of a percent of the screen
%  perc(1) = vertical
%  perc(2) = horizontal
% 
%--------------------------------------------------------------------------
function set_fig_relsiz(perc)

if nargin < 1
    perc = [0.9 0.9];
elseif length(perc) == 1
    perc = perc*[1 1];
end

Pix_SS = get(0,'screensize');
set(gcf,'position',[20 20 perc(1)*Pix_SS(3) perc(2)*Pix_SS(4)])