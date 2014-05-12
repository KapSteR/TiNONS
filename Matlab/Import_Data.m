%%  Import Data
%   Imports required amount of samples and outputs to .mat-file

% Clear workspace and set up timer
clear; clc
tic

%% Initialize

names = [
    'Camilla';
    'Jacob  ';
    'Mose   ';
    'Simon  '
    ];

names = cellstr(names);

trainingSetSize = 3;

dataPath = 'DATA\DataFiles\';

outputPath = 'DATA\';
outputName = 'TrainingData';

%% Import data to MATLAB
for nameCount = 1:numel(names)
    
    nameString = char(names(nameCount));
    
    for digitCount = 0:9
        
        samplePath = [dataPath nameString '\' num2str(digitCount)];       
        
        for sampleCount = 1:trainingSetSize
            
            sampleName = [nameString '_' num2str(digitCount) '_' ...
                num2str(sampleCount) '.wav'];           
            
            [x, Fs] = audioread([samplePath '\' sampleName]);
            
            x = x(0.01*Fs:end);             % Remove first 10 ms
            x = x - mean(x);                % Remove mean
            x = sqrt(length(x))*x/norm(x);  % Whitening of sound
            x = x+eps;                      % Avoid numerical problems
            
            DATA(nameCount, digitCount+1, sampleCount,:) = x;
            
        end        
    end    
end

%% Save output and stop timer

save([outputPath outputName],'DATA','Fs','names');
toc