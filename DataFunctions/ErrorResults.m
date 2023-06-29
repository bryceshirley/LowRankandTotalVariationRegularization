function X_full = ErrorResults(XStore,M,Omega,file_name)
% Dimension: N=n1*n2
[totalIts,n_E,N] = size(XStore);

% % Completed Result
% X_out = reshape(XStore(end,:,:),n_E,N);

% Load corresponding full data set:
full_file_name = ['DataFiles/',file_name(5:17),'_stack_completed.hdf5'];
complete_data = h5read(full_file_name,'/exchange/data');
X_full = reshape(complete_data,n_E,[]);

% Compute scanning residual, completion error and true undersampling ratio
res_scan = norm(Omega.*(X_full - M),'fro')/norm(Omega.*(X_full),'fro');
p_true = sum(sum(Omega))/numel(Omega);


% Commpute norms for various iterations
X = reshape(XStore(1,:,:),n_E,N);
totalRelativeError(1)=norm(X_full-X,'fro')/norm(X_full,'fro');
relativeError(1)=norm(Omega.*(M-X),'fro')/norm(M,'fro');
idx=2;

for i=5:5:totalIts
    X = reshape(XStore(i,:,:),n_E,N);
    totalRelativeError(idx)=norm(X_full-X,'fro')/norm(X_full,'fro');
    relativeError(idx)=norm(Omega.*(M-X),'fro')/norm(M,'fro');
    idx=idx+1;
end

% Display Relative Frobenius Norms
disp(['True Undersample Ratio:        p = ', num2str(p_true)])
disp(' ')
disp(['Completion Residual:     res_out = ', num2str(relativeError(end))])
disp(' ')
disp(['Total Completion Residual:     res_out = ', num2str(totalRelativeError(end))])
disp(' ')
disp(['Sparse Scan Residual:   res_scan = ', num2str(res_scan)])
disp(' ')


% Plot Results
figure()
yyaxis left
semilogy((2:length(totalRelativeError))*10,totalRelativeError(2:end),'-*')
ylabel('Frobenius Norm')
yyaxis right
semilogy((2:length(relativeError))*10,relativeError(2:end),'-*')
ylabel('Frobenius Norm')
title('Relative Errors')
xlabel('Iterations')
legend('Total Relative Error','Relative Error Between Recovered Image and Corrupted Image')
end