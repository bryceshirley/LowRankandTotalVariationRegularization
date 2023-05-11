%% Test Code 
N=256;
% Load image and set parameters
%X0 = double(imread(phantom(N)))/255;
X0 = phantom(N);
M = X0(1:256,1:256,:);
lambda = 0.05;
mu = 0.1;

% Solve image completion
X = solve_image_completion(X0, M, lambda, mu);

% Display results
figure;
subplot(1,2,1); imshow(M); title('Observed image');
subplot(1,2,2); imshow(X); title('Completed image');