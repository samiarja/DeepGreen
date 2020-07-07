function [sortedUserInputArray,sortedUserInputArray2, varargout] = sortObjectsInUserInputData(userInputArray,userInputRadiusArray,varargin)
%nFrame           = size(userInputArray);
xObs             = real(userInputArray);
xObs2             = real(userInputRadiusArray);
% yObs             = imag(userInputArray);
% yObs(yObs==0)    = nan;
%lastFrameWithObj = find(sum(isnan(xObs),2)>0,1,'last');
numObjectsInFinishedArray = find(sum(isnan(xObs),1)>0,1,'last');

numObjectsInFinishedArray2 = find(sum(isnan(xObs2),1)>0,1,'last');

if nargin>2
    objectClassArray = varargin{1};
else
    objectClassArray = nan(1,numObjectsInFinishedArray);
end
%
% if nargin>1
%     objectClassArray = varargin{1};
% else
%     objectClassArray = nan(1,numObjectsInFinishedArray2);
% end

firstFrameWithObj    = nan(numObjectsInFinishedArray,1);
firstFrameWithObj2    = nan(numObjectsInFinishedArray2,1);

numOfEmptyObj = 0;
numOfEmptyObj2 = 0;

for iObject=1:numObjectsInFinishedArray
    
    try firstFrameWithObj(iObject) = find(~isnan(xObs(:,iObject)),1,'first');
    catch
        firstFrameWithObj(iObject) = inf;
        numOfEmptyObj = numOfEmptyObj + 1;
    end
    
end

for iObject2=1:numObjectsInFinishedArray2
    
    try firstFrameWithObj2(iObject2) = find(~isnan(xObs(:,iObject2)),1,'first');
    catch
        firstFrameWithObj2(iObject2) = inf;
        numOfEmptyObj2 = numOfEmptyObj2 + 1;
    end
    
end


[~,orderedObjectIndeces] = sort(firstFrameWithObj);
sortedUserInputArray     = userInputArray(:,orderedObjectIndeces(1:end-numOfEmptyObj));
if nargout>2
    varargout{1}         = objectClassArray;
end

[~,orderedObjectIndeces2] = sort(firstFrameWithObj2);
sortedUserInputArray2     = userInputRadiusArray(:,orderedObjectIndeces2(1:end-numOfEmptyObj2));
if nargout>2
    varargout{1}         = objectClassArray;
end
