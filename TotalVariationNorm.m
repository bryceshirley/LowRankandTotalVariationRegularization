function [TVnorm,M] = TotalVariationNorm(X)
% X is a matrix
% TVnorm is the Total Variation norm of X
% M is the total variation matrix of X
%
% The total variation of the matrix can be defined as the sum of the 
% absolute differences between neighboring elements along the rows and 
% columns.
% TV(X) = ∑_{i=1}^{m-1} ∑_{j=1}^{n-1} (|X[i+1, j] - X[i, j]| + |X[i, j+1] - X[i, j]|)
    
    % find rows and columns of X
    [n,m] = size(X);

    % Mx is a matrix of size (n-1)x(m-1) defined in Eq (5)
    M = zeros((n-1),(m-1));

    for i=1:(n-1)
        for j=1:(m-1)
            M(i,j) = abs(X(i+1,j)-X(i,j))+abs(X(i,j)-X(i,j+1));
        end
    end

    % Compute the anisotropic total variation define in eq (4)
    TVnorm = sum(sum(M));

end