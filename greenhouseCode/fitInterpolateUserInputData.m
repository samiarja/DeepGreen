function interpedUserInputArray = fitInterpolateUserInputData(userInputArray,varargin)
if isempty(userInputArray)
    interpedUserInputArray =userInputArray;
    return
end
if nargin>1
    polyOrder = varargin{1};
end
nFrame           = size(userInputArray);
xObs             = real(userInputArray);
yObs             = imag(userInputArray);
xInterpedUserInputArray = nan+userInputArray;
yInterpedUserInputArray = nan+userInputArray;

yObs(yObs==0)    = nan;
lastFrameWithObj = find(sum(isnan(xObs),2)>0,1,'last');
nObj = find(sum(isnan(xObs),1)>0,1,'last');
xMax = max(xObs(:));
yMax = max(yObs(:));
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
        yTempValues                        = imag(userInputArray(:,iObj));
        yTempValues(yTempValues==0)        = nan;
        yInterpedUserInputArray(:,iObj) = yTempValues;
    elseif numel(xUserInputNoNan)<4 
        xInterpedUserInputArray(:,iObj) = interp1(iFrameNoNan,xUserInputNoNan,1:nFrame,'linear');
        yInterpedUserInputArray(:,iObj) = interp1(iFrameNoNan,yUserInputNoNan,1:nFrame,'linear');
    else
        xCurveFitObject = fit(iFrameNoNan,xUserInputNoNan,'poly1');
        yCurveFitObject = fit(iFrameNoNan,yUserInputNoNan,'poly1');
        
        xInterpedUserInputArray(:,iObj)  = xCurveFitObject(1:nFrame);
        yInterpedUserInputArray(:,iObj)  = yCurveFitObject(1:nFrame);
        
      
    end
   
end

outofBoundIndexArray = (xInterpedUserInputArray<1 | yInterpedUserInputArray<1 | xInterpedUserInputArray>xMax | yInterpedUserInputArray>yMax);
xInterpedUserInputArray(outofBoundIndexArray) = nan;
yInterpedUserInputArray(outofBoundIndexArray) = nan;

xInterpedUserInputArray(outofBoundIndexArray) = nan;
yInterpedUserInputArray(outofBoundIndexArray) = nan;

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