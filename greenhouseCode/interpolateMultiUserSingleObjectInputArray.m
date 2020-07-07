function interpedMultiUserInputArray = interpolateMultiUserSingleObjectInputArray(multiUserSingleObjectInputArray,varargin)
if isempty(multiUserSingleObjectInputArray)
    interpedMultiUserInputArray =multiUserSingleObjectInputArray;
    return
end
[nFrame ,nUser]              = size(multiUserSingleObjectInputArray);
if nargin<2  || isempty(varargin{1})
    objectClassArray = -ones(1,nUser);
else
    objectClassArray = varargin{1};
end
xObs                         = real(multiUserSingleObjectInputArray);
yObs                         = -real(multiUserSingleObjectInputArray*1i);
xInterpedMultiUserInputArray = nan+multiUserSingleObjectInputArray;
yInterpedMultiUserInputArray = nan+multiUserSingleObjectInputArray;

lastFrameWithObj = find(sum(isnan(xObs),2)>0,1,'last');
if nargin<3 || isempty(varargin{2})
    xMax = max(xObs(:));
else
    
    xMax = varargin{2};
end
if nargin<4 || isempty(varargin{3})
    yMax = max(yObs(:));
else
    yMax = varargin{3};
end

xUserInputNoNan = [];
yUserInputNoNan = [];
iFrameNoNan     = [];
for iUser=1:nUser
    iObs = 0;
    for iFrame = 1:nFrame
        if ~isnan(multiUserSingleObjectInputArray(iFrame,iUser))
            iObs = iObs +1;
            xUserInputNoNan(iObs,1) = real(multiUserSingleObjectInputArray(iFrame,iUser));
            yUserInputNoNan(iObs,1) = imag(multiUserSingleObjectInputArray(iFrame,iUser));
            iFrameNoNan(iObs,1)     = iFrame;
        end
    end
end
if numel(xUserInputNoNan)<2 % beacuse interp throws an error if asked to interp 1 element array or empty array
    xInterpedMultiUserInputArray = real(multiUserSingleObjectInputArray(:,iUser));
    yInterpedMultiUserInputArray = -real(multiUserSingleObjectInputArray(:,iUser)*1i);
elseif numel(xUserInputNoNan)<4
    xInterpedMultiUserInputArray = interp1(iFrameNoNan,xUserInputNoNan,1:nFrame,'linear');
    yInterpedMultiUserInputArray = interp1(iFrameNoNan,yUserInputNoNan,1:nFrame,'linear');
else
    if objectClassArray==1
        xCurveFitObject = fit(iFrameNoNan,xUserInputNoNan,'poly1');
        yCurveFitObject = fit(iFrameNoNan,yUserInputNoNan,'poly1');
    elseif objectClassArray==2
        xCurveFitObject = fit(iFrameNoNan,xUserInputNoNan,'poly2');
        yCurveFitObject = fit(iFrameNoNan,yUserInputNoNan,'poly2');
    end
    xInterpedMultiUserInputArray  = xCurveFitObject(1:nFrame);
    yInterpedMultiUserInputArray  = yCurveFitObject(1:nFrame);
end
outofBoundIndexArray = (xInterpedMultiUserInputArray<1 | yInterpedMultiUserInputArray<1 | xInterpedMultiUserInputArray>xMax | yInterpedMultiUserInputArray>yMax);
xInterpedMultiUserInputArray(outofBoundIndexArray) = nan;
yInterpedMultiUserInputArray(outofBoundIndexArray) = nan;
interpedMultiUserInputArray = xInterpedMultiUserInputArray + 1i*yInterpedMultiUserInputArray;

SHOW_INTERP_PLOT = 0;
if SHOW_INTERP_PLOT
    lineWidthVal = 1;
    figure
   % clf;
    subplot(2,1,1); hold on;
    plot(xObs,'o')
    stairs(xInterpedMultiUserInputArray,'-','lineWidth',lineWidthVal)
    grid on;
    xlim([0 lastFrameWithObj+1])
    subplot(2,1,2); hold on;
    plot(yObs,'o')
    stairs(yInterpedMultiUserInputArray,'-','lineWidth',lineWidthVal)
    grid on;
    xlim([0 lastFrameWithObj+1])
end