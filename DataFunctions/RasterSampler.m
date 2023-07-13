function [ind_probe_sample] = RasterSampler(n_x_probe,n_y_probe,sample_ratio)
% Function Samples Images Using Raster Row Sampling

% Generate a random permutation of row indices
ind_row = randperm(n_x_probe);

% Select portion of random permutation of indices 
ind_row = ind_row(1:floor(n_x_probe*(sample_ratio))); % Select the first "ratio" of ind

ind_probe = 1:(n_x_probe*n_y_probe);
ind_probe_matrix=reshape(ind_probe,n_x_probe,n_y_probe);

% remove random selection of rows from probe grid
ind_probe_matrix(ind_row,:)=0;

% change into probe sampling
ind_probe_sample = nonzeros(reshape(ind_probe_matrix,1,[]));
end