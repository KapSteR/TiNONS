%%  Import test Data
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

trainingSetEnd = 5;

dataPath = 'DATA\DataFiles\';

outputPath = 'DATA\';
outputName = 'TestData';

%% Import data to MATLAB
for nameCount = 1:numel(names)
    
    nameString = char(names(nameCount));
    
    for digitCount = 0:9
        
        samplePath = [dataPath nameString '\' num2str(digitCount)];       
        
        for sampleCount = 4:trainingSetEnd
            
            sampleName = [nameString '_' num2str(digitCount) '_' ...
                num2str(sampleCount) '.wav'];           
            
            [x, Fs] = audioread([samplePath '\' sampleName]);
            DATA(nameCount, digitCount+1, sampleCount,:) = x;
            
        end        
    end    
end

%% Save output and stop timer

save([outputPath outputName],'DATA','Fs','names');
toc