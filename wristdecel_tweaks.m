
%% P01. 48 trials
data = experiment.P01.trials; % use WristVel12 except 42, 40, 22, 8, 6, 1

except_trials = [1 6 8 40 42];
wristdecel = zeros(size(data, 2), 1);
VisFeedback = cell(size(data, 2), 1);
Cues = cell(size(data, 2), 1);
Direction = cell(size(data, 2), 1);


for i = 1:size(data, 2)
    
    if any(i == except_trials)
        [~, dec] = max(data(i).WristVel11);
        wristdecel(i) = (length(data(i).WristVel11) - dec) / 130;
    else
        [~, dec] = max(data(i).WristVel12);
        wristdecel(i) = (length(data(i).WristVel12) - dec) / 130;
    end
    
    [VisFeedback{i}, rem] = strtok(data(i).Name, '_');
    [Cues{i}, rem] = strtok(rem, '_');
    Direction{i} = strtok(rem(1:end-4), '_');
end

    ocl = strcmp(VisFeedback, 'Occlusion') & strcmp(Cues, 'Cue') & strcmp(Direction, 'LeftToRight');
    ocr = strcmp(VisFeedback, 'Occlusion') & strcmp(Cues, 'Cue') & strcmp(Direction, 'RightToLeft');
    onl = strcmp(VisFeedback, 'Occlusion') & strcmp(Cues, 'NoCue') & strcmp(Direction, 'LeftToRight');
    onr = strcmp(VisFeedback, 'Occlusion') & strcmp(Cues, 'NoCue') & strcmp(Direction, 'RightToLeft');
    vcl = strcmp(VisFeedback, 'Visible') & strcmp(Cues, 'Cue') & strcmp(Direction, 'LeftToRight');
    vcr = strcmp(VisFeedback, 'Visible') & strcmp(Cues, 'Cue') & strcmp(Direction, 'RightToLeft');
    vnl = strcmp(VisFeedback, 'Visible') & strcmp(Cues, 'NoCue') & strcmp(Direction, 'LeftToRight');
    vnr = strcmp(VisFeedback, 'Visible') & strcmp(Cues, 'NoCue') & strcmp(Direction, 'RightToLeft');

plot(wristdecel)

means = [mean(wristdecel(ocl)), mean(wristdecel(ocr)), mean(wristdecel(onl)), mean(wristdecel(onr)), ...
    mean(wristdecel(vcl)), mean(wristdecel(vcr)), mean(wristdecel(vnl)), mean(wristdecel(vnr))]

final_table(1, :) = [1, means];
    
    
 %% P12. 48 trials
 
data = experiment.P12.trials; % use WristVel11 except 10, 22 (-1 because 47 trials)

except_trials = [4 10 22 32];
wristdecel = zeros(size(data, 2), 1);
VisFeedback = cell(size(data, 2), 1);
Cues = cell(size(data, 2), 1);
Direction = cell(size(data, 2), 1);


for i = 1:48
    
    if any(i == except_trials)
        [~, dec] = max(data(i).WristVel12);
        wristdecel(i) = (length(data(i).WristVel12) - dec) / 130;
    else
        [~, dec] = max(data(i).WristVel11);
        wristdecel(i) = (length(data(i).WristVel11) - dec) / 130;
    end
    
    [VisFeedback{i}, rem] = strtok(data(i).Name, '_');
    [Cues{i}, rem] = strtok(rem, '_');
    Direction{i} = strtok(rem(1:end-4), '_');
end

    ocl = strcmp(VisFeedback, 'Occlusion') & strcmp(Cues, 'Cue') & strcmp(Direction, 'LeftToRight');
    ocr = strcmp(VisFeedback, 'Occlusion') & strcmp(Cues, 'Cue') & strcmp(Direction, 'RightToLeft');
    onl = strcmp(VisFeedback, 'Occlusion') & strcmp(Cues, 'NoCue') & strcmp(Direction, 'LeftToRight');
    onr = strcmp(VisFeedback, 'Occlusion') & strcmp(Cues, 'NoCue') & strcmp(Direction, 'RightToLeft');
    vcl = strcmp(VisFeedback, 'Visible') & strcmp(Cues, 'Cue') & strcmp(Direction, 'LeftToRight');
    vcr = strcmp(VisFeedback, 'Visible') & strcmp(Cues, 'Cue') & strcmp(Direction, 'RightToLeft');
    vnl = strcmp(VisFeedback, 'Visible') & strcmp(Cues, 'NoCue') & strcmp(Direction, 'LeftToRight');
    vnr = strcmp(VisFeedback, 'Visible') & strcmp(Cues, 'NoCue') & strcmp(Direction, 'RightToLeft');

plot(wristdecel)

means = [mean(wristdecel(ocl)), mean(wristdecel(ocr)), mean(wristdecel(onl)), mean(wristdecel(onr)), ...
    mean(wristdecel(vcl)), mean(wristdecel(vcr)), mean(wristdecel(vnl)), mean(wristdecel(vnr))]

final_table(8, :) = [12, means];
 

