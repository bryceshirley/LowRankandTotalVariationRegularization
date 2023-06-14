function [XCorrupted,P,XOriginal] = GenerateImage()

% First choose file from list
d = dir('DataFiles'); % structure for Data directory folder
file_All = {d.name}; % lists file names including '.' and '..'
file_All = file_All(3:end); % Ignore '.' and '..'

list = {};

% Construct file list in current directory
for i = 1:length(file_All)
    f_name = file_All{i};
    if ~strcmp('jpg',f_name(end-2:end)) %see help
    else
        list = [list,f_name]; %#ok<AGROW> 
    end
end
list = [list,'Phantom'];

% Create Prompt
[indx,tf] = listdlg('PromptString',{'Choose jpg file from this directory.',...
                    ' ',"Alternatively, select 'Phantom' function to enter size of test image.", ...
                    ' '},'ListString',list,'Name','Select a jpg File', ...
                    'SelectionMode','single','OKString','Select','ListSize', [350,150]);
if tf == 0
    return
end

% Set other user inputs:
dlgtitle = 'Enter Inputs:';

if indx == length(list)
    % Manually enter Phantom image size and ratio to be removed
    prompt = {'Enter N:','Enter Ratio of Pixels to Remove:'};
    definput = {'400','0.8'};  
    dims = [1 85];

    answer = inputdlg(prompt,dlgtitle,dims,definput);
    if isempty(answer)
        return
    else
        N = str2double(answer{1});
        ratio = str2double(answer{2});
    end

    % Validate inputs
    if mod(N,1)==0 && N > 0
    else
        error('Input 1: Not a postive integer.')
    end
    if ratio<1 && ratio > 0
    else
        error('Input 2: Not a number between 0 and 1.')
    end 

    imageMatrix = phantom(N);
else

    filename=list{indx};

    % Access data in file:
    try
        imageMatrix = imread(filename);
    catch
        error('File Specified is not an accessible type file.')
    end
    % Convert image to double
    imageMatrix= im2double(imageMatrix(:,:,1));

    % Enter Ratio to be removed
    prompt = {'Enter Ratio of Pixels to Remove:'};
    definput = {'0.8'};  
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


[XCorrupted,P,XOriginal] = CorruptImage(imageMatrix,ratio);

end