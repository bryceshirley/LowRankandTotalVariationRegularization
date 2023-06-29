function [M,Omega] = RandomSampleFull(file_name)
% Function randomly samples each image in tensor to a specified ratio.

% Pick Sample Ratio
ratio = SampleRatio();

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
    image_matrix = reshape(X_full(i,:),n1,n2);
    [corrupt_image,Omega_matrix,~] = CorruptImage(image_matrix,ratio);
    M(i,:) = reshape(corrupt_image,1,n1*n2);
    Omega(i,:) = reshape(Omega_matrix,1,n1*n2);
end

end