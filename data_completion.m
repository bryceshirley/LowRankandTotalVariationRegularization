% Completes spectromicroscopy data
clear
clc
close all
%% Add Folders to Path
addpath ('AlgorithmFunctions\','Algorithms\','TensorOperationFunctions\','Tests\','DataFiles\','DataFunctions\')


%% Prepare Data
% Pick DataSet
[data,file_name] = PickDataSet();

% Format data set:`
[n_E,n1,n2] = size(data);
A_sparse = reshape(data,n_E,n1*n2);
Amax = max(max(A_sparse));
Amin = min(min(A_sparse));

% Comstruct Omega, M and true undersampling ratio
Omega = A_sparse ~= -1;
p_true = sum(sum(Omega))/numel(Omega);
M = A_sparse.*Omega;

%% Hussam's Algorithm

% Run Algorithm 2: To Reconstruct Image
alpha = 0.95;
mu = 2; % Proximal term parameter

% Loop Stopping Parameters 
kmax = 50; % Max Iterations for Algorithm 1
kmax2 = 30; % Max Iterations for Algorithm 2
tol1 = 1e-2; % Tolerence Covergence Parameter for Algorithm 1
tol2 = 1e-2; % Tolerence for Algorithm 2 on alpha k

% Recover Original Image from Corrupted Image
XCorrupted = reshape(M,n_E,n1,n2);
KnownPixels = reshape(Omega,n_E,n1,n2);

% Complete Data:
tic
XStore = Algorithm2_3D(XCorrupted,KnownPixels,mu,kmax,tol1,tol2,alpha,kmax2);
T=toc;

Alg2_out = reshape(XStore(end,:,:),n_E,n1*n2);
%% Numerical Results

disp('Numerical Results for Hussams Algorithm')
disp(' ')
disp(['Completion Run Time:           T = ', num2str(T),'s'])
disp(' ')

A_full = ErrorResults(XStore,M,Omega,file_name);

%% Plot images of data sets:
figure()
imagesc(A_sparse)
colorbar
axis off
title('Colour Map of Sparse Data Set (flattened)')
xlabel('Pixels')
ylabel('Energy Levels')

figure()
imagesc(Alg2_out);
caxis manual
caxis([Amin Amax]);
colorbar
title('Colour Map of Completed Data Set Hussam Algorithm(flattened)')
xlabel('Pixels')
ylabel('Energy Levels')
axis off

beep
disp('Completion is... Complete!')
disp(' ')
disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
disp(' ')
%% LoopASD Diamonds Algorithm
% Algorithm Parameters
tol = 1e-4;
kmax = 2000;
r = SelectRank(file_name);

% Complete Data:
tic
[X_out,Y_out,k_fin,res] = LoopedASD_ES(M,Omega,r,tol,kmax);
LOOPASD_out = X_out*Y_out;
T = toc;

%% Results

%Compute residual of completion:
res_out = norm(Omega.*(LOOPASD_out - A_sparse),'fro')/norm(Omega.*A_sparse,'fro');



disp(['Numerical Results for LoopASD with Completion Rank = ',num2str(r)])
% Display numerical results
disp(' ')
disp(['Completion Run Time:           T = ', num2str(T),'s'])
disp(' ')
disp(['True Undersample Ratio:        p = ', num2str(p_true)])
disp(' ')
disp(['Completion Residual:     res_out = ', num2str(res_out)])
disp(' ')

% Plot images of data sets:
figure
imagesc(LOOPASD_out)
caxis manual
caxis([Amin Amax]);
colorbar
title({'Colour Map of Completed Data Set LoopASD (flattened)',['with Completion Rank = ',num2str(r)]})
xlabel('Pixels')
ylabel('Energy Levels')
axis off

% Compare with real data
% Compute scanning residual and completion error
res_scan = norm(Omega.*(A_full - M),'fro')/norm(Omega.*(A_full),'fro');
e_c = norm(A_full - LOOPASD_out,'fro')/norm(A_full,'fro');

disp(['Total Completion Error:            e_c = ', num2str(e_c)])
disp(' ')
disp(['Sparse Scan Residual:   res_scan = ', num2str(res_scan)])
disp(' ')

figure
imagesc(A_full)
title('Colour Map of Complete Data Set (flattened)')
caxis manual
caxis([Amin Amax]);
colorbar
axis off


beep
disp('Completion is... Complete!')

%% Unfold in X each layer
X_layers=reshape(reshape(Alg2_out,n_E,n1*n2)',n2,n_E*n2);
Full_layers=reshape(reshape(A_full,n_E,n1*n2)',n2,n_E*n2);
LOOPASD_layers=reshape(reshape(LOOPASD_out,n_E,n1*n2)',n2,n_E*n2);

figure()
subplot(1,2,1)
imagesc(X_layers(:,n2*80+1:n2*85))
caxis manual
caxis([Amin Amax]);
colorbar
axis off
title('Hussam''s Algorithm')
subplot(1,2,2)
imagesc(Full_layers(:,n2*80+1:n2*85))
title('Full Data')
caxis manual
caxis([Amin Amax]);
colorbar
axis off
set(gcf,'position',[20,150,600,200])

figure()
subplot(1,2,1)
imagesc(LOOPASD_layers(:,n2*80+1:n2*85))
title('LOOPASD')
caxis manual
caxis([Amin Amax]);
colorbar
axis off
subplot(1,2,2)
imagesc(Full_layers(:,n2*80+1:n2*85))
title('Full Data')
caxis manual
caxis([Amin Amax]);
colorbar
axis off
set(gcf,'position',[650,150,600,200])