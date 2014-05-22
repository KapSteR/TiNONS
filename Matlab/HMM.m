%% Hidden Markov Model
clear; clc;

addpath(genpath('HMMall'))

disp('Input Data')

tic

load('DATA\TrainingSetPCA.mat');
x_train = x_train(:,1:end-1); % Remove bias column of 1's 


%% Setup HMM

N_hiddenstates = 60;        % number of hidden states
Ndim = size(x_train,2);     % dimensions (of feature vector)
Niter = 100;                % max iteration of EM-alg

% Train hmm on class 1
% Train model on training data
% initial guess of parameters - randomly
N = 592;
Markov = struct('LL', {{}}, 'prior', {{}}, 'transmat', {{}}, 'mu', {{}}, 'sigma', {{}}, 'mixmat',{{}});






%% END
disp('End')
toc
