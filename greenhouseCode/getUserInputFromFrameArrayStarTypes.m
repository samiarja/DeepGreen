function [userInputArray,varargout] = getUserInputFromFrameArray(timeSurfaceArray,surfaceSamplingTimeArray,surfaceSamplingIndexArray,varargin)

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
    parameters =     varargin{1};
    if isfield(parameters,'tau')
        tau                            = parameters.tau;% in us or events'
    else
        tau                            = 1000;    % default value in micro-secs
    end
    if isfield(parameters,'surfaceSampleInterval')
        surfaceSampleInterval          = parameters.surfaceSampleInterval;% in us
    else
        surfaceSampleInterval          = tau;      %  default time or index window in in us or events
    end
    if isfield(parameters,'SURFACE_DECAY_REGIME_STRING')
        SURFACE_DECAY_REGIME_STRING    = parameters.SURFACE_DECAY_REGIME_STRING;
    else
        SURFACE_DECAY_REGIME_STRING    = 'Time';%  default time
    end
    if isfield(parameters,'DECAY_FUNCTION_STRING')
        DECAY_FUNCTION_STRING          = parameters.DECAY_FUNCTION_STRING;
    else
        DECAY_FUNCTION_STRING          = {'Exp'};% default %{'Bin','Lin','Exp'};
    end
    if isfield(parameters,'DECAY_FUNCTION_STRING')
        SURFACE_SAMPLING_REGIME_STRING = parameters.SURFACE_SAMPLING_REGIME_STRING;
    else
        SURFACE_SAMPLING_REGIME_STRING = {'Time'};%{'Time', 'Index'};
    end
    if isfield(parameters,'viewArray')
        viewArray = parameters.viewArray;
    else
        viewArray = [0,90]; % default
    end
    if isfield(parameters,'SHOW_TIME_STAMP_PLOT')
        SHOW_TIME_STAMP_PLOT = parameters.SHOW_TIME_STAMP_PLOT;
    else
        SHOW_TIME_STAMP_PLOT = 0; % default
    end
    if isfield(parameters,'SHOW_MEMORY_SURFACES_ONLINE')
        SHOW_MEMORY_SURFACES_ONLINE = parameters.SHOW_MEMORY_SURFACES_ONLINE;
    else
        SHOW_MEMORY_SURFACES_ONLINE = 0; % default
    end
    if isfield(parameters,'RECORD_VIDEO')
        RECORD_VIDEO = parameters.RECORD_VIDEO;
    else
        RECORD_VIDEO = 0; % default
    end
    if isfield(parameters,'versionNum')
        versionNum = parameters.versionNum;
    else
        versionNum = 0; % default
    end
    if isfield(parameters,'userInputFullFileName')
        userInputFullFileName = parameters.userInputFullFileName;
    else
        userInputFullFileName = '';
    end
    if isfield(parameters,'fullTdFileName')
        fullTdFileName        = parameters.fullTdFileName;
    else
        fullTdFileName        = '';
    end
    
end
if nargin <5  || isempty(varargin{2})
    userInputCellArray = {};
else
    userInputCellArray = varargin{2};
end
if nargin <6  || isempty(varargin{3})
    interpedUserInputCellArray = [];
else
    interpedUserInputCellArray = varargin{3};
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
userInputArray      = nan(nFrame,maxNumObjects); % x,y   --- nFrame --- 1 object
numObsPerObject     = sum(~isnan(userInputArray),1);
nExistingObjects    = find(numObsPerObject>0,1,'last');
if isempty(nExistingObjects)
    nExistingObjects = 0;
end
iObject             = nExistingObjects;
iFrame              = 1;
nFramesToSkip       = 1;
nObservationsToShow = 5;
objectClassArray    = nan(1,maxNumObjects);
%%%%%%%%-------------------------------------------------------------------------------------------------------------------------------
SHOW_ALL_NON_CURRENT_OBJECTS   = 0;
colorArray=hsv(nExistingObjects)*0.7; % make it a bit darker  %colorArray=zeros(nExistingObjects,3);
getUserInputFromFrameArrayJustLoop()
numObsPerObject     = sum(~isnan(userInputArray),1);nExistingObjects    = find(numObsPerObject>0,1,'last');if isempty(nExistingObjects)    nExistingObjects = 0;end
userInputArray      = single(userInputArray(:,1:nExistingObjects));

if RECORD_VIDEO
    close(Vid1_eventSurface);
end
% %%%%%--Check-for-variable-number-of-output-arguments----------------------------------------------------------------------------------------------------------------------------------------------
if nargout > 1
    varargout{1} = objectClassArray;
end




