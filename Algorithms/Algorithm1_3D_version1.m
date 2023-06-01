function [Xk] = Algorithm1_3D_version1(X0, M, P, lambda1,lambda2, mu,kmax,Tol)
% Version 1 just uses the low-rank regularization through each layer. Each
% row of the unfolded tensor corresponds to 1 pixel across the layers.


% Solves image completion using low-rank and total variation regularization
% Input:
% - X0: Initial guess (Tensor)
% - M: Observed image (values we know) (Tensor)
% - P: Mask for known pixels in image. 1 at known postions 0 otherwise.
% - lambda: Weighting to rank-based parameter (Tensor)
% - mu: >0 The proximal parameter
% - kmax: Total number of iterations permitted
% - Tol: the accuracy of convergence required
% Output:
% - Xk: Completed image

% Initialize variables
k = 0;
Xk = X0;

[n,m,r] = size(Xk);


while k < kmax

    % We are assuming low rank variation between the Xk3 unfolding
    Xk3 = UnfoldTensor(Xk,3); % mode-3 tube unfolding (each tube is a pixel)

    % Compute sub-gradient
    [~, S, ~] = svd(Xk3,'econ');
    p=1; % Lp norm (has to be <=1)
    w = Derivative_Weighted_Lpnorm_SF(diag(S),lambda1,p)./mu;

    
    % Compute the subgradient of the TV norm of Xk
    subGradTVnorm3D = SubGradTVNorm3D_OLD(Xk); %Tensor
    
    % Compute tk
    tk = Computetk(Xk,subGradTVnorm3D,P,M,lambda2); % Tensor
    
    % Define Y
    Y = Xk - (1/mu)*tk; % Tensor
    
    % Compute Xk+1
    Y3 = UnfoldTensor(Y,3); % Low-rank variation through Y image layers
    [U, S, V] = svd(Y3,'econ');
    Sw = shrinkage(diag(S), w);
    ind = find(Sw>0);
    X_new = U(:,ind) * diag(Sw(ind)) * V(:,ind)';
    % Reshape back to tensor
    X_new = reshape(X_new',n,m,r); 
    
    % Check for convergence
    if norm(X_new - Xk, 'fro') < Tol*norm(Xk, 'fro')
        Xk = X_new;
        break;
    end
    
    % Update k and X
    k = k + 1;
    Xk = X_new;
end
end
