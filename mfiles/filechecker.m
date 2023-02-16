%-------------------------------------------------------------------------------
% This function checks if the input file name (fname) exists in the input
% folder name (fold_name).  If it exists a flag is returned equal to 1, and
% otherwise its equal to 0.  
%-------------------------------------------------------------------------------
function file_exists = filechecker(fold_name,fname,dirobj)


if nargin < 3
dirobj      = dir(fold_name);
end
file_exists = 0;

for n = 3:length(dirobj)
    % dirobj(n).name
    if strcmp(dirobj(n).name,fname) == 1
        file_exists = 1;
    end
end