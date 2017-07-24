load('ExperimentData.mat')

a.fix.data = []; % fixations data
a.fix.data_colnames = {'Onset_frame', 'End_frame', 'Duration', 'Fix_X',...
    'Fix_Z', 'TP1', 'TP2', 'TP3', 'TP4', 'TP5', 'ID'};
a.fix.ro_frame = [];
a.fix.means = [];
a.fix.saccade_p1 = [];
a.fix.saccade_p2 = [];
a.fix.saccade_p3 = [];
a.fix.saccade_p4 = [];
a.fix.saccade_p5 = [];
a.fix.names = {};

a.sac.data = [];
a.sac.data_colnames = {'Onset_frame', 'End_frame', 'Amplitude', 'Fix_Duration', 'ID'};
a.sac.names = {};

n = []; % number of trials for every participant

a.grasp.data = [];
a.grasp.data_colnames = {'Index_X', 'Index_Z', 'Thumb_X', 'Thumb_Z', ...
    'Object_X', 'Object_Z', 'IndexObject_X', 'IndexObject_Z', ...
    'GazeObject_X', 'GazeObject_Z', 'ID'}; % final index & thumb position
a.grasp.names = {};

a.wrist.data = [];
a.wrist.names = {};


index_number = [8 8 8 8 7 8 7 8 8 8]; % which index marker gives the best data
thumb_number = [9 9 9 9 9 10 9 9 9 9];

p4n = [1 2 3 4 5 6 7 8 9 10];

for i = 1:length(p4a);
    if i < 10
        id = strcat('P0', num2str(p4a(i)));
    else
        id = strcat('P', num2str(p4a(i)));
    end
    chan = {strcat('Index', num2str(index_number(p4a(i))), 'x'), ... % indx indz thx thz
        strcat('Index', num2str(index_number(p4a(i))), 'z'), ...
        strcat('Thumb', num2str(thumb_number(p4a(i))), 'x'), ...
        strcat('Thumb', num2str(thumb_number(p4a(i))), 'z')};
    dat = experiment.(id).trials;
    
    n = [n; size(dat, 2)];
    
    for j = 1:size(dat, 2)
        
        
        % ind x % ind z % thumb x % thumb z % objx % objz % indx-obj % indz-obj
        theta = - dat(j).Position(end);
        
        a.grasp.data = [a.grasp.data; [dat(j).(chan{1})(end), ...
            dat(j).(chan{2})(end), ...
            dat(j).(chan{3})(end), ...
            dat(j).(chan{4})(end), ...
            dat(j).ObjectLoc(end), ...
            dat(j).ObjPosZ(end), ...
            
            (dat(j).(chan{1})(end) - dat(j).ObjectLoc(end)) * cosd(-theta) + ...
            (dat(j).(chan{2})(end) - dat(j).ObjPosZ(end)) * (-sind(-theta)), ...
            
            (dat(j).(chan{1})(end) - dat(j).ObjectLoc(end)) * sind(-theta) + ...
            (dat(j).(chan{2})(end) - dat(j).ObjPosZ(end)) * cosd(-theta), ...
            (dat(j).averageXeye(end) - dat(j).ObjectLoc(end)) * cosd(-theta) + ...
            (dat(j).averageZeye(end) - dat(j).ObjPosZ(end)) * (-sind(-theta)), ...
            (dat(j).averageXeye(end) - dat(j).ObjectLoc(end)) * sind(-theta) + ...
            (dat(j).averageZeye(end) - dat(j).ObjPosZ(end)) * cosd(-theta), ...
            i ]]; % also put the participant's number
        a.grasp.names = [a.grasp.names; dat(j).Name];
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        [fix, sac] = fixations_no(dat(j).averageXeye, dat(j).averageZeye, 0.01, 13);
        reach_onset = find(dat(j).StartMovement, 1);
        final_gaze = length(dat(j).averageXeye);
        
        a.fix.means = [a.fix.means; mean(fix(:, 3))]; % fixation duration mean for every trial
        a.fix.ro_frame = [a.fix.ro_frame; reach_onset];

        p1 = fix(:, 1) <= 1 & fix(:, 1) >= 1; % block appears??
        p2 = fix(:, 1) <= 202 & fix(:, 2) >= 202; % block starts moving at frame 202
        p3 = fix(:, 1) <= 412 & fix(:, 2) >= 412; % block's leading edge encounters the occluder at frame 412. check
        p4 = fix(:, 1) <= reach_onset & fix(:, 2) >= reach_onset; % gaze at reach onset
        p5 = fix(:, 1) <= final_gaze & fix(:, 2) >= final_gaze; % gaze at the time of contact
                
        if ~ any(p1)
            a.fix.saccade_p1 = [a.fix.saccade_p1; ...
                [dat(j).averageXeye(1), dat(j).averageZeye(1)]];
        elseif  ~ any(p2)
            a.fix.saccade_p2 = [a.fix.saccade_p2;...
                [dat(j).averageXeye(202), dat(j).averageZeye(202)]];
        elseif ~ any(p3)
            a.fix.saccade_p3 = [a.fix.saccade_p3; ...
                [dat(j).averageXeye(412), dat(j).averageZeye(412)]];
        elseif ~ any(p4)
            a.fix.saccade_p4 = [a.fix.saccade_p4; ...
                [dat(j).averageXeye(reach_onset), dat(j).averageZeye(reach_onset)]];
        elseif ~ any(p5)
            a.fix.saccade_p5 = [a.fix.saccade_p5; ...
                [dat(j).averageXeye(final_gaze), dat(j).averageZeye(final_gaze)]];
        end
        
        a.fix.data = [a.fix.data; [fix, p1, p2, p3, p4, p5, ...
            repmat(str2num(id(2:end)), [size(fix, 1) 1])]];
        a.fix.names = [a.fix.names; repmat({dat(j).Name}, [size(fix, 1) 1])];
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        a.sac.data = [a.sac.data; [sac, fix(1:end - 1, 3), repmat(str2num(id(2:end)), [size(sac, 1) 1])]];
        a.sac.names = [a.sac.names; repmat({dat(j).Name}, [size(sac, 1) 1])];
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [value, frame] = max(dat(j).WristVel11);
        a.wrist.data = [a.wrist.data; [value, (size(dat(j).WristVel11, 1) - frame) / 130, i]];
        a.wrist.names = [a.wrist.names; dat(j).Name];
    end
end


in = fieldnames(a);

for i = 1:size(in, 1)
    [a.(in{i}).names(:,1), rem] = strtok(a.(in{i}).names, '_');
    [a.(in{i}).names(:,2), rem] = strtok(rem, '_');
    a.(in{i}).names(:,3) = cell(size(a.(in{i}).data, 1), 1);
    
    for j = 1:size(a.(in{i}).data, 1)
        a.(in{i}).names{j, 3} = strtok(rem{j}(1:end-4), '_');
    end
    
%     a.(in{i}).cond = [strcmp(a.(in{i}).names(:,1), 'Occlusion'), ...
%         strcmp(a.(in{i}).names(:,2), 'Cue'), ...
%         strcmp(a.(in{i}).names(:,3), 'LeftToRight')];
    
    a.(in{i}).o = strcmp(a.(in{i}).names(:,1), 'Occlusion');
    a.(in{i}).v = strcmp(a.(in{i}).names(:,1), 'Visible');
    a.(in{i}).c = strcmp(a.(in{i}).names(:,2), 'Cue');
    a.(in{i}).n = strcmp(a.(in{i}).names(:,2), 'NoCue');
    a.(in{i}).lr = strcmp(a.(in{i}).names(:,3), 'LeftToRight');
    a.(in{i}).rl = strcmp(a.(in{i}).names(:,3), 'RightToLeft');
end        
        
a.grasp.data(a.grasp.rl, [7 9]) = a.grasp.data(a.grasp.rl, [7 9]) .* (-1);


%% Results table

dep_var = a.wrist.data(:, 2);
mult_factor = 1000;
final_table = zeros([length(part4an), 9]); % 8 rows for every participant, 9 columns for all indep var combinations + subjects' ids

for i = 1:length(part4an)
    final_table(i, 1) = part4an(i);
    final_table(i, 2) = mean(dep_var(a.wrist.o & a.wrist.c & a.wrist.lr & a.wrist.data(:, 3) == part4an(i)));
    final_table(i, 3) = mean(dep_var(a.wrist.o & a.wrist.c & a.wrist.rl & a.wrist.data(:, 3) == part4an(i)));
    final_table(i, 4) = mean(dep_var(a.wrist.o & a.wrist.n & a.wrist.lr & a.wrist.data(:, 3) == part4an(i)));
    final_table(i, 5) = mean(dep_var(a.wrist.o & a.wrist.n & a.wrist.rl & a.wrist.data(:, 3) == part4an(i)));
    final_table(i, 6) = mean(dep_var(a.wrist.v & a.wrist.c & a.wrist.lr & a.wrist.data(:, 3) == part4an(i)));
    final_table(i, 7) = mean(dep_var(a.wrist.v & a.wrist.c & a.wrist.rl & a.wrist.data(:, 3) == part4an(i)));
    final_table(i, 8) = mean(dep_var(a.wrist.v & a.wrist.n & a.wrist.lr & a.wrist.data(:, 3) == part4an(i)));
    final_table(i, 9) = mean(dep_var(a.wrist.v & a.wrist.n & a.wrist.rl & a.wrist.data(:, 3) == part4an(i)));
end


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

mult_factor = 1000;
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
text([1 2 3 4], [-5.5, -5.5, -5.5, -5.5], colnames_full(2:end),...
    'HorizontalAlignment', 'center', 'FontName', 'Open Sans Light')
l = legend('Rightward', 'Leftward');
set(l, 'Location', 'northeast', 'Orientation', 'vertical', 'box', 'off')
hold off


%% Export table for anova

dt = dataset({final_table(:,1) 'id'}, {final_table(:,2) 'ocl'},...
    {final_table(:,3) 'ocr'}, {final_table(:,4) 'onl'},...
    {final_table(:,5) 'onr'}, {final_table(:,6) 'vcl'},...
    {final_table(:,7) 'vcr'}, {final_table(:,8) 'vnl'}, {final_table(:,9) 'vnr'});

export(dt, 'file', 'data.txt')


%% Scatter plot of all fixations

subset_f = a.fix.o & a.fix.rl;

figure;
line([0.34 0.34 0.87 0.87 0.34], ...
    [0.18 0.48 0.48 0.18 0.18], 'Color', 'k', 'LineWidth', 0.2)
hold on
line([0.34 + 0.16, 0.34 + 0.16], [0.18 0.48], 'color', [0.7 0.7 0.7])
line([0.87 - 0.16, 0.87 - 0.16], [0.18 0.48], 'color', [0.7 0.7 0.7])
scatter(a.fix.data(subset_f, 4), a.fix.data(subset_f, 5), 200,...
    a.fix.data(subset_f, 3).*1000, 'marker', '.')

line([0.34 0.87], [0.34 0.34], 'color', 'r', 'linestyle', '--');
line([0.34 0.87], [0.34 + 0.02, 0.34 + 0.02], 'color', 'r', 'linestyle', '--');
line([0.34 0.87], [0.34 - 0.02, 0.34 - 0.02], 'color', 'r', 'linestyle', '--');

xlim([0.29 0.92]); ylim([0.13 0.53]);
colormap(jet(200));
colorbar

hold off


% [N, C] = hist3([a.fix.data(subset_f, 4), a.fix.data(subset_f, 5)]);
% contour(C{1}, C{2}, N')


%% Scatter plot of grasps

subset_i = a.grasp.v | a.grasp.o;

figure;
line([0.34 0.34 0.87 0.87 0.34], ...
    [0.18 0.48 0.48 0.18 0.18], 'Color', 'k', 'LineWidth', 0.2)
hold on
scatter(a.grasp.data(subset_i, 1), a.grasp.data(subset_i, 2), 30, 'k', 'filled', 'marker', '^')
scatter(a.grasp.data(subset_i, 3), a.grasp.data(subset_i, 4), 30, 'k', 'filled', 'marker', 'v')

d2p = a.grasp.data(subset_i, :);
for i = 1:size(d2p, 1)
    line([d2p(i, 1), d2p(i, 3)], ...
        [d2p(i, 2), d2p(i, 4)]);
end
line([0.34 0.87], [0.34 0.34], 'color', [0.5 0.5 0.5], 'linestyle', ':');
line([0.34 0.87], [0.34 + 0.02, 0.34 + 0.02], 'color', [0.5 0.5 0.5], 'linestyle', ':');
line([0.34 0.87], [0.34 - 0.02, 0.34 - 0.02], 'color', [0.5 0.5 0.5], 'linestyle', ':');

xlim([0.29 0.92]); ylim([0.13 0.53]);
colormap(jet(200));
colorbar

hold off

%%
figure;
scatter(mean(a.grasp.data(:, 7)), mean(a.grasp.data(:, 8)), 200, 'r.')
hold on
axis square
line([-0.02, -0.02, 0.02, 0.02, -0.02], [-0.02, 0.02, 0.02, -0.02, -0.02])
xlim([-0.04, 0.04]); ylim([-0.04, 0.04])
semx = std(a.grasp.data(:, 7)) / sqrt(length(a.grasp.data(:, 7)));
semy = std(a.grasp.data(:, 8)) / sqrt(length(a.grasp.data(:, 8)));
error_bar(mean(a.grasp.data(:, 7)), mean(a.grasp.data(:, 8)), semx, 'h', 'r')
error_bar(mean(a.grasp.data(:, 7)), mean(a.grasp.data(:, 8)), semy, 'v', 'r')


%% Distributions

subset_f = a.fix.o | a.fix.v;

figure;
subplot(2, 3, 1)
hist3([a.fix.data(subset_f, 4), a.fix.data(subset_f, 3) .* 1000], [20 20])
xlabel('X-axis, m'); ylabel('Fixation duration, msec'); zlabel('Frequency')
set(get(gca,'child'),'FaceColor','interp','CDataMode',...
    'auto');
view([0 90])
colormap(jet(1000))
colorbar

subplot(2, 3, 2)
hist(a.fix.data(subset_f, 4), 150);
% axis square
hold on
[f, xi] = ksdensity(a.fix.data(subset_f, 4), 'npoints', 150);
plot(xi, f.*10, 'r-') % scale density a little bit
h = get(gca, 'children');
set(h(2), 'FaceColor', [8/255 71/255 125/255], 'EdgeColor', 'none')
set(h(1), 'color', [202/255 40/255 33/255], 'linewidth', 1.5)
title('Fixations location distribution')
xlabel('X-axis space, m')
hold off

subplot(2, 3, 3)
hist(a.fix.data(subset_f, 3), 150);
% axis square
hold on
[f, xi] = ksdensity(a.fix.data(subset_f, 3), 'npoints', 150);
plot(xi, f.*10, 'r-')
h = get(gca, 'children');
set(h(2), 'FaceColor', [8/255 71/255 125/255], 'EdgeColor', 'none')
set(h(1), 'color', [202/255 40/255 33/255], 'linewidth', 1.5)
title('Fixations duration distribution')
xlabel('Duration, msec')
xlim([0.1 1.4])
hold off

ax4 = subplot(2, 3, 4);
hist(a.grasp.data(:,1), 100)
% axis square
hold on
[f, xi] = ksdensity(a.grasp.data(:,1), 'npoints', 100);
plot(xi, f, 'r-')
h = get(gca, 'children');
set(h(2), 'FaceColor', [8/255 71/255 125/255], 'EdgeColor', 'none')
set(h(1), 'color', [202/255 40/255 33/255], 'linewidth', 1.5)
title('Final index position distribution')
text(0.7, 25, sprintf('m = %.2f\nsd = %.2f', mean(a.grasp.data(:,1)), std(a.grasp.data(:,1))));
xlabel('X-axis space, m')
hold off

ax5 = subplot(2, 3, 5);
hist(a.grasp.data(:, 5), 100)
% axis square
hold on
[f, xi] = ksdensity(a.grasp.data(:,5), 'npoints', 100);
plot(xi, f, 'r-')
h = get(gca, 'children');
set(h(2), 'FaceColor', [8/255 71/255 125/255], 'EdgeColor', 'none')
set(h(1), 'color', [202/255 40/255 33/255], 'linewidth', 1.5)
title('Final object position distribution')
text(0.7, 25, sprintf('m = %.2f\nsd = %.2f', mean(a.grasp.data(:,5)), std(a.grasp.data(:,5))));
xlabel('X-axis space, m')
hold off

linkaxes([ax4, ax5])

subplot(2, 3, 6)
hist(a.fix.ro_frame ./ 130, 150);
% axis square
hold on
[f, xi] = ksdensity(a.fix.ro_frame ./ 130, 'npoints', 150);
plot(xi, f.*10, 'r-')
h = get(gca, 'children');
set(h(2), 'FaceColor', [8/255 71/255 125/255], 'EdgeColor', 'none')
set(h(1), 'color', [202/255 40/255 33/255], 'linewidth', 1.5)
title('Reach onset time distribution')
xlabel('Time, sec')
hold off


%% 1 Block appears

p = logical(a.fix.data(:, 6));

figure;
line([0.34 0.34 0.87 0.87 0.34], ...
    [0.18 0.48 0.48 0.18 0.18], 'Color', 'k', 'LineWidth', 0.2)
hold on
line([0.35 0.35 0.39 0.39 0.35], [0.32 0.36 0.36 0.32 0.32], 'color', [0.5 0.5 0.5])
line([0.82 0.82 0.86 0.86 0.82], [0.32 0.36 0.36 0.32 0.32], 'color', [0.5 0.5 0.5])
scatter(a.fix.data(p, 4), a.fix.data(p, 5), 200, a.fix.data(p, 3).*1000, ...
    'marker', '.')
scatter(a.fix.saccade_p1(:,1), a.fix.saccade_p1(:,2), 10, 'k', 'marker', 'x')
xlim([0.29 0.92]); ylim([0.13 0.53]);
colormap(jet(200));
colorbar
hold off


%% 2 Block starts moving (frame 202, 1.5538 sec)

% if the frame 202 belongs to a fixation, plot as a dot coloured according
% to the fixation's duration.
% If the frame does not belong to a fixation, plot the gaze as a black cross

p = logical(a.fix.data(:, 7));

figure;
line([0.34 0.34 0.87 0.87 0.34], ...
    [0.18 0.48 0.48 0.18 0.18], 'Color', 'k', 'LineWidth', 0.2)
hold on
scatter(a.fix.data(p, 4), a.fix.data(p, 5), 200, ...
    a.fix.data(p, 3).*1000, 'marker', '.')
scatter(a.fix.saccade_p2(:,1), a.fix.saccade_p2(:,2), 10, 'k', 'marker', 'x')
line([0.35 0.35 0.39 0.39 0.35], [0.32 0.36 0.36 0.32 0.32], 'color', [0.5 0.5 0.5])
line([0.82 0.82 0.86 0.86 0.82], [0.32 0.36 0.36 0.32 0.32], 'color', [0.5 0.5 0.5])
xlim([0.29 0.92]); ylim([0.13 0.53]);
colormap(jet(200));
colorbar

hold off


%% 3 Block starts disappearing

% occluder placed approximately 16 cm from the screen edge; find a better way to measure
% the block's speed is 0.065 m/sec
% the block's leading edge appears on x left = 0.37 + 0.02 = 0.39
% & x right = 0.85 - 0.02 = 0.83
% the block stays motionless for frames 1:201 (0:1.5462 sec)
% the leading edge meets the occluder at x left = 0.35 + 0.02 + 0.16
% & x right = 0.87 - 0.02 - 0.16
% find the frame when the block reaches x left & x right.
% rightward: 421; leftward: 441.

p = logical(a.fix.data(:, 8)) & a.fix.o;

figure;
line([0.34 0.34 0.87 0.87 0.34], ...
    [0.18 0.48 0.48 0.18 0.18], 'Color', 'k', 'LineWidth', 0.2)
hold on
% check the block's position at the frame
line([0.45 0.45 0.49 0.49 0.45], [0.32 0.36 0.36 0.32 0.32], 'color', [0.5 0.5 0.5])
line([0.67 0.67 0.71 0.71 0.67], [0.32 0.36 0.36 0.32 0.32], 'color', [0.5 0.5 0.5])
scatter(a.fix.data(p, 4), a.fix.data(p, 5), 200, a.fix.data(p, 3).*1000,...
    'marker', '.')
scatter(a.fix.saccade_p3(:,1), a.fix.saccade_p3(:,2), 20, 'k', 'marker', 'x')
xlim([0.29 0.92]); ylim([0.13 0.53]);
colormap(jet(200));
colorbar
hold off


%% 4 Reach onset

p = logical(a.fix.data(:, 9)) & a.fix.rl;

figure;
line([0.34 0.34 0.87 0.87 0.34], ...
    [0.18 0.48 0.48 0.18 0.18], 'Color', 'k', 'LineWidth', 0.2)
hold on
line([0.34 0.87], [0.34 0.34], 'color', [0.8 0.8 0.8]);
line([0.34 0.87], [0.34 + 0.02, 0.34 + 0.02], 'color', [0.8 0.8 0.8]);
line([0.34 0.87], [0.34 - 0.02, 0.34 - 0.02], 'color', [0.8 0.8 0.8]);
scatter(a.fix.data(p,4), a.fix.data(p,5), 200, ...
    a.fix.data(p,3) .* 1000, 'marker', '.')
scatter(a.fix.saccade_p4(:,1), a.fix.saccade_p4(:,2), 10, 'k', 'marker', 'x')

xlim([0.29 0.92]); ylim([0.13 0.53]);
colormap(jet(200));
colorbar
hold off


%% 5 Time of contact

p = logical(a.fix.data(:, 10)) & a.fix.o;

figure;
line([0.34 0.34 0.87 0.87 0.34], ...
    [0.18 0.48 0.48 0.18 0.18], 'Color', 'k', 'LineWidth', 0.2)
hold on
line([0.34 0.87], [0.34 0.34], 'color', [0.8 0.8 0.8]);
line([0.34 0.87], [0.34 + 0.02, 0.34 + 0.02], 'color', [0.8 0.8 0.8]);
line([0.34 0.87], [0.34 - 0.02, 0.34 - 0.02], 'color', [0.8 0.8 0.8]);
scatter(a.fix.data(p, 4), a.fix.data(p, 5), 200, a.fix.data(p, 3).*1000, ...
    'marker', '.')
scatter(a.fix.saccade_p5(:,1), a.fix.saccade_p5(:,2), 10, 'k', 'marker', 'x')
xlim([0.29 0.92]); ylim([0.13 0.53]);
colormap(jet(200));
colorbar
hold off



%% Block speed


objpos = [experiment.P1.trials(1).ObjectLoc, ...
    experiment.P1.trials(1).ObjPosY, ...
    experiment.P1.trials(1).ObjPosZ];
dist = diff(objpos);
mag = sqrt(sum(dist .^2, 2));
vel = mag ./ (1/130);

v = mean(vel) % m/sec
v = mean(mag) % m/frames

omega = vel ./ 0.5; % the angular velocity of the block in radiants/sec. the distance between the eye and screen is 50 cm = 0.5 m.
omega1 = radtodeg(omega); % the angular velocity of the block in deg/sec
theta = radtodeg(mag ./ 0.5); % angular distance between points
theta1 = omega1 .* (1/130);

sample = experiment.P1.trials(1);

eyepos = [sample.averageXeye, ...
    sample.averageYeye, ...
    sample.averageZeye];
dist = diff(eyepos);
mag = sqrt(sum(dist .^2, 2));
vel = mag ./ (1/130);

omega = vel ./ 0.5; % radians/sec
omega1 = radtodeg(omega);

theta = radtodeg(mag ./ 0.5); % angular distance between points



fix = fixations_no(sample.averageXeye, sample.averageYeye, 0.01, 13);

plot(omega1, 'b-', 'linewidth', 2)
hold on
for i = 1:length(fix)
    line([fix(i, 1), fix(i, 2)], [-10, -10], 'color', 'r')
    
    line([fix(i, 1), fix(i, 1)], [-10, omega1(fix(i, 1))], 'color', 'r')
    line([fix(i, 2), fix(i, 2)], [-10, omega1(fix(i, 2))], 'color', 'r')
end


%% Saccades
[fixations, saccades] = fixations_n(experiment.P1.trials(1).averageXeye, experiment.P1.trials(1).averageZeye, 0.01, 13)

fit = fitlm(a.sac.data(:, 4), a.sac.data(:, 3))

fit = fitlm(a.sac.data(:, 3), a.sac.data(:, 4))
scatter(a.sac.data(:, 3), a.sac.data(:, 4), 'marker', '.')

scatter(a.sac.data(:, 4), a.sac.data(:, 3), 'marker', '.')
hold on
[fit, S] = polyfit(a.sac.data(:, 4), a.sac.data(:, 3), 1);
x = linspace(min(a.sac.data(:, 4)), max(a.sac.data(:, 4)));
y = polyval(fit, x);
[Y, DELTA] = polyconf(fit, x, S, 'alpha', 0.05);
plot(x, y, 'r-')
line(x, Y + DELTA, 'color', 'r', 'LineStyle', ':')
line(x, Y - DELTA, 'color', 'r', 'LineStyle', ':')
hold off

hist(a.sac.data(:,3), 500)

[r, p] = corrcoef(a.sac.data(:, 4), a.sac.data(:, 3))

dt = dataset({a.sac.data(1:20,3) 'Saccade_amplitude'}, {a.sac.data(1:20,4) 'FixDuration'});

export(dt, 'file', 'ampldur.txt')

