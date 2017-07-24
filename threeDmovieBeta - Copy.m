
%% Set parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% [file, path] = uigetfile('*.exp', 'Select a raw data file');
% trial = importdata(strcat(path, file));

trial = importdata('C:\Users\marotta_admin\Desktop\fun.exp');

mesure = 130; % measurement rate

front_view = 1;
screen_only = 0;
side_view = 0;
above_view = 0;

index_data = 1;
    index7 = 0;
    index8 = 1;

thumb_data = 0;
    thumb9 = 1;
    thumb10 = 0;

wrist_data = 0;
    wrist11 = 0;
    wrist12 = 1;

eye_data = 0;
    fixations = 1;
    duration_th = round(mesure * 0.1); % 13 frames occur in 100 msec (= 0.1 sec)
    dispersion_th = 0.01; % 1 cm

cues = 0;
object_data = 0;

delay = 0.0; % set 0 for about real-time animation;
% 0.01 slows down ~ 2 times; 0.03 ~ 4 times; 0.05 ~ 8 times

save_movie = 0;
    file_name = 'test.avi';


% ------------------------------------------------------------------------%
%% Begin visualization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% First part - draws coordinate space, stationary objects (monitor), plots the
% first point in the data to be updated later in the loop. Also, decorates the
% plot.
% The black line shows where the monitor should be according to the 'ideal'
% coordinates. The grey rectangle's Y coordinate is the deepest point where
% the participant looked during experiment.

if index7 && index8 || thumb9 && thumb10 || wrist11 && wrist12
    errordlg('Select only one index/thumb/wrist marker')
end


% pos = trial.data(:, 38)';
% loc = trial.data(:, 39)';
% 
% for i = 1:length(pos)
%     if pos(1) == pos(i)
%         loc(i) = loc(length(pos) - length(unique(pos)));
%     end
% end


objx = trial.data(:,30)';
% objx = trial.data(:, 39)';
objy = trial.data(:, 31)';
objz = trial.data(:, 32)';

if index7
    indexx = trial.data(:, 2)';  % 2 for index7; 5 for index8
    indexy = trial.data(:, 3)'; % 3 for index7; 6 for index8
    indexz = trial.data(:, 4)'; % 4 for index7; 7 for index8
elseif index8
    indexx = trial.data(:, 5)';  % 2 for index7; 5 for index8
    indexy = trial.data(:, 6)'; % 3 for index7; 6 for index8
    indexz = trial.data(:, 7)'; % 4 for index7; 7 for index8
end

if thumb9
    thumbx = trial.data(:, 8)'; % 8 for thumb9; 11 for thumb10
    thumby = trial.data(:, 9)'; % 9 for thumb9; 12 for thumb10
    thumbz = trial.data(:, 10)'; % 10 for thumb9; 13 for thumb10
elseif thumb10
    thumbx = trial.data(:, 11)'; % 8 for thumb9; 11 for thumb10
    thumby = trial.data(:, 12)'; % 9 for thumb9; 12 for thumb10
    thumbz = trial.data(:, 13)'; % 10 for thumb9; 13 for thumb10
end

if wrist11
    wristx = trial.data(:, 14)'; % 14 for wrist11; 17 for wrist12
    wristy = trial.data(:, 15)'; % 15 for wrist11; 18 for wrist12
    wristz = trial.data(:, 16)'; % 16 for wrist11; 19 for wrist12
elseif wrist12
    wristx = trial.data(:, 17)'; % 14 for wrist11; 17 for wrist12
    wristy = trial.data(:, 18)'; % 15 for wrist11; 18 for wrist12
    wristz = trial.data(:, 19)'; % 16 for wrist11; 19 for wrist12
end

eyex = trial.data(:, 33)';
eyey = trial.data(:, 34)';
eyez = trial.data(:, 35)';


%% Fixations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

window = [1 duration_th];

i = 1; % i is the fixations' index. first, second, third fixations

fdata = [];
placeholder = [];


while window(2) < length(eyex)
    
    %         D = sum(mag(window(1):window(2)));
    D = ( max(eyex(window(1):window(2))) - min(eyex(window(1):window(2))) ) + ...
        ( max(eyez(window(1):window(2))) - min(eyez(window(1):window(2))) );
    
    
    if D <= dispersion_th
        
        while D <= dispersion_th && window(2) < length(eyex)
            window(2) = window(2) + 1;
            %                         D = sum(mag(window(1):window(2)));
            %             D = (max(eyex(start_window:start_window + window)) - ...
            %                 min(eyex(start_window:start_window + window))) + ...
            %                 (max(eyez(start_window:start_window + window)) - ...
            %                 min(eyez(start_window:start_window + window)));
            D = ( max(eyex(window(1):window(2))) - min(eyex(window(1):window(2))) ) + ...
                ( max(eyez(window(1):window(2))) - min(eyez(window(1):window(2))) );
            
        end
        
        if window(2) ~= length(eyex)
            window = [window(1), window(2) - 1];
        end
        
        fdata(i, 1:2) = [window(1) window(2)];
        fdata(i, 3) = (window(2) - window(1) + 1) / mesure;
        fdata(i, 4:6) = [mean(eyex(window(1):window(2))), ...
            mean(eyey(window(1):window(2))), ...
            mean(eyez(window(1):window(2)))];
        
        fdata(i, 7) = mean(sqrt(                          ...
            (eyex(window(1):window(2)) - fdata(i, 4)).^2 + ...
            (eyey(window(1):window(2)) - fdata(i, 5)).^2 + ...
            (eyez(window(1):window(2)) - fdata(i, 6)).^2   ...
            ));
        
        
        placeholder = [placeholder repmat(i, [1 window(2) - window(1) + 1])];
        
        i = i + 1;
        
        window = [window(2) + 1, window(2) + 13];
        
    else
        window = window + 1;
        placeholder = [placeholder 0];
        
    end
end

onset_frame = find(trial.data(:,43));
onset_frame = onset_frame(1);
p = find((onset_frame >= fdata(:,1)) & (onset_frame <= fdata(:,2)));

%% First ponts %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[n, ~] = size(trial.data);

figure;
if screen_only
    axis([0.3 0.9 0 0.55 0.15 0.5])
else
    axis([0.2 1 0 0.55 0 0.5])
end
set(gca, 'FontName', 'Cambria');
set(gcf, 'Position', get(0, 'Screensize'));

if front_view || screen_only
    view([0 0])
    time = text(0.71, 0.5, 0.52, sprintf('Frame %d of %d\nSecond %.2f', ...
        1, n, 1/mesure), 'FontName', 'Cambria');
elseif side_view
    view([270 0])
    time = text(0, 0.6, 0.45, sprintf('Frame %d of %d\nSecond %.2f', ...
        1, n, 1/mesure), 'FontName', 'Cambria');
elseif above_view
    view([0 90])
    time = text(0.74, 0.58, 0, sprintf('Frame %d of %d\nSecond %.2f', ...
        1, n, 1/mesure), 'FontName', 'Cambria');
else
    time = text(0.3, 0.5, 0.6, sprintf('Frame %d of %d\nSecond %.2f', ...
        1, n, 1/mesure), 'FontName', 'Cambria');
end
    
hold on

if index_data
    index_point = plot3(indexx(1), indexy(1), indexz(1), ...
        'b', 'Marker', '.', 'markersize', 17.5);
    index_traj = plot3(indexx(1:2), indexy(1:2), indexz(1:2), 'Color', 'b');
end

if thumb_data
    thumb_point = plot3(thumbx(1), thumby(1), thumbz(1), ...
        'r', 'Marker', '.', 'markersize', 17.5);
    thumb_traj = plot3(thumbx(1:2), thumby(1:2), thumbz(1:2), 'Color', 'r');
end

if wrist_data
    wrist_point = plot3(wristx(1), wristy(1), wristz(1), ...
        'color', [0.2 0.5 0.2], 'Marker', '.', 'markersize', 17.5);
    wrist_traj = plot3(wristx(1:2), wristy(1:2), wristz(1:2), ...
        'Color', [0.2 0.5 0.2]);
end

if eye_data
    eye_point =  plot3(eyex(1), eyey(1), eyez(1), ... % marker
        'Color', [0.6 0.2 0.5], 'Marker', '*', 'MarkerSize', 9, 'LineWidth', 1.5);
    eye_traj = plot3(eyex(1:2), eyey(1:2), eyez(1:2), 'Color', [0.6 0.2 0.5]);
end



line([0.34 0.34 0.87 0.87 0.34], [0.5414 0.5414 0.5414 0.5414 0.5414], ...
    [0.18 0.48 0.48 0.18 0.18], 'Color', 'k', 'LineWidth', 0.2)

% draw cues on the screen if selected


if object_data
    com = line(objx(1), objy(1), objz(1), ...
        'Marker', '+', 'Color', 'k', 'markersize', 3);
    obj_shape = line([objx(1) - 0.02, objx(1) - 0.02, ...
        objx(1) + 0.02, objx(1) + 0.02, ...
        objx(1) - 0.02], ... % 5 X coordinates
        [objy(1), objy(1), objy(1), objy(1), objy(1)], ... 5 Y coordinates
        [objz(1) - 0.02, objz(1) + 0.02, ...
        objz(1) + 0.02, objz(1) - 0.02, ...
        objz(1) - 0.02], ... 5 Z coordinates
        'color', [0.4 0.4 0.4], 'LineWidth', 2.5); % Update X coordinates only
end

tit = strtok(trial.textdata{3}, '-'); tit = tit(1:length(tit) - 3);
title(strrep(tit, '_', ' '), 'FontWeight', 'bold', ...
    'FontName', 'Cambria', 'FontSize', 12)

xlabel('X axis', 'FontName', 'Cambria')
ylabel('Y axis', 'FontName', 'Cambria')
zlabel('Z axis', 'FontName', 'Cambria')

grid on

hold off 


%% Updating %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Second part - accesses the created plot and updates coordinates of the
% moving objects: markers for index, thumb, wrist and eye; trajectory
% lines; object's centre of mass (small + sign); object's shape. The code
% execution slows down toward the end of the loop execution because
% trajectory lines get longer with each iteration. The difference between
% the quickest iteration and the fastest is 0.0132 seconds.
% plot(elapsed_time) for more information.

if save_movie
    M = VideoWriter(file_name);
    open(M)
end

elapsed_time = zeros([n,1]);

for frame = 1:n
    tic;
    
    if index_data
        set(index_point, 'XData', indexx(frame), ...
            'YData', indexy(frame), ...
            'ZData', indexz(frame))
        set(index_traj, 'XData', indexx(1:frame), ...
            'YData', indexy(1:frame), ...
            'ZData', indexz(1:frame))
    end
    
    if thumb_data
        set(thumb_point, 'XData', thumbx(frame), ...
            'YData', thumby(frame), ...
            'ZData', thumbz(frame))
        set(thumb_traj, 'XData', thumbx(1:frame), ...
            'YData', thumby(1:frame), ...
            'ZData', thumbz(1:frame))
    end
    
    if wrist_data
        set(wrist_point, 'XData', wristx(frame), ...
            'YData', wristy(frame), ...
            'ZData', wristz(frame))
        
        set(wrist_traj, 'XData', wristx(1:frame), ...
            'YData', wristy(1:frame), ...
            'ZData', wristz(1:frame))
    end
    
    if eye_data & (frame >= fdata(p, 1)) & (frame <= fdata(p, 2))
        set(eye_point, 'XData', eyex(frame), ...
            'YData', eyey(frame), ...
            'ZData', eyez(frame), 'Color', [0.9 0.7 0])
        set(eye_traj, 'XData', eyex(1:frame), 'YData', eyey(1:frame), ...
            'ZData', eyez(1:frame))
    elseif eye_data
        set(eye_point, 'XData', eyex(frame), ...
            'YData', eyey(frame), ...
            'ZData', eyez(frame), 'color', [0.6 0.2 0.5])
        set(eye_traj, 'XData', eyex(1:frame), 'YData', eyey(1:frame), ...
            'ZData', eyez(1:frame))
    end
    
    if object_data
        set(com, 'XData', objx(frame), ...
            'YData', objy(frame), ...
            'ZData', objz(frame))
        set(obj_shape, 'XData', [objx(frame) - 0.02, objx(frame) - 0.02, ...
            objx(frame) + 0.02, objx(frame) + 0.02, ...
            objx(frame) - 0.02]);
    end
    
    
    set(time, 'String', sprintf('Frame %d of %d\nSecond %.2f', ...
        frame, n, frame/mesure), 'FontName', 'Cambria');
    
    if fixations == 1 && any(fdata(:,1) == frame)
        hold on
        
        if exist('fix', 'var')
            set(fix, 'CData', [0.8 0.6 0.8]);
        end
        
        fix = scatter3(fdata(find(fdata(:,1) == frame), 4), max(eyey), ...
            fdata(find(fdata(:,1) == frame), 6), ...
            fdata(find(fdata(:,1) == frame), 7) * 120000, 'ko', ...
            'linewidth', 1.5);
        
        hold off
    end
    
    drawnow
    
    if save_movie
        writeVideo(M, getframe(gcf));
    end
    
    pause(delay)
    elapsed_time(frame) = toc;
end

if fixations
    hold on
    plot3(fdata(:,4), repmat(max(eyey)-0.001, [size(fdata,1) 1]), ...
        fdata(:,6), 'k.', 'markersize', 1);
%     if ~ isempty(p)
%         scatter3(fdata(p, 4), max(eyey), fdata(p, 6), fdata(p, 7) * 100000, ...
%             'o', 'markerfacecolor', [0.95 0.95 0.3]);
%     end
    hold off
end

miss_ix = indexx(end) - objx(end);
miss_iz = indexz(end) - objz(1);
miss_tx = thumbx(end) - objx(end);
miss_tz = thumbz(end) - objz(1);
miss_gx = eyex(end) - objx(end);
miss_gz = eyez(end) - objz(end);

miss_onset_gx = eyex(onset_frame) - objx(onset_frame);
miss_onset_gz = eyez(onset_frame) - objz(onset_frame);



sprintf(strcat(...
    'X:\n index - COM = %.4f\n', ...
    ' thumb - COM = %.4f\n',...
    ' gaze - COM = %.4f\n',...
    '  gaze at reach onset - COM = %.4f\n',...
    'Z:\n index - COM = %.4f\n',...
    ' thumb - COM = %.4f\n',...
    ' gaze - COM = %.4f\n',...
    '  gaze at reach onset - COM = %.4f\n\n',...
    'Fixations count:\n %d\n', ...
    'Reach onset fixation number:\n %d\n',...
    'Reach onset frame:\n %d\n\n',...
    'Total time for the trial:\n %.3f\n',...
    'Time for the animation:\n %.3f\n'), ...
    miss_ix, miss_tx, miss_gx, miss_onset_gx,...
    miss_iz, miss_tz, miss_gz, miss_onset_gz, size(fdata, 1), ...
    p, onset_frame, str2double(trial.textdata{5}(1:6)), sum(elapsed_time))

if save_movie
    close(M)
end


clear fix D above_view ans com cues delay dispersion_th duration_th elapsed_time ...
    eye_data eye_point eye_traj eyex eyey eyez fdata file_name fixations ...
    frame front_view i index7 index8 index_data index_point index_traj indexx indexy indexz...
    loc mesure miss_tz miss_gx miss_gz miss_ix miss_iz miss_onset_gx miss_onset_gz ...
    miss_tx n object_data obj_shape objx objy objz onset_frame p placeholder pos save_movie...
    screen_only side_view thumb10 thumb9 thumb_data thumb_point thumb_traj...
    thumbx thumby thumbz time tit trial window wrist11 wrist12 wrist_data wristx wristy wristz
