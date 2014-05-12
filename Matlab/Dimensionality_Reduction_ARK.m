%% Dimensionality Reduction - ARK
% Initialize workspace
clear; clc; tic;
close all;


% import training set
load('DATA\TrainingSet.mat');

% import test set
load('DATA\TestSet.mat');
%%
clc;
% Number of dimensions for 90% of variance:
X = x_train;

N = size(X,1);
mu = mean(X);

sigma = (1/N)*(X - repmat(mu, N, 1))'*(X - repmat(mu, N, 1));      % calculate the covariance matrix estimate
[v,d,~] = svd(sigma);  % find eigenvectors and eigenvalues
d = diag(d); % keep only non-zero entries..
res = d/sum(d)   ;
plot(cumsum(res))
grid on;
xlabel('Number of features');
ylabel('Procentage information');



v1= v(:, 1:3); % Using 3 features
Z = x_train*v1;
I = length(Z);
ploCol = {'r.','g.','b.','m.','k.','rx','gx','kx','mx','bx'};

[value, index] = max(t');
target_train = index;

%%
mu = mean(Z(:,1:3));

figure
hold on
% for i = 1:65
%     %scatter3(Z(i,1)-mu(1,1),Z(i,2)-mu(1,2),Z(i,3)-mu(1,3),cell2mat(ploCol(target_train(i)+1)))
%     scatter3(Z(i,1),Z(i,2),Z(i,3),cell2mat(ploCol(target_train(i)+1)))
%     %scatter(Z(i,1)-mu(1,1),Z(i,2)-mu(1,2),cell2mat(ploCol(target_train(i)+1)))
%     %scatter3(Z(i,1),Z(i,2),Z(i,3),cell2mat(ploCol(3)))
%     hold on;
% end
for i = 1:4
    scatter3(Z(target_train==i,1),Z(target_train==i,2),Z(target_train==i,3),cell2mat(ploCol(i)))
end

%%
v2 = v(:,1:2);
Z = x_train*v2;
figure
hold on 
for i = 1:4
    scatter(Z(target_train==i,1),Z(target_train==i,2),cell2mat(ploCol(i)))
end

%%

x_train = x_train*v;
x_test = x_test*v;

% Save Training data
save('DATA\TrainingSetPCA.mat', 'x_train', 't', 'names', 'N1', 'N2', 'N3', 'N4', 'N')

% Save Training data
save('DATA\TestSetPCA.mat', 'x_test', 't_test', 'Nt1', 'Nt2', 'Nt3', 'Nt4', 'Nt')