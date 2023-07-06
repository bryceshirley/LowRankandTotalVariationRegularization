function [sample_matrix,sample_image]=RasterSampler(full_image,sample_ratio)
% Function Samples Images Using Raster Row Sampling
% Inputs:
% - sample_ratio: the sample ratio
% - full_image: image in matrix for
% Outputs:
% - sample_matrix: Matrix with 1s at sampled pixels, 0 otherwise
% - sample_image: Matrix of sampled pixels

% Generate Parameter to Randomly Select Spiral Function
selection_interval = [2*pi,10*pi]; % Interval to be tuned
a = (selection_interval(2)-selection_interval(1)).*rand(1,1) + selection_interval(1);

% % Selects approx ratio from user.
% approx_sample_ratio = SampleRatio();

% Image size
[N,M] = size(full_image);

% interval_range=floor(N*sample_ratio);
% 
% interval_start=randi([1 (N-interval_range)]);
% interval_end = interval_start + interval_range;
% 
% rand_vec = zeros(N,1);
% rand_vec(interval_start:interval_end) = 1;
% 
% randI = diag(rand_vec);
% 
% % Generate samples
% sample_image=randI*full_image;
% sample_matrix=randI*ones(N,M);

% Random row selection
% Generate a random permutation of row indices
ind_row = randperm(N);

% Select portion of random permutation of indices 
ind_row = ind_row(1:floor(N*(1-sample_ratio))); % Select the first "ratio" of ind

% Generate randI
rand_vec = ones(N,1);
rand_vec(ind_row) = 0;
randI = diag(rand_vec);

% Generate samples: Select cols
sample_image=full_image*randI;
sample_matrix=ones(N,M)*randI;

% Generate samples: Select rows
% sample_image=randI*full_image;
% sample_matrix=randI*ones(N,M);
end