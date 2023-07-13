function [completed_data,res_out_hist,e_c_hist] = Algorithm2_4D(incomplete_data,P,mu,kmax,tol1,tol2,alpha,full_data)
% Algorithm 2 in the paper "Low-Rank and Total Variation 
% Regularization and Its Application to Image Recovery". The function
% recovers the original image from corrupted data.
% Inputs:
% - incomplete_data: Incomplete data 4D tensor
% - P: Mask Tensor with 1s at known pixel positions and 0 otherwise.
% - mu:Proximal term parameter
% - kmax: Max Iterations for Algorithm 1
% - tol1: Tolerence Covergence Parameter for Algorithm 1
% - tol2: Tolerence for Algorithm 2 on alpha k
% - alpha: Paramter to reduce the size of TV norm and rank surrogate
% functions relatuve to the size of Frobenius norm term in the
% optimization problem.
% - full_data: the full dataset for residual history purposes
% Ouput:
% - completed_data: the recovered image.

% Set Initial Guess
X0 = incomplete_data;

% Calculated additional Parameters for "SolveImageCompletion"
alphak = alpha;
lambda1 = norm(incomplete_data,'fro');
lambda2 = 0.02*lambda1;
%lambda2=0.0015*lambda2;

% Dimensions
[n_energy,n_probe,n_x,n_y]=size(X0);
% 
k=1;
idx=1;
while alphak > tol2
    % Use Algorithm1 to compute next image iteration
    [X] = Algorithm1_4D_test_time(X0, incomplete_data, P, lambda1*(alphak*5e-2),lambda2*(alphak*5e-2), mu,kmax,tol1);
    
    % Update parameters
    alphak = alpha*alphak;

    % Update X0
    X0 = X;
    
    % Compute Residual History
    if mod(k,5)==1
        res_out_hist(idx) = norm(P.*(X - incomplete_data),'fro')/norm(P.*incomplete_data,'fro');
        e_c_hist(idx) = norm(full_data - X,'fro')/norm(full_data,'fro');
        X_energy = reshape(X,n_energy,n_probe*n_x*n_y)';
        [~,S,~]=svd(X_energy,'econ');
        figure(1)
        semilogy(S,'r*')
        idx=idx+1;
    end
    k=k+1;
end
completed_data = X0;
end