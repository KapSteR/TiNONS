clear; clc

load('DATA\TrainingData.mat');


for nameCount = 1:numel(names)
    
    samplesTemp = double.empty;
    
    for digitCount = 1:10 % 0:9 +1
        
        for sampleCount = 1:size(DATA,3)
            
            samplesTemp = [samplesTemp ; squeeze(DATA(nameCount, digitCount, sampleCount,:))];
            
        end
    end
    name = char(names(nameCount));
    eval(['samples' name ' = samplesTemp;']);
    
    eval(['player' name ' = audioplayer(samples' name ', Fs)']);
    
end


%%


samplesTemp = samplesJacob;


frameLength = 256;
frameInterval = 100;

frames = floor((numel(samplesTemp)-frameLength)/frameInterval);

window = hamming(frameLength);

nc = 12; % no. of cepstral coeffs (apart from 0'th coef)

p = floor(3*log(Fs)) ;
 
voicebox_mfcc_dmfcc = melcepst(samplesTemp, Fs, 'M0dD',nc, p, frameLength, frameInterval);

% for frameCount = 0:frames-1
%     
%     % Extract one frame
%     samples = samplesTemp((frameCount*frameInterval)+1:(frameCount*frameInterval)+frameLength);
%     
%     % Remove mean and window
%     samples = samples-mean(samples);
%     samples = samples.*window;
%     
%     y = samples;
%     
%     y = sqrt(length(y)) * y / norm(y); % WHITENING OF SOUND INPUT
%     y = y + eps;    % To avoid numerical probs
%     nc = 12; % no. of cepstral coeffs (apart from 0'th coef)
%     n = 660; % length of frame
%     inc = 220; % increment = hop size (in number of samples)
%     p = floor(3*log(Fs)) ;
%     voicebox_mfcc_dmfcc = melcepst(y, Fs, 'M0d',nc, p, n, inc);
%     
% end







