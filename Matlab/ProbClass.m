%% Probabillistic classifiers
clear; clc;

%% Load data
tic
disp('Input Data')

load('DATA\TrainingSet1PCA.mat');
x_train = x_train(:,1:end-1); % Remove bias column of 1's
% x_train = x_train(:,1:10);
% x_train = x_train(1:N1+N2,:);

[value, t_train] = max(t');
% t_train = t_train(1:N1+N2)';

load('DATA\TestSet1PCA.mat');
x_test = x_test(:,1:end-1);% Remove bias column of 1's
% x_test = x_test(:,1:10);
% x_test = x_test(1:Nt1+Nt2,:);

[value, t_test] = max(t_test');
% t_test = t_test(1:Nt1+Nt2)';

%% Training
disp('Training')

mu1 = mean(x_train(1:N1,:));
S1 = cov(x_train(1:N1,:));
PD1 = fitdist(x_train(1:N1,:),'Normal');
toc

mu2 = mean(x_train(N1+1:N1+N2,:));
S1 = cov(x_train(N1+1:N1+N2,:));
PD2 = fitdist(x_train(N1+1:N1+N2,:),'Normal');
toc

mu3 = mean(x_train(N1+N2+1:N1+N2+N3,:));
S3 = cov(x_train(N1+N2+1:N1+N2+N3,:));
PD3 = fitdist(x_train(N1+N2+1:N1+N2+N3,:),'Normal');
toc
