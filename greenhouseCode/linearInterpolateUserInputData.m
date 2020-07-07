function interpedUserInputArray = linearInterpolateUserInputData(userInputArray,varargin)
if isempty(userInputArray)
    interpedUserInputArray =userInputArray;
    return
end
nFrame           = size(userInputArray);
xObs             = real(userInputArray);
yObs             = -real(userInputArray*1i);

lastFrameWithObj = find(sum(isnan(xObs),2)>0,1,'last');
nObj = find(sum(isnan(xObs),1)>0,1,'last');
if isempty(nObj)
    interpedUserInputArray =userInputArray;
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
    xUserInputNoNan = [];
    yUserInputNoNan = [];
    iFrameNoNan     = [];
    for iFrame = 1:nFrame
        
        if ~isnan(userInputArray(iFrame,iObj))
            iObs = iObs +1;
            xUserInputNoNan(iObs,1) = real(userInputArray(iFrame,iObj));
            yUserInputNoNan(iObs,1) = imag(userInputArray(iFrame,iObj));
            iFrameNoNan(iObs,1)     = iFrame;
        end
    end
    % figure(42432)
    % stairs(iFrameNoNan)
    if numel(xUserInputNoNan)<2 % beacuse interp throws an error if asked to interp 1 element array or empty array
        xInterpedUserInputArray(:,iObj) = real(userInputArray(:,iObj));
        yTempValues                        = -real(userInputArray(:,iObj)*1i);
        
        yInterpedUserInputArray(:,iObj) = yTempValues;
    else
        xInterpedUserInputArray(:,iObj) = interp1(iFrameNoNan,xUserInputNoNan,1:nFrame,'linear','extrap');
        yInterpedUserInputArray(:,iObj) = interp1(iFrameNoNan,yUserInputNoNan,1:nFrame,'linear');
    end
   
end

try
    outofBoundIndexArray = (xInterpedUserInputArray<1 |yInterpedUserInputArray<1 | xInterpedUserInputArray>xMax | yInterpedUserInputArray>yMax);
    xInterpedUserInputArray(outofBoundIndexArray) = nan;
    yInterpedUserInputArray(outofBoundIndexArray) = nan;
    
    xInterpedUserInputArray(outofBoundIndexArray) = nan;
    yInterpedUserInputArray(outofBoundIndexArray) = nan;
catch
    error
end

interpedUserInputArray = xInterpedUserInputArray + 1i*yInterpedUserInputArray;

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