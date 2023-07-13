function N=SelectMode()
% Select Mode for Unfolding

dlgtitle = 'Select Mode For Unfolding';
prompt = {'Choose 1,2 or 3'};
definput = {'1'};  
dims = [1 100];

answer = inputdlg(prompt,dlgtitle,dims,definput);
if isempty(answer)
    return
else
    N = str2double(answer{1});
end

% Validate r
validateattributes(N,{'numeric'},{'scalar','integer','positive','>=',1,'<=',3})
end