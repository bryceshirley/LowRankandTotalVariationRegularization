function [Xk] = Algorithm1_3D_version3(X0, M, P, lambda1,lambda2, mu,kmax,Tol)
% Version 2 just uses the low-rank regularization taking into account all
% three mode-n unfoldings.

% Solves image completion using low-rank and total variation regularization
% Input:
% - X0: Initial guess
% - M: Observed image (values we know)
% - P: Mask for known pixels in image. 1 at known postions 0 otherwise.
% - lambda: Weighting to rank-based parameter
% - mu: >0 The proximal parameter
% - kmax: Total number of iterations permitted
% - Tol: the accuracy of convergence required
% Output:
% - Xk: Completed image

% P: Mask for known pixels in Observed image

% Initialize variables
k = 0;
Xk = X0;

while k < kmax
    
    % Compute the subgradient of the TV norm of Xk
    subGradTVnorm3D = SubGradTVNorm3D(Xk); %Tensor
    
    % Compute tk
    tk = Computetk(Xk,subGradTVnorm3D,P,M,lambda2); % Tensor
    
    % Define Y
    Y = Xk - (1/mu)*tk; % Tensor
    
    % Use Multilinear SVD to Reconstuct X_{k+1} from X_{k} 
    p=1;
    X_new = LowRankContributionV3(Y,Xk,lambda1,p,mu);
   
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
