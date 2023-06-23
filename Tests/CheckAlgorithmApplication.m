
%% Add Folders to Path
addpath ('..\AlgorithmFunctions\','..\Algorithms\','..\TensorOperationFunctions\','..\DataFiles\','..\DataFunctions\')

% Pick dataset
[data,file_name] = PickDataSet('..\DataFiles');

% Load corresponding full data set:
full_file_name = ['../DataFiles/',file_name(5:17),'_stack_completed.hdf5'];
complete_data = h5read(full_file_name,'/exchange/data');

% Choose Unfolding Mode
N=SelectMode();

XN = UnfoldTensor(complete_data,N);
Amax = max(max(XN));
Amin = min(min(XN));

% Plot Complete Image
figure
imagesc(XN)
title({'Colour Map of Complete Data Set', ['(flattened: mode-',num2str(N),' unfolding)']})
caxis manual
caxis([Amin Amax]);
colorbar
axis off

% Plot SVD decay of Complete Image
figure
testRank(XN);
title(['Singular Value Decay for Mode-',num2str(N),' Unfolding'])

% Unfolded Total Variation Tensor
figure
M = TotalVariationTensor(complete_data);
MN= UnfoldTensor(M,N);
imagesc(MN)
title(['Total Variation for Mode-',num2str(N),' Unfolding'])
caxis manual
caxis([Amin Amax]);
colorbar
axis off

%%

% [n_E,n1,n2]=size(M);
% figure
% imagesc(reshape(MN(2,:),n1,n2))
% title('Total Variation at First layer')
% caxis manual
% caxis([Amin Amax]);
% colorbar
% axis off
% % figure
% % imagesc(reshape(MN(round(end/2)+20,:),n1,n2))
% % caxis manual
% % caxis([Amin Amax]);
% % colorbar
% % axis off
% figure
% imagesc(reshape(MN(end,:),n1,n2))
% title('Total Variation at Final layer')
% caxis manual
% caxis([Amin Amax]);
% colorbar
% axis off