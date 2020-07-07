function [varargout] = showMemorySurface(TD, varargin)
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
% parameters.xMax                               = 305;             % could be maximum number of rows or cols depending on how the camera was oriented
% parameters.yMax                               = 240;             % could be maximum number of cols or rows
% parameters.polaritiesToUse                    = {'on', 'off'};   % could be any combination of {'on','off','mix'}
%%%%%--Check-for-variable-number-of-input-arguments----------------------------------------------------------------------------------------------------------------------------------------------
RECORD_VIDEO =0;
tau                                = 1000;    %  default time or index window in in us or events
surfaceSampleInterval              = 100*tau;
SURFACE_DECAY_REGIME_STRING        = 'Time'; %{'Time', 'Index'};
DECAY_FUNCTION_STRING              = 'Exp';   %{'Bin','Lin','Exp'};
SURFACE_SAMPLING_REGIME_STRING     = 'Time';  %{'Time', 'Index'};
[xMax,yMax]                        = findxyMaxFromTd(TD);
polaritiesToUse                    = {'on', 'off'};    % could be any combination of {'on','off','mix'}
try
    parameters =     varargin{1};
    try
        tau                            = parameters.tau;% in us or events'
    end
    try
        surfaceSampleInterval          = parameters.surfaceSampleInterval;% in us or events'
    end
    try
        SURFACE_DECAY_REGIME_STRING    = parameters.SURFACE_DECAY_REGIME_STRING;
    end
    try
        SURFACE_SAMPLING_REGIME_STRING = parameters.SURFACE_SAMPLING_REGIME_STRING;
    end
    try
        SURFACE_SAMPLING_REGIME_STRING = parameters.SURFACE_SAMPLING_REGIME_STRING;
    end
    try
        xMax                            = parameters.xMax;% in us or events'
    end
    try
        yMax                            = parameters.yMax;% in us or events'
    end
    try
        polaritiesToUse                 = parameters.polaritiesToUse;% % could be any combination of {'on','off','mix'}
    end
    try
        RECORD_VIDEO                            = parameters.RECORD_VIDEO;% in us or events'
    end
end

memorySurfaceFigNum = 1;
figure(memorySurfaceFigNum);
if RECORD_VIDEO
    %set(gcf,'units','pixels','position',[0 0 1080 1080]);
    set(gcf,'units','pixels','position',[0 0 400 300]);
    axis image
    globalFrameRate                 = 30;
    vid1           = VideoWriter(['eventSurfaceVid'],'MPEG-4');
    vid1.FrameRate = globalFrameRate; %// Change the desired frame rate here.
    vid1.Quality   = 90;
    open(vid1);

end
smoothingFilter1 =  fspecial('gaussian');% 
smoothingFilter2 =  fspecial('average');
smoothingFilter = (smoothingFilter1+ smoothingFilter2)/2;
aVeryBigNonInfinitePsotiveNumber = 1e99;
[xMax, yMax] = findxyMaxFromTd(TD);
timeBasedFlag  = 1;
indexBasedFlag = 2;
binDecayFlag   = 1;
linDecayFlag   = 2;
expDecayFlag   = 3;
if strcmpi(SURFACE_DECAY_REGIME_STRING,'time')%---------- The code in this section is just a speed up so that we don't need to compare strings at each event
    SURFACE_DECAY_REGIME_FLAG = timeBasedFlag;  % Use time-based decay
    if     strcmpi(DECAY_FUNCTION_STRING,'bin')
        DECAY_FUNCTION_FLAG = binDecayFlag;    % Use bin decay
        binTimeWindow       = tau;
    elseif strcmpi(DECAY_FUNCTION_STRING,'lin')
        DECAY_FUNCTION_FLAG = linDecayFlag;    % Use lin decay
        linTimeSlope        = 0.5*1/tau; % 1/us
    elseif strcmpi(DECAY_FUNCTION_STRING,'exp')
        DECAY_FUNCTION_FLAG = expDecayFlag;    % Use exp decay
        tauTimeExp          = tau;
    end
elseif strcmpi(SURFACE_DECAY_REGIME_STRING,'index')
    SURFACE_DECAY_REGIME_FLAG = indexBasedFlag;% Use Index-based decay
    if     strcmpi(DECAY_FUNCTION_STRING,'bin')
        
        DECAY_FUNCTION_FLAG = binDecayFlag;    % Use bin decay
        binIndexWindow      = tau;
    elseif strcmpi(DECAY_FUNCTION_STRING,'lin')
        DECAY_FUNCTION_FLAG = linDecayFlag;    % Use lin decay
        linIndexSlope       = 0.5*1/tau;
    elseif strcmpi(DECAY_FUNCTION_STRING,'exp')
        DECAY_FUNCTION_FLAG = expDecayFlag;    % Use exp decay
        tauIndexExp         = tau;
    end
end
if strcmpi(SURFACE_SAMPLING_REGIME_STRING,'time')
    SURFACE_SAMPLING_REGIME_FLAG = timeBasedFlag; % Use time-based surface sampling
elseif strcmpi(SURFACE_SAMPLING_REGIME_STRING,'index')
    SURFACE_SAMPLING_REGIME_FLAG = 2;% Use Index-based surface sampling
end
nPolaritySurfacesToGenerate = numel(polaritiesToUse);
for iPolarity = 1:nPolaritySurfacesToGenerate
    if strcmpi(polaritiesToUse{iPolarity},'on')
        polarityIdArray(iPolarity) = 1;
    elseif strcmpi(polaritiesToUse{iPolarity},'off')
        polarityIdArray(iPolarity) = -1;
    elseif strcmpi(polaritiesToUse{iPolarity},'mix') || strcmpi(polaritiesToUse{iPolarity},'mixed')
        polarityIdArray(iPolarity) = 0;
    end
end
%%%%--Preprocess-timeDataStructure-then-generate-and-show-the-memory-surface-samples----------------------------------------------------------------------------------------------------------------------------------
tauIn_uSec = tau;
    fprintf('TD Found %d events during selected time... \n', length(TD.x));  % Filter the bad events
TD.p(TD.p == 0) = -1;                           % map the polarity TD.p from {0 1} to {-1 1}
invalidIndices = ~((TD.p == 1) | (TD.p == -1));% not -1 or 1
TD.x(invalidIndices) = [];    TD.y(invalidIndices) = [];    TD.p(invalidIndices) = [];    TD.ts(invalidIndices) = [];  fprintf('Removed invalid p values. %d events... \n', length(TD.x));

invalidIndices = TD.x > xMax;
TD.x(invalidIndices) = [];    TD.y(invalidIndices) = [];    TD.p(invalidIndices) = [];    TD.ts(invalidIndices) = [];   fprintf('TD Removed invalid x values. %d events... \n', length(TD.x));
invalidIndices = TD.y > yMax;
TD.x(invalidIndices) = [];    TD.y(invalidIndices) = [];    TD.p(invalidIndices) = [];    TD.ts(invalidIndices) = [];  fprintf('TD Removed invalid y values. %d events... \n', length(TD.x));
invalidIndices = TD.ts > TD.ts(end);
TD.x(invalidIndices) = [];    TD.y(invalidIndices) = [];    TD.p(invalidIndices) = [];    TD.ts(invalidIndices) = [];   fprintf('TD Removed invalid t values. %d events... larger than TD.ts(end)\n', length(TD.x));
invalidIndices = TD.ts < 0;
TD.x(invalidIndices) = [];    TD.y(invalidIndices) = [];    TD.p(invalidIndices) = [];    TD.ts(invalidIndices) = [];   fprintf('TD Removed invalid t values. %d events...  smaller than 0\n', length(TD.x));



TD.x = max(min((TD.x),xMax),1);                 % fix wierd x y values that fall outside the expected pixel range
TD.y = max(min((TD.y),yMax),1);                 %  ~
nEventsInRecording = numel(TD.ts);


 SHOW_MEMORY_SURFACE_IMAGES          = 1;
surfaceSamplingTimeArray             = nan(1,nEventsInRecording);
surfaceSamplingIndexArray            = nan(1,nEventsInRecording);
%lastValidEventStamp         = -inf(xMax, yMax,nPolaritySurfacesToGenerate); %this stamp could be time or index
lastValidEventStamp         = -aVeryBigNonInfinitePsotiveNumber + zeros(xMax, yMax); %this stamp could be time or index
lastValidPolarity          = zeros(xMax,yMax);
eventMemorySurface          = zeros(xMax,yMax);
onEventCount                =  0 ;
offEventCount               =  0 ;

numFramesInThisRecIncludingAugment   = 0;
iSurfaceSamplesInThisRec             = 0;
SURFACE_SAMPLING_AT_THIS_EVENT_FLAG  = 0;
nextSurfaceSamplingTime              = surfaceSampleInterval;
nextSurfaceSamplingIndex             = surfaceSampleInterval;
vidx    = 0;
originalTdStartTime = TD.ts(1);
TD.ts = TD.ts - originalTdStartTime;

for iPolarity = 1:nPolaritySurfacesToGenerate
    %if strcmpi(polaritiesToUse{iPolarity},'on')
    if 1%strcmpi(polaritiesToUse{iPolarity},'mix')
        %for idx = 5.24e7:nEventsInRecording
        for idx = 1:nEventsInRecording
            x = TD.x (idx);
            y = TD.y (idx);
            t = TD.ts(idx);
            p = TD.p (idx);
            
            %x = ceil(x/2);
            %y = ceil(y/2);
            lastValidPolarity(x,y)                                       = p;
            if 1%(p == 1)
                vidx = vidx + 1;
                onEventCount=  onEventCount+ 1;
                if  SURFACE_DECAY_REGIME_FLAG == timeBasedFlag  % Use time-based decay
                    lastValidEventStamp(x,y)                                       = t;
                elseif SURFACE_DECAY_REGIME_FLAG == indexBasedFlag  % Use index-based decay
                    lastValidEventStamp(x,y) = vidx;
                end
                if  SURFACE_SAMPLING_REGIME_FLAG == timeBasedFlag
                    if t>nextSurfaceSamplingTime % sample the surfaces at periodic time intervals
                        SURFACE_SAMPLING_AT_THIS_EVENT_FLAG                        = 1;
                        nextSurfaceSamplingTime                                    = max(nextSurfaceSamplingTime + surfaceSampleInterval,t);
                        if     SURFACE_DECAY_REGIME_FLAG == timeBasedFlag  % Use time-based decay
                            if     DECAY_FUNCTION_FLAG == binDecayFlag    % Use bin decay
                                eventMemorySurface                                     = single(binTimeWindow >= -(lastValidEventStamp-t));
                            elseif DECAY_FUNCTION_FLAG == linDecayFlag    % Use lin decay
                                eventMemorySurface                                     = max((lastValidEventStamp - t)*linTimeSlope,-1)+1;
                            elseif DECAY_FUNCTION_FLAG == expDecayFlag    % Use exp decay
                                eventMemorySurface                                     = exp((lastValidEventStamp - t)/tauTimeExp );
                            end
                        elseif SURFACE_DECAY_REGIME_FLAG == indexBasedFlag  % Use index-based decay
                            if     DECAY_FUNCTION_FLAG == binDecayFlag    % Use bin decay
                                eventMemorySurface                                     = single(binIndexWindow >= -(lastValidEventStamp - vidx));
                            elseif DECAY_FUNCTION_FLAG == linDecayFlag    % Use lin decay
                                eventMemorySurface                                     = max((lastValidEventStamp - vidx)*linIndexSlope,-1)+1;
                            elseif DECAY_FUNCTION_FLAG == expDecayFlag    % Use exp decay
                                eventMemorySurface                                     = exp((lastValidEventStamp - vidx)/tauIndexExp );
                            end
                        end
                    end
                elseif SURFACE_SAMPLING_REGIME_FLAG == indexBasedFlag
                    if vidx > nextSurfaceSamplingIndex % sample the surfaces at periodic index intervals
                        SURFACE_SAMPLING_AT_THIS_EVENT_FLAG                        = 1;
                        nextSurfaceSamplingIndex                                   = nextSurfaceSamplingIndex + surfaceSampleInterval;
                        if     SURFACE_DECAY_REGIME_FLAG == timeBasedFlag  % Use time-based decay
                            if     DECAY_FUNCTION_FLAG == binDecayFlag    % Use bin decay
                                eventMemorySurface                                     = single(binTimeWindow >= -(lastValidEventStamp-t));
                            elseif DECAY_FUNCTION_FLAG == linDecayFlag    % Use lin decay
                                eventMemorySurface                                     = max((lastValidEventStamp - t)*linTimeSlope,-1)+1;
                            elseif DECAY_FUNCTION_FLAG == expDecayFlag    % Use exp decay
                                eventMemorySurface                                     = exp((lastValidEventStamp - t)/tauTimeExp );
                            end
                        elseif SURFACE_DECAY_REGIME_FLAG == indexBasedFlag  % Use index-based decay
                            if     DECAY_FUNCTION_FLAG == binDecayFlag    % Use bin decay
                                eventMemorySurface                                     = single(binIndexWindow >= -(lastValidEventStamp - vidx));
                            elseif DECAY_FUNCTION_FLAG == linDecayFlag    % Use lin decay
                                eventMemorySurface                                     = max((lastValidEventStamp - vidx)*linIndexSlope,-1)+1;
                            elseif DECAY_FUNCTION_FLAG == expDecayFlag    % Use exp decay
                                eventMemorySurface                                     = exp((lastValidEventStamp - vidx)/tauIndexExp );
                            end
                        end
                    end
                end
                if  SURFACE_SAMPLING_AT_THIS_EVENT_FLAG
                    SURFACE_SAMPLING_AT_THIS_EVENT_FLAG = 0;
                    iSurfaceSamplesInThisRec                             = iSurfaceSamplesInThisRec + 1;
                    surfaceSamplingTimeArray(iSurfaceSamplesInThisRec )  = t;
                    surfaceSamplingIndexArray(iSurfaceSamplesInThisRec)  = idx;
                    if SHOW_MEMORY_SURFACE_IMAGES
                        if 1%rand
                            figure(memorySurfaceFigNum);
                            a = lastValidPolarity.*eventMemorySurface;
                            %a = conv2(a,smoothingFilter,'same');
                            imagesc(a');          %  colormap jet
                            colorbar;                        caxis([-1 1]);
                            axis image
                            if ~RECORD_VIDEO
                                title([SURFACE_DECAY_REGIME_STRING '-based decay surfaces \tau=' num2str(tauIn_uSec/1e6) ' sec  ' 't=' num2str((t)/1e6,'%0.5f')   '+(' num2str((originalTdStartTime)/1e6,'%0.5f')  ')sec   Index:' num2str((idx)/1e6,'%0.3f') ' (Me)'])
                            else
                                
                                colormap hot
                                axis off
                                frame = getframe(memorySurfaceFigNum);
                                writeVideo(vid1,frame);
                                
                            end
                            
                        end                        
                        if 0
                            figure(memorySurfaceFigNum);colormap hot
                            subtightplot(1,4,1)
                            imagesc(timeBinSurface);
                            title('time-based binning');
                            colorbar; axis image;  axis on;% xlim([90, 180]); ylim([1, 120])
                            subtightplot(1,4,2)
                            imagesc(timeLinSurface);
                            title('time-based linear decay');
                            colorbar; axis image;  axis off;%xlim([90, 180]); ylim([1, 120])
                            subtightplot(1,4,3)
                            imagesc(timeExpSurface);
                            title('time-based exp decay');
                            
                            if  strcmpi(SURFACE_DECAY_REGIME_STRING,'time')
                                imagesc(lastValidEventStamp-t);
                                if     DECAY_FUNCTION_ID == 1    % Use bin decay
                                    memorySurfacePatch = binTimeWindow >= -(lastValidEventStamp-t);
                                elseif DECAY_FUNCTION_ID == 2    % Use lin decay
                                    memorySurfacePatch = max((lastValidEventStamp-t)*linTimeSlope,-1)+1;
                                elseif DECAY_FUNCTION_ID == 3    % Use exp decay
                                    memorySurfacePatch = exp((lastValidEventStamp-t)/tauTimeExp );
                                end
                            elseif  strcmpi(SURFACE_DECAY_REGIME_STRING,'index')
                                if     DECAY_FUNCTION_ID == 1    % Use bin decay
                                    memorySurface = binIndexWindow >= -(lastValidEventStamp-vidx);
                                elseif DECAY_FUNCTION_ID == 2    % Use lin decay
                                    memorySurface = max((lastValidEventStamp-vidx)*linIndexSlope,-1)+1;
                                elseif DECAY_FUNCTION_ID == 3    % Use lin decay
                                    memorySurface = exp((lastValidEventStamp-vidx)/indexExpDecay );
                                end
                                subtightplot(1,3,2)
                                imagesc(memorySurface); colorbar; axis image;  axis on;
                                title([SURFACE_DECAY_REGIME_STRING 'Surface']);
                                subtightplot(1,3,3)
                                imagesc(lastValidEventStamp-vidx);  colorbar; axis image;  axis off;
                                title(['lastEvent' SURFACE_DECAY_REGIME_STRING 'Surface']);
                            end
                            colorbar;  axis image;  axis off;
                            majortitle([SURFACE_DECAY_REGIME_STRING '-based decay surfaces at:  eventIndex:' num2str(idx)  '  validEventIndex:' num2str(vidx) '  time:' num2str(t) '\mus'])
                        end
                        pause(.01)
                        drawnow
                    end
                end
            elseif (p == -1)
                offEventCount=  offEventCount+ 1;
            else
                error('The pixel polarity was neither 1 nor -1'); %#ok<ERTAG>
            end
        end
    end
end

try
close(vid1);
end
%%%%%--Check-for-variable-number-of-output-arguments----------------------------------------------------------------------------------------------------------------------------------------------
if nargout == 1
    varargout{1} = vid1;
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




