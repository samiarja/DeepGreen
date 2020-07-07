function meanInterpedUserInputArray = calculateMeanInterpedUserInputFromUserInputCellArray(userInputCellArray,varargin)
    %meanIntepredUserInputArray = calculateMeanInterpedUserInputFromUserInputCellArray(userInputCellArray,xMax,yMax,objectClassArray,meanMethod);
if isempty(userInputCellArray)    
    meanInterpedUserInputArray = [];
    return
end
[nFrame, nObj]                  = size(userInputCellArray{1});
if nObj == 0
    meanInterpedUserInputArray = [];
    return
end
nUser                           = numel(userInputCellArray);

userInputEqObjArray             = nan(nFrame,  nUser ,nObj);

meanInterpedUserInputArray      = nan(nFrame, nObj);
% check if the same number of objects are in each users input
nExistingObjectArray            = nan(1,nUser);
for iUser = 1:nUser
    userInputArray              = userInputCellArray{iUser};
    numObsPerObject             = sum(~isnan(userInputArray),1)';
    try
        nExistingObjectArray(iUser) = find(numObsPerObject>0,1,'last');
    catch
    end
end
if numel(unique(nExistingObjectArray))>1
    error('unequal number of objects per user input')
end
%%% xMax   %%% yMax  --------------------------------------------------------------------------------------------------------
if nargin<2 || isempty(varargin{1})
    xMax = 500; % excessively big image size to highlight the missing xMax input (without crashing old code)
else
    xMax = varargin{1};
end
if nargin<3 || isempty(varargin{2})
    yMax = 500; % excessively big image size to highlight the missing xMax input (without crashing old code)
else
    yMax = varargin{2};
end
%%% Check if each object's class was given else assume irregular clss for all -----------------------------------------
if nargin<4 || isempty(varargin{3})
    objectClassArray = -ones(1,nObj); % irregular objects are the default
else
    objectClassArray =  varargin{3};
    if iscell(objectClassArray)
        objectClassCellArray = objectClassArray;
        objectClassArray     = objectClassCellArray{1};
    end
end
%%% mean method --------------------------------------------------------------------------------------------------------
if nargin<5 || isempty(varargin{4})
    meanMethod = 'nanmedian';
else
    meanMethod = varargin{4};
end

% make matrix userInputEqObjArray from cell array
for iUser = 1:nUser
    aa = userInputCellArray{iUser};
    for iObj = 1:nObj
        userInputEqObjArray(:,iUser,iObj)   = aa(:,iObj);
    end
end

for iObj = 1:nObj
    if  objectClassArray(iObj) == -1  % irregular object: nanmean(linear interp )_over users
        tempInterpedUserInputIrregular  = nan(nFrame, nUser);
        for iUser = 1:nUser
            tempInterpedUserInputIrregular(:,iUser) = linearInterpolateUserInputData(userInputEqObjArray(:,iUser,iObj),xMax,yMax);   % done extrapolate
        end
        if strcmpi(meanMethod,'nanmean')
            meanInterpedUserInputArray(:,iObj) = nanmean(tempInterpedUserInputIrregular,2);
        elseif strcmpi(meanMethod,'mean')
            meanInterpedUserInputArray(:,iObj) = mean(tempInterpedUserInputIrregular,2);
        elseif strcmpi(meanMethod,'median')
            meanInterpedUserInputArray(:,iObj) = median(tempInterpedUserInputIrregular,2);
        elseif strcmpi(meanMethod,'nanmedian')
            meanInterpedUserInputArray(:,iObj) = nanmedian(tempInterpedUserInputIrregular,2);
        end
    elseif  objectClassArray(iObj) == 0 % object too fast: calculate a single mean point for the whole line and place it on all the frames where the obj has been labelled        
        sumOfNonNansAcrossUsersForThisObj = sum(isnan(userInputEqObjArray(:,:,iObj)),2);
        firstFastNonNanFrame = find(sumOfNonNansAcrossUsersForThisObj,1,'first');
        lastFastNonNanFrame  = find(sumOfNonNansAcrossUsersForThisObj,1,'last');
        if isempty(firstFastNonNanFrame) || isempty(lastFastNonNanFrame)       
            % object was not labeled anywhere. hmmm. ok ignore it.
        else
            meanInterpedUserInputArray(firstFastNonNanFrame:lastFastNonNanFrame,iObj)  = nanmean(mat2vec(userInputEqObjArray(:,:,iObj)));
        end
    elseif  objectClassArray(iObj) > 0% if first/second order polynomial
        meanInterpedUserInputArray(:,iObj)  = fitInterpolateMultiUserInputData(userInputEqObjArray(:,:,iObj),xMax,yMax,objectClassArray(iObj));
    end
end












