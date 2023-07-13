function [Xk] = Algorithm1_test_time(X0, M, P, lambda1,lambda2, mu,kmax,Tol)
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

% Ensure more rows than columns
[m,n]=size(Xk);
if n >m
    Xk = Xk';
    P = P';
    M = M';
end

while k < kmax
    % Compute Singular Values
    D = eig(Xk'*Xk); % more rows than colums so X'X better than XX'
    % Remove negative errors
    D(D<0)=0;

    % Change to descending order
    [~,ind] = sort(D,'descend');
    D = D(ind);

    % Find singular values
    S = sqrt(D);

    % Compute Surragate function 
    p=0.8; % Lp norm (has to be 0<p<1 see section 2.3 of paper)
    w = Derivative_Weighted_Lpnorm_SF(S,lambda1,p)./mu;
    
    % [~,S,~]=svd(Xk);
    % S = diag(S);
    % S(S<1e-5)=0;
    % nnz(S)

    % Compute the subgradient of the TV norm of Xk
    subGradTVnorm = SubGradTVNorm(Xk);
    
    % Compute tk
    tk = Computetk(Xk,subGradTVnorm,P,M,lambda2);
    
    % Define Y
    Y = Xk - (1/mu)*tk;
    
    % Compute Xk+1
    [V,D] = eig(Y'*Y);
    % Remove negative errors
    D(D<0)=0;

    % Change to descending order
    [~,ind] = sort(diag(D),'descend');
    D = D(ind,ind);
    V = V(:,ind);
    
    % Find singular values
    S = sqrt(diag(D));
    
    % Apply shrinkage
    Sw = S-w;
    ind = find(Sw>0);
    Vw = V(:,ind);
    

    X_new = Y*(Vw*Vw');

    
    % Check for convergence
    if norm(X_new - Xk, 'fro') < Tol*norm(Xk, 'fro')
        Xk = X_new;
        break;
    end
    
    % Update k and X
    k = k + 1;
    Xk = X_new;

    % [~,S,~]=svd(Xk);
    % S = diag(S);
    % S(S<1e-5)=0;
    % nnz(S)
end
if n >m
    Xk = Xk';
end
end
