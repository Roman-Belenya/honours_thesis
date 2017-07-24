
%% Accuracy checks

data = experiment.P21.accuracy(3);

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


%% Wrist deceleraion

data = experiment.P18.trials;

wdec = zeros(size(data, 2), 1);
VisFeedback = cell(size(data, 2), 1);
Cues = cell(size(data, 2), 1);
Direction = cell(size(data, 2), 1);

for i = 1:size(data, 2)
    
    [VisFeedback{i}, rem] = strtok(data(i).Name, '_');
    [Cues{i}, rem] = strtok(rem, '_');
    Direction{i} = strtok(rem(1:end-4), '_');
    
    [~, frame] = max(data(i).WristVel11);
    wdec(i) = (length(data(i).WristVel11) - frame) / 130;
end

o = strcmp(VisFeedback, 'Occlusion');
v = strcmp(VisFeedback, 'Visible');
c = strcmp(Cues, 'Cue');
n = strcmp(Cues, 'NoCue');
r = strcmp(Direction, 'RightToLeft');
l = strcmp(Direction, 'LeftToRight');

means = [ mean(wdec(o&c&l)), mean(wdec(o&c&r)), mean(wdec(o&n&l)), mean(wdec(o&n&r)), ...
    mean(wdec(v&c&l)), mean(wdec(v&c&r)), mean(wdec(v&n&l)), mean(wdec(v&n&r)) ];

[(1:length(wdec))', wdec]

figure
subplot(1, 3, 1)
axis square
set(gca, 'Position', [0.03 0.11 0.3 0.815]);
hold on
for i = 1:size(data, 2)
    plot(data(i).WristVel11, ':', 'color', [0.6 0.6 0.6])
    [value, frame] = max(data(i).WristVel11);
    plot(frame, value, 'r.', 'markersize', 10)
    drawnow
end
hold off

subplot(1, 3, 2)
plot(wdec)
axis square
set(gca, 'Position', [0.358 0.11 0.3 0.815]);
ylim([0 1])

subplot(1, 3, 3)
plot(means)
axis square
set(gca, 'Position', [0.69 0.11 0.3 0.815]);
ylim([0 1])


%% Grasp accuracy on visible trials

data = experiment.P18.trials;

gacc = zeros(size(data, 2), 1);
VisFeedback = cell(size(data, 2), 1);
Cues = cell(size(data, 2), 1);
Direction = cell(size(data, 2), 1);

chanx = 'Index8x';
chanz = 'Index8z';

for i = 1:size(data, 2)
    
    [VisFeedback{i}, rem] = strtok(data(i).Name, '_');
    [Cues{i}, rem] = strtok(rem, '_');
    Direction{i} = strtok(rem(1:end-4), '_');
    
    theta = - data(i).Position(end);
    gacc(i) = (data(i).(chanx)(end) - data(i).ObjectLoc(end)) * cosd(-theta) + ...
        (data(i).(chanz)(end) - data(i).ObjPosZ(end)) * (-sind(-theta));
end

v = strcmp(VisFeedback, 'Visible');
o = strcmp(VisFeedback, 'Occlusion');

plot(gacc(o))
% plot(gacc)


%% Gaze accuracy

data = experiment.P18.trials;

gazeacc = zeros(size(data, 2), 1);
VisFeedback = cell(size(data, 2), 1);
Cues = cell(size(data, 2), 1);
Direction = cell(size(data, 2), 1);

chanx = 'Index8x';
chanz = 'Index8z';

for i = 1:size(data, 2)
    
    [VisFeedback{i}, rem] = strtok(data(i).Name, '_');
    [Cues{i}, rem] = strtok(rem, '_');
    Direction{i} = strtok(rem(1:end-4), '_');
    
    theta = - data(i).Position(end);
    gazeacc(i) = (data(i).averageXeye(end) - data(i).ObjectLoc(end)) * cosd(-theta) + ...
        (data(i).averageZeye(end) - data(i).ObjPosZ(end)) * (-sind(-theta));
end

v = strcmp(VisFeedback, 'Visible');
o = strcmp(VisFeedback, 'Occlusion');

bar(gazeacc)
view([90 90])


%% Trial-by-trial

data = experiment.P21.trials;

for i = 1:size(data, 2)
    
    plot(data(i).Index7x(end), data(i).Index7z(end), 'r^', 'markerfacecolor', 'r')
    hold on
    plot(data(i).Index8x(end), data(i).Index8z(end), 'b^', 'markerfacecolor', 'b')
    plot(data(i).Thumb9x(end), data(i).Thumb9z(end), 'rv', 'markerfacecolor', 'r')
    plot(data(i).Thumb10x(end), data(i).Thumb10z(end), 'bv', 'markerfacecolor', 'b')
    plot(data(i).averageXeye(end), data(i).averageZeye(end), '*', ...
        'markersize', 10, 'linewidth', 1.5, 'color', [0.6 0.2 0.5])
    line([0.34 0.34 0.87 0.87 0.34], [0.18 0.48 0.48 0.18 0.18], ...
        'Color', 'k', 'LineWidth', 2)
    hold on
    objx = data(i).ObjectLoc(end);
    objz = data(i).ObjPosZ(end);
    plot(objx, objz, 'k+')
    line([objx - 0.02, objx - 0.02, objx + 0.02, objx + 0.02, objx - 0.02],...
        [objz - 0.02, objz + 0.02, objz + 0.02, objz - 0.02, objz - 0.02], ...
        'color', [0.5 0.5 0.5], 'LineWidth', 1)
%     line([objx data(i).Index7x(end)], [objz data(i).Index7z(end)], 'color', 'r')
%     line([objx data(i).Index8x(end)], [objz data(i).Index8z(end)], 'color', 'b')
%     line([objx data(i).Thumb9x(end)], [objz data(i).Thumb9z(end)], 'color', 'r')
%     line([objx data(i).Thumb10x(end)], [objz data(i).Thumb10z(end)], 'color', 'b')
    set(gca, 'XLim', [0.3 0.9], 'Ylim', [0.1 0.5]);
    title(strrep(data(i).Name, '_', ' '))
    legend('Index 7', 'Index 8', 'Thumb 9', 'Thumb 10')
   
    waitforbuttonpress
    
    hold off
     
end



