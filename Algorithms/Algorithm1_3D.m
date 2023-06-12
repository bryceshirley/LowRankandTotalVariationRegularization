function [Xk] = Algorithm1_3D(X0, M, P, lambda1,lambda2, mu,kmax,Tol)
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

[n_E,n1,n2] = size(X0);

% Unfolding mode
n=1;

while k < kmax

    % We are assuming low rank variation between the Xk3 unfolding
    Xk_n = UnfoldTensor(Xk,n); % mode-n unfolding

    % Compute Lp-norm of Singular Values
    [~, S, ~] = svd(Xk_n,'econ');
    
    p=.9; % Lp norm (has to be <=1)
    w = Derivative_Weighted_Lpnorm_SF(diag(S),lambda1,p)./mu;

    
    % Compute the subgradient of the TV norm of Xk
    subGradTVnorm3D = SubGradTVNorm3D(Xk); %Tensor
    
    % Compute tk
    tk = Computetk(Xk,subGradTVnorm3D,P,M,lambda2); % Tensor
    
    % Define Y
    Y = Xk - (1/mu).*tk; % Tensor
    
    % Compute Xk+1
    % Unfold so that each row is an image
    Y_n = UnfoldTensor(Y,n); % Low-rank variation through Y image layers
    [U, S, V] = svd(Y_n,'econ');
    Sw = shrinkage(diag(S), w);
    ind = find(Sw>0);
    X_new = U(:,ind) * diag(Sw(ind)) * V(:,ind)';

    % Reshape back to tensor
    X_new = FoldTensor(X_new,n_E,n1,n2,n); 
    
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