%% Liner Discrimination
% Initialize workspace
clear; clc; tic;


% import training set
load('DATA\TrainingSet.mat');

% import test set
load('DATA\TestSet.mat');


%% Train weigths

innerProd = x_train'*x_train;

W = inv(innerProd+eye(size(innerProd,1))*0.8)*x_train'*t;



%% I
y = W'*x_test';

r = y / norm(W);

[value, class] = max(y);
[value, classTest] = max(t_test');

figure(1)
plot(classTest, 'o')
hold on
plot(class, '+r')
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