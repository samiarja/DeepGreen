function [meanInterpedUserInputArray,varargout] = calculateNanMeanInterpedUserInputFromUserInputCellArray(userInputCellArray,varargin)

nUser                           = numel(userInputCellArray);
[nFrame, nObj]                  = size(userInputCellArray{1});
userInputEqObjArray             = nan(nFrame,  nUser ,nObj);
%interpedUserInputArray          = nan(nFrame, nObj, nUser);
tempInterpedUserInput           = nan(nFrame, nUser);
meanInterpedUserInputArray      = nan(nFrame, nObj);
% check if the same number of objects are in each users input
nExistingObjectArray            = nan(1,nUser);
for iUser = 1:nUser
    userInputArray              = userInputCellArray{iUser};
    numObsPerObject             = sum(~isnan(userInputArray),1)';
    try
        nExistingObjectArray(iUser) = find(numObsPerObject>0,1,'last');
    catch
        nExistingObjectArray(iUser) = 0;
    end
end
if numel(unique(nExistingObjectArray))>1
    error('unequal number of objects per user input')
end
% Check if each object's class was given else assume irregular shape
if nargin>1
    objectPolyFitOrderArray = varargin{1};
    if numel(objectPolyFitOrderArray) == 1
        objectPolyFitOrderArray = zeros(1,nObj) + objectPolyFitOrderArray;
    end
else
    objectPolyFitOrderArray = -ones(1,nObj); % irregular objects are the default
end
% make the interpedUserInputEqObjArray
for iUser = 1:nUser
    userInputEqObjArray(:,iUser,:)         = userInputCellArray{iUser};
    %interpedUserInputEqObjArray(:,:,iUser) = interpedUserInputCellArray{iUser};
end

for iObj = 1:nObj
    if objectPolyFitOrderArray(iObj) == -1  % irregular object
        for iUser = 1:nUser
            userInputArray              = userInputCellArray{iUser};
            tempInterpedUserInput (:,iUser) = linearInterpolateUserInputData(userInputArray(:,iObj)); 
        end
        meanInterpedUserInputArray(:,iObj) = nanmean(tempInterpedUserInput,2);
    else% if first order polynomial
        meanInterpedUserInputArray(:,iObj) = fitInterpolateMultiUserInputData(userInputEqObjArray(:,:,iObj),objectPolyFitOrderArray(iObj));
    end
end
