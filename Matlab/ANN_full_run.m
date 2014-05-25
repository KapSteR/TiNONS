%% Arteficial Neural Networks
clear all; clc;
addpath('HMMall\netlab3.3')
%% Load data
clear; clc;
tic
disp('Input Data')

load('DATA\TrainingSet1PCA.mat');
x_train = x_train(:,1:end-1); % Remove bias column of 1'sing_target.mat')

load('DATA\TestSet1PCA.mat');
x_test = x_test(:,1:end-1);

target = t;

test_target = t_test;
toc

%% Setup of run
disp('Set up run parameters')
% Set up network parameters.

nout = 3;               % Number of outputs.
nin = size(x_train,2);	% Number of inputs.

% First try
nHidVec = [ 10 20 50 100 200 300 500 ];
N = numel(nHidVec);
M = 8;
E = zeros(N,M,2);
Malpha  = linspace(0.01,1,M);
nTry = 8;

toc

for nHid = 1:N
    for alphaCount = 1:M
        
        errorVec = zeros(8,1);
       
        for tryCount = 1:nTry
            
            nhidden = nHidVec(nHid);	% Number of hidden units.
            alpha = Malpha(alphaCount);	% Coefficient of weight-decay prior.
            outputfunc = 'softmax';     % output function
                     
            % Set up vector of options for the optimiser.
            options = zeros(1,18);
            options(1) = 0;			% This provides display of error values.
            options(14) = 1000;		% Number of training cycles.
            
            % create network (object)
            net = mlp(nin, nhidden, nout, outputfunc, alpha);
            
            % Train using scaled conjugate gradients.
            [net, options] = netopt(net, options, x_train, target, 'scg');
            
            % Intermidiate rror
            errorVec(tryCount,1) = mlperr(net,x_test,test_target);
            
            toc
            disp(['Hidden units: ' num2str(nhidden)]);
            disp(['Alpha:        ' num2str(alpha)]);
            disp(['Try:          ' num2str(tryCount)]);
            disp([' ']);
                    
        
        end
        
        % Error statistics
        E(nHid,alphaCount,1) = mean(errorVec);
        E(nHid,alphaCount,2) = var(errorVec);

    end
end

save('DATA\Full_ANN_run_data');

%%
figure(1)
surf(Nhidden, Malpha, E(:,:,1))

%%
y_est = mlpfwd(net, x_test);

% for n = 1:10
%     subplot(10,1,n);
%     plot(test_t(:,n),'r')
%     hold on;
%     stem(y_est(:,n),'.');
% end

%% Highest prob -> class
disp('Classifiy')

y_est_conv = zeros(size(y_est,2), size(y_est,1)+100)';

for i = 1:3
    
  y_est_conv(i,:) = conv(y_est(:,i)',ones(1,100));  
    
end


[max_val,max_id] = max(y_est_conv'); % find max. values
t_est = max_id - 1 ; % id is 1,2,3.. in matlab - not 0,1,2..





% subplot(2,1,1)
% stem(test_target);
% subplot(212)
% stem(t_est)

%% Show results
disp('Show Results')

class = t_est+1;
test_target = test_target;

[value, classTarget] = max(test_target');

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


figurePath = '..\Document\Appendix\Figures';


% Confusion matrix
confMatrix = OurConfMat(classTarget,class);
confMatrix

disp(['Accuracy is: ', num2str(confMatrix(end)*100), '%'])
names

% % Make image
% this = pwd
% cd(figurePath)
% print -f2 -r600 -depsc ANN_2digit_8cent_3speak
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
% conMatLatex.tableCaption = 'Confusion matrix - 2 digit';
% 
% % LaTex table label:
% conMatLatex.tableLabel = 'ANN_conf_2';
% 
% % Switch to generate a complete LaTex document or just a table:
% conMatLatex.makeCompleteLatexDocument = 0;
% 
% % Now call the function to generate LaTex code:
% latex = latexTable(conMatLatex);
% 

toc