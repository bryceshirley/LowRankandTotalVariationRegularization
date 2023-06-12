function [X] = ReconstructRows(M, P, mu,kmax,tol1,tol2,alpha)
% Reconstructs X by applying the 2D method to each energy level.
% Solves image completion using low-rank and total variation regularization
% Inputs:
% - M: Image once data has been removed (ratio portion removed).
% - P: Matrix with 1s at known pixel positions and 0 otherwise.
% - mu:Proximal term parameter
% - kmax: Max Iterations for Algorithm 1
% - tol1: Tolerence Covergence Parameter for Algorithm 1
% - tol2: Tolerence for Algorithm 2 on alpha k
% - alpha: Paramter to reduce the size of TV norm and rank surrogate
% functions relatuve to the size of Frobenius norm term in the
% optimization problem.
% Ouput:
% - X: the recovered image.


% Initialize variables
[n_E,n1,n2] = size(M);
Xn = zeros(n_E,n1*n2); 

% Mode-1 Tensor unfoldings
Pn = UnfoldTensor(P,1); 
Mn = UnfoldTensor(M,1); 

% Loop through energy levels
for i = 1:n_E
    % Reshape row image into matrix
    pk = reshape(Pn(i,:),n1,n2);
    mk = reshape(Mn(i,:),n1,n2);
    
    % Preform reconstruction on image
    xk = Algorithm2(mk,pk,mu,kmax,tol1,tol2,alpha);

    % Store in updated image
    Xn(i,:) = reshape(xk,1,n1*n2);
end

% Reshape to tensor format
X = reshape(Xn,n_E,n1,n2);
end