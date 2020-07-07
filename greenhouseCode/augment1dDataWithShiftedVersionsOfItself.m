function shiftAugmentedX = augment1dDataWithShiftedVersionsOfItself(X,shiftAmounts)
% %%% augment1dDataWithShiftedVersionsOfItself
%%%%%%--Example Input--------------------------
% %%%  ch1 ch2
% X = [1   7      % obs #1
%      0   7      % obs #2 ...
%      1   3      
%      2   3 
%      3   0 
%      9   0]
% 
%  shiftAmounts = [0 2 3]
%%%%%%---Correct Output--------------------------
%  %%% ch1 ch2   ch1' ch2'    ch1'' ch2''    
%  Xo=[1   7      1   3         2   3
%      0   7      2   3         3   0
%      1   3      3   0         9   0
%      2   3      9   0         1   7
%      3   0      1   7         0   7
%      9   0      0   7         1   3]

[numObservations, numRawInputChannels]= size(X);
shiftAugmentedX = nan(numObservations, numRawInputChannels*numel(shiftAmounts));
for shiftIndex = 1:numel(shiftAmounts)
    shiftAmount = shiftAmounts(shiftIndex);    
    shiftAugmentedX(:,((shiftIndex-1)*numRawInputChannels+1):(shiftIndex*numRawInputChannels)) = circshift(X,[shiftAmount 0]);
end
