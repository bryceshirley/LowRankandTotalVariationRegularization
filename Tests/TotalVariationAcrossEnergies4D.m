function M = TotalVariationAcrossEnergies4D(X)
M = 0*X;
[n,m,r,s] = size(X);
XTemp = zeros(n+1,m,r,s);
XTemp(1:n,1:m,1:r,1:s) = X;
X = XTemp;
% Construct Total Variation Tensor
    for i=1:n  
            M(i,:,:,:) = abs(X(i,:,:,:)-X(i+1,:,:,:));
    end
end