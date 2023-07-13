%% Add Folders to Path
addpath ('AlgorithmFunctions\','Algorithms\','TensorOperationFunctions\','Tests\','DataFiles\','DataFunctions\')



data_energy_unfolding=double(h5read('DataFiles/SimDat.hdf5','/dataset_1'));
data_4D = reshape(data_energy_unfolding,n_energy,n_probe,n_x,n_y);

% [Uc,Sc,Vc] = svd(data_energy_unfolding, 'econ');
% semilogy(Sc,'b*-')

% imagesc(data_energy_unfolding)


%% 4D data

n_energy = 90;
n_probe = 225;
n_x = 32;
n_y = 32;

data_4D = reshape(data_energy_unfolding,n_energy,n_probe,n_x,n_y);

data_gridx_unfolding=reshape(reshape(data_4D,n_energy*n_probe,n_x*n_y)', n_x,n_y*n_energy*n_probe);
data_gridy_unfolding=reshape(data_4D,n_energy*n_probe*n_x,n_y)';
% figure()
% [Uc,Sc,Vc] = svd(data_gridx_unfolding, 'econ');
% semilogy(diag(Sc),'*-')
%hold on
% [Uc,Sc,Vc] = svd(data_gridy_unfolding, 'econ');
% semilogy(diag(Sc),'x-')
% [Uc,Sc,Vc] = svd(data_energy_unfolding, 'econ');
% semilogy(diag(Sc),'o-')



% reshape(data,n_energy,[]);
% x1=reshape(data,n_energy*n_probe*n_x,n_y)';
% x2=reshape(reshape(data,n_energy*n_probe,n_x*n_y)',n_x,n_y*n_energy*n_probe);


% norm(x1-x2,'fro')
% 
% data_4D = reshape(data,n_energy,n_probe,n_x,n_y);
% 
% M = TotalVariationAcrossEnergies4D(data_4D);
% 
% 
% % Display scaled Frobenius Norm
% disp(norm(data_4D,'fro'))
% disp(norm(M,'fro'))
% TV_test = norm(M,'fro')/norm(data_4D,'fro');
% 
% disp(TV_test)
% 
% % Normalize and apply  to find ratio of zeros to non-zeros
% M_mode_1 = reshape(M,n_energy,[]);
% imagesc(M_mode_1)
% colorbar
% scaled = M_mode_1/max(max(data));
% threshold =0.001;
% scaled(scaled<threshold) =0;
% scaled(scaled>0)=1;
% sum(sum(scaled))/(n_energy*n_probe*n_x*n_y)

figure(2)
hold on
slice_frame = reshape(data_4D(10,10,:,:),n_x,n_y);
slice_energy = reshape(data_4D(:,:,10,10),1,[]);
plot(slice_energy/max(max(slice_energy)))
imshow(slice_energy/max(max(slice_energy)))
xlabel('energy')
ylabel('f(energy)')

title('Normalized plot of how energy varies for fixed probe and pixel (10,10)')

%slice_frame = slice_frame/max(max(abs(slice_frame)));
% figure()
% imagesc(slice_frame)
% colorbar
% 
% TV_slice = TotalVariationMatrix(slice_frame);
% figure()
% imagesc(TV_slice)
% colorbar
% 
% M = TotalVariationInFramesTensor4D(data_4D);
% M_mode_1 = reshape(M,n_energy,[]);

%nnz(round(M_mode_1./max(max(abs(data))),5))/(numel(M_mode_1))
% % Display scaled Frobenius Norm
% M = TotalVariationTensor4D(data_4D);
% disp(norm(data_4D,'fro'))
% disp(norm(M,'fro'))
% TV_test = norm(M,'fro')/norm(data_4D,'fro');
% 
% disp(TV_test)
% 
% 
% % Display Data
% M_mode_1 = reshape(M,n_energy,[]);
% figure()
% imagesc(M_mode_1)
% colorbar
% figure()
% imagesc(M_mode_1./max(max(data)))
% colorbar
% 
% % Normalize and apply  to find ratio of zeros to non-zeros
% scaled = M_mode_1/max(max(data));
% threshold =0.01;
% scaled(scaled<threshold) =0;
% scaled(scaled>0)=1;
% sum(sum(scaled))/(n_energy*n_probe*n_x*n_y)




