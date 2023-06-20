function XStore = Algorithm2_3D(XCorrupted,P,mu,kmax,tol1,tol2,alpha,kmax2)
% Algorithm 2 in the paper "Low-Rank and Total Variation 
% Regularization and Its Application to Image Recovery". The function
% recovers the original image from corrupted data.
% Inputs:
% - XCorrupted: Images once data has been removed (ratio portion removed)
% - P: Tensor with 1s at known pixel positions and 0 otherwise.
% - mu:Proximal term parameter
% - kmax: Max Iterations for Algorithm 1
% - tol1: Tolerence Covergence Parameter for Algorithm 1
% - tol2: Tolerence for Algorithm 2 on alpha k
% - alpha: Paramter to reduce the size of TV norm and rank surrogate
% functions relatuve to the size of Frobenius norm term in the
% optimization problem.
% Ouput:
% - XRecovered: the recovered image.

% Set Initial Guess
X0 = XCorrupted;

% Calculated additional Parameters for "SolveImageCompletion"
alphak = alpha;
lambda1 = norm(XCorrupted,'fro');
lambda2 = 0.0015*lambda1;

% Dimensions
[n_E,n1,n2]=size(X0);

% Index Counter
XStore(1,:,:) = reshape(X0,n_E,n1*n2);
i=2;

% Stopping count
k = 1;
while alphak > tol2
    % Use Algorithm1 to compute next image iteration
    [X] = Algorithm1_3D(X0, XCorrupted, P, lambda1*(alphak*5e-2),lambda2*(alphak*5e-2), mu,kmax,tol1);
    
    % Update parameters
    alphak = alpha*alphak;

    % Update X0
    X0 = X;

    % Store values at each iteration for norm plot
    XStore(i,:,:) = reshape(X0,n_E,n1*n2);
    i = i+1;

    if k > kmax2
        break
    end
    k=k+1;
end

% % Recovered Image as Function Output
% XRecovered  = X0; 
end