%% Separate Gaussian Mixture Models
% Input data and setup GMM

clear; clc

load('DATA\TrainingSetPCA.mat');
x_train = x_train(:,1:end-1);

numSpeakers = numel(names);

nCoponents = 4;
start = 'randSample';
covType = 'full';



%% Make Mixture Models for all speakers
tic
GMM1 = fitgmdist(x_train(1:N1,:),nCoponents,'Start',start,'CovType',covType);
toc; tic
GMM2 = fitgmdist(x_train(N1+1:N1+N2,:),nCoponents,'Start',start,'CovType',covType);
toc;tic
GMM3 = fitgmdist(x_train(N1+N2+1:N1+N2+N3,:),nCoponents,'Start',start,'CovType',covType);
toc

%% Load test data and classify
tic

load('DATA\TestSetPCA.mat');
x_test = x_test(:,1:end-1);

nTframes = size(x_test,1);

probVec = [pdf(GMM1, x_test) pdf(GMM2, x_test) pdf(GMM3, x_test)];

[value, class] = max(probVec');
[value, classTarget] = max(t_test');

figure(1)
subplot(211)
plot(classTarget, 'o')  % 480 frames per second
hold on
plot(class, '+r')
alpha(0.1)
hold off

%% Confusion matrix

[C,order] = confusionmat(class, classTarget);

C
names(order)

subplot(212)
semilogy(probVec)


toc