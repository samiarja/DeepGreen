function [varargout] = showUserInputCellArray(userInputCellArray,userInputCellArrayRadius,interpedUserInputCellArray,interpedUserInputCellRadiusArray,timeSurfaceArray,surfaceSamplingTimeArray,surfaceSamplingIndexArray,varargin)

    nUser               = numel(userInputCellArray);
    [xMax,yMax, nFrame] = size(timeSurfaceArray);
    tMax                = surfaceSamplingTimeArray(end);
    idxMax              = surfaceSamplingIndexArray(end);
    
    if nargin<7 || isempty(varargin{1})
        iFrame  = nFrame;
    else
        iFrame  = varargin{1};
    end
    if nargin <8 || isempty(varargin{2})
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
        Parameters =     varargin{2};
        if isfield(Parameters,'tau')
            tau                            = Parameters.tau;% in us or events'
        else
            tau                            = 1000;    % default value in micro-secs
        end
        if isfield(Parameters,'surfaceSampleInterval')
            surfaceSampleInterval          = Parameters.surfaceSampleInterval;% in us
        else
            surfaceSampleInterval          = tau;      %  default time or index window in in us or events
        end
        if isfield(Parameters,'SURFACE_DECAY_REGIME_STRING')
            SURFACE_DECAY_REGIME_STRING    = Parameters.SURFACE_DECAY_REGIME_STRING;
        else
            SURFACE_DECAY_REGIME_STRING    = 'Time';%  default time
        end
        if isfield(Parameters,'DECAY_FUNCTION_STRING')
            DECAY_FUNCTION_STRING          = Parameters.DECAY_FUNCTION_STRING;
        else
            DECAY_FUNCTION_STRING          = {'Exp'};% default %{'Bin','Lin','Exp'};
        end
        if isfield(Parameters,'DECAY_FUNCTION_STRING')
            SURFACE_SAMPLING_REGIME_STRING = Parameters.SURFACE_SAMPLING_REGIME_STRING;
        else
            SURFACE_SAMPLING_REGIME_STRING = {'Time'};%{'Time', 'Index'};
        end
        if isfield(Parameters,'viewArray')
            viewArray = Parameters.viewArray;
        else
            viewArray = [0,90]; % default
        end
        if isfield(Parameters,'SHOW_TIME_STAMP_PLOT')
            SHOW_TIME_STAMP_PLOT = Parameters.SHOW_TIME_STAMP_PLOT;
        else
            SHOW_TIME_STAMP_PLOT = 0; % default
        end
        if isfield(Parameters,'SHOW_MEMORY_SURFACES_ONLINE')
            SHOW_MEMORY_SURFACES_ONLINE = Parameters.SHOW_MEMORY_SURFACES_ONLINE;
        else
            SHOW_MEMORY_SURFACES_ONLINE = 0; % default
        end
        if isfield(Parameters,'RECORD_VIDEO')
            RECORD_VIDEO = Parameters.RECORD_VIDEO;
        else
            RECORD_VIDEO = 0; % default
        end
        if isfield(Parameters,'versionNum')
            versionNum = Parameters.versionNum;
        else
            versionNum = 0; % default
        end
    end
    if nargin >9
        vid1 = varargin{3};
    end
    if nargin >10
        f11_eventSurfaceFigureNum = varargin{4};
        if isempty(f11_eventSurfaceFigureNum)
            f11_eventSurfaceFigureNum = 53454311;%f10_xyLabelFigureNum      = 53454310;
        end
    else
        f11_eventSurfaceFigureNum = 53454311;%f10_xyLabelFigureNum      = 53454310;
    end
    if nargin >11
        selectedObjectIndex = varargin{5};
    else
        selectedObjectIndex = [];
    end
    
    if isempty(interpedUserInputCellArray)
        INTERPED_USER_INPUT_IS_EMPTY = 1;
    else
        INTERPED_USER_INPUT_IS_EMPTY = 0;
    end
    
    if isempty(interpedUserInputCellRadiusArray)
        INTERPED_USER_INPUT_RADIUS_IS_EMPTY = 1;
    else
        INTERPED_USER_INPUT_RADIUS_IS_EMPTY = 0;
    end
    
    azimuth                   = viewArray(1);
    elevation                 = viewArray(2);
    timeSurfInterpObjLineWidth         = 2;
    userObsMarkerSize                  = 20;%25;
    figHandle = figure(f11_eventSurfaceFigureNum); clf;
    %figure(f10_xyLabelFigureNum);hold off;
    
    
    %% Show timesurface
    
    iFrame = max(min(iFrame,nFrame),1);
    timeSurface = abs(double(timeSurfaceArray(:,:,iFrame))/127);
    t           = surfaceSamplingTimeArray(iFrame);
    idx         = surfaceSamplingIndexArray(iFrame);
    spaceStr = '     ';
    % yy = ['nObjects:' num2str(nExistingObjectSoFar)                                      spaceStr];
    % zz = [ 'iUser='   num2str(iUser)   '/'  num2str(nUser)   'sec'                         spaceStr];
    aa = [ 'Time='   num2str(t/1e6,'%07.3f')   '/'  num2str(tMax/1e6,'%07.3f')   'sec'     spaceStr];
    bb = [ 'iFrame:' num2str(iFrame,'%05d')    '/'  num2str(nFrame,'%d')                   spaceStr];
    cc = [ 'index:'  num2str(idx/1e6,'%06.3f') '/'  num2str(idxMax/1e6,'%06.3f') 'MEvents' spaceStr];
    dd = [ SURFACE_DECAY_REGIME_STRING '-based decay'                                      spaceStr];
    ee = ['\tau = ' num2str(tau/1e6,'%.2f') 'sec'                                          spaceStr];
    ff = ['Frame rate' num2str(1e6/surfaceSampleInterval,'%.2f') 'Hz'                      spaceStr];
    %titleString1 = [yy zz aa bb];
    titleString1 = [aa bb];
    titleString2 =  [ cc dd ee ff];
    
    h1 = subtightplot(6,6,[[1 2 3]+0*6 [1 2 3]+1*6 [1 2 3]+2*6 [1 2 3]+3*6]);
    imagesc(timeSurface);
    title(titleString1);
    colormap(h1,'parula')
    
    %colorbar;
    caxis([0 1])
    xlim([1 xMax])
    ylim([1 yMax])
    axis image;
    if elevation<0
        view([azimuth elevation])
        set(gca,'Ydir','normal')
    else
        view([azimuth elevation])
    end
    if elevation<0
        xlim([1 yMax])
        ylim([1 xMax])
    else
        xlim([1 xMax])
        ylim([1 yMax])
    end
    %text(-14, -60, num2str(iFrame),'fontsize',40);
    
    yticklabels({})
    
    h2 = subtightplot(6,6,[[1 2 3]+0*6 [1 2 3]+1*6 [1 2 3]+2*6 [1 2 3]+3*6]+3);
    
    imagesc(timeSurface*0.2+.2);
    %imagesc(timeSurface);
    title(titleString2);
    colormap(h2,'gray')
    %colorbar;
    caxis([0 1])
    xlim([1 xMax])
    ylim([1 yMax])
    axis image;
    if elevation<0
        view([azimuth elevation])
        set(gca,'Ydir','normal')
    else
        view([azimuth elevation])
    end
    if elevation<0
        xlim([1 yMax])
        ylim([1 xMax])
    else
        xlim([1 xMax])
        ylim([1 yMax])
    end
    
    hold on;
    %text(-14, -60, num2str(iFrame),'fontsize',40);
    
    for iUser = 1:nUser%[1 9 2 8 3 7]%
        userInputArray           = userInputCellArray{iUser};
        userInputRadiusArray           = userInputCellArrayRadius{iUser};
        if ~INTERPED_USER_INPUT_IS_EMPTY
            interpedUserInputArray   = interpedUserInputCellArray{iUser};
        else
            interpedUserInputArray = [];
        end
        
        if ~INTERPED_USER_INPUT_RADIUS_IS_EMPTY
            interpedUserInputRadius   = interpedUserInputCellRadiusArray{iUser};
        else
            interpedUserInputRadius = [];
        end
        %     numObsPerObjectSoFar = sum(~isnan(userInputArray(1:iFrame,:)),1)';
        %     nExistingObjectSoFar  = find(numObsPerObjectSoFar>0,1,'last');
        %     if isempty(nExistingObjectSoFar)
        %         nExistingObjectSoFar = 0;
        %     end
        numObsPerObject     = sum(~isnan(userInputArray),1);
        nExistingObject  = find(numObsPerObject>0,1,'last');
        if isempty(nExistingObject)
            nExistingObject = 0;
        end
        if isempty(userInputArray)
            continue
        end
        if isempty(userInputCellArrayRadius)
            continue
        end
       
        colorArray=hsv(nExistingObject);
        set(figHandle, 'currentaxes', h2);
        for iToShowObject = 1:nExistingObject
            %         if numObsPerObjectArray(iToShowObject,iUser)>0
            %             indexOfFramesOfLastObs = find(~isnan(userInputArray(1:iFrame,iToShowObject)),nObservationsToShow,'last');
            %             for iObs = 1:numel(indexOfFramesOfLastObs)
            %                 xRecent = real(userInputArray(indexOfFramesOfLastObs(iObs),iToShowObject));
            %                 yRecent = imag(userInputArray(indexOfFramesOfLastObs(iObs),iToShowObject));
            %
            %                 plot(yRecent,xRecent,'.','markerSize',20,'color',colorArray(iToShowObject,:));
            %             end
            %         end
            
            xRecent = real(userInputArray(1:iFrame,iToShowObject));
            yRecent = imag(userInputArray(1:iFrame,iToShowObject));
            
            radiusRecent = real(userInputRadiusArray(1:iFrame,iToShowObject));
            
            plot(yRecent,xRecent,'.','markerSize',userObsMarkerSize,'color',colorArray(iToShowObject,:))
            viscircles([yRecent xRecent],radiusRecent,'color',colorArray(iToShowObject,:))

            if ~isempty(selectedObjectIndex)
                if selectedObjectIndex == iToShowObject
                    plot(yRecent,xRecent,'o','markerSize',userObsMarkerSize,'color',colorArray(iToShowObject,:))
%                     viscircles([yRecent xRecent],radiusRecent,'color',colorArray(iToShowObject,:))
                end
            end
            %         plot(yRecent,xRecent,'o','markerSize',userObsMarkerSize+1,'color',colorArray(iToShowObject,:));
            %         plot(yRecent,xRecent,'o','markerSize',userObsMarkerSize+2,'color',colorArray(iToShowObject,:));
            if ~INTERPED_USER_INPUT_IS_EMPTY
                xRecent = real(interpedUserInputArray(1:iFrame,iToShowObject));
                yRecent = imag(interpedUserInputArray(1:iFrame,iToShowObject));
                radiusRecent = real(userInputRadiusArray(1:iFrame,iToShowObject));
                plot(yRecent,xRecent,':','lineWidth',timeSurfInterpObjLineWidth,'color',colorArray(iToShowObject,:));
%                 viscircles([yRecent xRecent],radiusRecent,'color',colorArray(iToShowObject,:))
               
            end
            
            if ~INTERPED_USER_INPUT_RADIUS_IS_EMPTY
                radiusRecent = real(userInputRadiusArray(1:iFrame,iToShowObject));
                plot(yRecent,xRecent,':','lineWidth',timeSurfInterpObjLineWidth,'color',colorArray(iToShowObject,:));
%                 viscircles([yRecent xRecent],radiusRecent,'color',colorArray(iToShowObject,:))
%                 circle([yRecent,xRecent],radiusRecent,1000,'--');
            end
            
        end  %% Show Plot
        %yticklabels({})
        showxyPlotsFromUserInputArray(userInputArray,iFrame,interpedUserInputArray,selectedObjectIndex);
%         showxyPlotsFromUserInputRadiusArray(userInputRadiusArray,iFrame,interpedUserInputRadius,selectedObjectIndex);
        if   RECORD_VIDEO
            frame = getframe(f11_eventSurfaceFigureNum);
            writeVideo(vid1,frame);
        end
    end
    sliderPositionVector = [0.0400 0.192 0.9200 0.01];% from the subplot axes
    sld = uicontrol('Style', 'slider', 'Min',1,'Max',nFrame,'Value',iFrame,'units','normalized', 'Position', sliderPositionVector, 'Callback', @iFrameSet,'SliderStep', [0.00100 0.01000]);
    function iFrameSet(source,event)
    iFrame = round(source.Value);
    showUserInputCellArray(userInputCellArray,userInputCellArrayRadius,interpedUserInputCellArray,interpedUserInputCellRadiusArray,timeSurfaceArray,surfaceSamplingTimeArray,surfaceSamplingIndexArray,iFrame,Parameters)
    drawnow
    end
    if nargout>0
        varargout{1} = iFrame;
    end
end