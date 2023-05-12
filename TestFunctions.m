%% Generate Image/Corrupted Image

% N^2 Pixels in Original Image
N=400;

% Portion of original image to be removed (/Corrupted)
ratio = 0.9;

% Generate Image, Mask of Known Pixels Locations and Corrupted Image
[XCorrupted,KnownPixels,XOriginal] = GenerateImage(N,ratio);

%% Run Algorithm 2: To Reconstruct Image

alpha = 0.95;
mu = 2.2; % Proximal term parameter

% Loop Stopping Parameters 
kmax = 10; % Max Iterations for Algorithm 1
tol1 = 1e-6; % Tolerence Covergence Parameter for Algorithm 1
tol2 = 1e-5; % Tolerence for Algorithm 2 on alpha k

% Recover Original Image from Corrupted Image
XRecovered = Algorithm2(XCorrupted,KnownPixels,mu,kmax,tol1,tol2,alpha);

%% Calculate the Relative Frobenius Norms

% Display Relative Frobenius Norms
disp('Relative Frobenius Norm between Recovered Image and Original Image')
disp(norm(XOriginal-XRecovered,'fro')/norm(XOriginal,'fro'))
disp(' ')
disp('Relative Frobenius Norm between Recovered Image and Corrupted Image')
disp(norm(KnownPixels.*(XCorrupted-XRecovered),'fro')/norm(XCorrupted,'fro'))

%% Plot results
figure()
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
