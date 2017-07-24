%%

load('ExperimentData.mat')

% P1, 3, 6, 7, 8, 10, 11, 12, 13 are more or less usable for gaze analysis

index_number = [8 8 8 8 7 8 7 8 8 8 8 8 8 8 8 8 8 8 7 8 7]; % which index marker gives the best data. for all participants
wrist_number = [12 11 11 11 11 11 11 12 11 11 12 11 11 11 11 12 11 11 11 11 11];

p4a = [1 3 6 7 8 10 11 12 13 14 15 16 17 18 19 20 21]; % participants for analysis
% p4a = 1:12;
final_table = zeros([length(p4a) 9]); % 8 rows for every participant, 9 columns for all indep var combinations + subjects' ids


for k = 1:length(p4a) % for every participant. Use vector to access certain participants
    
    if p4a(k) < 10
        id = strcat('P0', num2str(p4a(k)));
    else
        id = strcat('P', num2str(p4a(k)));
    end
    
    data = experiment.(id).trials;
    chanx = strcat('Index', num2str(index_number(p4a(k))), 'x');
    chanz = strcat('Index', num2str(index_number(p4a(k))), 'z');
    wchan = strcat('WristVel', num2str(wrist_number(p4a(k))));
    
    % Independent variables
    VisFeedback = cell(size(data, 2), 1);
    Cues = cell(size(data, 2), 1);
    Direction = cell(size(data, 2), 1);
    
    % Dependent variables
    XindexO = zeros(size(data,2), 1);
    ZindexO = zeros(size(data,2), 1);
    XgazeO = zeros(size(data,2), 1);
    XgazeOr = zeros(size(data,2), 1);
    ZgazeO = zeros(size(data,2), 1);
    DindexO = zeros(size(data,2), 1);
    Fixations = zeros(size(data,2), 1);
    WristDecel = zeros(size(data,2), 1);
    PeakVel = zeros(size(data,2), 1);
    
    
    for i = 1:size(data, 2) % for every one of 48 trials CHECK THE FORMULAS
        
        [VisFeedback{i}, rem] = strtok(data(i).Name, '_');
        [Cues{i}, rem] = strtok(rem, '_');
        Direction{i} = strtok(rem(1:end-4), '_');
        
        theta = - data(i).Position(end);
        XindexO(i) = ... % index - COM on X
            (data(i).(chanx)(end) - data(i).ObjectLoc(end)) * cosd(-theta) + ...
            (data(i).(chanz)(end) - data(i).ObjPosZ(end)) * (-sind(-theta));
        ZindexO(i) = ... % index - COM on Z
            (data(i).(chanx)(end) - data(i).ObjectLoc(end)) * sind(-theta) + ...
            (data(i).(chanz)(end) - data(i).ObjPosZ(end)) * cosd(-theta);
        XgazeO(i) = ... % gaze - COM on X
            (data(i).averageXeye(end) - data(i).ObjectLoc(end)) * cosd(-theta) + ...
            (data(i).averageZeye(end) - data(i).ObjPosZ(end)) * (-sind(-theta));
        ro = find(data(i).StartMovement, 1); 
        theta_ro = - data(i).Position(ro);
        XgazeOr(i) = (data(i).averageXeye(ro) - data(i).ObjectLoc(ro)) * cosd(-theta_ro) + ...
            (data(i).averageZeye(ro) - data(i).ObjPosZ(ro)) * (-sind(-theta_ro));
        ZgazeO(i) = ... % gaze - COM on Z
            (data(i).averageXeye(end) - data(i).ObjectLoc(end)) * sind(-theta) + ...
            (data(i).averageZeye(end) - data(i).ObjPosZ(end)) * cosd(-theta);
%         DindexO(i) = sqrt((data(i).(chanx)(end) - data(i).ObjectLoc(end))^2 + ...
%             (data(i).(chanz)(end) - data(i).ObjPosZ(end))^2);
        fix = fixations_no(data(i).averageXeye, data(i).averageZeye, ...
            0.01, 13); Fixations(i) = mean(fix(:, 3)); % fix is the table of fixations for a cetrain trial. Take the mean of duration for every trial
        [PeakVel(i), dec] = max(data(i).(wchan)); WristDecel(i) = (length(data(i).(wchan)) - dec) / 130;
    end
    
    rl = strcmp(Direction, 'RightToLeft'); % invert right to left trials' X values
    XindexO(rl) = XindexO(rl) * -1;
    XgazeO(rl) = XgazeO(rl) * -1;
    XgazeOr(rl) = XgazeOr(rl) * -1 ;
    
    % Logical vectors for all indep var combinations
    ocl = strcmp(VisFeedback, 'Occlusion') & strcmp(Cues, 'Cue') & strcmp(Direction, 'LeftToRight');
    ocr = strcmp(VisFeedback, 'Occlusion') & strcmp(Cues, 'Cue') & strcmp(Direction, 'RightToLeft');
    onl = strcmp(VisFeedback, 'Occlusion') & strcmp(Cues, 'NoCue') & strcmp(Direction, 'LeftToRight');
    onr = strcmp(VisFeedback, 'Occlusion') & strcmp(Cues, 'NoCue') & strcmp(Direction, 'RightToLeft');
    vcl = strcmp(VisFeedback, 'Visible') & strcmp(Cues, 'Cue') & strcmp(Direction, 'LeftToRight');
    vcr = strcmp(VisFeedback, 'Visible') & strcmp(Cues, 'Cue') & strcmp(Direction, 'RightToLeft');
    vnl = strcmp(VisFeedback, 'Visible') & strcmp(Cues, 'NoCue') & strcmp(Direction, 'LeftToRight');
    vnr = strcmp(VisFeedback, 'Visible') & strcmp(Cues, 'NoCue') & strcmp(Direction, 'RightToLeft');
    
    depvar = XgazeO; % XgazeO
    
    final_table(k, 1) = p4a(k);
    final_table(k, 2) = mean(depvar(ocl)); % Take the mean of 6 trials of the same indep var combination
    final_table(k, 3) = mean(depvar(ocr));
    final_table(k, 4) = mean(depvar(onl));
    final_table(k, 5) = mean(depvar(onr));
    final_table(k, 6) = mean(depvar(vcl));
    final_table(k, 7) = mean(depvar(vcr));
    final_table(k, 8) = mean(depvar(vnl));
    final_table(k, 9) = mean(depvar(vnr));
end

colnames = {'id', 'ocl', 'ocr', 'onl', 'onr', 'vcl', 'vcr', 'vnl', 'vnr'};

mult_factor = 1000; % 1000 to make msec from sec; 100 to make cm from m

% wristdecel_tweaks %%%% DON'T FORGET THIS WHEN ANALYSING WRIST
% DECELERATION




%% Three-way ANOVA

anova_three(final_table)


%% Main effects

figure;
ax2 = subplot(1, 3, 1);
o = final_table(:, 2:5)*mult_factor;
v = final_table(:, 6:9)*mult_factor;
stderror_o = std(mean(o, 2)) / sqrt(size(final_table, 1));
stderror_v = std(mean(v, 2)) / sqrt(size(final_table, 1));

bar2 = bar([mean(o(:)), mean(v(:))], 0.5);
hold on
errorbar(1:2, [mean(o(:)), mean(v(:))], ...
    [stderror_o, stderror_v], 'LineStyle', 'none', 'color', [1 0 0])
set(gca, 'XTickLabel', {'Occlusion', 'Visible'}, 'Ygrid', 'on', ...
    'Yminorgrid', 'off', 'Yminortick', 'off', 'TickLength', [0 0]);
set(bar2, 'FaceColor', [8/255 71/255 125/255], 'EdgeColor', 'none')
title('Visual feedback')
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ax3 = subplot(1, 3, 2);
c = final_table(:, [2 3 6 7])*mult_factor;
nc = final_table(:, [4 5 8 9])*mult_factor;
stderror_c = std(mean(c,2)) / sqrt(size(final_table, 1));
stderror_nc = std(mean(nc,2)) / sqrt(size(final_table, 1));

bar3 = bar([mean(c(:)), mean(nc(:))], 0.5);
hold on
errorbar(1:2, [mean(c(:)), mean(nc(:))], ...
    [stderror_c, stderror_nc], 'LineStyle', 'none', 'color', [1 0 0])
set(gca, 'XTickLabel', {'Cues', 'No Cues'}, 'Ygrid', 'on', ...
    'Yminorgrid', 'off', 'Yminortick', 'off', 'YTickLabel', [], 'TickLength', [0 0]);
set(bar3, 'FaceColor', [8/255 71/255 125/255], 'EdgeColor', 'none')
title('Cue presence')
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ax4 = subplot(1, 3, 3);
lr = final_table(:, 2:2:9)*mult_factor;
rl = final_table(:, 3:2:9)*mult_factor;
stderror_lr = std(mean(lr,2)) / sqrt(size(final_table, 1));
stderror_rl = std(mean(rl,2)) / sqrt(size(final_table, 1));

bar4 = bar([mean(lr(:)), mean(rl(:))], 0.5);
hold on
errorbar(1:2, [mean(lr(:)), mean(rl(:))], ...
    [stderror_lr, stderror_rl], 'LineStyle', 'none', 'color', [1 0 0])
set(gca, 'XTickLabel', {'Rightward', 'Leftward'}, 'Ygrid', 'on', ...
    'Yminorgrid', 'off', 'Yminortick', 'off', 'YTickLabel', [], 'TickLength', [0 0]);
set(bar4, 'FaceColor', [8/255 71/255 125/255], 'EdgeColor', 'none')
title('Direction')
hold off

linkaxes([ax2, ax3, ax4], 'y')


%% Two way interactions

ax5 = subplot(1, 3, 1); % VisFeedback x Cues
oc = final_table(:, 2:3) .* mult_factor;
on = final_table(:, 4:5) .* mult_factor;
vc = final_table(:, 6:7) .* mult_factor;
vn = final_table(:, 8:9) .* mult_factor;

se = [std(mean(oc,2)) / sqrt(size(final_table, 1)), ...
    std(mean(on,2)) / sqrt(size(final_table, 1)), ...
    std(mean(vc,2)) / sqrt(size(final_table, 1)), ...
    std(mean(vn,2)) / sqrt(size(final_table, 1))];

bar5 = bar([mean(oc(:)), mean(on(:)); mean(vc(:)), mean(vn(:))], 1);
hold on
errorbar([0.86 1.14 1.86 2.14], [mean(oc(:)), mean(on(:)), mean(vc(:)), ...
    mean(vn(:))], se, 'LineStyle', 'none', 'color', [0 0 0])
set(bar5(1), 'FaceColor', [8/255 71/255 125/255], 'EdgeColor', 'none')
set(bar5(2), 'FaceColor', [202/255 40/255 33/255], 'EdgeColor', 'none')
set(gca, 'XTickLabel', {'Occlusion', 'Visible'}, 'Ygrid', 'on', ...
    'Yminorgrid', 'off', 'Yminortick', 'off', 'TickLength', [0 0]);
l = legend('Cues', 'No Cues');
set(l, 'Location', 'northeast', 'Orientation', 'vertical', 'box', 'off')
% set(gca, 'Position', [0.13 0.12 0.2134 0.8]);
title('Visual feedback x Cues')
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ax6 = subplot(1, 3, 2); % VisFeedback x Direction
olr = final_table(:, [2 4]) .* mult_factor;
orl = final_table(:, [3 5]) .* mult_factor;
vlr = final_table(:, [6 8]) .* mult_factor;
vrl = final_table(:, [7 9]) .* mult_factor;

se = [std(mean(olr,2)) / sqrt(size(final_table, 1)), ...
    std(mean(orl,2)) / sqrt(size(final_table, 1)), ...
    std(mean(vlr,2)) / sqrt(size(final_table, 1)), ...
    std(mean(vrl,2)) / sqrt(size(final_table, 1))];

bar6 = bar([mean(olr(:)), mean(orl(:)); mean(vlr(:)), mean(vrl(:))], 1);
hold on
errorbar([0.86 1.14 1.86 2.14], [mean(olr(:)), mean(orl(:)), mean(vlr(:)), ...
    mean(vrl(:))], se, 'LineStyle', 'none', 'color', [0 0 0])
set(bar6(1), 'FaceColor', [8/255 71/255 125/255], 'EdgeColor', 'none')
set(bar6(2), 'FaceColor', [202/255 40/255 33/255], 'EdgeColor', 'none')
set(gca, 'XTickLabel', {'Occlusion', 'Visible'}, 'Ygrid', 'on', ...
    'Yminorgrid', 'off', 'Yminortick', 'off', 'YtickLabel', [], 'TickLength', [0 0]);
l = legend('Rightward', 'Leftward');
set(l, 'Location', 'northeast', 'Orientation', 'vertical', 'box', 'off')
% set(gca, 'Position', [0.4108 0.12 0.2134 0.8]);
title('Visual feedback x Direction')
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ax7 = subplot(1, 3, 3); % VisFeedback x Direction
clr = final_table(:, [2 6]) .* mult_factor;
crl = final_table(:, [3 7]) .* mult_factor;
nlr = final_table(:, [4 8]) .* mult_factor;
nrl = final_table(:, [5 9]) .* mult_factor;

se = [std(mean(clr,2)) / sqrt(size(final_table, 1)), ...
    std(mean(crl,2)) / sqrt(size(final_table, 1)), ...
    std(mean(nlr,2)) / sqrt(size(final_table, 1)), ...
    std(mean(nrl,2)) / sqrt(size(final_table, 1))];

bar7 = bar([mean(clr(:)), mean(crl(:)); mean(nlr(:)), mean(nrl(:))], 1);
hold on
errorbar([0.86 1.14 1.86 2.14], [mean(clr(:)), mean(crl(:)), mean(nlr(:)), ...
    mean(nrl(:))], se, 'LineStyle', 'none', 'color', [0 0 0])
set(bar7(1), 'FaceColor', [8/255 71/255 125/255], 'EdgeColor', 'none')
set(bar7(2), 'FaceColor', [202/255 40/255 33/255], 'EdgeColor', 'none')
set(gca, 'XTickLabel', {'Cue', 'No Cue'}, 'Ygrid', 'on', ...
    'Yminorgrid', 'off', 'Yminortick', 'off', 'YtickLabel', [], 'TickLength', [0 0]);
l = legend('Rightward', 'Leftward');
set(l, 'Location', 'northeast', 'Orientation', 'vertical', 'box', 'off')
% set(gca, 'Position', [0.6916 0.12 0.2134 0.8]);
title('Cue presence x Direction')
hold off

linkaxes([ax6, ax5, ax7], 'y')


%% Three - way Interaction

mult_factor = 100;
figure;
stderror = std(final_table(:, 2:end).*mult_factor) / sqrt(size(final_table, 1));
ci = stderror .* 1.96;
colnames_full = {'id', sprintf('Occlusion\nCues'), ...
    sprintf('Occlusion\nNo Cues'), ...
    sprintf('Visible\nCues'), ...
    sprintf('Visible\nNo Cues')};

bar1 = bar([mean(final_table(:,2:3)) * mult_factor; ...
    mean(final_table(:,4:5)) * mult_factor; ...
    mean(final_table(:,6:7)) * mult_factor; ... 
    mean(final_table(:,8:9)) * mult_factor], 0.95);
hold on
errorbar([0.86 1.14 1.86 2.14 2.86 3.14 3.86 4.14], ...
    mean(final_table(:, 2:end)) * mult_factor, stderror, ...
    'LineStyle', 'none', 'color', [0.1 0 0]');
set(bar1(1), 'FaceColor', [20/255 135/255 200/255], 'EdgeColor', 'none')
set(bar1(2), 'FaceColor', [226/255 65/255 62/255], 'EdgeColor', 'none')
set(gca, 'YGrid', 'on', 'XTickLabel', [], 'Box', 'on', 'TickLength', [0 0], ...
    'FontName', 'Open Sans Light')
view([90 -90])
pos = get(gca, 'Ylim');
text([1 2 3 4], [pos(1)-0.5, pos(1)-0.5, pos(1)-0.5, pos(1)-0.5], colnames_full(2:end),...
    'HorizontalAlignment', 'center', 'FontName', 'Open Sans Light')
l = legend('Rightward', 'Leftward');
set(l, 'Location', 'northeast', 'Orientation', 'vertical', 'box', 'off')
hold off





%% Export table for anova

dt = dataset({final_table(:,1) 'id'}, {final_table(:,2) 'ocl'},...
    {final_table(:,3) 'ocr'}, {final_table(:,4) 'onl'},...
    {final_table(:,5) 'onr'}, {final_table(:,6) 'vcl'},...
    {final_table(:,7) 'vcr'}, {final_table(:,8) 'vnl'}, {final_table(:,9) 'vnr'});

export(dt, 'XLSFile', 'gaze_ro.xls')


%% Mean of participants' accuracy on visible trials - as a measurement of
% overall accuracy

[mean(final_table(:, 6:end), 2).*100, ... % visible trials, in cm
    mean(final_table(:, 2:5), 2).*100] % invisible trials

mean(final_table(:, 2:end), 2)




