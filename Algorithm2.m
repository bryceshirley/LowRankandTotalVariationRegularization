
N=50;
% N^2 Pixels in Original Image
XOriginal = phantom(N);

% Generate a random permutation of the numbers from 1 and N^2
ind = randperm(N*N);

% Portion of original image to be removed
ratio = 0.5;

% Select portion of Random Permutation of indicies
ind = ind(1:floor(N*N*ratio)); % Select the first "ratio" of ind

% Remove "ratio" portion of pixels (generated randomly)
XVector = reshape(XOriginal,N*N,1);
XVector(ind) = 0;
M = reshape(XVector,N,N); 

% Convert indicies to row-col indicies
%[ind_i, ind_j] = ind2sub([N,N], ind);

% Now Select the Random ratio of indices from the original image and set
% the rest to be zero
%M = 0*XOriginal;
%M(ind_i,ind_j) = XOriginal(ind_i,ind_j);

% P is a Mask that is 1 for all known positions and 0 otherwises
% P = 0*M;
% P(ind_i,ind_j)=1;
PVector=ones(N*N,1);
PVector(ind)=0;
P = reshape(PVector,N,N);

% Set Initial Guess
X0 = M;

alpha = 0.9;
tol = 1e-5;
alphak = alpha;
lambda1 = norm(M,'fro');
lambda2 = 0.02*lambda1;
mu = 1.1;
kmax = 300;
Tol = 1e-6;
while alphak > tol
    [X] = SolveImageCompletion(X0, M, P, lambda1,lambda2, mu,kmax,Tol,alphak); % Should alpha_k be a parameter?
    alphak = alpha*alphak;
    X0 = X;
end

% Plot results
figure()
subplot(1,3,1)
imshow(XOriginal);
xlabel('Original Image')
subplot(1,3,2)
imshow(M);
xlabel('X_{0}')
subplot(1,3,3)
imshow(X0);
xlabel('Image after iterations')
sgtitle({'Low Rank and Total Variation Regularization', ...
    'Applied to Image Recovery'})

% figure(2);
% imshow(P);
% xlabel('Mask')



norm(XOriginal-X,'fro')/norm(XOriginal,'fro')

norm(M-X,'fro')/norm(M,'fro')
