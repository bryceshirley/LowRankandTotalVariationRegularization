% Completes spectromicroscopy data
clear
clc
close all
%% Add Folders to Path
addpath ('AlgorithmFunctions\','Algorithms\','TensorOperationFunctions\','Tests\','DataFiles\','DataFunctions\')


%% Prepare Data

% Dimensions
n_energy = 90;
n_probe = 225;
n_x_probe = 15;
n_y_probe = 15;
n_x = 32;
n_y = 32;

% Load corresponding full data set:
full_data_flattened=double(h5read('DataFiles/SimDat.hdf5','/dataset_1'))'; % each row is an energy
full_data_tensor=reshape(full_data_flattened,n_energy,n_probe,n_x,n_y);

% Generate Raster sample and mask
[incomplete_data_flattened,mask_flattened] = RasterSampleFull(full_data_flattened);

% % Full data set
% Amax = max(max(data_energy_unfolding));
% Amin = min(min(data_energy_unfolding));


%% Hussam's Algorithm

% Run Algorithm 2: To Reconstruct Image
alpha = 0.95;
mu = 2; % Proximal term parameter

% Loop Stopping Parameters 
kmax = 5; % Max Iterations for Algorithm 1
% kmax2 = 30; % Max Iterations for Algorithm 2
tol1 = 1e-2; % Tolerence Covergence Parameter for Algorithm 1
tol2 = 1e-2; % Tolerence for Algorithm 2 on alpha k

% Tensor samples
incomplete_data_tensor = reshape(incomplete_data_flattened,n_energy,n_probe,n_x,n_y);
mask_tensor = reshape(mask_flattened,n_energy,n_probe,n_x,n_y); % Mask 

% Complete Data:
tic
[completed_data_tensor,res_out_hist,e_c_hist] = Algorithm2_4D(incomplete_data_tensor,mask_tensor,mu,kmax,tol1,tol2,alpha,full_data_tensor);
T=toc;

completed_data_flattened = reshape(completed_data_tensor,n_energy,n_probe*n_x*n_y);
%% Numerical Results

% Find true undersampling ratio
p_true = sum(sum(mask_flattened))/numel(mask_flattened);

%Compute residual of completion:
res_out = norm(mask_flattened.*(completed_data_flattened - incomplete_data_flattened), ...
    'fro')/norm(mask_flattened.*incomplete_data_flattened,'fro');

% Compare with real data
% Compute scanning residual and completion error
res_scan = norm(mask_flattened.*(full_data_flattened - incomplete_data_flattened), ...
    'fro')/norm(mask_flattened.*(full_data_flattened),'fro');
e_c = norm(full_data_flattened - completed_data_flattened,'fro')/norm(full_data_flattened,'fro');

disp('Numerical Results for Hussams Algorithm')
disp(' ')
disp(['Completion Run Time:           T = ', num2str(T),'s'])
disp(' ')
disp(['True Undersample Ratio:        p = ', num2str(p_true)])
disp(' ')
disp(['Completion Residual:     res_out = ', num2str(res_out)])
disp(' ')
disp(['Total Completion Error:            e_c = ', num2str(e_c)])
disp(' ')
disp(['Sparse Scan Residual:   res_scan = ', num2str(res_scan)])
disp(' ')

%% Graphical Results
figure(1)
semilogy(res_out_hist,'r*')
hold on
semilogy(e_c_hist,'bx')
legend('Known Data Error','Total Completion Error')
xlabel('Iteration')
ylabel('Error')
title(['kmax = ',num2str(kmax)])

%% Save data
h5create('completed_matrix_pty.hdf5', '/dataset1',size(completed_data_flattened))
h5write('completed_matrix_pty.hdf5', '/dataset1', completed_data_flattened)
h5create('mask_matrix_pty.hdf5', '/dataset1',size(mask_flattened))
h5write('mask_matrix_pty.hdf5', '/dataset1', mask_flattened)
h5create('incomplete_matrix_pty.hdf5', '/dataset1',size(incomplete_data_flattened))
h5write('incomplete_matrix_pty.hdf5', '/dataset1', incomplete_data_flattened)