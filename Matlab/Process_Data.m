%% Process data

%% Init workspace
clear; clc; tic;
% Load data from samples
load('DATA\TrainingData.mat');

numSpeakers = numel(names);

%% Concatenate samples for the same speakers
for nameCount = 1:numSpeakers
   
    samplesTemp = double.empty;
    
    for digitCount = 1:10 % 0:9 +1
        
        for sampleCount = 1:size(DATA,3)
            
            samplesTemp = [samplesTemp ; squeeze(DATA(nameCount, digitCount, sampleCount,:))];
            
        end
    end
    name = char(names(nameCount));
    eval(['samples' name ' = samplesTemp;']);
    
    % Make audioplayer object for all speakers
    eval(['player' name ' = audioplayer(samples' name ', Fs)']);
    
end


%% Feature extraction

for nameCount = 1:numSpeakers
    
    name = char(names(nameCount));
    eval(['samplesTemp = samples' name ';']);
        
    frameLength = 256;
    frameInterval = 100;
    
    frames = floor((numel(samplesTemp)-frameLength)/frameInterval);
    
    nc = 12; % no. of cepstral coeffs (apart from 0'th coef)
    
    p = floor(3*log(Fs)) ;
    
    voicebox_mfcc_dmfcc = melcepst(samplesTemp, Fs, 'M0dD',nc, p, frameLength, frameInterval);
    
    eval(['features' name ' = voicebox_mfcc_dmfcc;']);
    
end

%% Collect featureSpace
featureSpace = [
    featuresJacob;
%     featuresMose;
%     featuresSimon;
    featuresCamilla
    ];


%% Linear things

x = featureSpace;
x1 = featuresJacob;
x2 = featuresCamilla';

N1 = length(x1);
N2 = length(x2);

t(:,1) = [ones(N1,1) ; zeros(N2,1) ; ];
t(:,2) = [zeros(N1,1) ; ones(N2,1)];

% m_1 = mean(x1,2); M_1 = diag(m_1)*ones(size(x1));
% m_2 = mean(x2,2); M_2 = diag(m_2)*ones(size(x2));



% S_W = (x1-M_1)*(x1-M_1)'+(x2-M_2)*(x2-M_2)';

% w = inv(S_W)*(m_1-m_2);

x0 = 1;
x_ = [x ones(size(x,1),1)];

w = inv(x_'*x_)*x_'*t;

% w_ = [w0 w9];

y = w'*x_';


r = y / norm(w);

class = (y(1,:) > y(2,:))'

plot(class)








%% Fisher's linear discriminant










% %% Dimentionality reduction
% 
% 
% 
% %% Probabilistic methods
% %% Gaussian Mixture Models
% 
% nClasses = 2; %numel(names);
% 
% GMM = fitgmdist(featureSpace,nClasses)
% 
% idx = cluster(GMM,featureSpace);
% 
% cluster1 = (idx == 1);
% cluster2 = (idx == 2);
% cluster3 = (idx == 3);
% cluster4 = (idx == 4);
% clusterML = [cluster1 cluster2 cluster3 cluster4];
% 
% 
% %% Present result
% 
% plot(idx,'.')














%% End


toc