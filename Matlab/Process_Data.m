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



%% Create model




%% End
toc