growthFactorForNumFramesToSkip1 = 1.2;
growthFactorForNumFramesToSkip2 = 5;

selectedClassTypeColor  = [1 .3 0.8];
nonSelectedClassTypeColor = [1  1 0.8];
while 1
    %       nUser               = numel(userInputCellArray);
    %     if    nUser>0
    %
    %         showUserInputCellArray(userInputCellArray,interpedUserInputCellArray,timeSurfaceArray,surfaceSamplingTimeArray,surfaceSamplingIndexArray,iFrame,parameters)
    %
    %     end
    %% Show Plot
    %     figure(f0_xyLabelFigureNum); clf;
    %     showxyPlotsFromUserInputArray(userInputArray,iFrame)
    %% Show GUI
    figure(f1_eventSurfaceFigureNum);clf;
    hold off;
    numObsPerObject = sum(~isnan(userInputArray),1);
    nExistingObjects = find(numObsPerObject>0,1,'last');
    if isempty(nExistingObjects)
        nExistingObjects = 0;
    end
    timeSurface = double(timeSurfaceArray(:,:,iFrame))/127;
    t           = surfaceSamplingTimeArray(iFrame);
    idx         = surfaceSamplingIndexArray(iFrame);
    %imageHandle =
    imagesc(abs(timeSurface));
    colormap parula
    %colormap winter
    %colormap copper
    %colormap bone
    spaceStr = '     ';
    zz = [fullTdFileName                                                                    newline];
    aa = [ 'Time='   num2str(t/1e6,'%07.3f')   '/'  num2str(tMax/1e6,'%07.3f')   'sec'     spaceStr];
    bb = [ 'iFrame:' num2str(iFrame,'%05d')    '/'  num2str(nFrame,'%d')                   spaceStr];
    cc = [ 'index:'  num2str(idx/1e6,'%06.3f') '/'  num2str(idxMax/1e6,'%06.3f') 'MEvents' spaceStr];
    dd = [ SURFACE_DECAY_REGIME_STRING '-based decay'                                      spaceStr];
    ee = ['\tau = ' num2str(tau/1e6,'%.2f') 'sec'                                          spaceStr];
    ff = ['Frame rate' num2str(1e6/surfaceSampleInterval,'%.2f') 'Hz'                      spaceStr];
    titleString = [zz aa bb cc dd ee ff];
    title(titleString,'interpreter','none');
    %colorbar;
    %caxis([0.5 1])
    xlim([1 xMax])
    ylim([1 yMax])
    axis image;
    if elevation<0
        view([azimuth elevation])
        set(gca,'Ydir','normal')
    else
        view([azimuth elevation])
    end
    rForwardPos1 = rectangle('Position',[3/4*yMax xMax 0.5*yMax/4 80]);
    set(rForwardPos1,'Clipping','off','FaceColor','blue');
    rForwardPos2 = rectangle('Position',[(3+0.5)/4*yMax xMax 0.5*yMax/4 80]);
    set(rForwardPos2,'Clipping','off','FaceColor',[0 0 0.8]);
    
    rForwardFrames = rectangle('Position',[1/4*yMax xMax yMax/2 60]);
    set(rForwardFrames,'Clipping','off','FaceColor','y');
    rForwardFrames1 = rectangle('Position',[1/4*yMax xMax+60 yMax/2 20]);
    set(rForwardFrames1,'Clipping','off','FaceColor',[1 .8 .3]);
    
    rForwardNeg1 = rectangle('Position',[0 xMax 0.5*yMax/4 80]);
    set(rForwardNeg1,'Clipping','off','FaceColor','b');
    rForwardNeg2 = rectangle('Position',[0.5*yMax/4 xMax 0.5*yMax/4 80]);
    set(rForwardNeg2,'Clipping','off','FaceColor',[0 0 0.8]);
    
    rBackPos1 = rectangle('Position',[3/4*yMax -79  0.5*yMax/4 80]);
    set(rBackPos1,'Clipping','off','FaceColor','blue');
    rBackPos2 = rectangle('Position',[(3+0.5)/4*yMax -79  0.5*yMax/4 80]);
    set(rBackPos2,'Clipping','off','FaceColor',[0 0 0.8]);
    
    rBackNeg1 = rectangle('Position',[0 -79 0.5*yMax/4 80]);
    set(rBackNeg1,'Clipping','off','FaceColor','b');
    rBackNeg2 = rectangle('Position',[0.5*yMax/4 -79 0.5*yMax/4 80]);
    set(rBackNeg2,'Clipping','off','FaceColor',[0 0 0.8]);
    
    rBackFrames = rectangle('Position',[1/4*yMax -59  yMax/2 60]);
    set(rBackFrames,'Clipping','off','FaceColor','y');
    rBackFrames1 = rectangle('Position',[1/4*yMax -79  yMax/2 20]);
    set(rBackFrames1,'Clipping','off','FaceColor',[1 .8 .3]);
    
    rectNegObject = rectangle('Position',[-29+4 0 30-4 xMax/3]);
    set(rectNegObject,'Clipping','off','FaceColor','g');
    
    rectUndo = rectangle('Position',[-29+4 xMax/3 10 xMax/3]);
    set(rectUndo,'Clipping','off','FaceColor','r');
    
    rectObjType1 = rectangle('Position',[-15 3*xMax/6 16 .25*xMax/6]);     % straight line
    if objectClassArray(iObject) == 1
        set(rectObjType1,'Clipping','off','FaceColor',selectedClassTypeColor);
    else
        set(rectObjType1,'Clipping','off','FaceColor',nonSelectedClassTypeColor);
    end
    
    rectObjType1 = rectangle('Position',[-15 3.25*xMax/6 16 .25*xMax/6]);   % irregular
    if objectClassArray(iObject) < 0
        set(rectObjType1,'Clipping','off','FaceColor',selectedClassTypeColor);
    else
        set(rectObjType1,'Clipping','off','FaceColor',nonSelectedClassTypeColor);
    end
    
    rectObjType1 = rectangle('Position',[-15 3.5*xMax/6 16 .25*xMax/6]);  % too fast
    if objectClassArray(iObject) == 0
        set(rectObjType1,'Clipping','off','FaceColor',selectedClassTypeColor);
    else
        set(rectObjType1,'Clipping','off','FaceColor',nonSelectedClassTypeColor);
    end
    
    rectObjType1 = rectangle('Position',[-15 3.75*xMax/6 16 .25*xMax/6]); % curved
    if objectClassArray(iObject) == 2
        set(rectObjType1,'Clipping','off','FaceColor',selectedClassTypeColor);
    else
        set(rectObjType1,'Clipping','off','FaceColor',nonSelectedClassTypeColor);
    end
    
    rectPosObject = rectangle('Position',[-29+4 2*xMax/3 30-4 xMax/3]);
    set(rectPosObject,'Clipping','off','FaceColor','g');
    
    rTotalEnd = rectangle('Position',[-29+4 xMax+50 15 30]);
    set(rTotalEnd,'Clipping','off','FaceColor','r');
    
    rKill = rectangle('Position',[-29+4 xMax+10 15 30]);
    set(rKill,'Clipping','off','FaceColor','r');
    
    if elevation<0
        xlim([1 yMax])
        ylim([1 xMax])
    else
        xlim([1 xMax])
        ylim([1 yMax])
    end
    text(7.5/8*yMax, xMax+30, '++','fontsize',70);
    text(6.5/8*yMax, xMax+35, '+','fontsize',70);
    text(1.5/8*yMax, xMax+35, '-','fontsize',70);
    text(0.5/8*yMax, xMax+30, '--','fontsize',70);
    
    text(7.5/8*yMax, -55, '++','fontsize',70);
    text(6.5/8*yMax, -50, '+','fontsize',70);
    text(1.5/8*yMax, -55, '-','fontsize',70);
    text(0.5/8*yMax, -50, '--','fontsize',70);
    
    text(yMax/2, xMax+65,num2str(1),'fontsize',30);
    text(yMax/2, -75, num2str(-1),'fontsize',30);
    
    text(yMax/2, xMax+30, num2str(nFramesToSkip),'fontsize',30);
    text(yMax/2, -40, num2str(-nFramesToSkip),'fontsize',30);
    
    text(-16, xMax+53, 'END','fontsize',30);
    text(-16, xMax+17, 'kill','fontsize',30);
    text(-10, -60, num2str(iFrame),'fontsize',40);
    text(-10, xMax*(0.9*1/6), '-','fontsize',70);
    text(-10, xMax*(0.95*5/6), '+','fontsize',70);
    
    text(-7, xMax*(6.2/12),'/','fontsize',40);
    text(-7, xMax*(6.57/12),'S','fontsize',35);
    text(-7, xMax*(7.2/12),'!','fontsize',35);
    text(-6, xMax*(7.65/12),'(','fontsize',35);
    try
        text(-7, xMax*(4.1/12),['#' num2str(iObject) '   ' num2str(numObsPerObject( iObject))],'fontsize',30);
    catch
        text(-7, xMax*(4.1/12),['#' num2str(iObject) '   0' ],'fontsize',30);
    end
    text(-19, xMax*(5/12),'undo last','fontsize',20);
    hold on;
    
    colorArray=hsv(nExistingObjects)*0.4; % make it a bit darker  %colorArray=zeros(nExistingObjects,3);
    for iToShowObject = 1:nExistingObjects
        if iToShowObject == iObject || iToShowObject == (iObject-1) || iToShowObject == (iObject+1) || SHOW_ALL_NON_CURRENT_OBJECTS
            if numObsPerObject(iToShowObject)>0
                indexOfFramesOfLastObs = find(~isnan(userInputArray(1:iFrame,iToShowObject)),nObservationsToShow,'last');
                for iObs = 1:numel(indexOfFramesOfLastObs)
                    xRecent = real(userInputArray(indexOfFramesOfLastObs(iObs),iToShowObject));
                    yRecent = imag(userInputArray(indexOfFramesOfLastObs(iObs),iToShowObject));
                    
                    pt1 = [xRecent yRecent]
                    
                    plot(yRecent,xRecent,'o','markerSize',10+20*(iToShowObject==iObject),'color',colorArray(iToShowObject,:));
                end
            end
        end
    end
    drawnow%-------------------------------
    %% Acquire and check user input
    [y,x,button]        = ginput(2)
%     if elevation<0
%         [y,x,button]        = ginput(1);
%     else
%         [y,x,button]        = ginput(1);
%     end
    if button == 1 || button == 2 || button ==3 % mouse clicks
        if x<0 && y<yMax && y>0% go back in frames;
            if y > yMax/4  && y < 3*yMax/4
                if x<-59
                    iFrame         = max(iFrame - 1,1);
                else
                    iFrame         = max(iFrame - nFramesToSkip,1);
                end
            elseif y < yMax/4
                if y < 0.5*yMax/4
                    nFramesToSkip  = max(round(1/growthFactorForNumFramesToSkip2*(nFramesToSkip-5)),1);
                else
                    nFramesToSkip  = max(round(1/growthFactorForNumFramesToSkip1*(nFramesToSkip-1)),1);
                end
            elseif y > 3*yMax/4
                if y > (3+0.5)/4*yMax
                    nFramesToSkip  = round(growthFactorForNumFramesToSkip2*(nFramesToSkip+5));
                else
                    nFramesToSkip  = round(growthFactorForNumFramesToSkip1*(nFramesToSkip+1));
                end
            end
        end
        if x>xMax && y<yMax && y>0         % go forward in frames;
            if y > yMax/4  && y < 3*yMax/4
                if x >xMax+60
                    iFrame         =  min(iFrame + 1,nFrame);
                else
                    iFrame         =  min(iFrame + nFramesToSkip,nFrame);
                end
            elseif y < yMax/4
                if y < 0.5*yMax/4
                    nFramesToSkip  = max(round(1/growthFactorForNumFramesToSkip2*(nFramesToSkip-5)),1);
                else
                    nFramesToSkip  = max(round(1/growthFactorForNumFramesToSkip1*(nFramesToSkip-1)),1);
                end
            elseif y > 3*yMax/4
                if y > (3+0.5)/4*yMax
                    nFramesToSkip  = round(growthFactorForNumFramesToSkip2*(nFramesToSkip+5));
                else
                    nFramesToSkip  = round(growthFactorForNumFramesToSkip1*(nFramesToSkip+1));
                end
            end
        end
        if x<xMax && x>0 && y<yMax && y>0  % mark target
            if iObject == 0
                iObject = iObject + 1;
            end
            if size(userInputArray,2)<iObject  % grow the data array
                userInputArray =[userInputArray nan(nFrame,1)];
                numObsPerObject = [numObsPerObject 0];
            end
            if  isnan(userInputArray(iFrame,iObject))
                numObsPerObject(iObject) =  numObsPerObject(iObject) +1;
            end
            userInputArray(iFrame,iObject) = x + y*1i;
            iFrame         = min(iFrame + nFramesToSkip,nFrame);
            
        end
        if  0<x && x<xMax/3  &&  y<0       % go back to last object (if it exists)
            iObject                        = max(iObject - 1,1);
        end
        if  xMax*2/3<x && x<xMax  &&  y<0  % go forward to next object (if it exists)
            iObject                        = min(iObject + 1,maxNumObjects);
            
        end
        if y>-29 && x>xMax+50 && y<-14 && x<xMax+80% indicate end of recording
            FINISH_RECORDING_FLAG = 1;
            break
        end
        if y>-29 && x>xMax+10 && y<-14 && x<xMax+30 % kill this object
            if iObject>0
                userInputArray(:,iObject) = nan;
                numObsPerObject = sum(~isnan(userInputArray),1);
                nExistingObjects = find(numObsPerObject>0,1,'last');
                if isempty(nExistingObjects)
                    nExistingObjects = 0;
                end
            end
        end
        if y>-29 && x>xMax/3 && y<-19 &&  x<2*xMax/3%undo last
            
            indexOfLastObservation = find(~isnan(userInputArray(1:iFrame,iObject)),1,'last');
            if ~isempty(indexOfLastObservation)
                userInputArray(indexOfLastObservation,iObject) = nan;
                numObsPerObject = sum(~isnan(userInputArray),1);
                nExistingObjects = find(numObsPerObject>0,1,'last');
                if isempty(nExistingObjects)
                    nExistingObjects = 0;
                end
                iFrame = indexOfLastObservation;
            end
        end
        if y>-15 && y<0
            if x> 3*xMax/6  && x<3.25*xMax/6 % straight line
                objectClassArray(iObject) = 1;
            end
            if x> 3.25*xMax/6  && x<3.5*xMax/6 % irregular
                objectClassArray(iObject) = -1;
            end
            if x> 3.5*xMax/6  && x<3.75*xMax/6 % too fast
                objectClassArray(iObject) = 0;
            end
            if x> 3.75*xMax/6  && x<4*xMax/6 % too fast
                objectClassArray(iObject) = 2;
            end
        end
        
    elseif button == 47 % go forward by 1
        iFrame         =  min(iFrame + 1,nFrame);
    elseif button == 46 % go forward nFramesToSkip
        iFrame         =  min(iFrame + nFramesToSkip,nFrame);
    elseif button == 44 % go backward nFramesToSkip
        iFrame         = max(iFrame - nFramesToSkip,1);
    elseif button == 109 % go backward 1
        iFrame         = max(iFrame - 1,1);
    end
end