% First choose file from list
d = dir('DataFiles'); % structure for Data directory folder
file_All = {d.name}; % lists file names including '.' and '..'
file_All = file_All(3:end); % Ignore '.' and '..'

list = {};

% Construct file list in current directory
for i = 1:length(file_All)
    f_name = file_All{i};
    if ~strcmp('hdf5',f_name(end-3:end)) %see help
    elseif length(f_name) > 15 && strcmp('_completion',f_name(end-15:end-5))
    elseif length(f_name) > 19 && strcmp('_completion',f_name(end-19:end-9))
    elseif length(f_name) > 15 && strcmp('_completed',f_name(end-14:end-5))
    else
        list = [list,f_name]; %#ok<AGROW> 
    end
end
list = [list,'Manual'];

% Create Prompt
[indx,tf] = listdlg('PromptString',{'Choose hdf5 file from this directory.',...
                    ' ',"Alternatively, select 'Manual' to enter path directly.", ...
                    ' '},'ListString',list,'Name','Select Mantis File', ...
                    'SelectionMode','single','OKString','Select','ListSize', [350,150]);
if tf == 0
    return
end

% Set other user inputs:
dlgtitle = 'Enter Inputs';

if indx == length(list)
    % Manually enter file path too
    prompt = {'Enter path:'};
    definput = {'path to file'};  
    dims = [1 85];

    answer = inputdlg(prompt,dlgtitle,dims,definput);
    if isempty(answer)
        return
    else
        file_name = answer{1};
    end

    % Validate path entered
    if ~isfile(file_name)
        file_name_new = [file_name,'.hdf5'];
        if ~isfile(file_name_new)
            error('Input 1: No such file on path.')
        else
            file_name = file_name_new;
        end
    else
        file_extension = file_name(end-3:end);
        if ~strcmp(file_extension,'hdf5')
            error('File must be an hdf5.')
        end
    end    
else
    file_name = list{indx};
end

% Access data in hdf file:
try
    data = h5read(file_name,'/exchange/data');
catch
    error('File Specified is not a Mantis file.')
end