%% Support Vector Machines
% pause
clear; clc;
%% Load data
tic
disp('Input Data')

load('DATA\TrainingSet1PCA.mat');
x_train = x_train(:,1:end-1); % Remove bias column of 1's
x_train = x_train(1:N1+N2,:);

[value, t_train] = max(t,[],2);
t_train = t_train(1:N1+N2);

load('DATA\TestSet1PCA.mat');
x_test = x_test(:,1:end-1);% Remove bias column of 1's
x_test = x_test(1:Nt1+Nt2,:);

[value, t_test] = max(t,[],2);
t_test = t_test(1:Nt1+Nt2);

target = t;

test_target = t_test;
toc

%%

C = 1e3; % soft-margin parameter ("regularisation") - automatisk rescaled for imbalanced classes
mykernel = 'rbf'; % 'linear', 'quadratic',
my_sigma = 10; % kernel width
opts = statset('Display', 'iter', 'MaxIter', 100000);
mysvm = svmtrain(x_train, t_train, 'boxconstraint', C, 'kernel_function', mykernel, 'rbf_sigma', my_sigma,'method', 'SMO', 'options', opts, 'showplot', 'true');
mytitle = ['#support vectors : ' num2str(size(mysvm.SupportVectors,1))];
mytitle = [mytitle ', C = ' num2str(C), ', \sigma = ' num2str(my_sigma)];
title(mytitle)