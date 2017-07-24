
function data_organizer

id = inputdlg('Participant''s id');
[files, path] = uigetfile('*.exp', '------------------------------------------------------> Select all files', 'multiselect', 'on');
[wfiles, wpath] = uigetfile('*.exp', '------------------------------------------------------> Select all wrist files', 'multiselect', 'on');
[accfiles, accpath] = uigetfile('*.exp', '------------------------------------------------------> Select all accuracy files', 'multiselect', 'on');

if exist('ExperimentData.mat')
    load('ExperimentData.mat')
    if any(strcmp(fieldnames(experiment), id))
        error('\nParticipant error\n%s already exists in ExperimentData.mat\n\n', id{1})
    end
else
    choice = questdlg('ExperimentData.mat was not found in the current working directory. Conintue?');
    switch choice
        case 'Yes'
            sprintf('\nCreating ''ExperimentData.mat'' in %s\n\n', pwd)
        case 'No'
            fprintf('\nCancelling...\n\n')
            return
        case 'Cancel'
            fprintf('\nCancelling...\n\n')
            return
    end
end

if size(files, 2) ~= size(wfiles, 2)
    error('\nFiles error\nNumber of trial files (%d) does not match the number of wrist files (%d)\n\n', ...
        size(files, 2), size(wfiles, 2))
elseif size(files, 2) ~= 48 % 48 is the total number of trials
    choice1 = questdlg(sprintf('You have selected only %d trials out of 48. Conintue?', size(files,2)));
    switch choice1
        case 'Yes'
            sprintf('\nContinuing with %d trials\n\n', size(files, 2))
        case 'No'
            fprintf('\nCancelling...\n\n')
            return
    end
end

for i = 1:size(files, 2) % import trials data + wrist velocity column
    
    trial = importdata(strcat(path, files{i}));
    wtrial = importdata(strcat(wpath, wfiles{i}));
    
    [sIn, eIn] = regexp(trial.textdata{3}, '\d\d:\d\d:\d\d:\d\d\d');
    if ~strcmp(trial.textdata{3}(sIn:eIn), wtrial.textdata{3}(sIn:eIn))
        error('\nFiles error.\nTrial %d does not correspond to wrist trial %d\n', i, i)
    end
    
    [~, endIn] = regexp(trial.textdata{3}, 't00\d\d'); % endIn is the index of the trial name's end
    trial_name = trial.textdata{3}(7:endIn);
    
    if size(trial.data, 2) ~= 43 % this will remove two last weird columns from right to left trials
        sprintf('Columns %s and %s were removed from trial %s', ...
            trial.colheaders{end - 1}, trial.colheaders{end}, trial_name)
        trial.data = trial.data(:, 1:end - 2);
        trial.colheaders = trial.colheaders(1:end - 2);
    end
    
    trial.colheaders =  strrep(trial.colheaders, ' ', '');
    trial.colheaders =  strrep(trial.colheaders, '#', '');
    
%     in = [['Name', trial.colheaders, wtrial.colheaders(43), wtrial.colheaders(49)];...
%         [{trial_name}, num2cell(trial.data, 1), num2cell(wtrial.data(:,43), 1), num2cell(wtrial.data(:,49), 1)]];
%     s = struct(in{:});
    
    in = [['Name', ...
        trial.colheaders(1:39), wtrial.colheaders(45), ...
        wtrial.colheaders(43), wtrial.colheaders(49)];...
        [{trial_name}, ...
        num2cell(trial.data(:, 1:39), 1), num2cell(wtrial.data(:,45), 1), ...
        num2cell(wtrial.data(:,43), 1), num2cell(wtrial.data(:,49), 1)]];
    s = struct(in{:});
    
    experiment.(id{1}).trials(i) = s;
end

for i = 1:size(accfiles, 2) % import accuracy data
    acctrial = importdata(strcat(accpath, accfiles{i}));
    acctrial.colheaders =  strrep(acctrial.colheaders, '#', '');
    acctrial.colheaders =  strrep(acctrial.colheaders, ' ', '');
    
    in = [acctrial.colheaders; num2cell(acctrial.data, 1)];
    
    s = struct(in{:});
    experiment.(id{1}).accuracy(i) = s;
end

for i = 1:size(accfiles, 2) % error tht is more than 1 cm is probably a blink, therefore remove data points with error more than 1 cm
    experiment.(id{1}).accuracy(i).bad_values = [...
        (experiment.(id{1}).accuracy(i).finaleyeX > 0.01 | ...
        experiment.(id{1}).accuracy(i).finaleyeX < -0.01), ...
        (experiment.(id{1}).accuracy(i).finaleyeZ > 0.01 | ...
        experiment.(id{1}).accuracy(i).finaleyeZ < -0.01)];
end

% experiment.(id{1}).date = datetime(trial.textdata{2}(1:end-19), 'InputFormat', 'dd-MM-yyyy');
sprintf('\nWrist velocity channels (column 43 and 49) are %s and %s\n', wtrial.colheaders{43}, wtrial.colheaders{49})
save('ExperimentData.mat', 'experiment')

end
