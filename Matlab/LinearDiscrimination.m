%% Liner Discrimination
% Initialize workspace
clear; clc; tic;


% import training set
load('DATA\TrainingSet10PCA.mat');

% import test set
load('DATA\TestSet10PCA.mat');

%% Truncate feautures

numFeatStart = 1;
numFeat = 10;

x_train = x_train(:,numFeatStart:numFeat);
x_test = x_test(:,numFeatStart:numFeat);


%% Train weigths

innerProd = x_train'*x_train;

W = inv(innerProd+eye(size(innerProd,1))*0.8)*x_train'*t;



%% I
y = W'*x_test';

r = y / norm(W);

nTframes = size(x_test,1);
frameStep = 100;

[value, class] = max(y);
[value, classTarget] = max(t_test');

% figure(1)
% plot(classTarget, 'o')
% hold on
% plot(class, '+r')
% alpha(0.1)
% hold off


%% Show results



h = figure(2)
subplot(211)
plot(class,'+b')
title('Classification')
xlabel('Frames - 10 ms/frame')
ylabel('Class estimate')
% set(gca,'plotboxaspectratio',aspect)
subplot(212)
h = plot(classTarget, 'or')
title('Target')
xlabel('Frames - 10 ms/frame')
ylabel('Class target')
% set(gca,'plotboxaspectratio',aspect)

% Confusion matrix
clc
confMatrix = OurConfMat(classTarget,class);

confMatrix

disp(['Accuracy is: ', num2str(confMatrix(end)*100), '%'])
names

% %% Make LaTeX
% set(gcf, 'PaperPositionMode', 'manual');
% set(gcf, 'PaperUnits', 'centimeters');
% set(gcf, 'PaperPosition', [2 1 18 7]);
% 
% 
% figurePath = '..\Document\Appendix\Figures';
% 
% this = pwd
% cd(figurePath)
% print -f2 -r600 -depsc Linear_10_PCA_trunc
% cd(this)
% 
% 
% disp('')
% conMatLatex.tableCloumnHeaders = {
%     ['Speaker ', char(names(1))]
%     ['Speaker ', char(names(2))]
%     ['Speaker ', char(names(3))]
%     'Precision [\%]'
%     };
% 
% conMatLatex.tableRowLabels = {
%     ['Estimate ', char(names(1))]
%     ['Estimate ', char(names(2))]
%     ['Estimate ', char(names(3))]
%     'Sensitivity [\%]'
%     };
% 
% conMatLatex.tableData = confMatrix;
% conMatLatex.tableData(end,:) = conMatLatex.tableData(end,:)*100; 
% conMatLatex.tableData(1:end-1,end) = conMatLatex.tableData(1:end-1,end)*100;
% 
% conMatLatex.tableDataRowFormat = {'%.1f'};
% 
% % Column alignment ('l'=left-justified, 'c'=centered,'r'=right-justified):
% conMatLatex.tableColumnAlignment = 'c';
% 
% % Switch table borders on/off:
% conMatLatex.tableBorders = 1; 
% 
% % LaTex table caption:
% % conMatLatex.tableCaption = 'Confusion matrix - 10 digits';
% conMatLatex.tableCaption = 'Confusion matrix - Linear classifier, truncated to 10 dimensions';
% 
% % LaTex table label:
% % conMatLatex.tableLabel = 'Lin_conf_10';
% conMatLatex.tableLabel = 'Lin_conf_10_trunc';
% 
% % Switch to generate a complete LaTex document or just a table:
% conMatLatex.makeCompleteLatexDocument = 0;
% 
% % Now call the function to generate LaTex code:
% latex = latexTable(conMatLatex);



toc