function M = TotalVariationInFramesTensor4D(X)
M = 0*X;
[n,m,r,s] = size(X);
XTemp = zeros(n,m,r+1,s+1);
XTemp(1:n,1:m,1:r,1:s) = X;
X = XTemp;
% Construct Total Variation Tensor
    for j=1:r 
        for k=1:s 
            M(:,:,j,k) = abs(X(:,:,j,k)-X(:,:,j+1,k)) + ...
                       abs(X(:,:,j,k)-X(:,:,j,k+1));
        end
    end
end
      