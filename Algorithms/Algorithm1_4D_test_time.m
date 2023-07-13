function [Xk] = Algorithm1_4D_test_time(X0, M, P, lambda1,lambda2, mu,kmax,Tol)
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

% Dimensions
[n_energy,n_probe,n_x,n_y]=size(X0);

% Unfolding mode
while k < kmax

    % We are assuming low rank variation between the energy unfolding
    % Xk_energy = reshape(Xk,n_energy,n_probe*n_x*n_y)'; 

    
    %% Compute Singular values with svd
    % Compute Lp-norm of Singular Values
    % tic;
    % [~, S, ~] = svd(Xk_energy,'econ');
    % T=toc;
    % disp('Singular values with SVD')
    % disp(T)

    %% Compute Singular values without svd
    % % tic;
    % D = eig(Xk_energy'*Xk_energy); % more rows than colums so X'X better than XX'
    % % Remove negative errors
    % D(D<0)=0;
    % 
    % % Change to descending order
    % [~,ind] = sort(D,'descend');
    % D = D(ind);
    % 
    % % Find singular values
    % S = sqrt(D);
    % % T=toc;
    % % disp('Singular values with no SVD')
    % % disp(T)
    % 
    % %%
    % p=1; % Lp norm (has to be <=1)
    % w = Derivative_Weighted_Lpnorm_SF(S,lambda1,p)./mu;

    % Since p=1
    w=lambda1/mu;

    
    % Compute the subgradient of the TV norm of Xk
    subGradTVnorm4D = SubGradTVNorm4D(Xk); %Tensor
    
    % Compute tk
    tk = Computetk(Xk,subGradTVnorm4D,P,M,lambda2); % Tensor
    
    % Define Y
    Y = Xk - (1/mu).*tk; % Tensor
    
    %% Compute Next Iteration with no SVD
    % tic;
    % Compute Xk+1
    % Unfold so that each row is an energy
    Y_energy = reshape(Y,n_energy,n_probe*n_x*n_y)'; 
    [V,D] = eig(Y_energy'*Y_energy);
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
    % disp('Current Rank')
    % disp(length(ind))
    % disp(' ')
    X_new = Y_energy*(Vw*Vw');

    X_new = reshape(X_new,n_energy,n_probe,n_x,n_y);
    % T=toc;
    % disp('Calculate next iteration with no SVD')
    % disp(T)

    %% Compute Next Iteration with SVD
    % tic;
    % % Compute Xk+1
    % % Unfold so that each row is an energy
    % Y_energy = reshape(Y,n_energy,n_probe*n_x*n_y)'; 
    % 
    % [U, S, V] = svd(Y_energy,'econ');
    % 
    % 
    % Sw = shrinkage(diag(S), w);
    % ind = find(Sw>0);
    % 
    % Uw = U(:,ind);
    % Sw = diag(Sw(ind));
    % Vw = V(:,ind);
    % 
    % X_new = Uw*(Sw*Vw');
    % 
    % % Reshape back to tensor
    % X_new = reshape(X_new,n_energy,n_probe,n_x,n_y);
    % 
    % T=toc;
    % disp('Calculate next iteration with SVD')
    % disp(T)
    
    %% Check for convergence
    if norm(X_new - Xk, 'fro') < Tol*norm(Xk, 'fro')
        Xk = X_new;
        break;
    end
    
    % Update k and X
    k = k + 1;
    Xk = X_new;
end
end
