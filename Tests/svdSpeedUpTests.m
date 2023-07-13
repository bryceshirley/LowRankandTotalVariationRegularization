function svdSpeedUpTests(N)
% Tests to find a quicker way of doing the svd and shrinking the data in
% this application

    %% Construct test data 
    Xk=phantom(N); 
    [n,r]=size(Xk);
    sample_ratio=0.5;
    % Generate a random permutation of row indices
    ind_row = randperm(n);

    % Select portion of random permutation of indices 
    ind_row = ind_row(1:floor(n*(sample_ratio))); % Select the first "ratio" of ind
    
    % Set Up samples
    P=ones(n,r);
    P(ind_row,:)=0;

    Xk(ind_row,:)=0;
    M=Xk;

  
    %% Test1: Compute Singular values without svd

    tic;
    D = eig(Xk'*Xk); 
    
    % Remove negative errors
    D(D<0)=0;

    % Change to descending order
    [~,ind] = sort(D,'descend');
    D = D(ind);
    
    % Find singular values
    S1 = sqrt(D);
    disp('Time to compute Singular values without SVD:')
    toc
    disp(' ')
    
    %% Test1: Compute singular values with svd function
    tic;
    [~, S, ~] = svd(Xk,'econ');
    disp('Time to compute Singular values with SVD:')
    toc
    disp(' ')

    disp('Relative difference in singular values computed:')
    disp(norm(S1-diag(S),'fro')/norm(S1,'fro'))
    disp(' ')
    %% Set up Second Test Section
    lambda1 = norm(Xk,'fro');
    lambda2 = 0.2*lambda1;

    % Compute Lp-norm of Singular Values
    p=1; % Lp norm (has to be <=1)
    mu=1.2;
    w = Derivative_Weighted_Lpnorm_SF(diag(S),lambda1,p)./mu;

    
    % Compute the subgradient of the TV norm of Xk
    subGradTVnorm2D = SubGradTVNorm2D(Xk); %Tensor

    % Compute tk
    tk = Computetk(Xk,subGradTVnorm2D,P,M,lambda2); % Tensor

    % Define Y
    Y = Xk - (1/mu).*tk; % Tensor

    %% Test2: Shrinkage using svd function
    tic;
    [U1, S1, V1] = svd(Y,'econ');
    disp('Time using svd function:')
    toc
    disp(' ')

    % Check svd error
    Y1=U1*S1*V1';
    disp('Error with svd function:')
    if norm(Y1,'fro')>0
    disp(norm(Y1-Y,'fro')/norm(Y1,'fro'))
    else
        disp(norm(Y1,'fro'))
    end
    disp('')

    % Apply Shrinkage
    S1w = shrinkage(diag(S1), w);
    ind1 = find(S1w>0);

    U1w = U1(:,ind1);
    S1w = diag(S1w(ind1)); 
    V1w = V1(:,ind1);
    
    % Compute updated data
    X_new1 = U1w*S1w*V1w';
    
    
    %% Test2: Shrinkage without svd function

    % Compute Xk+1
    % Unfold so that each row is an energy 

    tic;
    [V,D] = eig(Y'*Y);
    % Remove negative errors
    D(D<0)=0;
    % Change to descending order
    [~,ind] = sort(diag(D),'descend');
    D = D(ind,ind);
    V = V(:,ind);
    
    % Find singular values
    S = sqrt(diag(D));
       
    disp('Time without using svd function:')
    toc
    disp(' ')
    % Test svd error
    Y2=U*diag(S)*V';
    disp('Error without svd function:')
    if norm(Y2,'fro')>0
        disp(norm(Y2-Y,'fro')/norm(Y2,'fro'))
    else
        disp(norm(Y2,'fro'))
    end
    disp(' ')

    % Apply shrinkage
    Sw = S-w;
    ind = find(Sw>0);
    Vw = V(:,ind);

    % Compute updated data
    X_new2 = Y*(Vw*Vw');

    
    % Test Xk updated error
    disp('Error between new Xk:')
    if norm(X_new2,'fro')>0
    disp(norm(X_new2-X_new1,'fro')/norm(X_new2,'fro'))
    else
        disp(norm(X_new2,'fro'))
    end

end