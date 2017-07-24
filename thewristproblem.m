%% The wrist problem

trial = importdata('C:\Users\marotta_admin\Desktop\Roman\Roman_P12\wrist\Roman_Occlusion_Cue_LeftToRight0000.exp');
trial = importdata('A:\Project\RomanP_test7\Roman_Visible_Cue_LeftToRight0003.exp');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Note where the glitches occur

trial = importdata('C:\Users\marotta_admin\Desktop\Roman\Roman_P2\Roman_Visible_Cue_LeftToRight0002.exp');

plot(trial.data(:,43), 'k-', 'linewidth', 1) % Wrist12Velocity
hold on
plot(trial.data(:,17), 'r-') % Wrist12x
plot(trial.data(:,18), 'b-') % Wrist12y
plot(trial.data(:,19), 'g-') % Wrist12z

line([635 635], [0 1.2], 'color', [0.5 0.5 0.5], 'linestyle', ':')
line([639 639], [0 1.2], 'color', [0.5 0.5 0.5], 'linestyle', ':')

line([646 646], [0 1.2], 'color', [0.5 0.5 0.5], 'linestyle', ':')
line([650 650], [0 1.2], 'color', [0.5 0.5 0.5], 'linestyle', ':')

line([657 657], [0 1.2], 'color', [0.5 0.5 0.5], 'linestyle', ':')
line([661 661], [0 1.2], 'color', [0.5 0.5 0.5], 'linestyle', ':')

line([664 664], [0 1.2], 'color', [0.5 0.5 0.5], 'linestyle', ':')
line([668 668], [0 1.2], 'color', [0.5 0.5 0.5], 'linestyle', ':')

line([678 678], [0 1.2], 'color', [0.5 0.5 0.5], 'linestyle', ':')
line([679 679], [0 1.2], 'color', [0.5 0.5 0.5], 'linestyle', ':')

line([690 690], [0 1.2], 'color', [0.5 0.5 0.5], 'linestyle', ':')
line([694 694], [0 1.2], 'color', [0.5 0.5 0.5], 'linestyle', ':')


hold off

legend('Wrist12Velocity m/sec', 'Wrist12x', 'Wrist12y', 'Wrist12z')
xlabel('Frames')
ylabel('Metres')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



wristvel12 = trial.data(:,43);
plot(wristvel12, 'b-')

hold on

wristx = trial.data(:, 14);
wristy = trial.data(:, 15);
wristz = trial.data(:, 16);

% D = squareform(pdist([wristx, wristy, wristz], 'euclidean'));
% distances = [0, diag(D, -1)'];
% velocity = distances ./ (1/130);


distx = diff(wristx);
disty = diff(wristy);
distz = diff(wristz);


mag = sqrt((distx).^2 + (disty).^2 + (distz).^2);

vel = mag ./ (1/130);


plot([0; vel], 'r-')
hold off




% plot(trial.data(:,43), 'k-') % Wrist12Velocity

plot([vel; 0], 'k-') % without butterworth filter?
hold on




plot(trial.data(:,17), 'r-') % Wrist12x
plot(trial.data(:,18), 'b-') % Wrist12y
plot(trial.data(:,19), 'g-') % Wrist12z

line([635 635], [-0.1 2], 'color', [0.5 0.5 0.5], 'linestyle', ':')
line([647 647], [-0.1 2], 'color', [0.5 0.5 0.5], 'linestyle', ':')
line([657 657], [-0.1 2], 'color', [0.5 0.5 0.5], 'linestyle', ':')
line([660 660], [-0.1 2], 'color', [0.5 0.5 0.5], 'linestyle', ':')
line([668 668], [-0.1 2], 'color', [0.5 0.5 0.5], 'linestyle', ':')
line([671 671], [-0.1 2], 'color', [0.5 0.5 0.5], 'linestyle', ':')

hold off





%% Compare eye velocity and fixations


eyex = trial.data(:, 24);
eyey = trial.data(:, 25);
eyez = trial.data(:, 26);

distx = diff(eyex);
disty = diff(eyey);
distz = diff(eyez);


mag = sqrt((distx).^2 + (disty).^2 + (distz).^2);

vel = mag ./ (1/130);


plot(vel)
hold on

for i = 1:size(fdata, 1)
    line([fdata(i, 1) fdata(i, 1) fdata(i, 2) fdata(i, 2)],...
        [0 -0.15 -0.15 0], 'color', 'c')
    drawnow
end

plot(eyex, 'k:')
plot(eyey, 'c:')
plot(eyez, 'm:')



%% Compare with PASAT's fixations

Signals = [experiment.P1.trials(1).averageXeye ...
    experiment.P1.trials(1).averageZeye];
Param.Dispersion_Threshold = 0.01;
Param.Duration_Threshold = 100;
Param.Fs = 130;
Com = find_fixation_IDT(Signals, Param);

for i = 1:size(Com, 2)
   line([Com(i).Start Com(i).Start Com(i).Finish Com(i).Finish],...
        [0 -0.1 -0.1 0], 'color', 'r')
    drawnow
end



%% Superimpose all trials

[file, path] = uigetfile('*.exp', 'Select a raw data file', 'multiselect', 'on');

figure
% axis([0 900 0 1])
% axis([0 900 0.3 0.9])
set(gcf, 'Position', get(0, 'Screensize'));
hold on

for i = 1:size(file, 2)
    if iscell(file)
        trial = importdata(strcat(path, file{i}));
    else
        trial = importdata(strcat(path, file));
    end
    
%     plot(trial.data(:, 4:-1:2)) % index7
%     plot(trial.data(:, 7:-1:5)) % index8
    
    plot(trial.data(:, 10:-1:8)) % thumb9
%     plot(trial.data(:, 13:-1:11)) % thumb10
    
%     plot(trial.data(:, 16:-1:14)) % wrist11
%     plot(trial.data(:, 19:-1:17)) % wrist12
    
%     plot(trial.data(:, [39 22:23]), 'c-') % Object X Y&Z
    
%     plot(trial.data(:, [24 26])) % eyes x & z
    
%     plot(trial.data(:, 43)) % wrist velocity
    
    drawnow
%     waitforbuttonpress
end

legend('Z', 'Y', 'X')
hold off


%% Apply Salvizky-Golay filter to wrist velocity

[file, path] = uigetfile('*.exp', 'Select a raw data file', 'multiselect', 'on');

figure
set(gcf, 'Position', get(0, 'Screensize'));
% hold on

for i = 1:size(file, 2)
    trial = importdata(strcat(path, file{i}));
    plot(sgolayfilt(trial.data(:, 43), 2, 31), 'b-', 'linewidth', 2)
    hold on
    plot(trial.data(:,43), 'r-')
    drawnow
    hold off
    waitforbuttonpress
end


%%%%%%%%%%%%

x = trial.data(:, 43);
plot(x, 'r-')
hold on
plot(sgolayfilt(x, 2, 21), 'b-')
hold off

%%%%%%%%%%%%%%%%

x = trial.data(:, 43);

fc = 100;
Wn = (2/length(x)) * fc;
b = fir1(5, Wn, 'low', kaiser(6, 1));

% fvtool(b, 1, 'Fs', length(x))

y = filter(b, 1, x);

plot(x, 'r-')
hold on
plot(y, 'b-')


%% Analyze accuracy

data = experiment.P8.accuracy(1);

% plot(data)
% m = median(data);
% hold on
% line([0 length(data)], [m m], 'color', 'r', 'linestyle', ':')
% line([0 length(data)], [m+0.005 m+0.005], 'color', 'r')
% line([0 length(data)], [m-0.005 m-0.005], 'color', 'r')
% hold off


figure
% set(gcf, 'Position', get(0, 'Screensize'));
axis([data.ObjPosX(1)-0.05 data.ObjPosX(1)+0.05 data.ObjPosZ(1)-0.05 data.ObjPosZ(1)+0.05]);
axis square
hold on
scatter(data.ObjPosX(1), data.ObjPosZ(1), 'marker', '+', 'CData', [1 0 0])
h = plot(data.averageXeye(1), data.averageZeye(1), 'color', [0 0 1], ...
    'marker', '*', 'markersize', 5);
l = line([data.ObjPosX(1) data.averageXeye(1)], ...
    [data.ObjPosZ(1) data.averageZeye(1)], 'color', [0.5 0.5 0.5]);
t = text(0.63, 0.335, sprintf('%.3f', ...
    sqrt( (data.ObjPosX(1) - data.averageXeye(1))^2 + (data.ObjPosZ(1) - data.averageZeye(1))^2 )));

theta = 0:pi/100:2*pi;
x = 0.005 .* cos(theta) + data.ObjPosX(1);
y = 0.005 .* sin(theta) + data.ObjPosZ(1);
plot(x, y, 'r-')

hold off

for i = 1:length(data.Frame)
    set(h, 'XData', data.averageXeye(i), 'YData', data.averageZeye(i))
    set(l, 'XData', [data.ObjPosX(1) data.averageXeye(i)], ...
        'YData', [data.ObjPosZ(1) data.averageZeye(i)])
    set(t,'String', sprintf('%.3f', ...
        sqrt( (data.ObjPosX(i) - data.averageXeye(i))^2 + (data.ObjPosZ(i) - data.averageZeye(i))^2 )));
    pause(0.01)
end


xy = [mean(data.averageXeye) mean(data.averageZeye)];
d = sqrt( (data.averageXeye - xy(1)).^2 + (data.averageZeye - xy(2)).^2 );
x = max(d) * cos(theta) + xy(1);
y = max(d) * sin(theta) + xy(2);
hold on
plot(x, y, 'b-')
hold off




%% Make an accuracy scatterplot

close all

% data = importdata('A:\P04\Accuracy\Accuracy0002.exp');
% q = [data.colheaders(2:end); num2cell(data.data(:, 2:end), 1)];
% data = struct(q{:});
% data.bad_values = [...
%             (data.finaleyeX > 0.01 | ...
%             data.finaleyeX < -0.01), ...
%             (data.finaleyeZ > 0.01 | ...
%             data.finaleyeZ < -0.01)];

data = experiment.P9.accuracy(3);

% [median(data.averageXeye) mean(data.averageXeye(~data.bad_values(:,1)))]
% [median(data.averageZeye) mean(data.averageZeye(~data.bad_values(:,2)))]

figure;

%%%%% Scatterplot of gaze points %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(1,3,1)
set(gcf, 'Position', get(0, 'Screensize'));
set(gca, 'Position', [0.03 0.11 0.3 0.815]);
axis([data.ObjPosX(1)-0.05 data.ObjPosX(1)+0.05 data.ObjPosZ(1)-0.05 data.ObjPosZ(1)+0.05]);
axis square
box on
title('Dispersion')
hold on
plot(data.ObjPosX, data.ObjPosZ, 'k+', ...
    'linewidth', 2, 'markersize', 10)
plot(data.averageXeye, data.averageZeye, '.', 'markersize', 4, 'color', [0 0.447 0.741])

theta = 0:pi/100:2*pi;
xy = [mean(data.averageXeye) mean(data.averageXeye(~data.bad_values(:,1)))...
    mean(data.averageZeye) mean(data.averageZeye(~data.bad_values(:,2)))];
% x = 0.005 * cos(theta) + xy(1);
% y = 0.005 * sin(theta) + xy(2);
% x1 = 0.01 * cos(theta) + xy(1);
% y1 = 0.01 * sin(theta) + xy(2);
x = 0.005 * cos(theta) + data.ObjPosX(1);
y = 0.005 * sin(theta) + data.ObjPosZ(1);
x1 = 0.01 * cos(theta) + data.ObjPosX(1);
y1 = 0.01 * sin(theta) + data.ObjPosZ(1);
plot(x, y, 'color', [1 0.6 0], 'linestyle', ':')
plot(x1, y1, 'r-')
p1 = plot(xy(1), xy(3), '.', 'color', [1 0.6 0], 'markersize', 10);
p2 = plot(xy(2), xy(4), 'r.', 'markersize', 10);
legend([p1, p2], {'\mu\it_{gaze}', '\mu\it_{gaze adj}'}, 'Orientation', 'vertical')
hold off

%%%%% Absolute distance plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(1,3,2)
plot(sqrt((data.ObjPosX - data.averageXeye).^2 + ...
    (data.ObjPosZ - data.averageZeye).^2), 'color', [0 0.447 0.741])
hold on
line([0 length(data.ObjPosX)], [0.005 0.005], 'color', [1 0.6 0],  'linestyle', ':')
line([0 length(data.ObjPosX)], [0.01 0.01], 'color', 'r')
plot(0, median(sqrt((data.ObjPosX - data.averageXeye).^2 + ...
    (data.ObjPosZ - data.averageZeye).^2)), 'marker', 'x',...
    'color', [0 0.447 0.741], 'linewidth', 1.5)
ylim([0 0.05]); xlim([0 length(data.ObjPosX)])
axis square
set(gca, 'Position', [0.358 0.11 0.3 0.815]);
title('Object - gaze absolute distance')
hold off

%%%%% X & Z distances separately %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(1,3,3)
plot(data.finaleyeX, 'color', [0 0.447 0.741])
hold on
plot(data.finaleyeZ, 'color', [0 0.6 0])
ylim([-0.05 0.05])
xlim([0 length(data.finaleyeX)])
axis square
set(gca, 'Position', [0.69 0.11 0.3 0.815]);
line([0 length(data.finaleyeX)], [-0.005 -0.005], 'color', [1 0.6 0],  'linestyle', ':')
line([0 length(data.finaleyeX)], [0.005 0.005], 'color', [1 0.6 0],  'linestyle', ':')
line([0 length(data.finaleyeX)], [-0.01 -0.01], 'color', 'r')
line([0 length(data.finaleyeX)], [0.01 0.01], 'color', 'r')
% line([0 length(data.finaleyeX)], [0 0], 'color', [0.95 0.95 0.95])
plot(0, median(data.finaleyeX), 'marker', 'x', 'color', [0 0.447 0.741], 'linewidth', 1.5)
plot(0, median(data.finaleyeZ), 'marker', 'x', 'color', [0 0.6 0], 'linewidth', 1.5)
legend('X', 'Z')
title('Object - gaze distance on X&Y axes')
hold off

%%% Some statistics
q = sum(data.bad_values) / length(data.bad_values);
fprintf('Mean X error = %.4f;\tAdjusted = %.4f;\tBad values = %.2f %%\nMean Z error = %.4f;\tAdjusted = %.4f;\tBad values = %.2f %%\n\n', ...
    mean(data.finaleyeX), ...
    mean(data.finaleyeX(~data.bad_values(:,1))), ...
    q(1)*100, ...
    mean(data.finaleyeZ),...
    mean(data.finaleyeZ(~data.bad_values(:,2))), ...
    q(2)*100)

%%
% for i = 1:6
%     plot(experiment.P4.trials(i).Index8x)
%     drawnow
% end


x = zeros([48 1]);

for i = 1:48
    x(i) = experiment.P1.trials(i).Index7x(end) - experiment.P1.trials(i).ObjectLoc(end);
end


% for i = 1:7
%     for j = 1:3
%     experiment.(strcat('P', num2str(i))).accuracy(j).bad_values = [...
%             (experiment.(strcat('P', num2str(i))).accuracy(j).finaleyeX > 0.01 | ...
%             experiment.(strcat('P', num2str(i))).accuracy(j).finaleyeX < -0.01), ...
%             (experiment.(strcat('P', num2str(i))).accuracy(j).finaleyeZ > 0.01 | ...
%             experiment.(strcat('P', num2str(i))).accuracy(j).finaleyeZ < -0.01)];
%     end 
% end

save('ExperimentData.mat', 'experiment')

% for i = 1:6
%     experiment.P1.trials(i).Name = strcat('Occlusion_Cue_LeftToRight000', num2str(i-1));
% end
    
% for i = 1:8
%     dat = importdata(strcat('C:\Users\marotta_admin\Desktop\Roman\Roman_P', num2str(i), '\Roman_Occlusion_Cue_RightToLeft0004.exp'));
%     experiment.(strcat('P', num2str(i))).date = datestr(dat.textdata{2}(1:end-19), 'dd-mm-yyyy');
% end

%% Calculate the distances between the markers and the object's COM

data = experiment.P1.trials(1);
theta = - data.Position;

indexX_com = (data.Index8x - data.ObjectLoc) .* cosd(-theta) + ...
    (data.Index8z - data.ObjPosZ) .* (-sind(-theta));
indexZ_com = (data.Index7x - data.ObjectLoc) .* sind(-theta) + ...
    (data.Index8z - data.ObjPosZ) .* cosd(-theta);


thumbX_com = (data.Thumb10x - data.ObjectLoc) .* cosd(-theta) + ...
    (data.Thumb10z - data.ObjPosZ) .* (-sind(-theta));
thumbZ_com = (data.Thumb10x - data.ObjectLoc) .* sind(-theta) + ...
    (data.Thumb10z - data.ObjPosZ) .* cosd(-theta);


eyeX_com = (data.averageXeye - data.ObjectLoc) .* cosd(-theta) + ...
    (data.averageZeye - data.ObjPosZ) .* (-sind(-theta));
eyeZ_com = (data.averageXeye - data.ObjectLoc) .* sind(-theta) + ...
    (data.averageZeye - data.ObjPosZ) .* cosd(-theta);


x = data.WristVel11;
y = zeros([length(data.WristVel11) 1]);

i= 1;
while i < length(data.Wrist11)-1
    
    for k = 0:5
        if abs(x(i) - x(i+1)) > 0.1
            y(i) = x(i);
            y(i+1) = NaN;
            i = i + 2;
        end
        else
            y(i) = x(i);
            i = i+1;
    end
end
    
    
%% fitting the velocity curve

plot(data(1).WristVel11(650:end), 'marker', '.', 'linestyle', 'none')

f = fittype('poly1');
fit1 = fit(data(1).WristVel11(650:end), (1:145)', f)
[d1, d2] = differentiate(fit1, (1:145)')

plot(fit1, (1:145)', data(1).WristVel11(650:end))



vel = data(1).WristVel11(650:end);
in = (650:length(data(1).WristVel11))';

f = fittype( 'poly9' );
opts = fitoptions( 'Method', 'LinearLeastSquares' );
opts.Normalize = 'on';
opts.Robust = 'Bisquare';

fit1 = fit(in, vel, f, opts)


fdata = feval(fit1, in);
I = abs(fdata - vel) > 0.3 * std(vel);

outliers = excludedata(in, vel, 'indices', I);

fit2 = fit(in, vel, f, 'Exclude', outliers)
plot(fit2)
hold on
plot(in, vel)
sum(outliers)

vel_fixed = vel(~outliers);
in_fixed = 650:649+length(vel_fixed)';

vel_fixed(outliers) = NaN;
plot(vel_fixed)
hold on
plot(vel + 0.01)



f = fit(in, vel, 'fourier2');
plot(f, in, vel);


%%

data = experiment.P1.trials(8).WristVel11;

plot(data); hold on;
[peaks, locs] = findpeaks(data, 'threshold', 0.001);
plot(locs, peaks, 'r.')
hold off

x = 1:length(data);
y = data(~peaks);



%% Correlations

load('ExperimentData.mat')

GraspAccuracy = [];
FixationLength = [];
FixationCount = [];
FixationOnset = [];

index_number = [8 8 8 8 7 8 7 8];

for i = 1:8
    id = strcat('P', num2str(i));
    data = experiment.(id).trials;
    chanx = strcat('Index', num2str(index_number(i)), 'x');
    chanz = strcat('Index', num2str(index_number(i)), 'z');
    
    for k = 1:size(data, 2)
        theta = - data(k).Position(end);
        GraspAccuracy = [GraspAccuracy, ... % index - COM on X
            (data(k).(chanx)(end) - data(k).ObjectLoc(end)) * cosd(-theta) + ...
            (data(k).(chanz)(end) - data(k).ObjPosZ(end)) * (-sind(-theta))];
        fix = fixations_no(data(k).averageXeye, data(k).averageZeye, ...
            0.01, 13);
        FixationLength = [FixationLength, mean(fix(:, 3))];
        FixationCount = [FixationCount, size(fix, 1)];
    end
end

        
scatter(abs(GraspAccuracy), FixationLength, 'marker', '.')
hold on
[fit, S] = polyfit(abs(GraspAccuracy), FixationLength, 1);
x = linspace(min(abs(GraspAccuracy)), max(abs(GraspAccuracy)));
y = polyval(fit, x);
[Y, DELTA] = polyconf(fit, x, S, 'alpha', 0.05);
plot(x, y, 'r-')
line(x, Y + DELTA, 'color', 'r', 'LineStyle', ':')
line(x, Y - DELTA, 'color', 'r', 'LineStyle', ':')
hold off


scatter(FixationCount, FixationLength, 'marker', '.')
hold on
[fit, S] = polyfit(FixationCount, FixationLength, 1);
x = linspace(min(FixationCount), max(FixationCount));
y = polyval(fit, x);
plot(x, y, 'r-')
hold off

scatter(FixationCount, abs(GraspAccuracy), 'marker', '.')
hold on
fit = polyfit(FixationCount, abs(GraspAccuracy), 1);
x = linspace(min(FixationCount), max(FixationCount));
y = polyval(fit, x);
plot(x, y, 'r-')
hold off


[r, p] = corrcoef([abs(GraspAccuracy)', FixationLength', FixationCount'])


%% Fixation onset, termination & duration

load('ExperimentData.mat')

onset = [];
termination = [];
duration = [];

for i = 1
    data = experiment.P7.trials(i);
    fix = fixations_no(data.averageXeye, data.averageZeye, 0.01, 13);
    
    onset = [onset, (fix(:,1) ./ 130)'];
    termination = [termination, (fix(:,2) ./ 130)'];
    duration = [duration, fix(:,3)'];
    
end

scatter(onset, duration, 'b.')
hold on
scatter(termination, duration, 'r.')
line([onset, termination], [duration duration])




data = experiment.P7.trials(2);
fix = fixations_no(data.averageXeye, data.averageZeye, 0.01, 13);
plot(data.averageXeye, data.averageZeye, 'b:')
hold on
for i = 1:size(fix, 1)
    scatter(data.averageXeye(fix(i,1):fix(i,2)), data.averageZeye(fix(i,1):fix(i,2)), 'r.')
    text(data.averageXeye(fix(i,1)), data.averageZeye(fix(i,1)), num2str(i))
    drawnow
end



%% changing the wrist velocity

for i = 11:12
    if i < 10
        id = strcat('P0', num2str(i));
    else
        id = strcat('P', num2str(i));
    end
    k = size(experiment.(id).trials, 2)
    [wfiles, wpath] = uigetfile('*.exp', strcat('Select wrist files for participant ', num2str(i)), 'multiselect', 'on');
    if size(wfiles, 2) ~= k
        error('Something is wrong')
    end
    for j = 1:k
        trial = importdata(strcat(wpath, wfiles{j}));
        if length(experiment.(id).trials(j).WristVel11) ~= length(trial.data(:, 43))
            warning('Participant %d, trial %d does not match\n', i, j)
        else
            fprintf(strcat(trial.colheaders{43}, trial.colheaders{49}, '\n\n'));
            experiment.(id).trials(j).WristVel12 = trial.data(:, 49);
        end
    end
end


%% check for a mess-up

for i = 1:9
    [files, path] = uigetfile('*.exp', strcat('Select files for participant ', num2str(i)), 'multiselect', 'on');
    [wfiles, wpath] = uigetfile('*.exp', strcat('Select wrist files for participant ', num2str(i)), 'multiselect', 'on');
    if size(wfiles, 2) ~= size(files, 2)
        error('Number of files/wrist files does not match')
    end
    for j = 1:size(files, 2)
        a = importdata(strcat(path, files{j}));
        b = importdata(strcat(wpath, wfiles{j}));
        
        if strcmp(a.textdata{3}, b.textdata{3})
            fprintf('Patricipant %d, trial %d match\n', i, j)
        else
            warning('Patricipant %d, trial %d NOT MATCH\n', i, j)
        end
    end
end

    
%% one more time
id = fieldnames(experiment);
for i = 1:12
    k = size(experiment.(id{i}).trials, 2);
    for j = 1:k
        if length(experiment.(id{i}).trials(j).WristVel11) == length(experiment.(id{i}).trials(j).WristVel12)
            fprintf('ok\n')
        else
            sprintf('Participant %s, trial %d\n', id{i}, j)
        end
    end
end








%% measurement problem

trial = importdata('C:\Users\marotta_admin\Desktop\tests\tap test.exp');

plot(trial.data(:,4))

trial1 = importdata('C:\Users\marotta_admin\Desktop\tests\100 all the same.exp');
time1 = linspace(0, size(trial1.data, 1) / 100, size(trial1.data, 1));
trial2 = importdata('C:\Users\marotta_admin\Desktop\tests\130 all the same.exp');
time2 = linspace(0, size(trial2.data, 1) / 130, size(trial2.data, 1));

plot(trial1.data(:,4))
hold on
plot(trial2.data(:,4) + 0.05, 'r-')

plot(time1, trial1.data(:,4))
hold on
plot(time2, trial2.data(:,4) + 0.05, 'r-')

