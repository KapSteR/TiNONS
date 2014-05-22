%% Arteficial Neural Networks
clear all; close all; clc;
addpath('netlab')
%% Load data
load('_training_fVector.mat')
load('_test_fVector.mat')
load('_test_target.mat')
load('_training_target.mat')

%% One of K-coding
target = zeros(10,length(training_target));
for i = 0:9
    idx = find(training_target == i);
    target(i+1,idx) = 1;
end
target = target';


test_t = zeros(10,length(test_target));
for i = 0:9
    idx = find(test_target == i);
    test_t(i+1,idx) = 1;
end

test_t = test_t';


%%

% Set up network parameters.
nin = 50;                % Number of inputs.
nhidden = 100;			% Number of hidden units.
nout = 10;               % Number of outputs.
outputfunc = 'softmax';  % output function
alpha = 0.5;			% Coefficient of weight-decay prior.

% create network (object)
net = mlp(nin, nhidden, nout, outputfunc, alpha);

% Set up vector of options for the optimiser.
options = zeros(1,18);
options(1) = 0;			% This provides display of error values.
options(14) = 2000;		% Number of training cycles.

% Train using scaled conjugate gradients.
[net, options] = netopt(net, options, training_fVector, target, 'scg');



% Error
E = mlperr(net,test_fVector,test_t)

%%
y_est = mlpfwd(net, test_fVector);

for n = 1:10
    subplot(10,1,n);
    plot(test_t(:,n),'r')
    hold on;
    stem(y_est(:,n),'.');
end

%% Highest prob -> class
[max_val,max_id] = max(y_est'); % find max. values
t_est = max_id - 1 ; % id is 1,2,3.. in matlab - not 0,1,2..

subplot(2,1,1)
stem(test_target);
subplot(212)
stem(t_est)

%% Confusion matrix
CM = confusionmat(test_target,t_est); % note: omvendt af hvad vi plejer
CM = CM';

targetClassACC = round(diag(CM)'./sum(CM).*10000)/100;
outputClassACC = round(diag(CM')'./sum(CM').*10000)/100;
totalACC = round(sum(diag(CM))./sum(CM(:)).*10000)/100;


CM_ACC = [CM,outputClassACC';targetClassACC,totalACC]