%-------------------------------------------------------------------------------
%
% Fit the data to an ellipse
%
%-------------------------------------------------------------------------------
function pfits  = eval_four_cylfit(tzs,rbf4ps)

%-------------------------------------------------------------------------------
% Extract fitting parameters
b    = rbf4ps.b;
zcs  = rbf4ps.zcs;
Nf   = rbf4ps.Nf;
Nzc  = rbf4ps.Nzc;
sigz = rbf4ps.sigz;

%-------------------------------------------------------------------------------
ts = tzs(:,1);
zs = tzs(:,2);

%-------------------------------------------------------------------------------
% Construct the data matrix
A = zeros(size(tzs,1),Nzc*(2*Nf+1));
for m = 1:size(tzs,1)   
    p        = 1;
    for i = 1:Nzc            
        rbffac   = exp(-(zs(m) - zcs(i)).^2/sigz^2);
        A(m, p ) = 1 * rbffac;
        p        = p+1;        
        for k = 1:2
            for n = 1:Nf
                if k == 1
                    A(m,p) = cos(n*ts(m)) * rbffac;
                else
                    A(m,p) = sin(n*ts(m)) * rbffac;
                end
                p = p+1;
            end
        end
    end
end

%-------------------------------------------------------------------------------
% Construct the fit data
r_four  = A*b;
pfits   = [r_four.*cos(ts) r_four.*sin(ts) zs];

