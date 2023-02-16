function filename = ifdec(filename,dec_char)

%-------------------------------------------------------------------------------
% Set the decimal point character
if (nargin==1)
    dec_char = 'o';    
end

%-------------------------------------------------------------------------------
if isnumeric(filename) == 1
    filename = num2str(filename);
end

for i = 1:length(filename)
   if strcmp('.',filename(i))==1
       filename(i) = dec_char;
   end
end