function XRecovered = Algorithm2_TensorV2(XCorrupted,P,mu,kmax,tol1,tol2,alpha)
% Algorithm 2 in the paper "Low-Rank and Total Variation 
% Regularization and Its Application to Image Recovery". The function
% recovers the original image from corrupted data.
% Inputs:
% - XCorrupted: Image once data has been removed (ratio portion removed)
% - P: Matrix with 1s at known pixel positions and 0 otherwise.
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
M = XCorrupted;

% Calculated additional Parameters for "SolveImageCompletion"
alphak = alpha;
lambda1 = norm(XCorrupted,'fro');
lambda2 = 0.02*lambda1;

% Find Unfoldings for P and M
P1 = UnfoldTensor(P,1);
P2 = UnfoldTensor(P,2);
P3 = UnfoldTensor(P,3);
M1 = UnfoldTensor(M,1);
M2 = UnfoldTensor(M,2);
M3 = UnfoldTensor(M,3);

while alphak > tol2
    % Find each unfolding of Xk
    X01 = UnfoldTensor(X0,1);
    X02 = UnfoldTensor(X0,2);
    X03 = UnfoldTensor(X0,3);

    [X1] = Algorithm1_TensorV2(X01, M1, P1, lambda1*(alphak*5e-2),lambda2*(alphak*5e-2), mu,kmax,tol1);
    [X2] = Algorithm1_TensorV2(X02, M2, P2, lambda1*(alphak*5e-2),lambda2*(alphak*5e-2), mu,kmax,tol1);
    [X3] = Algorithm1_TensorV2(X03, M3, P3, lambda1*(alphak*5e-2),lambda2*(alphak*5e-2), mu,kmax,tol1);

    [U1, ~, ~] = svd(X1,'econ');
    [U2, ~, ~] = svd(X2,'econ');
    [U3, ~, ~] = svd(X3,'econ');

    % Compute G= X *_1 U1' *_2 U2' *_3 U3'
    G1 = TensorMatrixProduct(X0,U1',1); 
    G2 = TensorMatrixProduct(G1,U2',2);
    G = TensorMatrixProduct(G2,U3',3);

    % Compute Xk+1
    X_new1 = TensorMatrixProduct(G,U1,1);
    X_new2 = TensorMatrixProduct(X_new1,U2,2);
    X = TensorMatrixProduct(X_new2,U3,3);

    % Update for next iteration
    alphak = alpha*alphak;
    X0 = X;

    % Plot
    figure(1)
    subplot(1,3,1)
    imshow(X(:,:,1));
    subplot(1,3,2)
    imshow(X(:,:,2));
    subplot(1,3,3)
    imshow(X(:,:,3));
end

% Recovered Image as Function Output
XRecovered  = X0; 
end