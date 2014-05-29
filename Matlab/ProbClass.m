%% Probabillistic classifiers
clear; clc;

%% Load data
tic
disp('Input Data')

load('DATA\TrainingSet2PCA.mat');
x_train = x_train(:,1:end-1); % Remove bias column of 1's
% x_train = x_train(:,1:10);
% x_train = x_train(1:N1+N2,:);

[value, t_train] = max(t');
% t_train = t_train(1:N1+N2)';

load('DATA\TestSet2PCA.mat');
x_test = x_test(:,1:end-1);% Remove bias column of 1's
% x_test = x_test(:,1:10);
% x_test = x_test(1:Nt1+Nt2,:);

[value, t_test] = max(t_test');
% t_test = t_test(1:Nt1+Nt2)';

nSpeakers = numel(names);
nFeatures = size(x_train,2);
toc

%% Training
disp('Training')

mu = zeros(nFeatures,nSpeakers);
S  = zeros(nFeatures,nFeatures,nSpeakers);
PD = cell(nSpeakers,1);

for k = 1:nSpeakers
    
    mu(:,k)  = mean(x_train(t_train == k,:));
    S(:,:,k) = cov(x_train(t_train == k,:));
    toc
    
end


%% Classify
disp('Classify')

probVec = zeros(size(t_test,2),nSpeakers);
posterior = zeros(size(t_test,2),nSpeakers);

for k = 1:nSpeakers
    
    probVec(:,k) = mvnpdf(x_test,mu(:,k)',S(:,:,k));
    
    
    numer = mvnpdf(x_test,mu(:,k)',S(:,:,k))*1/nSpeakers;
    
    denom = zeros(size(t_test))';
    for j = 1:nSpeakers
        if j ~= k 
            denom = denom + mvnpdf(x_test,mu(:,j)',S(:,:,j))*1/nSpeakers;
        end
    end
    
    posterior(:,k) = numer ./ denom;

end
toc






[value, class] = max(posterior');
class = class-1;

classTarget = t_test-1;
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





% % Confusion matrix
% confMatrix = OurConfMat(classTarget,class);
% confMatrix
% 
% disp(['Accuracy is: ', num2str(confMatrix(end)*100), '%'])
% names
% 
% % Make image
% 
% figurePath = '..\Document\Appendix\Figures';
% this = pwd
% cd(figurePath)
% print -f2 -r600 -depsc PGM_2digit
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
% conMatLatex.tableCaption = 'Confusion matrix - 2 digits';
% 
% % LaTex table label:
% conMatLatex.tableLabel = 'PGM_conf_2';
% 
% % Switch to generate a complete LaTex document or just a table:
% conMatLatex.makeCompleteLatexDocument = 0;
% 
% % Now call the function to generate LaTex code:
% latex = latexTable(conMatLatex);

toc





