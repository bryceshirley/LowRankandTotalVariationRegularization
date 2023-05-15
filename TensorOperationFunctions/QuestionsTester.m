%% ~~~ Multilinear SVD Exercise Function Tester ~~~

% Various comments have been added to provided an explanation of the theory
% with in this file and the functions accossiated with it.


%% Question 1 - part 1
disp('~~~~~~~')
disp('Qu1) i.')
disp('~~~~~~~')
disp(' ')

m=1000;
n=100;

A = randn(m,n);
B = randn(m,n);

disp('Time to Compute Classic SVD - calculate AB^T directly.')
tic;
X = A*B';
[U,S,V]=svd(X,'econ');
toc;

disp('Time to Compute SVD with QR - calculate AB^T not directly.')
tic;
[U,S,V]=SvdABTranspose(A,B);
toc;

% Computing the standard SVD by first computing A*B' directly cost
% considerably more computational time and takes much more memory. Matlab
% is unable to store a matrix if the number of columns m are a couple of
% orders of magnitude larger.
% The computation of A*B' is also numerically unstable due to round off
% error.
% For these reasons A*B' should never be computed.
% Using the QR method as seen in function [U,S,V]=svdABTranspose(A,B)
% drastically improves these properties.


m=10^5;
n=100;

A = randn(m,n);
B = randn(m,n);

disp('Time to Compute SVD with QR - calculate AB^T not directly. Much larger A and B.')
QRstart=tic;
[Uqr,Sqr,Vqr]=SvdABTranspose(A,B);
QRtime=toc(QRstart);
disp(['Elapsed time is ', num2str(QRtime) ,' seconds.'])
% There m was too large for MATLABs memory when computing AB' directly,
% however, the svd was computed in approx 0.25s when using the QR
% decomposition.
%% Question 1 -part 2
disp('~~~~~~~~')
disp('Qu1) ii.')
disp('~~~~~~~~')
disp(' ')

disp('Time to Compute Classic SVD of A.')
tic;
[U,S,V]=svd(A,'econ');
toc;

% When using the random svd we want to choose parameter r so that we can
% approximate a rank-r matrix. This will later be down by introduceing
% another parameter p where we use r+p to generate a guassian matrix, which
% is called over sampling. For now we will just pick r << n.

% Random matrix columns parameter r:
r = 10;  % r<<n
disp('Time to Compute Randomized SVD of matrix A.')
tic;
[Ur,Sr,Vr] = RandomizedSVD(A,r);
toc;

% Relative Frobenius Norm of randomized approximation of A. 
% Approximation of A 
Ar = Ur*(Sr*Vr');

disp('Relative Frobenius norm of randomized svd approximation of A')
relativeFrobeniusNorm = norm(A-Ar, 'fro')/norm(A,'fro');
disp(relativeFrobeniusNorm);
%% Question 1 -part 3
disp('~~~~~~~~~')
disp('Qu1) iii.')
disp('~~~~~~~~~')

disp('Recall the time to compute the SVD using QR Method of AB^T:')
disp(['Elapsed time was ', num2str(QRtime) ,' seconds.'])


disp('Time to Compute randomized SVD of matrix AB^T.')
tic;
[Ur,Sr,Vr] = RandomizedSvdABTranspose(A,B,r);
toc;

% I know this is wrong but what is the alternative?
% Recall: ||A||_fro equals ||S||_fro where ||.||_fro is the Frobenius Norm.
% relativeFrobeniusNorm = norm(diag(Sr)-diag(Sqr), 'fro')/norm(diag(Sqr),'fro'); 
% disp(relativeFrobeniusNorm);

%% Construct Matrix X for Questions 2 to 6
I1=100; I2=200; I3=300;

X = xTensor(I1,I2,I3);

%% Question 2-5 Multilinear SVD
disp(' ')
disp('~~~~~~~')
disp('Qu2-5) ')
disp('~~~~~~~')
disp(' ')
disp('Computation time for Multilinear SVD:')


% Using Classic svd
tic;
Y = TensorSVD(X);
toc;

% Qu4 Compute X-Y
disp(' ')
disp('Relative Frobenius Norm:')
relativeFrobeniusNorm = norm(X-Y, 'fro')/norm(X,'fro');
disp(relativeFrobeniusNorm)
%% Qu5
% Define tau
tau = 1e-10;
disp(' ')
disp('~~~~~~~')
disp('Qu5)')
disp('~~~~~~~')
disp(' ')
disp('Computation time for trunctated Multilinear SVD:')

tic;
% Compute Truncated SVD Approximation of a X
Y = TensorTruncSVD(X,tau);
toc;

disp(' ')

% Compute the relative Frobenius Norm between X and truncated Y
disp('Relative Frobenius Norm:')
relativeFrobeniusNorm = norm(X-Y, 'fro')/norm(X,'fro');
disp(relativeFrobeniusNorm)
disp('Tolerence tau:')
disp(tau)
%% Question 6: Randomized Truncated SVD
tau = 1e-10;
r = 19; % Guess what the truncated r-rank will be based on Tau.

disp(' ')
disp('~~~~~~~')
disp('Qu6)')
disp('~~~~~~~')
disp(' ')
disp('Computation time for Randomized Trunctated Multilinear SVD:')
tic;

% Compute Randomized Truncated SVD Approximation of a X
Y = TensorRandTruncSVD(X,tau,r); 

toc;
disp(' ')

% Compute the relative Frobenius Norm between X and truncated Y
disp('Relative Frobenius Norm:')
relativeFrobeniusNorm = norm(X-Y, 'fro')/norm(X,'fro');
disp(relativeFrobeniusNorm)
disp(' ')
disp('Tolerence tau:')
disp(tau)