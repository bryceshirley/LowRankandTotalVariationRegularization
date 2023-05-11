function subGradTVnorm = SubGradTVNorm(X)
% Computes the sub gradient matrix the total variation norm.
% INPUTS:
% - X: is a matrix
% OUTPUTS:
% - subGradTVnorm: subgradient matrix of TV norm of matrix X
%
% Relevant Theory/ Formulation:
% The total variation of the matrix can be defined as the sum of the 
% absolute differences between neighboring elements along the rows and 
% columns.
%
% We Define the TV norm TV(x) as:
% TV(X) = ∑_{i=1}^{m} ∑_{j=1}^{n} Mx(i,j)
% Where, Mx(i,j) = |X(i, j) - X(i, j+1)| + |X(i+1, j) - X(i, j)|
% 
% Introduce sharp boundary conditions of 0 to represent the edge of the 
% image.
%
% When taking the subgradient we form a Jacobian matrix where each in
% postion (i,j) is the partial derivative of sum TV(X) with respect to
% X(i,j).
% 
% NOTE:
% Most of the contributions of the sum TV(x) are lost when taking
% partial derivatives w.r.t X(i,j). The contributions that remain are 1 
% from Mx(i-1,j), 1 from Mx(i,j-1) and 2 from Mx(i,j) (calculated 
% already above).
% Subgradient of a function |x|=0 is -1 for x<0, 1 x>0 and can take any
% value between -1 and 1 for x=0 (we choose 0 for convinience). Hence,
% the sign function is suitable for this task.
    
    % find rows and columns of X
    [n,m] = size(X);

    
    %% Compute Mx(i,j) terms in as defined above

    % a) Compute X(i+1, j) - X(i, j)
    XRowBoundary = [X;zeros(1,m)]; % Choose sharp Boundary Values as zeros
    rowNeighboursDiff = - diff(XRowBoundary); % Negate signs

    % b) Compute X(i, j) - X(i, j+1)
    XColBoundary = [X,zeros(n,1)];
    colNeighboursDiff = diff(XColBoundary')';
    

    %% Compute contributions from Mx(i,j-1) (containing X(i,j))
    
    % Compute X(i, j-1) - X(i, j)
    XColBoundaryLeft = [zeros(n,1),X]; 
    colNeighboursDiffLeft = diff(XColBoundaryLeft')';

    %% Contributions from Mx(i-1,j) (containing X(i,j))
    
    % Compute X(i, j) - X(i-1, j)
    XRowBoundaryTop = [zeros(1,m);X];
    RowNeighboursDiffTop = - diff(XRowBoundaryTop); % Negate signs

    
    %% Compute The Subgradient for Each Term and Sum

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