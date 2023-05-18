function [Xk] = Algorithm1_TensorV2(X0n, Mn, Pn, lambda1,lambda2, mu,kmax,Tol)
% Solves image completion using low-rank and total variation regularization
% Input:
% - X0n: Initial guess (mode-n unfolding)
% - Mn: Observed image (values we know) (mode-n unfolding)
% - Pn: Mask for known pixels in image. 1 at known postions 0 otherwise. (mode-n unfolding)
% - lambda: Weighting to rank-based parameter
% - mu: >0 The proximal parameter
% - kmax: Total number of iterations permitted
% - Tol: the accuracy of convergence required
% Output:
% - Xk: Completed image

% P: Mask for known pixels in Observed image

% Initialize variables
k = 0;
Xk = X0n;

while k < kmax
%while true
    % Compute sub-gradient
    [~, S, ~] = svd(Xk,'econ');
    p=1; % Lp norm (has to be <=1)
    %w = Derivative_Weighted_Lpnorm_SF(diag(S),lambda1,p)./mu;
    w = Derivative_Weighted_Lpnorm_SF(diag(S),lambda1,p);
    
    % Compute the subgradient of the TV norm of Xk
    subGradTVnorm = SubGradTVNorm(Xk);
    
    % Compute tk
    tk = Computetk(Xk,subGradTVnorm,Pn,Mn,lambda2);
    
    % Define Y
    Y = Xk - (1/mu)*tk;
    
    % Compute Xk+1
    [U, S, V] = svd(Y,'econ');
    Sw = shrinkage(diag(S), w);
    ind = find(Sw>0);
    X_new = U(:,ind) * diag(Sw(ind)) * V(:,ind)';
    
    % Check for convergence
    if norm(X_new - Xk, 'fro') < Tol*norm(Xk, 'fro')
        Xk = X_new;
        break;
    end
    
    % Update k and X
    k = k + 1;
    Xk = X_new;
end
%disp('Kmax reached')
end