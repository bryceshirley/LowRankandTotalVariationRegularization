function testRank(X)

[~, S, ~] = svd(X,'econ');

[n,m]=size(X);

% Select singular values
S_values=diag(S);

% Output
disp(' ')
disp(['The approximate rank is: ',num2str(length(S_values(S_values>1e-5)))])
disp(' ')
disp(['The max possible rank is: ', num2str(min(n,m))])

semilogy(1:length(S_values),S_values,'*-')
title('Singular Value Decay')
ylabel('Singular Values')

end