function M = TotalVariationTensor(X)
M = 0*X;
[n,m,r] = size(X);
XTemp = zeros(n+1,m+1,r+1);
XTemp(1:n,1:m,1:r) = X;
X = XTemp;
% Construct Total Variation Tensor
    for i = 1:n
        for j=1:m
            for k=1:r
                M(i,j,k) = abs(X(i,j,k)-X(i,j+1,k)) + ...
                           abs(X(i+1,j,k)-X(i,j,k)) + ...
                           abs(X(i,j,k)-X(i,j,k+1));
            end
        end
    end
      
end