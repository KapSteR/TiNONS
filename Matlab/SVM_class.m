%% SVM classify
clear; clc;

load('DATA\SVM_PCA_1digit.mat')

avg_len = 100;

classEst = svmclassify(mysvm,x_test);

classConv = conv(classEst',ones(1,avg_len)*1/avg_len);

% [max_val,max_id] = max(y_est_conv); % find max. values
% t_est = max_id - 1 ; % id is 1,2,3.. in matlab - not 0,1,2..

class = ones(size(classEst));

class(classConv(1:end-99)>1.5) = 2;




% subplot(2,1,1)
% stem(test_target);
% subplot(212)
% stem(t_est)

%% Show results
disp('Show Results')

test_target = test_target;

classTarget = t_test;

toc




% figure(1)
% subplot(211)
% plot(classTarget, 'o')  % 480 frames per second
% hold on
% plot(class, '+r')
% hold off
% 
% subplot(212)
% semilogy(probVec)


% aspect = [5 1 1];

h = figure(2);
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



%% Make LaTeX
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperPosition', [2 1 18 10]);





% Confusion matrix
confMatrix = OurConfMat(classTarget,class);
confMatrix

disp(['Accuracy is: ', num2str(confMatrix(end)*100), '%'])
names

% Make image

figurePath = '..\Document\Appendix\Figures';
this = pwd
cd(figurePath)
print -f2 -r600 -depsc SVM_1digit_PCA10
cd(this)



disp('')
conMatLatex.tableCloumnHeaders = {
    ['Speaker ', char(names(1))]
    ['Speaker ', char(names(2))]
%     ['Speaker ', char(names(3))]
    'Precision [\%]'
    };

conMatLatex.tableRowLabels = {
    ['Estimate ', char(names(1))]
    ['Estimate ', char(names(2))]
%     ['Estimate ', char(names(3))]
    'Sensitivity [\%]'
    };

conMatLatex.tableData = confMatrix;
conMatLatex.tableData(end,:) = conMatLatex.tableData(end,:)*100; 
conMatLatex.tableData(1:end-1,end) = conMatLatex.tableData(1:end-1,end)*100;

conMatLatex.tableDataRowFormat = {'%.1f'};

% Column alignment ('l'=left-justified, 'c'=centered,'r'=right-justified):
conMatLatex.tableColumnAlignment = 'c';

% Switch table borders on/off:
conMatLatex.tableBorders = 1; 

% LaTex table caption:
conMatLatex.tableCaption = 'Confusion matrix - 1 digit';

% LaTex table label:
conMatLatex.tableLabel = 'SVM_conf_1';

% Switch to generate a complete LaTex document or just a table:
conMatLatex.makeCompleteLatexDocument = 0;

% Now call the function to generate LaTex code:
latex = latexTable(conMatLatex);


toc

