%% Support Vector Machines
% pause
clear; clc;

%% Load data
tic
disp('Input Data')

load('DATA\TrainingSet1PCA.mat');
x_train = x_train(:,1:end-1); % Remove bias column of 1's
x_train = x_train(:,1:10);
% x_train = x_train(1:N1+N2,:);

[value, t_train] = max(t');
% t_train = t_train(1:N1+N2)';

load('DATA\TestSet1PCA.mat');
x_test = x_test(:,1:end-1);% Remove bias column of 1's
x_test = x_test(:,1:10);
% x_test = x_test(1:Nt1+Nt2,:);

[value, t_test] = max(t_test');
% t_test = t_test(1:Nt1+Nt2)';

toc

%% Training
disp('Training SVM - Prep data')
C = 1e3; % soft-margin parameter ("regularisation") - automatisk rescaled for imbalanced classes
mykernel = 'rbf'; % 'linear', 'quadratic',
my_sigma = 10; % kernel width
opts = statset('Display', 'iter', 'MaxIter', 1000000);


x_train_12 = x_train(1:N1+N2,:);
t_train_12 = [ones(N1,1) ; zeros(N2,1)];

x_train_23 = x_train(N1+1:N1+N2+N3,:);
t_train_23 = [ones(N2,1) ; zeros(N3,1)];

x_train_13 = [x_train(1:N1,:) ; x_train(N1+N2+1:N1+N2+N3,:)];
t_train_13 = [ones(N1,1) ; zeros(N3,1)];

disp('Training SVM12')
SVMs12 = svmtrain(x_train_12, t_train_12, 'boxconstraint', C, ...
    'kernel_function', mykernel, 'rbf_sigma', my_sigma, ...
    'method', 'SMO', 'options', opts, 'showplot', 'true');
toc

disp('Training SVM23')
SVMs23 = svmtrain(x_train_23, t_train_23, 'boxconstraint', C, ...
    'kernel_function', mykernel, 'rbf_sigma', my_sigma, ...
    'method', 'SMO', 'options', opts, 'showplot', 'true');
toc

disp('Training SVM13')
SVMs13 = svmtrain(x_train_13, t_train_13, 'boxconstraint', C, ...
    'kernel_function', mykernel, 'rbf_sigma', my_sigma, ...
    'method', 'SMO', 'options', opts, 'showplot', 'true');
toc

% mytitle = ['#support vectors : ' num2str(size(mysvm.SupportVectors,1))];
% mytitle = [mytitle ', C = ' num2str(C), ', \sigma = ' num2str(my_sigma)];
% title(mytitle)


disp('Saving data')
save('DATA\SVM_3_PCA_1digit.mat')
toc
