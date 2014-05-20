%% Separate Gaussian Mixture Models
% Input data and setup GMM

clear; clc
tic

load('DATA\TrainingSetPCA.mat');
x_train = x_train(:,1:end-1); % Remove bias column of 1's 

numSpeakers = numel(names);

nCoponents = 8;
start = 'randSample';
covType = 'full';



%% Make Mixture Models for all speakers

% tic
% 
% GMM = cell(1,3);
% 
% parfor gmCount = 1:3
%  
%         GMM{i}= fitgmdist(x_train(1:N1,:),nCoponents,'Start',start,'CovType',covType);
%     
%     
% %     if (gmCount == 1)
% %         GMM{1}= fitgmdist(x_train(1:N1,:),nCoponents,'Start',start,'CovType',covType);
% %                
% %     elseif (gmCount == 2)
% %         GMM{2} = fitgmdist(x_train(N1+1:N1+N2,:),nCoponents,'Start',start,'CovType',covType);
% %         
% %     elseif(gmCount ==3)     
% %         GMM{3} = fitgmdist(x_train(N1+N2+1:N1+N2+N3,:),nCoponents,'Start',start,'CovType',covType);
% %     
% %     end
%     
%     
%     
% end
% toc



GMM1 = fitgmdist(x_train(1:N1,:),nCoponents,'Start',start,'CovType',covType);
toc
GMM2 = fitgmdist(x_train(N1+1:N1+N2,:),nCoponents,'Start',start,'CovType',covType);
toc
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
    
    classWeigth = sum(log(probVecTemp));
    
    [value, classTemp] = max(classWeigth);
    
    class(i:i+frameStep-1) = repmat(classTemp,1,frameStep);
   
end

class(i:end) = repmat(classTemp,1,nTframes-i+1);

[value, classTarget] = max(t_test');


%% Show results
figure(1)
subplot(211)
plot(classTarget, 'o')  % 480 frames per second
hold on
plot(class, '+r')
alpha(0.1)
hold off

subplot(212)
semilogy(probVec)

% aspect = [5 1 1];

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


% %% Make LaTeX
% set(gcf, 'PaperPositionMode', 'manual');
% set(gcf, 'PaperUnits', 'centimeters');
% set(gcf, 'PaperPosition', [2 1 18 10]);
% 
% 
% figurePath = '..\Document\Appendix\Figures';
% 
% this = pwd
% cd(figurePath)
% print -f2 -r600 -depsc GMM_1digit_8cent_3speak
% cd(this)
% % Confusion matrix
% clc
% confMatrix = OurConfMat(classTarget,class);
% 
% confMatrix
% 
% disp(['Accuracy is: ', num2str(confMatrix(end)*100), '%'])
% names
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
% conMatLatex.tableLabel = 'GMM_conf_1';
% 
% % Switch to generate a complete LaTex document or just a table:
% conMatLatex.makeCompleteLatexDocument = 0;
% 
% % Now call the function to generate LaTex code:
% latex = latexTable(conMatLatex);
% 
% 
% toc