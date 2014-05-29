%%
clear; clc; tic
load('DATA\Full_ANN_run_data.mat');


%%
h = figure(1)

E(6,end-2:end,1) = NaN;
E(7:end,:,1) = NaN;
E
surf(nHidVec, Malpha, E(:,:,1)')
xlabel('Number of hidden varialbles')
ylabel('Alpha value')
zlabel('Mean error')


set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperPosition', [2 1 18 10]);


figurePath = '..\Document\Appendix\Figures';

% % Make image
this = pwd
cd(figurePath)
print -f1 -r600 -depsc ANN_error
cd(this)

toc