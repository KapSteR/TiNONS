%% Feature Extraction Training

%% Init workspace
clear; clc; tic;
% Load data from samples
load('DATA\TrainingData.mat');

numSpeakers = numel(names);

melCepOptions = 'M0dD'; %HUSK AT GGENTAGE FOR TEST DATA ! ! !        
frameLength = 256;
frameInterval = 100;

startDigits = 0;
numDigits = 10;%HUSK AT GGENTAGE FOR TEST DATA ! ! !  

%% Concatenate samples for the same speakers
for nameCount = 1:numSpeakers
   
    samplesTemp = double.empty;
    
    for digitCount = startDigits+1:startDigits+numDigits
        
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

featureSpace = double.empty;

for nameCount = 1:numSpeakers
    
    name = char(names(nameCount));
    eval(['samplesTemp = samples' name ';']);
    
    frames = floor((numel(samplesTemp)-frameLength)/frameInterval);
    
    nc = 12; % no. of cepstral coeffs (apart from 0'th coef)
    
    p = floor(3*log(Fs)) ;
    
    voicebox_mfcc_dmfcc = melcepst(samplesTemp, Fs, melCepOptions, nc, p, frameLength, frameInterval);
    
    featureSpace = [
        featureSpace ;
        voicebox_mfcc_dmfcc
        ];
%     eval(['features' name ' = voicebox_mfcc_dmfcc;']);
    eval(['N' num2str(nameCount) ' = size(voicebox_mfcc_dmfcc,1);']);
end

%% Collect training featureSpace
% featureSpace = [
%     featuresJacob;
%     featuresMose;
%     featuresSimon%;
% %     featuresCamilla
%     ];

%%

% for i = 1:numel(names)
%    
%     eval(['N' num2str(i) ' = size(features' char(names(i)) ',1);']);
%       
% end

% t(:,1) = [ones(N1,1) ; zeros(N2+N3+N4,1)];
% t(:,2) = [zeros(N1,1) ; ones(N2,1); zeros(N3+N4,1)];
% t(:,3) = [zeros(N1+N2,1) ; ones(N3,1); zeros(N4,1)];
% t(:,4) = [zeros(N1+N2+N3,1) ; ones(N4,1)];

% x_train = [featureSpace ones(N1+N2+N3+N4,1)];

t(:,1) = [ones(N1,1) ; zeros(N2+N3,1)];
t(:,2) = [zeros(N1,1) ; ones(N2,1); zeros(N3,1)];
t(:,3) = [zeros(N1+N2,1) ; ones(N3,1)];

x_train = [featureSpace ones(N1+N2+N3,1)];

N = size(x_train,1);

% Save Training data
% save('DATA\TrainingSet.mat', 'x_train', 't', 'names', 'N1', 'N2', 'N3', 'N4', 'N')
save('DATA\TrainingSet.mat', 'x_train', 't', 'names', 'N1', 'N2', 'N3', 'N')
toc

%% Prepare for test data
tic
clear
% Load data from samples
load('DATA\TestData.mat');

numSpeakers = numel(names);
startDigits = 0;
numDigits = 10; %HUSK AT GGENTAGE FOR TRAIN DATA ! ! !

melCepOptions = 'M0dD'; %HUSK AT GGENTAGE FOR TRAIN DATA ! ! !
frameLength = 256;
frameInterval = 100;

%% Concatenate samples for the same speakers
for nameCount = 1:numSpeakers
   
    samplesTemp = double.empty;
    
    for digitCount = startDigits+1:startDigits+numDigits
        
        for sampleCount = 1:size(DATA,3)
            
            samplesTemp = [samplesTemp ; squeeze(DATA(nameCount, digitCount, sampleCount,:))];
            
        end
    end
    name = char(names(nameCount));
    eval(['samples' name ' = samplesTemp;']);
    
    % Make audioplayer object for all speakers
%     eval(['player' name ' = audioplayer(samples' name ', Fs)']);
%     figure(1)
%     plot(linspace(0,numel(samplesTemp)/Fs,numel(samplesTemp)),samplesTemp)
%     pause
end


%% Feature extraction

testSpace = double.empty;

for nameCount = 1:numSpeakers
    
    name = char(names(nameCount));
    eval(['samplesTemp = samples' name ';']);
        
 
    frames = floor((numel(samplesTemp)-frameLength)/frameInterval);
    
    nc = 12; % no. of cepstral coeffs (apart from 0'th coef)
    
    p = floor(3*log(Fs)) ;
    
    voicebox_mfcc_dmfcc = melcepst(samplesTemp, Fs, melCepOptions, nc, p, frameLength, frameInterval);
    
    testSpace = [
        testSpace ;
        voicebox_mfcc_dmfcc
        ];
    
%     eval(['test' name ' = voicebox_mfcc_dmfcc;']);
    eval(['Nt' num2str(nameCount) ' = size(voicebox_mfcc_dmfcc,1);']);

end

%% Collect training featureSpace
% testSpace = [
%     testJacob;
%     testMose;
%     testSimon%;
% %     testCamilla
%     ];

%%
% 
% for i = 1:numel(names)
%    
%     eval(['Nt' num2str(i) ' = size(test' char(names(i)) ',1);']);
%       
% end

% t_test(:,1) = [ones(Nt1,1) ; zeros(Nt2+Nt3+Nt4,1)];
% t_test(:,2) = [zeros(Nt1,1) ; ones(Nt2,1); zeros(Nt3+Nt4,1)];
% t_test(:,3) = [zeros(Nt1+Nt2,1) ; ones(Nt3,1); zeros(Nt4,1)];
% t_test(:,4) = [zeros(Nt1+Nt2+Nt3,1) ; ones(Nt4,1)];
% 
% x_test = [testSpace ones(Nt1+Nt2+Nt3+Nt4,1)];

t_test(:,1) = [ones(Nt1,1) ; zeros(Nt2+Nt3,1)];
t_test(:,2) = [zeros(Nt1,1) ; ones(Nt2,1); zeros(Nt3,1)];
t_test(:,3) = [zeros(Nt1+Nt2,1) ; ones(Nt3,1)];

x_test = [testSpace ones(Nt1+Nt2+Nt3,1)];

Nt = size(x_test,1);

% Save Training data
% save('DATA\TestSet.mat', 'x_test', 't_test', 'Nt1', 'Nt2', 'Nt3', 'Nt4', 'Nt')
save('DATA\TestSet.mat', 'x_test', 't_test', 'Nt1', 'Nt2', 'Nt3', 'Nt')
toc














