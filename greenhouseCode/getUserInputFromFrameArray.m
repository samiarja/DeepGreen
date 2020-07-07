function [userInputArray,userInputRadiusArray,varargout] = getUserInputFromFrameArray(timeSurfaceArray,surfaceSamplingTimeArray,surfaceSamplingIndexArray,varargin)

maxNumObjects  =500;
if nargin <4 || isempty(varargin{1})
    tau                                = 1000;    %  default time or index window in in us or events
    surfaceSampleInterval              = tau; %in micro-secs
    versionNum                         = 0; % default
    SURFACE_DECAY_REGIME_STRING        = 'Time'; %{'Time', 'Index'};
    DECAY_FUNCTION_STRING              = 'Exp';   %{'Bin','Lin','Exp'};
    SURFACE_SAMPLING_REGIME_STRING     = 'Time';  %{'Time', 'Index'};
    viewArray                          = [0,90]; % default
    SHOW_TIME_STAMP_PLOT = 0; % default
    SHOW_MEMORY_SURFACES_ONLINE = 0; % default
    RECORD_VIDEO = 0; % default
else
    UserInputGettingParameters =     varargin{1};
    if isfield(UserInputGettingParameters,'tau')
        tau                            = UserInputGettingParameters.tau;% in us or events'
    else
        tau                            = 1000;    % default value in micro-secs
    end
    if isfield(UserInputGettingParameters,'surfaceSampleInterval')
        surfaceSampleInterval          = UserInputGettingParameters.surfaceSampleInterval;% in us
    else
        surfaceSampleInterval          = tau;      %  default time or index window in in us or events
    end
    if isfield(UserInputGettingParameters,'SURFACE_DECAY_REGIME_STRING')
        SURFACE_DECAY_REGIME_STRING    = UserInputGettingParameters.SURFACE_DECAY_REGIME_STRING;
    else
        SURFACE_DECAY_REGIME_STRING    = 'Time';%  default time
    end
    if isfield(UserInputGettingParameters,'DECAY_FUNCTION_STRING')
        DECAY_FUNCTION_STRING          = UserInputGettingParameters.DECAY_FUNCTION_STRING;
    else
        DECAY_FUNCTION_STRING          = {'Exp'};% default %{'Bin','Lin','Exp'};
    end
    if isfield(UserInputGettingParameters,'DECAY_FUNCTION_STRING')
        SURFACE_SAMPLING_REGIME_STRING = UserInputGettingParameters.SURFACE_SAMPLING_REGIME_STRING;
    else
        SURFACE_SAMPLING_REGIME_STRING = {'Time'};%{'Time', 'Index'};
    end
    if isfield(UserInputGettingParameters,'viewArray')
        viewArray = UserInputGettingParameters.viewArray;
    else
        viewArray = [0,90]; % default
    end
    if isfield(UserInputGettingParameters,'SHOW_TIME_STAMP_PLOT')
        SHOW_TIME_STAMP_PLOT = UserInputGettingParameters.SHOW_TIME_STAMP_PLOT;
    else
        SHOW_TIME_STAMP_PLOT = 0; % default
    end
    if isfield(UserInputGettingParameters,'SHOW_MEMORY_SURFACES_ONLINE')
        SHOW_MEMORY_SURFACES_ONLINE = UserInputGettingParameters.SHOW_MEMORY_SURFACES_ONLINE;
    else
        SHOW_MEMORY_SURFACES_ONLINE = 0; % default
    end
    if isfield(UserInputGettingParameters,'RECORD_VIDEO')
        RECORD_VIDEO = UserInputGettingParameters.RECORD_VIDEO;
    else
        RECORD_VIDEO = 0; % default
    end
    if isfield(UserInputGettingParameters,'versionNum')
        versionNum = UserInputGettingParameters.versionNum;
    else
        versionNum = 0; % default
    end
    if isfield(UserInputGettingParameters,'userInputFullFileName')
        userInputFullFileName = UserInputGettingParameters.userInputFullFileName;
    else
        userInputFullFileName = '';
    end
    if isfield(UserInputGettingParameters,'fullTdFileName')
        fullTdFileName        = UserInputGettingParameters.fullTdFileName;
    else
        fullTdFileName        = '';
    end
    
end
if nargin <4  || isempty(varargin{1})
    userInputCellArray = {};
else
    userInputCellArray = varargin{1};
end

if nargin <5  || isempty(varargin{2})
    userInputRadiusArray = {};
else
    userInputRadiusArray = varargin{2};
end

if nargin <6  || isempty(varargin{3})
    objectClassArray    = nan(1,maxNumObjects);    
else
    objectClassArray    = varargin{3};
end


f0_xyLabelFigureNum = 53454350;
f1_eventSurfaceFigureNum = 53454351;
if SHOW_MEMORY_SURFACES_ONLINE
    figure(f1_eventSurfaceFigureNum); clf;
end
if RECORD_VIDEO
    globalFrameRateInHz                 = 1/(surfaceSampleInterval/1e6);
    figure(f1_eventSurfaceFigureNum);
    set(gcf,'units','pixels','position',[0 0  715 613]);
    Vid1_eventSurface           = VideoWriter(['timeSurface_v' num2str(versionNum) ],'MPEG-4');
    Vid1_eventSurface.FrameRate = globalFrameRateInHz; %// Change the desired frame rate here.
    Vid1_eventSurface.Quality   = 100;
    open(Vid1_eventSurface);
end
azimuth   = viewArray(1);
elevation = viewArray(2);

if SHOW_TIME_STAMP_PLOT
    figure(f1_eventSurfaceFigureNum+1);
    clf;
    plot(surfaceSamplingIndexArray,surfaceSamplingTimeArray);
    %plot(TD.ts);
    hold on;
    ylabel('time index');
    grid on;
    xlabel('event index')
    
    %   set(timeDataPlotArray{2},'Xdata',2:6)
    drawnow
end


[xMax, yMax, nFrame]= size(timeSurfaceArray);
tMax                = surfaceSamplingTimeArray(end);
idxMax              = surfaceSamplingIndexArray(end);
userInputArray      = nan(nFrame,maxNumObjects);
userInputRadiusArray= nan(nFrame,maxNumObjects);
% x,y   --- nFrame --- 1 object
numObsPerObject     = sum(~isnan(userInputArray),1);
numObsPerObject     = sum(~isnan(userInputRadiusArray),1);
% userInputRadiusArray      = nan(nFrame,maxNumObjects); % x,y   --- nFrame --- 1 object
% numObsPerObject     = sum(~isnan(userInputRadiusArray),1);

nExistingObjects    = find(numObsPerObject>0,1,'last');
if isempty(nExistingObjects)
    nExistingObjects = 0;
end
iObject             = max(nExistingObjects,1);
iFrame              = 1;
nFramesToSkip       = 1;
nObservationsToShow = 5;
%%%%%%%%-------------------------------------------------------------------------------------------------------------------------------
SHOW_ALL_NON_CURRENT_OBJECTS   = 1;
colorArray=hsv(nExistingObjects)*0.7; % make it a bit darker  %colorArray=zeros(nExistingObjects,3);
getUserInputFromFrameArrayJustLoop()

numObsPerObject     = sum(~isnan(userInputArray),1);
nExistingObjects    = find(numObsPerObject>0,1,'last');

if isempty(nExistingObjects)    
    nExistingObjects = 0;
end

userInputArray      = single(userInputArray(:,1:nExistingObjects));
% numObsPerObject     = sum(~isnan(userInputRadiusArray),1);
nExistingObjects    = find(numObsPerObject>0,1,'last');

% if isempty(nExistingObjects)    
%     nExistingObjects = 0;
% end

userInputRadiusArray      = single(userInputRadiusArray(:,1:nExistingObjects));
objectClassArray    = objectClassArray(1:nExistingObjects);

% if isempty(nExistingObjects)
%     nExistingObjects = 0;
% end

if RECORD_VIDEO
    close(Vid1_eventSurface);
end
% %%%%%--Check-for-variable-number-of-output-arguments----------------------------------------------------------------------------------------------------------------------------------------------
if nargout > 1
    varargout{1} = objectClassArray;
end

