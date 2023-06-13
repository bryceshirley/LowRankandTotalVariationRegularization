% Completes spectromicroscopy data
clear
clc
close all

compare = 1;

addpath ('AlgorithmFunctions\','Algorithms\','TensorOperationFunctions\','Tests\','DataFiles\')
% First choose file from list
d = dir('DataFiles'); % structure for Data directory folder
file_All = {d.name}; % lists file names including '.' and '..'
file_All = file_All(3:end); % Ignore '.' and '..'

list = {};

% Construct file list in current directory
for i = 1:length(file_All)
    f_name = file_All{i};
    if ~strcmp('hdf5',f_name(end-3:end)) %see help
    elseif length(f_name) > 15 && strcmp('_completion',f_name(end-15:end-5))
    elseif length(f_name) > 19 && strcmp('_completion',f_name(end-19:end-9))
    elseif length(f_name) > 15 && strcmp('_completed',f_name(end-14:end-5))
    else
        list = [list,f_name]; %#ok<AGROW> 
    end
end
list = [list,'Manual'];

% Create Prompt
[indx,tf] = listdlg('PromptString',{'Choose hdf5 file from this directory.',...
                    ' ',"Alternatively, select 'Manual' to enter path directly.", ...
                    ' '},'ListString',list,'Name','Select Mantis File', ...
                    'SelectionMode','single','OKString','Select','ListSize', [350,150]);
if tf == 0
    return
end

% Set other user inputs:
dlgtitle = 'Enter Inputs';

if indx == length(list)
    % Manually enter file path too
    prompt = {'Enter path:'};
    definput = {'path to file'};  
    dims = [1 85];

    answer = inputdlg(prompt,dlgtitle,dims,definput);
    if isempty(answer)
        return
    else
        file_name = answer{1};
    end

    % Validate path entered
    if ~isfile(file_name)
        file_name_new = [file_name,'.hdf5'];
        if ~isfile(file_name_new)
            error('Input 1: No such file on path.')
        else
            file_name = file_name_new;
        end
    else
        file_extension = file_name(end-3:end);
        if ~strcmp(file_extension,'hdf5')
            error('File must be an hdf5.')
        end
    end    
else
    file_name = list{indx};
end

% Access data in hdf file:
try
    data = h5read(file_name,'/exchange/data');
catch
    error('File Specified is not a Mantis file.')
end

% Format data set:
[n_E,n1,n2] = size(data);
A_sparse = reshape(data,n_E,n1*n2);
Amax = max(max(A_sparse));
Amin = min(min(A_sparse));
% Comstruct Omega, M and compute true undersample ratio:
Omega = A_sparse ~= -1;

M = A_sparse.*Omega;

%% Hussam's Algorithm

% Run Algorithm 2: To Reconstruct Image
alpha = 0.95;
mu = 2; % Proximal term parameter

% Loop Stopping Parameters 
kmax = 20; % Max Iterations for Algorithm 1
tol1 = 1e-4; % Tolerence Covergence Parameter for Algorithm 1
tol2 = 1e-4; % Tolerence for Algorithm 2 on alpha k

% Recover Original Image from Corrupted Image
XCorrupted = reshape(M,n_E,n1,n2);
KnownPixels = reshape(Omega,n_E,n1,n2);
tic
XRecovered = Algorithm2_3D(XCorrupted,KnownPixels,mu,kmax,tol1,tol2,alpha);
T=toc;


% Compute residual of completion:
res_out=norm(KnownPixels.*(XCorrupted-XRecovered),'fro')/norm(XCorrupted,'fro');
p_true = sum(sum(Omega))/numel(Omega);


disp('Numerical Results for Hussams Algorithm')
% Display numerical results
disp(' ')
disp(['Completion Run Time:           T = ', num2str(T),'s'])
disp(' ')
disp(['True Undersample Ratio:        p = ', num2str(p_true)])
disp(' ')
disp(['Completion Residual:     res_out = ', num2str(res_out)])
disp(' ')

% Plot images of data sets:
figure(1)
imagesc(A_sparse)
colorbar
axis off
title('Colour Map of Sparse Data Set (flattened)')
xlabel('Pixels')
ylabel('Energy Levels')

figure(2)
A_out = reshape(XRecovered,n_E,n1*n2);
imagesc(A_out);
caxis manual
caxis([Amin Amax]);
colorbar
title('Colour Map of Completed Data Set Hussam Algorithm(flattened)')
xlabel('Pixels')
ylabel('Energy Levels')
axis off

% Compare with real data
if compare == 1
    % % Load corresponding full data set:
    % full_file_name = [file_name(1:12),'100'];
    % load(full_file_name,'data')
    % A_full = reshape(data,n_E,[]);

    % Load corresponding full data set:
    full_file_name = ['DataFiles/',file_name(5:17),'_stack_completed.hdf5'];
    complete_data = h5read(full_file_name,'/exchange/data');
    A_full = reshape(complete_data,n_E,[]);

    % Compute scanning residual and completion error
    res_scan = norm(Omega.*(A_full - M),'fro')/norm(Omega.*(A_full),'fro');
    e_c = norm(A_full - A_out,'fro')/norm(A_full,'fro');

    disp(['Sparse Scan Residual:   res_scan = ', num2str(res_scan)])
    disp(' ')
    disp(['Completion Error:            e_c = ', num2str(e_c)])
    disp(' ')

    % figure
    % imagesc(A_full)
    % axis off
end

beep
disp('Completion is... Complete!')
disp(' ')
disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
disp(' ')
%% LoopASD Diamonds Algorithm
A_sparse = reshape(data,n_E,[]);

% Input completion rank r
file_name = list{indx};
dlgtitle = 'Continue to run LOOPASD';
prompt = {'Set Completion Rank (3 - 12):'};
definput = {'8'};  
dims = [1 100];

answer = inputdlg(prompt,dlgtitle,dims,definput);
if isempty(answer)
    return
else
    r = str2double(answer{1});
end

% Validate r
validateattributes(r,{'numeric'},{'scalar','integer','positive','>',2,'<',15},file_name,'r',2)

% Fixed Variables
tol = 1e-8;
kmax = 2000;

% Comstruct Omega, M and compute true undersample ratio:
r=8;
Omega = A_sparse ~= -1;
p_true = sum(sum(Omega))/numel(Omega);
M = A_sparse.*Omega;

%Complete Data:
tic
[X_out,Y_out,k_fin,res] = LoopedASD_ES(M,Omega,r,tol,kmax);
T = toc;
A_out = X_out*Y_out;

%Compute residual of completion:
res_out = norm(Omega.*(A_out - A_sparse),'fro')/norm(Omega.*A_sparse,'fro');



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
figure(3)
imagesc(A_out)
caxis manual
caxis([Amin Amax]);
colorbar
title({'Colour Map of Completed Data Set LoopASD (flattened)',['with Completion Rank = ',num2str(r)]})
xlabel('Pixels')
ylabel('Energy Levels')
axis off

% Compare with real data
if compare == 1
    % % Load corresponding full data set:
    % full_file_name = [file_name(1:12),'100'];
    % load(full_file_name,'data')
    % A_full = reshape(data,n_E,[]);

    % Load corresponding full data set:
    full_file_name = ['DataFiles/',file_name(5:17),'_stack_completed.hdf5'];
    data = h5read(full_file_name,'/exchange/data');
    A_full = reshape(data,n_E,[]);

    % Compute scanning residual and completion error
    res_scan = norm(Omega.*(A_full - M),'fro')/norm(Omega.*(A_full),'fro');
    e_c = norm(A_full - A_out,'fro')/norm(A_full,'fro');

    disp(['Sparse Scan Residual:   res_scan = ', num2str(res_scan)])
    disp(' ')
    disp(['Completion Error:            e_c = ', num2str(e_c)])
    disp(' ')

    figure
    imagesc(A_full)
    title('Colour Map of Complete Data Set (flattened)')
    caxis manual
    caxis([Amin Amax]);
    colorbar
    axis off
end

beep
disp('Completion is... Complete!')
%% Don't Save completed version

% % Copy original file to store completed data set
% data_complete = reshape(A_out,[n_E,n1,n2]);
% file_name_complete = [file_name(1:end-5),'_completion.hdf5'];
% 
% % Add version number if file already exists
% file_exists = isfile(file_name_complete);
% i = 1;
% while file_exists
%     file_name_complete = [file_name_complete(1:end-5),'-(',num2str(i),').hdf5'];
%     i = i+1;
%     if ~isfile(file_name_complete)
%         file_exists = 0;
%     end
% end

% status = copyfile(file_name,file_name_complete);
% 
% if status == 0
%     error("Failed to make copy of hdf file to store completed data. Completed data set is in 'data_complete' variable.")
% end
% 
% % Replace data with completion in hdf file.
% h5write(file_name_complete,'/exchange/data',data_complete)