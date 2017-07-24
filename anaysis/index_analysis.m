load('C:\Users\marotta_admin\Desktop\Roman\ExperimentData.mat')
index_number = [8 8 8 8 7 8 7 8 8 8 8 8 8 8 8 8 8 8 7 8 7];
p4a = [1 3 6 7 8 10 11 12 13 14 15 16 17 18 19 20 21];

all_names = fieldnames(experiment);
names = all_names(p4a);
index_no = index_number(p4a);

table_index_x = zeros(length(p4a), 9);
table_index_z = zeros(length(p4a), 9);

for id = 1:length(names)
    
    data = experiment.(char(names(id))).trials;
    chanx = sprintf('Index%sx', num2str(index_no(id)));
    chanz = sprintf('Index%sz', num2str(index_no(id)));
    
    XindexO = zeros(size(data,2), 1);
    ZindexO = zeros(size(data,2), 1);
    
    VisFeedback = cell(size(data, 2), 1);
    Cues = cell(size(data, 2), 1);
    Direction = cell(size(data, 2), 1);

    
    for trial = 1:size(data, 2)
        
        [VisFeedback{trial}, rem] = strtok(data(trial).Name, '_');
        [Cues{trial}, rem] = strtok(rem, '_');
        Direction{trial} = strtok(rem(1:end-4), '_');

        theta = - data(trial).Position(end);
        XindexO(trial) = ... % index - COM on X
            (data(trial).(chanx)(end) - data(trial).ObjectLoc(end)) * cosd(-theta) + ...
            (data(trial).(chanz)(end) - data(trial).ObjPosZ(end)) * (-sind(-theta));
        ZindexO(trial) = ... % index - COM on Z
            (data(trial).(chanx)(end) - data(trial).ObjectLoc(end)) * sind(-theta) + ...
            (data(trial).(chanz)(end) - data(trial).ObjPosZ(end)) * cosd(-theta);
    end
    
    rl = strcmp(Direction, 'RightToLeft'); % invert right to left trials' X values
    XindexO(rl) = XindexO(rl) * -1;

    ocl = strcmp(VisFeedback, 'Occlusion') & strcmp(Cues, 'Cue') & strcmp(Direction, 'LeftToRight');
    ocr = strcmp(VisFeedback, 'Occlusion') & strcmp(Cues, 'Cue') & strcmp(Direction, 'RightToLeft');
    onl = strcmp(VisFeedback, 'Occlusion') & strcmp(Cues, 'NoCue') & strcmp(Direction, 'LeftToRight');
    onr = strcmp(VisFeedback, 'Occlusion') & strcmp(Cues, 'NoCue') & strcmp(Direction, 'RightToLeft');
    vcl = strcmp(VisFeedback, 'Visible') & strcmp(Cues, 'Cue') & strcmp(Direction, 'LeftToRight');
    vcr = strcmp(VisFeedback, 'Visible') & strcmp(Cues, 'Cue') & strcmp(Direction, 'RightToLeft');
    vnl = strcmp(VisFeedback, 'Visible') & strcmp(Cues, 'NoCue') & strcmp(Direction, 'LeftToRight');
    vnr = strcmp(VisFeedback, 'Visible') & strcmp(Cues, 'NoCue') & strcmp(Direction, 'RightToLeft');
    
    table_index_x(id, :) = [p4a(id) mean(XindexO(ocl)) mean(XindexO(ocr)) mean(XindexO(onl)) mean(XindexO(onr)) ...
                                    mean(XindexO(vcl)) mean(XindexO(vcr)) mean(XindexO(vnl)) mean(XindexO(vnr))];
                                
    table_index_z(id, :) = [p4a(id) mean(ZindexO(ocl)) mean(ZindexO(ocr)) mean(ZindexO(onl)) mean(ZindexO(onr)) ...
                                    mean(ZindexO(vcl)) mean(ZindexO(vcr)) mean(ZindexO(vnl)) mean(ZindexO(vnr))];

end
    
%% Save excel files

colnames = {'id', 'ocl', 'ocr', 'onl', 'onr', 'vcl', 'vcr', 'vnl', 'vnr'};

xlswrite('test.xls', [colnames; num2cell(table_index_z)])
    
    
