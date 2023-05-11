function [TVnorm,subGradTVnorm] = TotalVariationNormV3(X)
% [TVnorm,subGradTVnorm] = TotalVariationNorm(X) Computes the TV norm of a
% Matrix and the sub gradient matrix of its total variation.
% INPUTS:
% - X is a matrix
% OUTPUTS:
% - TVnorm is the Total Variation norm of X
% - subGradTVnorm is the sub gradient of total variation matrix of X
%
% The total variation of the matrix can be defined as the sum of the 
% absolute differences between neighboring elements along the rows and 
% columns.
% Introduce sharp boundary conditions of 0 to represent the edge of the image.
    
    %% Output 1: Calculate the TV norm of X
    % find rows and columns of X
    [n,m] = size(X);

    % We Define the TV norm TV(x) as:
    % TV(X) = ∑_{i=1}^{m} ∑_{j=1}^{n} Mx(i,j)
    % Where, Mx(i,j) = |X(i, j) - X(i, j+1)| + |X(i+1, j) - X(i, j)|


    % a) Compute X(i+1, j) - X(i, j)
    XRowBoundary = [X;zeros(1,m)]; % Choose sharp Boundary Values as zeros
    rowNeighboursDiff = - diff(XRowBoundary); % Negate signs

    % b) Compute X(i, j) - X(i, j+1)
    XColBoundary = [X,zeros(n,1)];
    colNeighboursDiff = diff(XColBoundary')';

    % c) Compute Matrix Mx (defined above)
    Mx = abs(colNeighboursDiff) + abs(rowNeighboursDiff);

    % Find TV(x) by Summing all elements in Mx
    TVnorm = sum(sum(Mx));

    %% Output 2: Calculate the Sub-Gradient of the TV norm of X

    % Most of the contributions of the sum TV(x) are lost when taking
    % partial derivatives w.r.t x. The contributions that remain are 1 
    % from Mx(i-1,j), 1 from Mx(i,j-1) and 2 from Mx(i,j) (calculated 
    % already above).

    % Contributions from Mx(i,j-1) containing X(i,j):
    %   Compute X(i, j-1) - X(i, j)
    XColBoundaryLeft = [zeros(n,1),X]; 
    colNeighboursDiffLeft = diff(XColBoundaryLeft')';

    % Contributions from Mx(i-1,j) containing X(i,j):
    %   Compute X(i, j) - X(i-1, j)
    XRowBoundaryTop = [zeros(1,m);X];
    RowNeighboursDiffTop = - diff(XRowBoundaryTop); % Negate signs

    
    % Subgradient of a function |x|=0 is -1 for x<0, 1 x>0 and can take any
    % value between -1 and 1 for x=0 (we choose 0 for convinience). Hence,
    % the sign function is suitable for this task.

    % Sub gradient of 2 terms from Mx(i,j)
    rowNeighboursDiff = sign(rowNeighboursDiff);
    colNeighboursDiff = sign(colNeighboursDiff);

    % Sub gradient of term from Mx(i,j-1)
    colNeighboursDiffLeft = sign(colNeighboursDiffLeft);

    % Sub gradient of term from Mx(i-1,j)
    RowNeighboursDiffTop = sign(RowNeighboursDiffTop);

    
    % Combine the matrices to subgradient TV norm matrix
    subGradTVnorm = colNeighboursDiff + rowNeighboursDiff + ...
    colNeighboursDiffLeft + RowNeighboursDiffTop;

end
