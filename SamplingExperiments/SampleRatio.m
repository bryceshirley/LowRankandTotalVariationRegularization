function ratio = SampleRatio()
% Function selects ratio from user.

% Enter Ratio to be removed
    dlgtitle = 'Choose Variable';
    prompt = {'Enter Approx Ratio of Pixel:'};
    definput = {'0.2'};  
    dims = [1 85];

    answer = inputdlg(prompt,dlgtitle,dims,definput);
    if isempty(answer)
        return
    else
        ratio = str2double(answer{1});
    end

    % Validate inputs
    if ratio<1 && ratio > 0
    else
        error('Input 2: Not a number between 0 and 1.')
    end 
end