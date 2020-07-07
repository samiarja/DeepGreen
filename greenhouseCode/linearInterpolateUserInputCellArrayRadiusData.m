function interpedUserInputRadius = linearInterpolateUserInputCellArrayRadiusData(userInputRadiusArray,varargin)

if isempty(userInputRadiusArray)
    interpedUserInputRadius =userInputRadiusArray;
    return
end
nFrame           = size(userInputRadiusArray);
xObs             = real(userInputRadiusArray);

lastFrameWithObj = find(sum(isnan(xObs),2)>0,1,'last');
nObj = find(sum(isnan(xObs),1)>0,1,'last');
if isempty(nObj)
    interpedUserInputRadius =userInputRadiusArray;
    return
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

for iObj=1:nObj
    iObs = 0;
    xUserInputNoNanR = [];
    yUserInputNoNanR = [];
    iFrameNoNanR     = [];
    for iFrame = 1:nFrame
        
        if ~isnan(userInputRadiusArray(iFrame,iObj))
            iObs = iObs +1;
            xUserInputNoNanR(iObs,1) = real(userInputRadiusArray(iFrame,iObj));
            iFrameNoNanR(iObs,1)     = iFrame;
        end
    end
    % figure(42432)
    % stairs(iFrameNoNan)
    if numel(xUserInputNoNanR)<2 % beacuse interp throws an error if asked to interp 1 element array or empty array
        xinterpedUserInputRadius(:,iObj) = real(userInputRadiusArray(:,iObj));
    else
        xinterpedUserInputRadius(:,iObj) = interp1(iFrameNoNanR,xUserInputNoNanR,1:nFrame,'linear','extrap');
    end
   
end

try
    outofBoundIndexArray = (xinterpedUserInputRadius<1 | xinterpedUserInputRadius>xMax);
    xinterpedUserInputRadius(outofBoundIndexArray) = nan;
    
    xinterpedUserInputRadius(outofBoundIndexArray) = nan;
catch
    error
end

interpedUserInputRadius = xinterpedUserInputRadius;

SHOW_INTERP_PLOT = 0;
if SHOW_INTERP_PLOT
    lineWidthVal = 1;
    figure
   % clf;
    subplot(2,1,1); hold on;
    plot(xObs,'o')
    stairs(xInterpedUserInputArray,'-','lineWidth',lineWidthVal)
    grid on;
    xlim([0 lastFrameWithObj+1])
    subplot(2,1,2); hold on;
    plot(yObs,'o')
    stairs(yInterpedUserInputArray,'-','lineWidth',lineWidthVal)
    grid on;
    xlim([0 lastFrameWithObj+1])
end