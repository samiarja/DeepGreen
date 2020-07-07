function interpedMultiUserInputArray = fitInterpolateMultiUserInputData(multiUserSingleObjectInputArray,varargin)
if isempty(multiUserSingleObjectInputArray)
    interpedMultiUserInputArray =multiUserSingleObjectInputArray;
    return
end


%%% xMax   %%% yMax  --------------------------------------------------------------------------------------------------------
if nargin<3 || isempty(varargin{1})
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

if nargin==2  % if just two inputs then second input is objectClassArray (this disgusting hack is for backward compatibility)
    objectClassArray = varargin{1};
    if isempty(objectClassArray)
        objectClassArray = -ones(1,nObj);
    elseif iscell(objectClassArray)
            objectClassCellArray = objectClassArray;
            objectClassArray     = objectClassCellArray{1};
    end
end
[nFrame ,nUser]              = size(multiUserSingleObjectInputArray);
xObs                         = real(multiUserSingleObjectInputArray);
yObs                         = -real(multiUserSingleObjectInputArray*1i);
xInterpedMultiUserInputArray = nan+multiUserSingleObjectInputArray;
yInterpedMultiUserInputArray = nan+multiUserSingleObjectInputArray;

lastFrameWithObj = find(sum(isnan(xObs),2)>0,1,'last');


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
    yTempValues                        = imag(multiUserSingleObjectInputArray(:,iUser));
    yTempValues(yTempValues==0)        = nan;
    yInterpedMultiUserInputArray = yTempValues;
elseif numel(xUserInputNoNan)<4
    xInterpedMultiUserInputArray = interp1(iFrameNoNan,xUserInputNoNan,1:nFrame,'linear','extrap');% extrapolate
    yInterpedMultiUserInputArray = interp1(iFrameNoNan,yUserInputNoNan,1:nFrame,'linear','extrap');
else
    if objectClassArray==1
        xCurveFitObject = fit(iFrameNoNan,xUserInputNoNan,'poly1'); % extrapolate
        yCurveFitObject = fit(iFrameNoNan,yUserInputNoNan,'poly1');
    elseif objectClassArray==2
        xCurveFitObject = fit(iFrameNoNan,xUserInputNoNan,'poly2');% extrapolate
        yCurveFitObject = fit(iFrameNoNan,yUserInputNoNan,'poly2');
    end
    xInterpedMultiUserInputArray  = xCurveFitObject(1:nFrame);
    yInterpedMultiUserInputArray  = yCurveFitObject(1:nFrame);
end
try
    outOfBoundIndexArray = (xInterpedMultiUserInputArray<1 | yInterpedMultiUserInputArray<1 | xInterpedMultiUserInputArray>xMax | yInterpedMultiUserInputArray>yMax);
catch
end
xInterpedMultiUserInputArray(outOfBoundIndexArray) = nan;
yInterpedMultiUserInputArray(outOfBoundIndexArray) = nan;
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