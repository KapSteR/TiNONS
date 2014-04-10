clear, close all
clc

[y, fs] = audioread('speech_dft.mp3');
y = y - mean(y);    %REMOVAL OF MEAN OF SOUND INPUT
y = sqrt(length(y)) * y / norm(y); % WHITENING OF SOUND INPUT
y = y + eps;    % To avoid numerical probs
nc = 12; % no. of cepstral coeffs (apart from 0'th coef)
n = 660; % length of frame
inc = 220; % increment = hop size (in number of samples)
p = floor(3*log(fs));
voicebox_mfcc_dmfcc = melcepst(y, fs, 'M0d',nc, p, n, inc);
mfcc = dct(voicebox_mfcc_dmfcc);
%Forstå melcepst bedre
for i=1:25
    subplot(5,5,i);
    plot(mfcc(:,i));
end
