function [timeSurfaceArray,surfaceSamplingTimeArray,surfaceSamplingIndexArray,varargout] = generateTimeSurfArrayForUserInput(TD, varargin)

%%%%%% Show a Time Data structure (TD) in the form of frames/samples of a memory surface.
%%%%%% Using either time/event-based decay, bin/lin/exp decay functions, and   time/event decay
%
% showMemorySurface(TD)                               replays temporal difference events (using default showMemorySurfaceParameters)
%
% showMemorySurface(TD,parameters)                    replays temporal difference events
%
% [vid]                 = showMemorySurface( __ )     and also returns a video object
%
% [ ~ , surfaceSamples] = showMemorySurface( __ )     and also returns the generated surface samples/frames
%
% [ ~ , ~ , parameters] = showMemorySurface( __ )     and also returns the showMemorySurfaceParameters used to generate the video/surfaceSamples
%                                                     this might be used when one needs the default parameters
%%%%% Example parameters: -----------------------------------------------------------------------------------------------------------------
% parameters.tau                                = 1000;            %  default time or index interval for decaying in in us or events
% parameters.surfaceSampleInterval              = tau;             %  default time or index interval for sampling in in us or events
% parameters.SURFACE_DECAY_REGIME_STRING        = 'Index';         % {'Time', 'Index'};
% parameters.DECAY_FUNCTION_STRING              = 'Exp';           % {'Bin','Lin','Exp'};
% parameters.SURFACE_SAMPLING_REGIME_STRING     = 'Time';          % {'Time', 'Index'};
% parameters.polaritiesToUse                    = {'on', 'off'};   % could be any combination of {'on','off','mix'}
%%%%%--Check-for-variable-number-of-input-arguments----------------------------------------------------------------------------------------------------------------------------------------------
gap      =0.1;    
marg_h   =0.1;    
marg_w   =0.1;    

if nargin == 1 ||  (nargin >1 && isempty(varargin{1})) % If no showTdParameters is provided as the second input use default values
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
elseif nargin >1
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
end

avgWindow = 50; % inFrmaes

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


aVeryBigNonInfinitePsotiveNumber = 1e99;
[xMax, yMax] = findxyMaxFromTd(TD);

nEventsInRecording  = numel(TD.ts);
originalTdStartTime = TD.ts(1);
originalTdEndTime   = TD.ts(end);

estimatedNumberOfFrames     = ceil((originalTdEndTime - originalTdStartTime)/surfaceSampleInterval)+1;
surfaceSamplingTimeArray    = nan(1,estimatedNumberOfFrames);
surfaceSamplingIndexArray   = nan(1,estimatedNumberOfFrames);
%lastValidEventStamp        = -inf(xMax, yMax,nPolaritySurfacesToGenerate); %this stamp could be time or index
lastEventTimeStamp          = -aVeryBigNonInfinitePsotiveNumber + zeros(xMax, yMax); %this stamp could be time or index
timeSurfaceArray     = zeros(xMax,yMax,estimatedNumberOfFrames,'int8');
lastValidPolarity           = zeros(xMax,yMax);

iFrame             = 0;
nextSurfaceSamplingTime              = surfaceSampleInterval;

TD.ts = TD.ts - originalTdStartTime;

for idx = 1:nEventsInRecording
    x = TD.x (idx);
    y = TD.y (idx);
    t = TD.ts(idx);
    p = TD.p (idx);
    
    lastValidPolarity(x,y)   = p;
    lastEventTimeStamp(x,y)  = t;
    
    if t>nextSurfaceSamplingTime % sample the surfaces at periodic time intervals
        nextSurfaceSamplingTime             = nextSurfaceSamplingTime + surfaceSampleInterval;
        iFrame                              = iFrame + 1;
        surfaceSamplingTimeArray(iFrame )   = t;
        surfaceSamplingIndexArray(iFrame)   = idx;
        timeSurfaceInt8 = 127*lastValidPolarity.*exp((lastEventTimeStamp - t)/tau );
        timeSurfaceArray(:,:,iFrame) = int8(timeSurfaceInt8);        
        timeSurface = double(timeSurfaceArray(:,:,iFrame))/127;
        if SHOW_MEMORY_SURFACES_ONLINE
            if 1
                figure(f1_eventSurfaceFigureNum);
                clf;
                %subtightplot(1,2,1,gap,marg_h,marg_w)
                % subplot(1,2,1)
                %colormap jet;
                colormap parula;
                %colormap gray;
                imagesc(max(timeSurface,0)); hold on
                %colorbar;
                caxis([0 1])
                xlim([1 xMax])
                ylim([1 yMax])
                axis image;
                title([ 'Time=' num2str(t/1e6,'%07.3f') ' sec  iFrame:'  num2str(iFrame,'%05d') '    index:' num2str(idx/1e6,'%06.3f')  ' MEvents     '   SURFACE_DECAY_REGIME_STRING '-based decay       \tau = ' num2str(tau/1e6,'%.2f') 'sec     frame rate' num2str(1e6/surfaceSampleInterval,'%.2f') 'Hz'   ]);
                xlabel('x')
                ylabel('y')
                if elevation<0
                    view([azimuth elevation])
                    set(gca,'Ydir','normal')
                else
                    view([azimuth elevation])
                end
                if RECORD_VIDEO
                    frame = getframe(f1_eventSurfaceFigureNum);    
                    writeVideo(Vid1_eventSurface,frame);
                end
            end
            if SHOW_TIME_STAMP_PLOT
                
                figure(f1_eventSurfaceFigureNum+1);
                clf;
                hold on;
                timeDataPlotArray{1} = plot(TD.ts);
                timeDataPlotArray{2} = plot(eye(5));
                ylabel('time index');
                grid on;
                xlabel('event index')
                set(timeDataPlotArray{2},'Xdata',2:6)
            end
            drawnow
        end
    end
end

if RECORD_VIDEO   
    close(Vid1_eventSurface);
end
nFrame = iFrame;
surfaceSamplingTimeArray    = surfaceSamplingTimeArray(1:nFrame);
surfaceSamplingIndexArray   = surfaceSamplingIndexArray(1:nFrame);
timeSurfaceArray     = timeSurfaceArray(:,:,1:nFrame);

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





%%%%%--Check-for-variable-number-of-output-arguments----------------------------------------------------------------------------------------------------------------------------------------------
if nargout == 1
    varargout{1} = Vid1;
elseif nargout > 1
    varargout{1} = surfaceSamples;
elseif nargout > 2
    parameters.tau                            = tau;
    parameters.surfaceSampleInterval          = surfaceSampleInterval;
    parameters.SURFACE_DECAY_REGIME_STRING    = SURFACE_DECAY_REGIME_STRING
    parameters.DECAY_FUNCTION_STRING          = DECAY_FUNCTION_STRING
    parameters.SURFACE_SAMPLING_REGIME_STRING = SURFACE_SAMPLING_REGIME_STRING
    varargout{2} = parameters;
end




