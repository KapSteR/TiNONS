%% SVM classify
clear; clc; tic
disp('Input Models')

load('DATA\SVM_3_PCA_1digit.mat')

%% Test all models

disp('Classify individual decisions')

avg_len = 100;
classTarget = t_test-1;

class12 = svmclassify(SVMs12,x_test);
class23 = svmclassify(SVMs23,x_test);
class13 = svmclassify(SVMs13,x_test);


% 
% 
% 
% classConv = conv(classEst13',ones(1,avg_len)*1/avg_len);
% class13 = ones(size(classEst13));
% class13(classConv13(1:end-(avg_len-1))>1.5) = 1;


%% Classify

classEst1 = zeros(size(class13));
classEst2 = zeros(size(classEst1));
classEst3 = zeros(size(classEst2));

for i = 1:size(classEst1,1)
    if (class12(i) && class13(i))
        classEst1(i) = 1;%-1;
        
    elseif (not(class12(i)) && class23(i))
        classEst2(i) = 1;%-1;
        
    elseif (not(class13(i)) && not(class23(i)))
        classEst3(i) = 1;%3-1;
    else
        classEst1(i) = NaN;
        classEst2(i) = NaN;
        classEst3(i) = NaN;
    end 
end

classConv1 = conv(classEst1',ones(1,avg_len)*1/avg_len);
classConv2 = conv(classEst2',ones(1,avg_len)*1/avg_len);
classConv3 = conv(classEst3',ones(1,avg_len)*1/avg_len);


classConv1 =classConv1(1:end-(avg_len-1));
classConv2 =classConv2(1:end-(avg_len-1));
classConv3 =classConv3(1:end-(avg_len-1));

[value, class] = max([classConv1' classConv2' classConv3']');
class = class-1;
toc 

%% Show results
disp('Show Results')

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

% % Make image
% 
% figurePath = '..\Document\Appendix\Figures';
% this = pwd
% cd(figurePath)
% print -f2 -r600 -depsc SVM_3_1digit_PCA10
% cd(this)
% 
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
% conMatLatex.tableCaption = 'Confusion matrix - 1 digit';
% 
% % LaTex table label:
% conMatLatex.tableLabel = 'SVM_3_conf_1';
% 
% % Switch to generate a complete LaTex document or just a table:
% conMatLatex.makeCompleteLatexDocument = 0;
% 
% % Now call the function to generate LaTex code:
% latex = latexTable(conMatLatex);

toc

