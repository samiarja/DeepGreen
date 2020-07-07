function [interpedUserInputCellArray]= interpolateUserInputCellArray(userInputCellArray,xMax,yMax,varargin)
if isempty(userInputCellArray)
    interpedUserInputCellArray = userInputCellArray;
    return
end

nUser                = numel(userInputCellArray);
[nFrame, nObj]       = size(userInputCellArray{1});
if nargin<4 || isempty(varargin{1})
    objectClassArray = -ones(1,nObj); % default irregular object linear interp no extrap
else
    objectClassArray =  varargin{1};
    if iscell(objectClassArray)
        objectClassCellArray = objectClassArray;
        objectClassArray     = objectClassCellArray{1};
    end
end
interpedUserInputCellArray  = {};
for iUser = 1:nUser
    userInputArray         = userInputCellArray{iUser};
    interpedUserInputArray = userInputArray + nan;
    for iObj = 1:nObj
        try            
        thisObj = userInputArray(:,iObj);
        catch
            error('unequal number of objects from each user')
        end
        iFrameNoNan = find(~isnan(thisObj));
        xUserInputNoNan    = double(real(thisObj(iFrameNoNan)));
        yUserInputNoNan    = double(-real(thisObj(iFrameNoNan)*1i));
        if objectClassArray(iObj) == 0 % object too fast: calculate a single mean point for the whole line and place it on all the frames where the obj has been labelled
            xInterpedUserInputArray                                  = nan(nFrame,1);
            yInterpedUserInputArray                                  = nan(nFrame,1);
            xInterpedUserInputArray(iFrameNoNan(1):iFrameNoNan(end)) = mean(xUserInputNoNan);
            yInterpedUserInputArray(iFrameNoNan(1):iFrameNoNan(end)) = mean(yUserInputNoNan);
        else
            if numel(xUserInputNoNan)<2  % can't interp with 0 or 1 data point
                xInterpedUserInputArray  = real(userInputArray(:,iObj));
                yInterpedUserInputArray  = -real(userInputArray(:,iObj)*1i);
            elseif numel(xUserInputNoNan)<4  % fit don't work with less than 4
                if objectClassArray(iObj)     == 1 || objectClassArray(iObj)     == 2
                    xInterpedUserInputArray  = interp1(iFrameNoNan,xUserInputNoNan,1:nFrame,'linear','extrap'); % extrapolate
                    yInterpedUserInputArray  = interp1(iFrameNoNan,yUserInputNoNan,1:nFrame,'linear','extrap');
                elseif objectClassArray(iObj) == -1  % irregular object
                    xInterpedUserInputArray  = interp1(iFrameNoNan,xUserInputNoNan,1:nFrame,'linear');  % don't extrapolate
                    yInterpedUserInputArray  = interp1(iFrameNoNan,yUserInputNoNan,1:nFrame,'linear');
                end
            else
                if objectClassArray(iObj)     == 1
                    xCurveFitObject      = fit(iFrameNoNan,xUserInputNoNan,'poly1');  % extrapolate
                    yCurveFitObject      = fit(iFrameNoNan,yUserInputNoNan,'poly1');
                    xInterpedUserInputArray  = xCurveFitObject(1:nFrame);
                    yInterpedUserInputArray  = yCurveFitObject(1:nFrame);
                elseif objectClassArray(iObj) == 2   % curve
                    xCurveFitObject      = fit(iFrameNoNan,xUserInputNoNan,'poly2');  % extrapolate
                    yCurveFitObject      = fit(iFrameNoNan,yUserInputNoNan,'poly2');
                    xInterpedUserInputArray  = xCurveFitObject(1:nFrame);
                    yInterpedUserInputArray  = yCurveFitObject(1:nFrame);
                elseif objectClassArray(iObj) == -1  % irregular object
                    xInterpedUserInputArray  = interp1(iFrameNoNan,xUserInputNoNan,1:nFrame,'linear');  % don't extrapolate
                    yInterpedUserInputArray  = interp1(iFrameNoNan,yUserInputNoNan,1:nFrame,'linear');
                end
            end
        end
        try
            outofBoundIndexArray = find(xInterpedUserInputArray<1 | yInterpedUserInputArray<1 | xInterpedUserInputArray>xMax | yInterpedUserInputArray>yMax);
        catch
        end
        xInterpedUserInputArray(outofBoundIndexArray) = nan;
        yInterpedUserInputArray(outofBoundIndexArray) = nan;
        interpedUserInputArray(:,iObj)                = xInterpedUserInputArray + 1i*yInterpedUserInputArray;
    end
    interpedUserInputCellArray{iUser}   = interpedUserInputArray; %#ok<AGROW>
end

%nanMeanfigureNum = 34232;showMeanLinesIn3d(interpedUserInputCellArray,objectClassArray,[],'nanmean',nanMeanfigureNum);
% multiUserMultiObjectInputArray        = nan(nFrame,nUser,nObj);
% for iObj = 1:nObj
%     for iUser = 1:nUser
%         userInputArray                               = userInputCellArray{iUser};
%         multiUserMultiObjectInputArray(:,iUser,iObj) = userInputArray(:,iObj);
%     end
%     interpedUserInputArray = interpolateMultiUserSingleObjectInputArray(multiUserMultiObjectInputArray(:,:,iObj),objectClassArray(iObj));
% end


% interpedUserInputCellArray = {};
% for iUser = 1:nUser
%     interpedUserInputCellArray{iUser}         = linearInterpolateUserInputData(userInputCellArray{iUser});
% end