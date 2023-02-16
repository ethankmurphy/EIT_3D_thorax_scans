%--------------------------------------------------------------------------
%
% Fit the data to an ellipse
%
%--------------------------------------------------------------------------
function [pfits, rbf4ps]  = four_cylfit(ps,Nf,Nzc,sigz)

%--------------------------------------------------------------------------
rs = sqrt( ps(:,1).^2 + ps(:,2).^2 );
ts = atan2(ps(:,2),ps(:,1));
zs = ps(:,3);

%--------------------------------------------------------------------------
% Define the RBF centers
zcs = linspace( min(ps(:,3)), max(ps(:,3)), Nzc);

%--------------------------------------------------------------------------
% Construct the data matrix
A = zeros(size(ps,1),Nzc*(2*Nf+1));
for m = 1:size(ps,1)   
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
% figure
% surf(A)
%--------------------------------------------------------------------------
% Calculate the best fit
ATA = A'*A;
% rank(ATA)
% cond(ATA)
b   = pinv(ATA)*A'*rs;

%--------------------------------------------------------------------------
% Construct the fit data
r_four  = A*b;
pfits   = [r_four.*cos(ts) r_four.*sin(ts) zs];

%--------------------------------------------------------------------------
rbf4ps.b    = b;
rbf4ps.zcs  = zcs;
rbf4ps.Nf   = Nf;
rbf4ps.Nzc  = Nzc;
rbf4ps.sigz = sigz;