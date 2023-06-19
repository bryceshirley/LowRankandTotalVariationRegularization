function ErrorResults(XStore,XOriginal,XCorrupted,KnownPixels)

[totalAlg2Iterations,n1,n2] = size(XStore);

% Commpute norms for various iterations
X = reshape(XStore(2,:,:),n1,n2);
totalRelativeError(1)=norm(XOriginal-X,'fro')/norm(XOriginal,'fro');
relativeError(1)=norm(KnownPixels.*(XCorrupted-X),'fro')/norm(XCorrupted,'fro');
idx=2;
for i=10:10:totalAlg2Iterations
    X = reshape(XStore(i,:,:),n1,n2);
    totalRelativeError(idx)=norm(XOriginal-X,'fro')./norm(XOriginal,'fro');
    relativeError(idx)=norm(KnownPixels.*(XCorrupted-X),'fro')./norm(XCorrupted,'fro');
    idx=idx+1;
end

% Display Relative Frobenius Norms
disp('Relative Frobenius Norm between Recovered Image and Original Image')
disp(totalRelativeError(end))
disp(' ')
disp('Relative Frobenius Norm between Recovered Image and Corrupted Image')
disp(relativeError(end))
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