%% Add Folders to Path
addpath ('AlgorithmFunctions\','Algorithms\','TensorOperationFunctions\','Tests\','DataFiles\','DataFunctions\','SamplingExperiments\')
%%
[data,file_name] = PickDataSet('DataFiles');

% Load corresponding full data set:
full_file_name = ['DataFiles/',file_name(5:17),'_stack_completed.hdf5'];
complete_data = h5read(full_file_name,'/exchange/data');
% X_full = reshape(complete_data,n_E,[]);

[n_E,n1,n2]=size(complete_data);

matrix = zeros(n1,n2);

% [sample_matrix,sample_image,ratio]=SpiralSampler(matrix,5,0.08);
% figure()
% disp(ratio)
% imagesc(sample_matrix)
% 
% [sample_matrix,sample_image,ratio]=SpiralSampler2(matrix,10,500,0.1);
% figure()
% disp(ratio)
% imagesc(sample_matrix)
sample_matrix = reshape(sample_matrix,1,[]);

incomplete_data = reshape(complete_data,n_E,[]);
sumratio = 0;
for i=1:n_E
    data=incomplete_data(i,:);
    
    [sample_matrix,sample_image,ratio]=SpiralSampler(matrix,randi([1,20]),0.09);
    sumratio = sumratio + ratio;
    sample_matrix = reshape(sample_matrix,1,[]);
    data=data.*sample_matrix;
    incomplete_data(i,:,:)=data;
end
sumratio/n_E
imagesc(incomplete_data)