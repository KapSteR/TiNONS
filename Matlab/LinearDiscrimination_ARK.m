%% Liner Discrimination - ARK
% Initialize workspace
clear; clc; tic;


% import training set
load('DATA\TrainingSet.mat');

% import test set
load('DATA\TestSet.mat');



%% I
Z = x_train;
W = inv(Z'*Z+eye(size(Z,2)))*Z'*t;
y = Z*W;



[value, class] = max(y');
[value, classTest] = max(t');
t_est = zeros(size(class));
t_est(1:28654) = median(class(1:28645));
t_est(28654:(2*28654)) = median(class(28654:(2*28654)));



subplot(2,1,1); stem(classTest,'.');
title('Classification'); ylabel('Label {1...4}'); xlabel('sound file#');
subplot(2,1,2); stem(t_est, 'r.')
title('Target Labels'); ylabel('Label {1...4}'); xlabel('sound file#');

CM = confusionmat(class, classTest); % note: omvendt af hvad vi plejer
CM = CM';

targetClassACC = diag(CM)'./sum(CM);
outputClassACC = diag(CM')'./sum(CM');
totalACC = sum(diag(CM))./sum(CM(:));


CM_ACC = [CM,outputClassACC';targetClassACC,totalACC]


%%

figure(2)
plot(classTest, 'o')
hold on
plot(class, '.r')
alpha(0.1)
hold off

%% Confusion matrix

[C,order] = confusionmat(class, classTest);

C
names(order)

%% Fisher's linear discriminant



% m_1 = mean(x1,2); M_1 = diag(m_1)*ones(size(x1));
% m_2 = mean(x2,2); M_2 = diag(m_2)*ones(size(x2));



% S_W = (x1-M_1)*(x1-M_1)'+(x2-M_2)*(x2-M_2)';

% w = inv(S_W)*(m_1-m_2);

%% End


toc