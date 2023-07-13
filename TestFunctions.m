clear all;
clc
close all;
%% Add Folders to path

addpath ('AlgorithmFunctions\','Algorithms\','DataFunctions\','DataFiles\')

%% Generate Image/Corrupted Image

[XCorrupted,KnownPixels,XOriginal] = GenerateImage();

%% Initialize Parameters

% Algorithm parameters
alpha = 0.95; % Regularization Dampening parameter
mu = 2; % Proximal term parameter

% Stopping Parameters 
kmax = 5; % Max Iterations for Algorithm 1
tol1 = 1e-16; % Tolerence Covergence Parameter for Algorithm 1
tol2 = 1e-2; % Tolerence for Algorithm 2 on alpha k

% Run Algorithm 2: To Reconstruct Image

tic;
[XRecovered,XStore] = Algorithm2(XCorrupted,KnownPixels,mu,kmax,tol1,tol2,alpha);
T=toc;

figure(1)
subplot(1,3,1)
[~,S,~]=svd(XOriginal);
semilogy(diag(S),'*')
title('Full Data')
subplot(1,3,2)
[~,S,~]=svd(XCorrupted);
semilogy(diag(S),'*')
title('Corrupted Data')
subplot(1,3,3)
[~,S,~]=svd(XRecovered);
semilogy(diag(S),'*')
title('Recovered Data')
disp(['The runtime was: ', num2str(T),'s'])

% Output Error Related Results

ErrorResults(XStore,XOriginal,XCorrupted,KnownPixels)

%% Plot Final Reconstructions

figure(3)
subplot(1,3,1)
imshow(XOriginal);
xlabel('Original Image')
subplot(1,3,2)
imshow(XCorrupted);
xlabel('Corrupted Image')
subplot(1,3,3)
imshow(XRecovered);
xlabel('Recovered Image')
sgtitle({'Low Rank and Total Variation Regularization', ...
    'Applied to Image Recovery'})
