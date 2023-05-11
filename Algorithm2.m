function XRecovered = Algorithm2(XCorrupted,P,mu,kmax,Tol,alpha)

% Set Initial Guess
X0 = XCorrupted;

alphak = alpha;
lambda1 = norm(XCorrupted,'fro');
lambda2 = 0.02*lambda1;

while alphak > tol
    [X] = SolveImageCompletion(X0, XCorrupted, P, lambda1,lambda2, mu,kmax,Tol,alphak); % Should alpha_k be a parameter?
    alphak = alpha*alphak;
    X0 = X;
end

% Recovered Image as Function Output
XRecovered  = X0; 
end