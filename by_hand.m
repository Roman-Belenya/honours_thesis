load('C:\Users\marotta_admin\Desktop\Roman\ExperimentData.mat')
p4a = [1 3 6 7 8 10 11 12 13 14 15 16 17 18 19];

save('C:\Users\marotta_admin\Desktop\Roman\ExperimentData.mat', 'experiment')

plot(experiment.P21.trials(15).StartMovement)
hold on
plot(experiment.P21.trials(15).WristVel11)
plot(experiment.P21.trials(15).WristVel12)




experiment.P01.trials(3).StartMovement = experiment.P01.trials(3).WristVel12 > 0.05;
experiment.P01.trials(30).StartMovement = experiment.P01.trials(30).WristVel12 > 0.05;
experiment.P01.trials(45).StartMovement = experiment.P01.trials(45).WristVel12 > 0.05;

experiment.P11.trials(11).StartMovement(1:500) = zeros(1, 500);

experiment.P12.trials(4).StartMovement = experiment.P12.trials(4).WristVel12 > 0.05;
experiment.P12.trials(22).StartMovement = experiment.P12.trials(22).WristVel12 > 0.05;
experiment.P12.trials(32).StartMovement = experiment.P12.trials(32).WristVel12 > 0.05;

experiment.P13.trials(20).StartMovement(1:500) = zeros(1, 500);
experiment.P13.trials(34).StartMovement(1:500) = zeros(1, 500);

experiment.P18.trials(48).StartMovement(1:500) = zeros(1, 500);
experiment.P18.trials = experiment.P18.trials([1:24, 26:end]);

experiment.P21.trials(15).StartMovement(1:500) = zeros(1, 500);





%% reach onnset stuff

data = experiment.P21.trials;
ro = [];

for i = 1:size(data, 2)
    ro(i) = find(data(i).StartMovement, 1);
end

[(1:size(ro, 2))' ro']

