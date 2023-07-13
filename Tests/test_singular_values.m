% Completes spectromicroscopy data
clear
clc
close all
%% Add Folders to Path
addpath ('AlgorithmFunctions\','Algorithms\','TensorOperationFunctions\','Tests\','DataFiles\','DataFunctions\','SamplingExperiments\')


%% Prepare Data

% Pick DataSet
[data,file_name] = PickDataSet('DataFiles');


% Load corresponding full data set:
full_file_name = ['DataFiles/',file_name(5:17),'_stack_completed.hdf5'];
complete_data = h5read(full_file_name,'/exchange/data');



[n_E,n1,n2]=size(complete_data);

Ac = reshape(complete_data,n_E,[])';

Ai = reshape(data,n_E,[])';

(Ac-Ai)*M

figure()
imagesc(Ac)
figure()
imagesc(Ai)

[Uc,Sc,Vc] = svd(Ac, 'econ');

[Ui,Si,Vi] = svd(Ai, 'econ');


figure()
semilogy(diag(Sc),'*')
hold on
semilogy(diag(Si),'x')

