function [M,Omega] = RasterSampleFull(file_name)
% Function randomly samples each image in tensor to a specified ratio.
% Where the sampler uses row raster sampling.

% Pick Sample Ratio
sample_ratio = SampleRatio();

% Load corresponding full data set:
full_file_name = ['DataFiles/',file_name(5:17),'_stack_completed.hdf5'];
complete_data = h5read(full_file_name,'/exchange/data');

[n_E,n1,n2] = size(complete_data);
X_full = reshape(complete_data,n_E,[]);

% Define sample and sample map
M = zeros(n_E,n1*n2);
Omega = zeros(n_E,n1*n2);

% Sample data
for i=1:n_E
    % Select one image from data
    image_matrix = reshape(X_full(i,:),n1,n2);

    % Select a random spiral of pixels
    [sample_matrix,sample_image] = RasterSampler(image_matrix,sample_ratio);

    % Store in output
    M(i,:) = reshape(sample_image,1,n1*n2);
    Omega(i,:) = reshape(sample_matrix,1,n1*n2);
end
end