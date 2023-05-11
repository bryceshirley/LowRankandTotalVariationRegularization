function XRecovered = Algorithm2(XCorrupted,P,mu,kmax,tol1,tol2,alpha)
% Algorithm 2 in the paper "Low-Rank and Total Variation 
% Regularization and Its Application to Image Recovery". The function
% recovers the original image from corrupted data.
% Inputs:
% - XCorrupted:
% - P:
% - mu:
% - kmax: 
% - Tol: 
% - alpha: 
% Ouput:
% - XRecovered: the recovered image.

% Set Initial Guess
X0 = XCorrupted;

% Calculated additional Parameters for "SolveImageCompletion"
alphak = alpha;
lambda1 = norm(XCorrupted,'fro');
lambda2 = 0.02*lambda1;

while alphak > tol2
    [X] = SolveImageCompletion(X0, XCorrupted, P, lambda1,lambda2, mu,kmax,tol1,alphak);
    alphak = alpha*alphak;
    X0 = X;
end

% Recovered Image as Function Output
XRecovered  = X0; 
end