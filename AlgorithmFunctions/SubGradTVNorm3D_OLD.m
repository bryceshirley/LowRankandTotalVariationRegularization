function subGradTVnorm3D = SubGradTVNorm3D_OLD(X)
% Computes the sub gradient matrix the total variation norm.
% INPUTS:
% - X: is a tensor
% OUTPUTS:
% - subGradTVnorm: subgradient tensor of TV norm of tensor X
%
% Relevant Theory/ Formulation:
% The total variation of the matrix can be defined as the sum of the 
% absolute differences between neighboring elements along the rows and 
% columns.
%
% We Define the TV norm TV(x) as:
% TV(X) = ∑_{i=1}^{m} ∑_{j=1}^{n} ∑_{k=1}^{r} Tx(i,j,k)
% Where, Tx(i,j,k) = |X(i, j, k) - X(i, j+1, k)| + 
%                    |X(i+1, j, k) - X(i, j, k)| +
%                    |X(i, j, k) - X(i, j, k+1)|
% Tx(i,j,k-1) = |X(i, j, k-1) - X(i, j, k)|
% Introduce sharp boundary conditions of 0 to represent the edge of the 
% image.
%
% When taking the subgradient we form a Jacobian Tensor where each in
% postion (i,j,k) is the partial derivative of sum TV(X) with respect to
% X(i,j,k).
% 
% NOTE:
% Subgradient of a function |x|=0 is -1 for x<0, 1 x>0 and can take any
% value between -1 and 1 for x=0 (we choose 0 for convinience). Hence,
% the sign function is suitable for this task.
    
    % find rows and columns of X
    [n,m,r] = size(X);
    
    %% Find TV norm for pixels through the Images
    % X forward unfolding - Differences taken forward
    % (Each column of unfolding is an image)
    XF = [reshape(X,n*m,r),zeros(n*m,1)]; % zero boundary condition applied
    TxF = -reshape(diff(XF,1,2),n,m,r); % Take difference and reshape to Tensor

    % Contributions from Tx(i,j,k-1)
    % X backword unfolding - Differences taken Backward
    XB = [zeros(n*m,1),reshape(X,n*m,r)];
    TxB = reshape(diff(XB,1,2),n,m,r); 

    pixelSubGradTVNorm = sign(TxB) + sign(TxF);
    
    
    %% Find TV norm for each image
    imageSubGradTVNorm=zeros(n,m,r);
    for i = 1:r
        image = X(:,:,i); 
        imageSubGradTVNorm(:,:,i) = SubGradTVNorm(image);
    end


    
    %% Compute The Subgradient for Each Term and Sum For Subgradient of TV
    subGradTVnorm3D = pixelSubGradTVNorm + imageSubGradTVNorm;

end