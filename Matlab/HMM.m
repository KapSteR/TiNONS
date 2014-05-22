%% Hidden Markov Model
clear; clc;

addpath(genpath('HMMall'))

disp('Input Data')

tic

load('DATA\TrainingSetPCA.mat');
x_train = x_train(:,1:end-1); % Remove bias column of 1's

xTrain{1} = x_train(1:N1,:);
xTrain{2} = x_train(N1+1:N1+N2,:);
xTrain{3} = x_train(N1+N2+1:N1+N2+N3,:);


%% Setup HMM

N_hiddenstates = 10;        % number of hidden states
Ndim = size(x_train,2);     % dimensions (of feature vector)
Niter = 100;                % max iteration of EM-alg
N_classes = 3

for classCount = 1:N_classes
    
    clear data;
    for n = 1:N_(classCount)
        data{n} = xTrain{classCount}(n,:)';
    end
    
    
    % train hmm on all class
    % Train model on training data
    % initial guess of parameters - randomly
    prior0 = zeros(N_hiddenstates, 1); prior0(1) = 1; % start in state 1
    transmat0 = rand(N_hiddenstates,N_hiddenstates);
    % ensure left-right model - and has to pass through all states..
    for i=1:N_hiddenstates,
        for j=1:i-1,
            transmat0(i, j) = 0;
        end
        for j=i+2:N_hiddenstates,
            transmat0(i, j) = 0;
        end
    end
    
    transmat0 = mk_stochastic(transmat0);
    sigma0 = repmat(eye(Ndim), [1 1 N_hiddenstates]); % covariance matrices
   
    idx = randperm(N_(classCount));
    for i=1:N_hiddenstates,
        mu0(:,i) = data{classCount}(:, idx(i)); % choosing mu's randomly from data set..
    end
    % training - hmm with gaussian outputs
    [LLh, prior1h, transmat1h, mu1h, sigma1h, mixmat1h] = ...
        mhmm_em(data, prior0, transmat0, mu0, sigma0, [], 'max_iter', Niter);
    
    
end




%% END
disp('End')
toc
