%%  Import test Data
%   Imports required amount of samples and outputs to .mat-file

% Clear workspace and set up timer
clear; clc
tic

%% Initialize

names = [
%     'Camilla';
    'Jacob  ';
    'Mose   ';
    'Simon  '
    ];

names = cellstr(names);

testSetStart = 28;
testSetEnd = testSetStart+5;

startDigits = 0;
numDigits = 10;

dataPath = 'DATA\DataFiles\';

outputPath = 'DATA\';
outputName = 'TestData';

%% Import data to MATLAB
for nameCount = 1:numel(names)
    
    nameString = char(names(nameCount));
    
    for digitCount = startDigits:startDigits+numDigits-1
        
        samplePath = [dataPath nameString '\' num2str(digitCount)];       
        
        for sampleCount = testSetStart:testSetEnd
            
            sampleName = [nameString '_' num2str(digitCount) '_' ...
                num2str(sampleCount) '.wav'];           
            
            [x, Fs] = audioread([samplePath '\' sampleName]);
            
            x = x(0.4*Fs:end-0.4*Fs);       % Remove first and last 400 ms
            x = x - mean(x);                % Remove mean
            x = sqrt(length(x))*x/norm(x);  % Whitening of sound
            x = x+eps;                      % Avoid numerical problems
            
            DATA(nameCount, digitCount+1, sampleCount-testSetStart+1,:) = x;
            
        end        
    end    
end

%% Save output and stop timer

save([outputPath outputName],'DATA','Fs','names');
toc