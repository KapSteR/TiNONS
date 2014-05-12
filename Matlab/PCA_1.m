%% Pricipal Component analysis
% Initialize workspace
clear; clc; tic;

% import training set
load('DATA\TrainingSet.mat');

% import test set
load('DATA\TestSet.mat');

%%



xtx = x_train'*x_train;




% x_pca = printcomp(x_train);

[U,S,V] = svd(xtx);
% 
T = x_train*V';





%%
% figure(1)
% plot(x_pca)
% hold on
% plot(latent)