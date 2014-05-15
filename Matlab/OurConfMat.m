function [ confMatrix ] = OurConfMat( target, output )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[C] = confusionmat(output, target);

D =  size(C,1);

confMatrix = zeros(D+1);
confMatrix(1:end-1,1:end-1) = C;

correct = diag(C);

for i = 1:D
    
    confMatrix(i,end) = correct(i)/sum(C(i,:));
    confMatrix(end,i) = correct(i)/sum(C(:,i));
    
end

confMatrix(end,end) = sum(correct)/sum(C(:));

return

end

