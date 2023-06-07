function testRank(S)
% Select singular values
S_values=diag(S);

% Output
disp(' ')
disp(['The approximate rank is: ',num2str(length(S_values(S_values>1e-5)))])
disp(' ')
semilogy(1:length(S_values),S_values,'*')
title('Singular Value Decay')
ylabel('Singular Values')

end