function [Xk] = Algorithm1_Tensor(X0, M, P, lambda1,lambda2, mu,kmax,Tol)
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

% Find Unfoldings for P and M
P1 = UnfoldTensor(P,1);
P2 = UnfoldTensor(P,2);
P3 = UnfoldTensor(P,3);
M1 = UnfoldTensor(M,1);
M2 = UnfoldTensor(M,2);
M3 = UnfoldTensor(M,3);

while k < kmax
%while true

    % Find each unfolding of Xk
    Xk1 = UnfoldTensor(Xk,1);
    Xk2 = UnfoldTensor(Xk,2);
    Xk3 = UnfoldTensor(Xk,3);

    % Compute sub-gradient
    % Compute Classical SVDs in Each Unfolding
    [~,S1,~] = ComputeSVDUnfoldedxTensor(Xk,1); % mode-1
    [~,S2,~] = ComputeSVDUnfoldedxTensor(Xk,2); % mode-2
    [~,S3,~] = ComputeSVDUnfoldedxTensor(Xk,3); % mode-3
    p=1; % Lp norm (has to be <=1)
    %w = Derivative_Weighted_Lpnorm_SF(diag(S),lambda1,p)./mu;
    w1 = Derivative_Weighted_Lpnorm_SF(diag(S1),lambda1,p);
    w2 = Derivative_Weighted_Lpnorm_SF(diag(S2),lambda1,p);
    w3 = Derivative_Weighted_Lpnorm_SF(diag(S3),lambda1,p);
    
    % Compute the subgradient of the TV norm of Xk
    subGradTVnorm1 = SubGradTVNorm(Xk1); % mode-1
    subGradTVnorm2 = SubGradTVNorm(Xk2); % mode-2
    subGradTVnorm3 = SubGradTVNorm(Xk3); % mode-3
    
    % Compute tk
    tk1 = Computetk(Xk1,subGradTVnorm1,P1,M1,lambda2);
    tk2 = Computetk(Xk2,subGradTVnorm2,P2,M2,lambda2);
    tk3 = Computetk(Xk3,subGradTVnorm3,P3,M3,lambda2);
    
    % Define Y
    Y1 = Xk1 - (1/mu)*tk1;
    Y2 = Xk2 - (1/mu)*tk2;
    Y3 = Xk3 - (1/mu)*tk3;
    
    % Use Shrinkage Operation on Each Unfolding
    [U1, S1, ~] = svd(Y1,'econ');
    Sw1 = shrinkage(diag(S1), w1);
    ind = find(Sw1>0);
    Uw1 = U1(:,ind);


    [U2, S2, ~] = svd(Y2,'econ');
    Sw2 = shrinkage(diag(S2), w2);
    ind = find(Sw2>0);
    Uw2 = U2(:,ind);

    [U3, S3, ~] = svd(Y3,'econ');
    Sw3 = shrinkage(diag(S3), w3);
    ind = find(Sw3>0);
    Uw3 = U3(:,ind);

    % Compute G= X *_1 U1' *_2 U2' *_3 U3'
    G1 = TensorMatrixProduct(Xk,Uw1',1); % Xk is the wrong dimensions
    G2 = TensorMatrixProduct(G1,Uw2',2);
    G = TensorMatrixProduct(G2,Uw3',3);

    % Compute Xk+1
    X_new1 = TensorMatrixProduct(G,Uw1,1);
    X_new2 = TensorMatrixProduct(X_new1,Uw2,2);
    X_new = TensorMatrixProduct(X_new2,Uw3,3);
    
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
