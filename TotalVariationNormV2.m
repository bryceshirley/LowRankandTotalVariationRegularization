function [TVnorm,subGradM] = TotalVariationNormV2(X)
% [TVnorm,subGradM] = TotalVariationNorm(X) Computes the TV norm of a
% Matrix and the sub gradient matrix of its total variation.
% INPUTS:
% - X is a matrix
% OUTPUTS:
% - TVnorm is the Total Variation norm of X
% - subGradM is the sub gradient of total variation matrix of X
%
% The total variation of the matrix can be defined as the sum of the 
% absolute differences between neighboring elements along the rows and 
% columns.
% TV(X) = ∑_{i=1}^{m-1} ∑_{j=1}^{n-1} (|X[i+1, j] - X[i, j]| + |X[i, j+1] - X[i, j]|)
    
    % find rows and columns of X
    [n,m] = size(X);

    % Mx is a matrix of size (n-1)x(m-1) defined in Eq (5)
    %Mx = zeros((n-1),(m-1));
    TVnorm = 0;
    subGradMx = zeros((n-1),(m-1));

    for i=1:(n-1)
        for j=1:(m-1)
            % Calculate the sub gradient of each term in the Total
            % Variation Sum:
            % Absolute Difference term 1 |X[i+1, j] - X[i, j]|
            diffTerm1 = X(i+1,j)-X(i,j);
            subGradOfAbsDiffTerm1 = SubGradOfAbsDiffTerm(diffTerm1);

            % Absolute Difference term 2 |X[i, j+1] - X[i, j]|
            diffTerm2 = X(i+1,j)-X(i,j);
            subGradOfAbsDiffTerm2 = SubGradOfAbsDiffTerm(diffTerm2);
 
            % Matrix from norm formula
            %Mx = abs(diffTerm1)+abs(diffTerm2);
            
            % Compute Total Variation Norm Sum
            TVnorm = TVnorm + abs(diffTerm1)+abs(diffTerm2);
            % Sub Gradient Matrix of TVnorm
            subGradMx(i,j) = subGradOfAbsDiffTerm1 + subGradOfAbsDiffTerm2;
        end
    end

    % Compute the anisotropic total variation define in eq (4)
    %TVnorm = sum(sum(Mx));

end


function subGradOfAbsDiffTerm = SubGradOfAbsDiffTerm(diffTerm)
    if diffTerm > 0
        subGradOfAbsDiffTerm = 1;
    elseif diffTerm < 0
        subGradOfAbsDiffTerm = -1;
    else % Equality
        % subGradMx(i,j) can take any value between 0 and 1. 
        % Choose 0.
        subGradOfAbsDiffTerm = 0;
    end
end