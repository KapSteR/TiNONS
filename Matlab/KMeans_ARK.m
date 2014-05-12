%% K-Means - ARK
% Initialize workspace
clear; clc; tic;


% import training set
load('DATA\TrainingSet.mat');

% import test set
load('DATA\TestSet.mat');

%%

k = 4;
data = x_train;
IDX = kmeans(data,k);
