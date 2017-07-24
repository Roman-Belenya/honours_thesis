load('C:\Users\marotta_admin\Desktop\Roman\ExperimentData.mat')

p4a = [1 3 6 7 8 10 11 12 13 14 15 16 17 18 19 20 21];

all_names = fieldnames(experiment);
names = all_names(p4a);

table_gaze_x = zeros(length(p4a), 9);
table_gaze_z = zeros(length(p4a), 9);
table_gaze_ro_x = zeros(length(p4a), 9);
table_gaze_ro_z = zeros(length(p4a), 9);

count = 0;
total_trials = 0;

for id = 1:length(names)
    
    data = experiment.(char(names(id))).trials;
    
    XgazeO = zeros(size(data,2), 1);
    ZgazeO = zeros(size(data,2), 1);
    
    Xgaze_ro = zeros(size(data,2), 1);
    Zgaze_ro = zeros(size(data,2), 1);
    
    VisFeedback = cell(size(data, 2), 1);
    Cues = cell(size(data, 2), 1);
    Direction = cell(size(data, 2), 1);
    
    for trial = 1:size(data, 2)
        
        [VisFeedback{trial}, rem] = strtok(data(trial).Name, '_');
        [Cues{trial}, rem] = strtok(rem, '_');
        Direction{trial} = strtok(rem(1:end-4), '_');
        
        fix = fixations_no(data(trial).averageXeye, data(trial).averageZeye);
        
        theta = - data(trial).Position(end);
        XgazeO(trial) = ... % index - COM on X
            (fix(end, 4) - data(trial).ObjectLoc(end)) * cosd(-theta) + ...
            (fix(end, 5) - data(trial).ObjPosZ(end)) * (-sind(-theta));
        ZgazeO(trial) = ... % index - COM on Z
            (fix(end, 4) - data(trial).ObjectLoc(end)) * sind(-theta) + ...
            (fix(end, 5) - data(trial).ObjPosZ(end)) * cosd(-theta);
        
        
        ro_frame = find(data(trial).StartMovement == 1, 1);
        ro_fixation =  fix(:, 1) <= ro_frame & fix(:,2) >= ro_frame;
        if ~any(ro_fixation)
            fprintf('Not found for %s, trial %d\n', char(names(id)), trial)
            count = count+1;
            
            next_fixation = find(fix(:,1) > ro_frame, 1);
            if ~any(next_fixation); fprintf('Totally fucked up---------'); end
            
            theta = - data(trial).Position(ro_frame);
            Xgaze_ro(trial) = ... % index - COM on X
                (fix(next_fixation, 4) - data(trial).ObjectLoc(ro_frame)) * cosd(-theta) + ...
                (fix(next_fixation, 5) - data(trial).ObjPosZ(ro_frame)) * (-sind(-theta));
            Zgaze_ro(trial) = ... % index - COM on Z
                (fix(next_fixation, 4) - data(trial).ObjectLoc(ro_frame)) * sind(-theta) + ...
                (fix(next_fixation, 5) - data(trial).ObjPosZ(ro_frame)) * cosd(-theta);
        else
            theta = - data(trial).Position(ro_frame);
            Xgaze_ro(trial) = ... % index - COM on X
                (fix(ro_fixation, 4) - data(trial).ObjectLoc(ro_frame)) * cosd(-theta) + ...
                (fix(ro_fixation, 5) - data(trial).ObjPosZ(ro_frame)) * (-sind(-theta));
            Zgaze_ro(trial) = ... % index - COM on Z
                (fix(ro_fixation, 4) - data(trial).ObjectLoc(ro_frame)) * sind(-theta) + ...
                (fix(ro_fixation, 5) - data(trial).ObjPosZ(ro_frame)) * cosd(-theta);
        end
        
        total_trials = total_trials + 1;
        
    end
    
    rl = strcmp(Direction, 'RightToLeft'); % invert right to left trials' X values
    XgazeO(rl) = XgazeO(rl) * -1;
    Xgaze_ro(rl) = Xgaze_ro(rl) * -1;
    
    ocl = strcmp(VisFeedback, 'Occlusion') & strcmp(Cues, 'Cue') & strcmp(Direction, 'LeftToRight');
    ocr = strcmp(VisFeedback, 'Occlusion') & strcmp(Cues, 'Cue') & strcmp(Direction, 'RightToLeft');
    onl = strcmp(VisFeedback, 'Occlusion') & strcmp(Cues, 'NoCue') & strcmp(Direction, 'LeftToRight');
    onr = strcmp(VisFeedback, 'Occlusion') & strcmp(Cues, 'NoCue') & strcmp(Direction, 'RightToLeft');
    vcl = strcmp(VisFeedback, 'Visible') & strcmp(Cues, 'Cue') & strcmp(Direction, 'LeftToRight');
    vcr = strcmp(VisFeedback, 'Visible') & strcmp(Cues, 'Cue') & strcmp(Direction, 'RightToLeft');
    vnl = strcmp(VisFeedback, 'Visible') & strcmp(Cues, 'NoCue') & strcmp(Direction, 'LeftToRight');
    vnr = strcmp(VisFeedback, 'Visible') & strcmp(Cues, 'NoCue') & strcmp(Direction, 'RightToLeft');
    
    table_gaze_x(id, :) = [p4a(id) mean(XgazeO(ocl)) mean(XgazeO(ocr)) mean(XgazeO(onl)) mean(XgazeO(onr)) ...
        mean(XgazeO(vcl)) mean(XgazeO(vcr)) mean(XgazeO(vnl)) mean(XgazeO(vnr))];
    
    table_gaze_z(id, :) = [p4a(id) mean(ZgazeO(ocl)) mean(ZgazeO(ocr)) mean(ZgazeO(onl)) mean(ZgazeO(onr)) ...
        mean(ZgazeO(vcl)) mean(ZgazeO(vcr)) mean(ZgazeO(vnl)) mean(ZgazeO(vnr))];
    
    table_gaze_ro_x(id, :) = [p4a(id) mean(Xgaze_ro(ocl)) mean(Xgaze_ro(ocr)) mean(Xgaze_ro(onl)) mean(Xgaze_ro(onr)) ...
        mean(Xgaze_ro(vcl)) mean(Xgaze_ro(vcr)) mean(Xgaze_ro(vnl)) mean(Xgaze_ro(vnr))];
    
    table_gaze_ro_z(id, :) = [p4a(id) mean(Zgaze_ro(ocl)) mean(Zgaze_ro(ocr)) mean(Zgaze_ro(onl)) mean(Zgaze_ro(onr)) ...
        mean(Zgaze_ro(vcl)) mean(Zgaze_ro(vcr)) mean(Zgaze_ro(vnl)) mean(Zgaze_ro(vnr))];
    
    
end

%% Save excel files

colnames = {'id', 'ocl', 'ocr', 'onl', 'onr', 'vcl', 'vcr', 'vnl', 'vnr'};

xlswrite('gaze_ro.xls', [colnames; num2cell(table_gaze_ro_x)])
    


%% Figures


% 1.Time x Vf interaction

ro_o = mean(mean(table_gaze_ro_x(:, 2:5))) * 100;
ro_v = mean(mean(table_gaze_ro_x(:, 6:end))) * 100;
f_o = mean(mean(table_gaze_x(:, 2:5))) * 100;
f_v = mean(mean(table_gaze_x(:, 6:end))) * 100;


l1 = plot([1 2], [ro_o f_o], '.-', 'Color', [170/255 170/255 170/255], ...
    'LineWidth', 1.5, 'MarkerSize', 20);
hold on
l2 = plot([1 2], [ro_v f_v], '.-', 'Color', [70/255 70/255 70/255], ...
    'LineWidth', 1.5, 'MarkerSize', 20);
ylabel('Horisontal axis, cm')
set(gca, 'XLim', [0.5 2.5], ...
         'Ylim', [-3 3], ...
         'XTick', [1 2], ...
         'XTickLabel', {'Reach onset', 'Time of grasp'}, ...
         'Ygrid', 'on', ...
         'GridLineStyle', ':', ...
         'Yminorgrid', 'off',...
         'Yminortick', 'off',...
         'TickLength', [0 0], ...
         'Box', 'off');
     
l = legend('Occlusion', 'Visible');
set(l, 'Location', 'northeast', 'Orientation', 'vertical', 'box', 'off')
hold off


