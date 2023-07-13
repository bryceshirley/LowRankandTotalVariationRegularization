function M = TotalVariationMatrix(X)
M = 0*X;
[n,m] = size(X);
XTemp = zeros(n+1,m+1);
XTemp(1:n,1:m) = X;
X = XTemp;
% Construct Total Variation Tensor
    for i = 1:n
        for j=1:m
                M(i,j) = abs(X(i,j)-X(i,j+1)) + ...
                           abs(X(i+1,j)-X(i,j));

        end
    end
      
end