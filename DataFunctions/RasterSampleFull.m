function [M,Omega] = RasterSampleFull(data_energy_unfolding)
% Function randomly samples each image in tensor to a specified ratio.
% Where the sampler uses row raster sampling.

% Pick Sample Ratio
sample_ratio = SampleRatio();

% Dimensions
n_energy = 90;
n_probe = 225;
n_x_probe = 15;
n_y_probe = 15;
n_x = 32;
n_y = 32;

% % each row is a probe.
% data_probe_unfolding=reshape(data_energy_unfolding',n_probe,n_energy*n_x*n_y);

% 
% data_4D = reshape(data_energy_unfolding,n_energy,n_probe,n_x,n_y);
% 
% X_full = reshape(complete_data,n_E,[]);

% Define sample and sample map
M = 0*data_energy_unfolding;
Omega = M;


% Select Energy Level
for i=1:n_energy
    % Select Energy Level
    data_const_energy = data_energy_unfolding(i,:);

    % Generate probe pattern
    [ind_sample_probe] = RasterSampler(n_x_probe,n_y_probe,sample_ratio);

    % Select the probe unfolding (each row is a probe)
    data_probe_unfolding_const_energy = reshape(data_const_energy,n_probe,n_x*n_y);

    % Generate mask
    omega_probe = ones(n_probe,n_x*n_y);
    omega_probe(ind_sample_probe,:) = 0;

    % Apply probe mask to data
    data_probe_unfolding_const_energy(ind_sample_probe,:) = 0;

    % Change into a vector to store
    omega_const_energy = reshape(omega_probe,1,[]);
    data_const_energy = reshape(data_probe_unfolding_const_energy,1,[]);
    
    % Store data
    M(i,:) = data_const_energy;
    Omega(i,:) = omega_const_energy;
end
end