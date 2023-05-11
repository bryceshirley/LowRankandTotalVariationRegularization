%% Test Functions

% N^2 Pixels in Original Image
N=50;

% Portion of original image to be removed (/Corrupted)
ratio = 0.5;

% Generate Image, Mask and Corrupted Image
[XCorrupted,KnownPixels,XOriginal] = GenerateImage(N,ratio);

% Set Algorithm 2 Parameter Values
alpha = 0.9;
mu = 2.2;
kmax = 1000; 
tol1 = 1e-6; 
tol2 = 1e-5; 

% Recover Original Image from Corrupted Image
XRecovered = Algorithm2(XCorrupted,KnownPixels,mu,kmax,tol1,tol2,alpha);


% Plot results
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


% Display Relative Frobenius Norms
disp('Relative Frobenius Norm between Recovered Image and Original Image')
disp(norm(XOriginal-XRecovered,'fro')/norm(XOriginal,'fro'))
disp(' ')
disp('Relative Frobenius Norm between Recovered Image and Corrupted Image')
disp(norm(XCorrupted-XRecovered,'fro')/norm(XCorrupted,'fro'))
