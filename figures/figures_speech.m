load('tables.mat')

%% 1. Gaze/grasp visual feedback

fig = figure();

conv = 100;

mean_occ_eye_x = mean(mean(tables.gaze_x(:, 2:5))) * conv;
mean_occ_eye_z = mean(mean(tables.gaze_z(:, 2:5))) * conv;
mean_vis_eye_x = mean(mean(tables.gaze_x(:, 6:end))) * conv;
mean_vis_eye_z = mean(mean(tables.gaze_z(:, 6:end))) * conv;

mean_occ_ind_x = mean(mean(tables.index_x(:, 2:5))) * conv;
mean_occ_ind_z = mean(mean(tables.index_z(:, 2:5))) * conv;
mean_vis_ind_x = mean(mean(tables.index_x(:, 6:end))) * conv;
mean_vis_ind_z = mean(mean(tables.index_z(:, 6:end))) * conv;


n = size(tables.index_x, 1);

se_occ_eye_x = std(mean(tables.gaze_x(:, 2:5), 2)) / sqrt(n) * conv;
se_occ_eye_z = std(mean(tables.gaze_z(:, 2:5), 2)) / sqrt(n) * conv;
se_vis_eye_x = std(mean(tables.gaze_x(:, 6:end), 2)) / sqrt(n) * conv;
se_vis_eye_z = std(mean(tables.gaze_z(:, 6:end), 2)) / sqrt(n) * conv;

se_occ_ind_x = std(mean(tables.index_x(:, 2:5), 2)) / sqrt(n) * conv;
se_occ_ind_z = std(mean(tables.index_z(:, 2:5), 2)) / sqrt(n) * conv;
se_vis_ind_x = std(mean(tables.index_x(:, 6:end), 2)) / sqrt(n) * conv;
se_vis_ind_z = std(mean(tables.index_z(:, 6:end), 2)) / sqrt(n) * conv;

plot(mean_occ_eye_x, mean_occ_eye_z, 'ro')
hold on
plot(mean_occ_ind_x, mean_occ_ind_z, 'r^')
plot(mean_vis_eye_x, mean_vis_eye_z, 'bo')
plot(mean_vis_ind_x, mean_vis_ind_z, 'b^')

errorbar([mean_occ_eye_x, mean_vis_eye_x, mean_occ_ind_x, mean_vis_ind_x], ...
    [0 0 0 0], [se_occ_eye_x, se_vis_eye_x, se_occ_ind_x, se_vis_ind_x], ...
    'LineStyle', 'none', 'color', 'k')

errorbar([mean_occ_eye_x, mean_vis_eye_x, mean_occ_ind_x, mean_vis_ind_x], ...
    [mean_occ_eye_z, mean_vis_eye_z, mean_occ_ind_z, mean_vis_ind_z], ...
    [se_occ_eye_z, se_vis_eye_z, se_occ_ind_z, se_vis_ind_z], ...
    'LineStyle', 'none', 'color', 'k')

set(gca, 'Xlim', [-4 4], ...
         'Ylim', [-4 4])
% set(gcf, 'Units', 'centimeters', ...
%          'Position', [2 2 10 10])
axis square
ylabel('Vertical distance, cm')
xlabel('Horizontal distance, cm')


%% 2. Gaze/grasp direction

fig = figure();

conv = 100;

mean_lr_eye_x = mean(mean(tables.gaze_x(:, 2:2:end))) * conv;
mean_lr_eye_z = mean(mean(tables.gaze_z(:, 2:2:end))) * conv;
mean_rl_eye_x = mean(mean(tables.gaze_x(:, 3:2:end))) * conv;
mean_rl_eye_z = mean(mean(tables.gaze_z(:, 3:2:end))) * conv;

mean_lr_ind_x = mean(mean(tables.index_x(:, 2:2:end))) * conv;
mean_lr_ind_z = mean(mean(tables.index_z(:, 2:2:end))) * conv;
mean_rl_ind_x = mean(mean(tables.index_x(:, 3:2:end))) * conv;
mean_rl_ind_z = mean(mean(tables.index_z(:, 3:2:end))) * conv;


n = size(tables.index_x, 1);

se_lr_eye_x = std(mean(tables.gaze_x(:, 2:2:end), 2)) / sqrt(n) * conv;
se_lr_eye_z = std(mean(tables.gaze_z(:, 2:2:end), 2)) / sqrt(n) * conv;
se_rl_eye_x = std(mean(tables.gaze_x(:, 3:2:end), 2)) / sqrt(n) * conv;
se_rl_eye_z = std(mean(tables.gaze_z(:, 3:2:end), 2)) / sqrt(n) * conv;

se_lr_ind_x = std(mean(tables.index_x(:, 2:2:end), 2)) / sqrt(n) * conv;
se_lr_ind_z = std(mean(tables.index_z(:, 2:2:end), 2)) / sqrt(n) * conv;
se_rl_ind_x = std(mean(tables.index_x(:, 3:2:end), 2)) / sqrt(n) * conv;
se_rl_ind_z = std(mean(tables.index_z(:, 3:2:end), 2)) / sqrt(n) * conv;

plot(mean_lr_eye_x, mean_lr_eye_z, 'ro')
hold on
plot(mean_lr_ind_x, mean_lr_ind_z, 'r^')
plot(mean_rl_eye_x, mean_rl_eye_z, 'bo')
plot(mean_rl_ind_x, mean_rl_ind_z, 'b^')

errorbar([mean_lr_eye_x, mean_rl_eye_x, mean_lr_ind_x, mean_rl_ind_x], ...
    [0 0 0 0], [se_lr_eye_x, se_rl_eye_x, se_lr_ind_x, se_rl_ind_x], ...
    'LineStyle', 'none', 'color', 'k')

errorbar([mean_lr_eye_x, mean_rl_eye_x, mean_lr_ind_x, mean_rl_ind_x], ...
    [mean_lr_eye_z, mean_rl_eye_z, mean_lr_ind_z, mean_rl_ind_z], ...
    [se_lr_eye_z, se_rl_eye_z, se_lr_ind_z, se_rl_ind_z], ...
    'LineStyle', 'none', 'color', 'k')

set(gca, 'Xlim', [-4 4], ...
         'Ylim', [-4 4])
% set(gcf, 'Units', 'centimeters', ...
%          'Position', [2 2 10 10])
axis square
ylabel('Vertical distance, cm')
xlabel('Horizontal distance, cm')




%% 3. Gaze/grasp cues x vis feedback

fig = figure();

conv = 100;

mean_occ_qu_eye_x = mean(mean(tables.gaze_x(:, 2:3))) * conv;
mean_occ_qu_eye_z = mean(mean(tables.gaze_z(:, 2:3))) * conv;
mean_occ_no_eye_x = mean(mean(tables.gaze_x(:, 4:5))) * conv;
mean_occ_no_eye_z = mean(mean(tables.gaze_z(:, 4:5))) * conv;

mean_vis_qu_eye_x = mean(mean(tables.gaze_x(:, 6:7))) * conv;
mean_vis_qu_eye_z = mean(mean(tables.gaze_z(:, 6:7))) * conv;
mean_vis_no_eye_x = mean(mean(tables.gaze_x(:, 8:9))) * conv;
mean_vis_no_eye_z = mean(mean(tables.gaze_z(:, 8:9))) * conv;
%--------------------------------------------------------------------
mean_occ_qu_ind_x = mean(mean(tables.index_x(:, 2:3))) * conv;
mean_occ_qu_ind_z = mean(mean(tables.index_z(:, 2:3))) * conv;
mean_occ_no_ind_x = mean(mean(tables.index_x(:, 4:5))) * conv;
mean_occ_no_ind_z = mean(mean(tables.index_z(:, 4:5))) * conv;

mean_vis_qu_ind_x = mean(mean(tables.index_x(:, 6:7))) * conv;
mean_vis_qu_ind_z = mean(mean(tables.index_z(:, 6:7))) * conv;
mean_vis_no_ind_x = mean(mean(tables.index_x(:, 8:9))) * conv;
mean_vis_no_ind_z = mean(mean(tables.index_z(:, 8:9))) * conv;


n = size(tables.index_x, 1);

se_occ_qu_eye_x = std(mean(tables.gaze_x(:, 2:3), 2)) / sqrt(n) * conv;
se_occ_no_eye_x = std(mean(tables.gaze_x(:, 4:5), 2)) / sqrt(n) * conv;
se_vis_qu_eye_x = std(mean(tables.gaze_x(:, 6:7), 2)) / sqrt(n) * conv;
se_vis_no_eye_x = std(mean(tables.gaze_x(:, 8:9), 2)) / sqrt(n) * conv;

se_occ_qu_ind_x = std(mean(tables.index_x(:, 2:3), 2)) / sqrt(n) * conv;
se_occ_no_ind_x = std(mean(tables.index_x(:, 4:5), 2)) / sqrt(n) * conv;
se_vis_qu_ind_x = std(mean(tables.index_x(:, 6:7), 2)) / sqrt(n) * conv;
se_vis_no_ind_x = std(mean(tables.index_x(:, 8:9), 2)) / sqrt(n) * conv;



plot(mean_occ_qu_eye_x, mean_occ_qu_eye_z, 'o', 'color', [1 100/255 100/255])
hold on
plot(mean_occ_qu_ind_x, mean_occ_qu_ind_z, '^', 'color', [1 100/255 100/255])

plot(mean_vis_qu_eye_x, mean_vis_qu_eye_z, 'ro')
plot(mean_vis_qu_ind_x, mean_vis_qu_ind_z, 'r^')

plot(mean_occ_no_eye_x, mean_occ_no_eye_z, 'o', 'color', [100/255 100/255 1])
plot(mean_occ_no_ind_x, mean_occ_no_ind_z, '^', 'color', [100/255 100/255 1])

plot(mean_vis_no_eye_x, mean_vis_no_eye_z, 'bo')
plot(mean_vis_no_ind_x, mean_vis_no_ind_z, 'b^')


errorbar(...
    [mean_occ_qu_eye_x, mean_occ_no_eye_x, mean_vis_qu_eye_x, mean_vis_no_eye_x, mean_occ_qu_ind_x, mean_occ_no_ind_x, mean_vis_qu_ind_x, mean_vis_no_ind_x], ...
    [mean_occ_qu_eye_z, mean_occ_no_eye_z, mean_vis_qu_eye_z, mean_vis_no_eye_z, mean_occ_qu_ind_z, mean_occ_no_ind_z, mean_vis_qu_ind_z, mean_vis_no_ind_z], ...
    [se_occ_qu_eye_x, se_occ_no_eye_x, se_vis_qu_eye_x, se_vis_no_eye_x, se_occ_qu_ind_x, se_occ_no_ind_x, se_vis_qu_ind_x, se_vis_no_ind_x], ...
    'LineStyle', 'none', 'color', 'k')

set(gca, 'Xlim', [-4 4], ...
         'Ylim', [-4 4])
% set(gcf, 'Units', 'centimeters', ...
%          'Position', [2 2 10 10])
axis square
ylabel('Vertical distance, cm')
xlabel('Horizontal distance, cm')


%% Gaze time x vis feedback

conv = 100;
n = size(tables.index_x, 1);

mean_onset_occ_x = mean(mean(tables.gaze_ro_x(:, 2:5))) * conv;
mean_onset_occ_z = mean(mean(tables.gaze_ro_z(:, 2:5))) * conv;

mean_onset_vis_x = mean(mean(tables.gaze_ro_x(:, 6:end))) * conv;
mean_onset_vis_z = mean(mean(tables.gaze_ro_z(:, 6:end))) * conv;

mean_final_occ_x = mean(mean(tables.gaze_x(:, 2:5))) * conv;
mean_final_occ_z = mean(mean(tables.gaze_z(:, 2:5))) * conv;

mean_final_vis_x = mean(mean(tables.gaze_x(:, 6:end))) * conv;
mean_final_vis_z = mean(mean(tables.gaze_z(:, 6:end))) * conv;


se_onset_occ = std(mean(tables.gaze_ro_x(:, 2:5), 2)) / sqrt(n) * conv;
se_onset_vis = std(mean(tables.gaze_ro_x(:, 6:end), 2)) / sqrt(n) * conv;
se_final_occ = std(mean(tables.gaze_x(:, 2:5), 2)) / sqrt(n) * conv;
se_final_vis = std(mean(tables.gaze_x(:, 6:end), 2)) / sqrt(n) * conv;


plot(mean_onset_occ_x, mean_onset_occ_z, 'ro')
hold on
plot(mean_onset_vis_x, mean_onset_vis_z, 'bo')
plot(mean_final_occ_x, mean_final_occ_z, 'ro')
plot(mean_final_vis_x, mean_final_vis_z, 'bo')

errorbar(...
    [mean_onset_occ_x, mean_onset_vis_x, mean_final_occ_x, mean_final_vis_x], ...
    [mean_onset_occ_z, mean_onset_vis_z, mean_final_occ_z, mean_final_vis_z], ...
    [se_onset_occ, se_onset_vis, se_final_occ, se_final_vis], ...
    'LineStyle', 'none', 'color', 'k')

set(gca, 'Xlim', [-4 4], ...
         'Ylim', [-4 4])
% set(gcf, 'Units', 'centimeters', ...
%          'Position', [2 2 10 10])
axis square
ylabel('Vertical distance, cm')
xlabel('Horizontal distance, cm')



%% Gaze time x direction


conv = 100;
n = size(tables.index_x, 1);

mean_onset_lr_x = mean(mean(tables.gaze_ro_x(:, 2:2:end))) * conv;
mean_onset_lr_z = mean(mean(tables.gaze_ro_z(:, 2:2:end))) * conv;

mean_onset_rl_x = mean(mean(tables.gaze_ro_x(:, 3:2:end))) * conv;
mean_onset_rl_z = mean(mean(tables.gaze_ro_z(:, 3:2:end))) * conv;

mean_final_lr_x = mean(mean(tables.gaze_x(:, 2:2:end))) * conv;
mean_final_lr_z = mean(mean(tables.gaze_z(:, 2:2:end))) * conv;

mean_final_rl_x = mean(mean(tables.gaze_x(:, 3:2:end))) * conv;
mean_final_rl_z = mean(mean(tables.gaze_z(:, 3:2:end))) * conv;


se_onset_lr = std(mean(tables.gaze_ro_x(:, 2:2:end), 2)) / sqrt(n) * conv;
se_onset_rl = std(mean(tables.gaze_ro_x(:, 3:2:end), 2)) / sqrt(n) * conv;
se_final_lr = std(mean(tables.gaze_x(:, 2:2:end), 2)) / sqrt(n) * conv;
se_final_rl = std(mean(tables.gaze_x(:, 3:2:end), 2)) / sqrt(n) * conv;


plot(mean_onset_lr_x, mean_onset_lr_z, 'ro')
hold on
plot(mean_onset_rl_x, mean_onset_rl_z, 'bo')
plot(mean_final_lr_x, mean_final_lr_z, 'ro')
plot(mean_final_rl_x, mean_final_rl_z, 'bo')

errorbar(...
    [mean_onset_lr_x, mean_onset_rl_x, mean_final_lr_x, mean_final_rl_x], ...
    [mean_onset_lr_z, mean_onset_rl_z, mean_final_lr_z, mean_final_rl_z], ...
    [se_onset_lr, se_onset_rl, se_final_lr, se_final_rl], ...
    'LineStyle', 'none', 'color', 'k')

set(gca, 'Xlim', [-4 4], ...
         'Ylim', [-4 4])
% set(gcf, 'Units', 'centimeters', ...
%          'Position', [2 2 10 10])
axis square
ylabel('Vertical distance, cm')
xlabel('Horizontal distance, cm')



%% fixations/saccades pic


fig = figure();
trial = importdata('C:\Users\Roman Belenya\Google Drive\{ honours seminar }\thesis\oral presntation\fixations.exp');
fix = fixations_no(trial.data(:, 25), trial.data(:, 27), 0.01, 13);

plot(trial.data(:, 25), trial.data(:, 27), 'r-')
hold on
plot(fix(:, 4), fix(:, 5), 'r.', 'markersize', 25)

x_l = 0.3344 + 0.045;
x_r = 0.8703 - 0.045;
z_b = 0.1741;
z_t = 0.4759;

plot([x_l, x_l, x_r, x_r], [z_b, z_t, z_t, z_b], 'k.')

axis equal

