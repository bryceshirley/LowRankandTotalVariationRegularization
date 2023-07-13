function subGradTVnorm = SubGradTVNorm2D(X)
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
    XD = [X;zeros(1,m)]; % Choose sharp Boundary Values as zeros
    MxD = - diff(XD,1,1); % Negate sign to remove skew

    % b) Compute X(i, j) - X(i, j+1)
    XR = [X,zeros(n,1)];
    MxR = - diff(XR,1,2); % Negate signs to remove skew
    

    %% Compute contributions from Mx(i,j-1) (containing X(i,j))
    
    % Compute X(i, j-1) - X(i, j)
    XL = [zeros(n,1),X];
    MxL = diff(XL,1,2);

    %% Contributions from Mx(i-1,j) (containing X(i,j))
    
    % Compute X(i, j) - X(i-1, j)
    XU = [zeros(1,m); X]; 
    MxU = diff(XU,1,1);

    
    %% Compute The Subgradient for Each Term and Sum For Subgradient of TV
    subGradTVnorm = sign(MxL) + sign(MxR) + sign(MxD) + sign(MxU);

end
