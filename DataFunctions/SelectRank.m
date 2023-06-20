function r=SelectRank(file_name)
% Input completion rank r

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
end