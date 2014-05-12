%% Gaussian Mix model - ARK
% Initialize workspace
clear; clc; tic;


% import training set
load('DATA\TrainingSet.mat');

% import test set
load('DATA\TestSet.mat');

%%

dim = 37; % dimensions
ncentres = 4; % number of mixtures - try using e.g. 3, 5 and 7..
covartype = 'full';%'spherical'; % covariance-matrix type.. 'spherical', 'diag' or 'full'
mix = gmm(dim, ncentres, covartype);


opts = foptions; % standard options
opts(1) = 1; % show errors
opts(3) = 0.001; % stop-criterion of EM-algorithm
opts(5) = 0; % do not reset covariance matrix in case of small singular values.. (1=do reset..)
opts(14) = 100; % max number of iterations
%[MIX, OPTIONS, ERRLOG] = GMMEM(MIX, X, OPTIONS)
[mix, opts, errlog] = gmmem(mix, x_train, opts);

mix % see contents..
