%% Separate Gaussian Mixture Models
% Input data and setup GMM

clear; clc

load('DATA\TrainingSetPCA.mat');
x_train = x_train(:,1:end-1);

numSpeakers = numel(names);

nCoponents = 8;
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
frameStep = 100;

probVec = [pdf(GMM1, x_test) pdf(GMM2, x_test) pdf(GMM3, x_test)];

class = zeros(1, nTframes);

for i = 1:frameStep:nTframes-100
   
    probVecTemp = [ pdf(GMM1, x_test(i:i+frameStep,:)) pdf(GMM2, x_test(i:i+frameStep,:)) pdf(GMM3, x_test(i:i+frameStep,:))];
    
    classWeigth = sum(log10(probVecTemp));
    
    [value, classTemp] = max(classWeigth);
    
    class(i:i+frameStep-1) = repmat(classTemp,1,frameStep);
   
end

class(i:end) = repmat(classTemp,1,nTframes-i+1);

[value, classTarget] = max(t_test');

figure(1)
subplot(211)
plot(classTarget, 'o')  % 480 frames per second
hold on
plot(class, '+r')
alpha(0.1)
hold off

%% Confusion matrix
clc
confMatrix = OurConfMat(classTarget,class);

confMatrix
names

subplot(212)
semilogy(probVec)

toc