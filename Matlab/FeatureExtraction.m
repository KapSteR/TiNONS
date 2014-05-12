%% Feature Extraction Training

%% Init workspace
clear; clc; tic;
% Load data from samples
load('DATA\TrainingData.mat');

numSpeakers = numel(names);

melCepOptions = 'MdD';

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
%     eval(['player' name ' = audioplayer(samples' name ', Fs)']);
    
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
    
    voicebox_mfcc_dmfcc = melcepst(samplesTemp, Fs, melCepOptions, nc, p, frameLength, frameInterval);
    
    eval(['features' name ' = voicebox_mfcc_dmfcc;']);
    
end

%% Collect training featureSpace
featureSpace = [
    featuresJacob;
    featuresMose;
    featuresSimon;
    featuresCamilla
    ];

%%

for i = 1:numel(names)
   
    eval(['N' num2str(i) ' = size(features' char(names(i)) ',1);']);
      
end

t(:,1) = [ones(N1,1) ; zeros(N2+N3+N4,1)];
t(:,2) = [zeros(N1,1) ; ones(N2,1); zeros(N3+N4,1)];
t(:,3) = [zeros(N1+N2,1) ; ones(N3,1); zeros(N4,1)];
t(:,4) = [zeros(N1+N2+N3,1) ; ones(N4,1)];

x_train = [featureSpace ones(N1+N2+N3+N4,1)];
N = size(x_train,1);

% Save Training data
save('DATA\TrainingSet.mat', 'x_train', 't', 'names', 'N1', 'N2', 'N3', 'N4', 'N')

toc

%% Prepare for test data
tic
% Load data from samples
load('DATA\TestData.mat');

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
%     eval(['player' name ' = audioplayer(samples' name ', Fs)']);
    
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
    
    voicebox_mfcc_dmfcc = melcepst(samplesTemp, Fs, melCepOptions, nc, p, frameLength, frameInterval);
    
    eval(['test' name ' = voicebox_mfcc_dmfcc;']);
    
end

%% Collect training featureSpace
testSpace = [
    testJacob;
    testMose;
    testSimon;
    testCamilla
    ];

%%

for i = 1:numel(names)
   
    eval(['Nt' num2str(i) ' = size(test' char(names(i)) ',1);']);
      
end

t_test(:,1) = [ones(Nt1,1) ; zeros(Nt2+Nt3+Nt4,1)];
t_test(:,2) = [zeros(Nt1,1) ; ones(Nt2,1); zeros(Nt3+Nt4,1)];
t_test(:,3) = [zeros(Nt1+Nt2,1) ; ones(Nt3,1); zeros(Nt4,1)];
t_test(:,4) = [zeros(Nt1+Nt2+Nt3,1) ; ones(Nt4,1)];

x_test = [testSpace ones(Nt1+Nt2+Nt3+Nt4,1)];

Nt = size(x_test,1);

% Save Training data
save('DATA\TestSet.mat', 'x_test', 't_test', 'Nt1', 'Nt2', 'Nt3', 'Nt4', 'Nt')

toc














