function TVnorm = TotalVariationNorm(X)
% X is a matrix
% TVnorm is the Total Variation norm of X
    
    % find rows and columns of X
    [n,m] = size(X);

    % Mx is a matrix of size (n-1)x(m-1) defined in Eq (5)
    Mx = zeros((n-1),(m-1));

    for i=1:(n-1)
        for j=1:(m-1)
            Mx(i,j) = abs(X(i,j)-X(i,j+1))+abs(X(i+1,j)-X(i,j));
        end
    end

    % Compute the anisotropic total variation define in eq (4)
    TVnorm = sum(sum(Mx));

end