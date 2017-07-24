load('C:\Users\marotta_admin\Desktop\Roman\ExperimentData.mat')
p4a = [1 3 6 7 8 10 11 12 13 14 15 16 17 18 19 20 21];

all_names = fieldnames(experiment);
names = all_names(p4a);

table = zeros(length(p4a), 9);

for id = 1:length(names)
    
    data = experiment.(char(names(id))).trials;
    
    error_x = zeros(size(data,2), 1);
    error_z = zeros(size(data,2), 1);
    total_error = zeros(size(data,2), 1);
    
    VisFeedback = cell(size(data, 2), 1);
    Cues = cell(size(data, 2), 1);
    Direction = cell(size(data, 2), 1);

    
    for trial = 1:size(data, 2)
        
        [VisFeedback{trial}, rem] = strtok(data(trial).Name, '_');
        [Cues{trial}, rem] = strtok(rem, '_');
        Direction{trial} = strtok(rem(1:end-4), '_');
        
        error_x(trial) = data(trial).averageXeye(end) - data(trial).ObjectLoc(end);
        error_z(trial) = data(trial).averageZeye(end) - data(trial).ObjPosZ(end);
        
        total_error(trial) = sqrt( error_x(trial) ^2 + error_z(trial) ^2 );
    end
    
    ocl = strcmp(VisFeedback, 'Occlusion') & strcmp(Cues, 'Cue') & strcmp(Direction, 'LeftToRight');
    ocr = strcmp(VisFeedback, 'Occlusion') & strcmp(Cues, 'Cue') & strcmp(Direction, 'RightToLeft');
    onl = strcmp(VisFeedback, 'Occlusion') & strcmp(Cues, 'NoCue') & strcmp(Direction, 'LeftToRight');
    onr = strcmp(VisFeedback, 'Occlusion') & strcmp(Cues, 'NoCue') & strcmp(Direction, 'RightToLeft');
    vcl = strcmp(VisFeedback, 'Visible') & strcmp(Cues, 'Cue') & strcmp(Direction, 'LeftToRight');
    vcr = strcmp(VisFeedback, 'Visible') & strcmp(Cues, 'Cue') & strcmp(Direction, 'RightToLeft');
    vnl = strcmp(VisFeedback, 'Visible') & strcmp(Cues, 'NoCue') & strcmp(Direction, 'LeftToRight');
    vnr = strcmp(VisFeedback, 'Visible') & strcmp(Cues, 'NoCue') & strcmp(Direction, 'RightToLeft');
    
    table(id, :) = [p4a(id) mean(total_error(ocl)) mean(total_error(ocr)) mean(total_error(onl)) mean(total_error(onr)) ...
                            mean(total_error(vcl)) mean(total_error(vcr)) mean(total_error(vnl)) mean(total_error(vnr))];
                                
end
    
%% Save excel files

colnames = {'id', 'ocl', 'ocr', 'onl', 'onr', 'vcl', 'vcr', 'vnl', 'vnr'};

xlswrite('absolute_distance.xls', [colnames; num2cell(table)])
    
    
