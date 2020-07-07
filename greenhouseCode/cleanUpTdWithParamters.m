function [TD,varargout] = cleanUpTdWithParamters(inputTD,varargin)
%%% Example Usage --------------------------------------------------------------
% [TD] = cleanUpTd(TD)
% [TD] = cleanUpTd(TD,[startTime EndTime])         % times in uSec                     eg: [2.8e6 12e6] uSec
% [TD] = cleanUpTd(TD,__,prctHotPixelsToRemove)    % Remove % most active pixels       eg: 2  (percent)
% [TD] = cleanUpTd(TD,__,__,FilterTimeWindow)      % FilterTimeWindow in uSec          eg: 50000 uSec
% [TD] = cleanUpTd(TD,__,__,__,FilterRadius)       % FilterRad in pixels               eg: 2 pixels
% [ __ , [initialStartTimeIn_uSec ,initialEndTimeIn_uSec]]  = cleanUpTd( __ )
% [ __ ,__ ,[initialStartIndex, initialEndIndex]]           = cleanUpTd( __ )

% This file should be in [myMatlabPath '\ML\data\ATIS\dataAquisitionCode\myAtisLibrary\']
CleanUpTdResults=[];
CleanUpTdParameters=[];

if ~isstruct(inputTD)  % Check if TD is a matrix and encoded in Gregory Cohens's Style. If so make it a struct
    TD1         = [];
    [nEvents,~] = size(inputTD);
    eventIndexArray           = (1:nEvents);
    TD1.x(eventIndexArray)    = inputTD(eventIndexArray,1);
    TD1.y(eventIndexArray)    = inputTD(eventIndexArray,2);
    TD1.p(eventIndexArray)    = inputTD(eventIndexArray,3)*2-1;
    TD1.ts(eventIndexArray)   = inputTD(eventIndexArray,4);
    inputTD = TD1;
end
try
    if    isempty(inputTD.x)
        TD = inputTD;
        if nargout >1
            varargout{1} = [];
        end
        if nargout >2
            varargout{2} = [];
        end
        return
    end
end
try
    inputTD.x(1) = single(inputTD.x(1));
catch
    nEventsInBadTd = numel(inputTD);
    try
        for idx = 1:nEventsInBadTd
            tempInputTD.x(idx,1)  = inputTD(idx).x;
            tempInputTD.y(idx,1)  = inputTD(idx).y;
            tempInputTD.p(idx,1)  = inputTD(idx).p;
            tempInputTD.ts(idx,1) = inputTD(idx).ts;
        end
    catch
        for idx = 1:nEventsInBadTd  % stupid way
            tempInputTD.x(idx,1) = inputTD(idx).x;
            tempInputTD.y(idx,1) = inputTD(idx).y;
            tempInputTD.p(idx,1) = inputTD(idx).polarity;
            tempInputTD.ts(idx,1) = inputTD(idx).time;
        end
    end
    inputTD = tempInputTD;
end

inputTD.x = single(inputTD.x(:));
inputTD.y = single(inputTD.y(:));
inputTD.p = single(inputTD.p(:));
inputTD.ts = single(inputTD.ts(:));


nEventsInOriginalTd      = numel(inputTD.ts);
originalStartTimeIn_uSec = inputTD.ts(1);
originalEndTimeIn_uSec   = inputTD.ts(nEventsInOriginalTd);

TD = inputTD;
if nargin>1
    cleanUpTdParameters = varargin{1};
    try
        givenStartTimeIn_uSec = cleanUpTdParameters.givenStartTimeIn_uSec;
        initialStartTimeIn_uSec =   givenStartTimeIn_uSec;
    catch
        initialStartTimeIn_uSec = originalStartTimeIn_uSec;% default        
    end
    try
        givenEndTimeIn_uSec =  cleanUpTdParameters.givenEndTimeIn_uSec;
        initialEndTimeIn_uSec   =   givenEndTimeIn_uSec;
    catch
        initialEndTimeIn_uSec   = originalEndTimeIn_uSec;% default
    end
else
    initialStartTimeIn_uSec = originalStartTimeIn_uSec;% default
    initialEndTimeIn_uSec   = originalEndTimeIn_uSec;% default
end

try
    prctHotPixelsToRemove = cleanUpTdParameters.prctHotPixelsToRemove;
catch
    prctHotPixelsToRemove = [];% default
end

PRE_FILTER_TD = 0;
try
    preFilterTimeIn_uSec  = cleanUpTdParameters.preFilterTimeIn_uSec;
    if ~isempty(preFilterTimeIn_uSec)
        PRE_FILTER_TD = 1;
    else
        PRE_FILTER_TD = 0;
    end
end
try
    preFilterRadius  = cleanUpTdParameters.preFilterRadius;
    if  ~isempty(preFilterRadius)
        PRE_FILTER_TD = 1;
    else
        PRE_FILTER_TD = 0;
    end
end
SHOW_CLEANED_UP_TD_RESULTS = 0; % default
try
    SHOW_CLEANED_UP_TD_RESULTS = cleanUpTdParameters.SHOW_CLEANED_UP_TD_RESULTS;
    if isempty(  SHOW_CLEANED_UP_TD_RESULTS)
        SHOW_CLEANED_UP_TD_RESULTS = 0; % default
    end
end
try 
    xMax = cleanUpTdParameters.xMax;
    yMax = cleanUpTdParameters.yMax;
catch    
    [xMax,yMax] = findxyMaxFromTd(TD);
end
initialStartIndex = find(TD.ts>= initialStartTimeIn_uSec,1,'first');
initialEndIndex = find(TD.ts<= initialEndTimeIn_uSec,1,'last');

fprintf('Found %d events in original recording... ', length(TD.x));  % Filter the bad events
TD.x = TD.x(initialStartIndex:initialEndIndex);
TD.y = TD.y(initialStartIndex:initialEndIndex);
TD.p = TD.p(initialStartIndex:initialEndIndex);
TD.ts = TD.ts(initialStartIndex:initialEndIndex);
fprintf('Taking %d events.\n', length(TD.x));  % Filter the bad events

% medianWindowSize = 40;
% initialMedianStartTimeIn_uSec = median(TD.ts(1:medianWindowSize));
% initialMedianEndTimeIn_uSec   = median(TD.ts((end-medianWindowSize):end));

invalidIndicesDueToNegative_ts = TD.ts < 0;
nEventsRemovedDueToNegativeTimeStamp = sum(invalidIndicesDueToNegative_ts);
TD.x(invalidIndicesDueToNegative_ts) = [];    TD.y(invalidIndicesDueToNegative_ts) = [];    TD.p(invalidIndicesDueToNegative_ts) = [];    TD.ts(invalidIndicesDueToNegative_ts) = [];   fprintf('%d t smaller than 0. Removed. %d left\n',nEventsRemovedDueToNegativeTimeStamp, length(TD.x));
if ~isempty(TD.ts)
    invalidIndicesWith_tsHigherThanEnd = TD.ts >  TD.ts(end); %mean(TD.ts((end-100):end));
    nEventsRemovedWith_tsHigherThanEnd = sum(invalidIndicesWith_tsHigherThanEnd);
    TD.x(invalidIndicesWith_tsHigherThanEnd) = [];    TD.y(invalidIndicesWith_tsHigherThanEnd) = [];    TD.p(invalidIndicesWith_tsHigherThanEnd) = [];    TD.ts(invalidIndicesWith_tsHigherThanEnd) = [];   fprintf('%d t larger than TD.ts(end). Removed. %d left\n',nEventsRemovedWith_tsHigherThanEnd, length(TD.x));
    
    
    % % TD.ts((1:10)+3e6) = 4e8;
    % % figure(1); plot(TD.ts); grid on
    if 1
        fprintf('Looking for backJumping time values. Negative time diffs found:\n');
        nNegTimeEventsRemovedFromTd = 0;
        negTimeDiffFirstIndexArray = nan;
        idxToRemoveDueToBackwardTimeAll   = [];
        idxToRemoveDueToBackwardTimeAllx  = [];
        idxToRemoveDueToBackwardTimeAlly  = [];
        idxToRemoveDueToBackwardTimeAllts = [];
        idxToRemoveDueToBackwardTimeAllp  = [];
        timeDiffSearchingAttempts=1;
        oldNumberOfNegTimeDiffs = inf;
        while ~isempty(negTimeDiffFirstIndexArray)
            nEventsLeftInTd = numel(TD.ts);
            diffTs = TD.ts(2:(nEventsLeftInTd)) - TD.ts(1:(nEventsLeftInTd-1));
            diffNegRect = min(diffTs,0);
            negTimeDiffFirstIndexArray = find(diffNegRect<0);
            numberOfNegTimeDiffs = numel(negTimeDiffFirstIndexArray);
            if oldNumberOfNegTimeDiffs ==  numberOfNegTimeDiffs
                numIndexToJumpForwardBy = numIndexToJumpForwardBy*2;
                fprintf('\n%d (%d) \n', numberOfNegTimeDiffs,numIndexToJumpForwardBy);
            else
                numIndexToJumpForwardBy = 1;
                fprintf('%d ', numberOfNegTimeDiffs);
            end
            
            oldNumberOfNegTimeDiffs = numberOfNegTimeDiffs;
            if mod(timeDiffSearchingAttempts,10)==0
                fprintf('\n');
            end
            timeDiffSearchingAttempts=timeDiffSearchingAttempts+1;
            idxToRemoveDueToBackwardTime = negTimeDiffFirstIndexArray(:);
            for k = 1:numIndexToJumpForwardBy
                negTimeDiffEndIndexArray = min(negTimeDiffFirstIndexArray+k,nEventsLeftInTd);            %min(negTimeDiffFirstIndexArray+k,nEventsLeftInTd);
                idxToRemoveDueToBackwardTime = [idxToRemoveDueToBackwardTime  ; negTimeDiffEndIndexArray(:)]; %#ok<AGROW>
            end
            idxToRemoveDueToBackwardTimeAll   = [idxToRemoveDueToBackwardTimeAll    ;idxToRemoveDueToBackwardTime]; %#ok<AGROW>
            idxToRemoveDueToBackwardTimeAll   = idxToRemoveDueToBackwardTimeAll(:);
            idxToRemoveDueToBackwardTimeAllx  = [idxToRemoveDueToBackwardTimeAllx   ;mat2vec(TD.x(idxToRemoveDueToBackwardTime))]; %#ok<AGROW>
            idxToRemoveDueToBackwardTimeAllx = idxToRemoveDueToBackwardTimeAllx(:);
            idxToRemoveDueToBackwardTimeAlly  = [idxToRemoveDueToBackwardTimeAlly   ;mat2vec(TD.y(idxToRemoveDueToBackwardTime))]; %#ok<AGROW>
            idxToRemoveDueToBackwardTimeAlly = idxToRemoveDueToBackwardTimeAlly(:);
            idxToRemoveDueToBackwardTimeAllts = [idxToRemoveDueToBackwardTimeAllts  ;mat2vec(TD.ts(idxToRemoveDueToBackwardTime))]; %#ok<AGROW>
            idxToRemoveDueToBackwardTimeAllts = idxToRemoveDueToBackwardTimeAllts(:);
            idxToRemoveDueToBackwardTimeAllp  = [idxToRemoveDueToBackwardTimeAllp   ;mat2vec(TD.p(idxToRemoveDueToBackwardTime))]; %#ok<AGROW>
            idxToRemoveDueToBackwardTimeAllp  = idxToRemoveDueToBackwardTimeAllp(:);
            nNegTimeEventsRemovedFromTd = nNegTimeEventsRemovedFromTd + numel(idxToRemoveDueToBackwardTime(:));
            TD.ts(idxToRemoveDueToBackwardTime) = [];    TD.x(idxToRemoveDueToBackwardTime) = [];    TD.y(idxToRemoveDueToBackwardTime) = [];    TD.p(idxToRemoveDueToBackwardTime) = [];
        end; fprintf('TD Removed %d back jumping t values. %d events...  decreasing time 0\n',   nNegTimeEventsRemovedFromTd, length(TD.x));
    end
    TD.p(TD.p == 0) = -1;%-------map 0s to  -1s
    invalidIndicesDueToBadPolarity = ~((TD.p == 1) | (TD.p == -1));% not -1 or 1
    invalidpVals = unique(TD.p(invalidIndicesDueToBadPolarity));
    fprintf('Checking for invalid p values... ')
    if ~isempty(invalidpVals)
        fprintf('Invalid p values:\n')
        disp(invalidpVals)
    end
    nEventsRemovedDueToBadPolarity = sum(invalidIndicesDueToBadPolarity);
    TD.x(invalidIndicesDueToBadPolarity) = [];    TD.y(invalidIndicesDueToBadPolarity) = [];    TD.p(invalidIndicesDueToBadPolarity) = [];    TD.ts(invalidIndicesDueToBadPolarity) = [];  fprintf('%d p values invalid. Removed. %d events left. \n',nEventsRemovedDueToBadPolarity, length(TD.x));
    %%%% find xMax and yMax
    % xyMaxThreshold = 99.999;
    %
    invalidIndices = TD.x > xMax;
    nEventsRemovedDueToHigh_x = sum(invalidIndices);
    TD.x(invalidIndices) = [];    TD.y(invalidIndices) = [];    TD.p(invalidIndices) = [];    TD.ts(invalidIndices) = [];   fprintf('%d x values too high Removed. %d events left. \n',nEventsRemovedDueToHigh_x, length(TD.x));
    
    
    invalidIndices = TD.x < 1;
    nEventsRemovedDueToLow_x = sum(invalidIndices);
    TD.x(invalidIndices) = [];    TD.y(invalidIndices) = [];    TD.p(invalidIndices) = [];    TD.ts(invalidIndices) = [];   fprintf('%d x values too low. Removed. %d events left. \n',nEventsRemovedDueToLow_x, length(TD.x));
    
    
    invalidIndices = TD.y > yMax;
    nEventsRemovedDueToHigh_y = sum(invalidIndices);
    TD.x(invalidIndices) = [];    TD.y(invalidIndices) = [];    TD.p(invalidIndices) = [];    TD.ts(invalidIndices) = [];   fprintf('%d y values too high. Removed. %d events left. \n',nEventsRemovedDueToHigh_y, length(TD.x));
    
    
    invalidIndices = TD.y < 1;
    nEventsRemovedDueToLow_y = sum(invalidIndices);
    TD.x(invalidIndices) = [];    TD.y(invalidIndices) = [];    TD.p(invalidIndices) = [];    TD.ts(invalidIndices) = [];   fprintf('%d y values too low. Removed. %d events left. \n',nEventsRemovedDueToLow_y, length(TD.x));
    
    nEventsRemovedDueToHotPixels = 0;
    if ~isempty(prctHotPixelsToRemove)
        if prctHotPixelsToRemove ~= 0
            %  || isnan(prctHotPixelsToRemove)) || prctHotPixelsToRemove ~= 0 %REMOVE_HOT_PIXELS
            initialxyCoordsAreBadCount = 0;
            initialEventCountPerPixel    = zeros(xMax,yMax);
            initialEventCountPerPixelPos = zeros(xMax,yMax);
            initialEventCountPerPixelNeg = zeros(xMax,yMax);
            initialEventCountPerPixelBadPol = zeros(xMax,yMax);
            for iTd = 1:nEventsInOriginalTd
                if inputTD.p(iTd) == 1
                    x = inputTD.x(iTd);
                    y = inputTD.y(iTd);
                    try
                        initialEventCountPerPixelPos(x,y) = initialEventCountPerPixelPos(x,y)+1;
                    catch %if the x and y value are also corrupted ignore the event
                    end
                elseif inputTD.p(iTd) == -1
                    x = inputTD.x(iTd);
                    y = inputTD.y(iTd);
                    try
                        initialEventCountPerPixelNeg(x,y) = initialEventCountPerPixelNeg(x,y)+1;
                    catch  %if the x and y value are also corrupted ignore the event
                    end
                else
                    x = inputTD.x(iTd);
                    y = inputTD.y(iTd);
                    try
                        initialEventCountPerPixelBadPol(x,y) = initialEventCountPerPixelBadPol(x,y)+1;
                    catch % if the x and y value are also corrupted ignore the event
                    end
                end
                try
                    initialEventCountPerPixel(x,y) = initialEventCountPerPixel(x,y)+1;
                catch  %if the x and y value are also corrupted ignore the event (but keep a count)
                    initialxyCoordsAreBadCount = initialxyCoordsAreBadCount + 1;
                end
            end
            
            initialEventCountPerPixelBadTime = zeros(xMax,yMax);
            tsBeforeStartCount = 0;
            tsAfterEndCount = 0;
            idxToRemoveCauseTsIsBeforeStartTime = [];
            idxToRemoveCauseTsIsAfterEndTime    = [];
            for iTd = initialStartIndex:initialEndIndex %1:numel(idxToRemoveDueToBackwardTimeAllx)
                if  inputTD.ts(iTd)<initialStartTimeIn_uSec
                    tsBeforeStartCount =   tsBeforeStartCount +1;
                    idxToRemoveCauseTsIsBeforeStartTime(tsBeforeStartCount) = iTd;  %#ok<AGROW>
                end
                if inputTD.ts(iTd)>initialEndTimeIn_uSec
                    tsAfterEndCount = tsAfterEndCount + 1;
                    idxToRemoveCauseTsIsAfterEndTime(tsAfterEndCount) = iTd; %#ok<AGROW>
                end
            end
            idxToRemoveDueToBadTime = unique([idxToRemoveCauseTsIsBeforeStartTime(:);  idxToRemoveCauseTsIsAfterEndTime(:)]);
            nEventsToRemoveDueToBadTime = numel(idxToRemoveDueToBadTime);
            for indexOfIndex = 1:nEventsToRemoveDueToBadTime
                iTd = idxToRemoveDueToBadTime(indexOfIndex);
                x = inputTD.x(iTd);
                y = inputTD.y(iTd);
                try
                    initialEventCountPerPixelBadTime(x,y)=initialEventCountPerPixelBadTime(x,y)+1;
                catch %if the x and y value are also corrupted ignore the event
                end
            end
            
            
            eventCountThreshold = prctile(initialEventCountPerPixel(:),100-prctHotPixelsToRemove);
            
            figure(43432);clf;hold on;
            plot(sort(initialEventCountPerPixel(:)+.01),'lineWidth',1)
            plot(initialEventCountPerPixel(:)*0+eventCountThreshold,'--','lineWidth',1)
            set(gca,'yscale','log');   setFont(15); box on;
            grid on; xlabel('pixels in order of events'); ylabel('event count');
            legend('event count per pixel','hot pixel rejection threshold')
            invalidIndicesDueToHotPixels = zeros(size(TD.x));
            fprintf('Checking for hot pixels x = \n');
            iHotPixelRemoved = 0;
            cleanedEventCountPerPixelRemoved = zeros(xMax,yMax);
            for x = 1:xMax
                fprintf('%d ',x);
                if mod(x,10)==0
                    fprintf('\n');
                end
                for y = 1:yMax
                    if initialEventCountPerPixel(x,y) > eventCountThreshold
                        iHotPixelRemoved = iHotPixelRemoved +1;
                        hotPixelRemovedCoordArray(iHotPixelRemoved,:) = [x, y];
                        theseInvalidIndices =     (TD.x==x) & (TD.y==y);
                        invalidIndicesDueToHotPixels = theseInvalidIndices |  invalidIndicesDueToHotPixels;
                        cleanedEventCountPerPixel(x,y)        = 0;
                        cleanedEventCountPerPixelRemoved(x,y) = 1;
                    end
                end
            end
            fprintf('\n');
            try
                TD.x(invalidIndicesDueToHotPixels) = [];    TD.y(invalidIndicesDueToHotPixels) = [];    TD.p(invalidIndicesDueToHotPixels) = [];    TD.ts(invalidIndicesDueToHotPixels) = [];
            catch
            end
            nEventsRemovedDueToHotPixels =  sum(invalidIndicesDueToHotPixels);
            fprintf('TD Removed most active %.2f%% of most active pixels (%d).%d events removed %d events left... \n',prctHotPixelsToRemove,iHotPixelRemoved,nEventsRemovedDueToHotPixels, length(TD.x));
            
            cleanedEventCountPerPixel        = zeros(xMax,yMax);
            cleanedEventCountPerPixelPos     = zeros(xMax,yMax);
            cleanedEventCountPerPixelNeg     = zeros(xMax,yMax);
            nEventsLeftInTd                  = numel(TD.ts);
            
            for iTd = 1:nEventsLeftInTd
                if TD.p(iTd) == 1
                    x = TD.x(iTd);
                    y = TD.y(iTd);
                   try cleanedEventCountPerPixelPos(x,y) = cleanedEventCountPerPixelPos(x,y)+1;
                   catch
                   end
                elseif TD.p(iTd) == -1
                    x = TD.x(iTd);
                    y = TD.y(iTd);
                    cleanedEventCountPerPixelNeg(x,y) = cleanedEventCountPerPixelNeg(x,y)+1;
                end
                cleanedEventCountPerPixel(x,y) = cleanedEventCountPerPixel(x,y)+1;
            end
            
            if SHOW_CLEANED_UP_TD_RESULTS
                tdImageSubplotGap    = 0.005;
                tdImageSubplotMarg_h = 0.02;
                tdImageSubplotMarg_w = 0.03;
                
                hotPixelRemovalFigureNum = 576563;
                figure(hotPixelRemovalFigureNum); clf ;
                
                set(gcf,'units','pixels','position',[0 0  1600 1080]);
                subtightplot(4,4,1,tdImageSubplotGap,tdImageSubplotMarg_h,tdImageSubplotMarg_w);
                imagesc(initialEventCountPerPixel');
                title('On+Off Event Count (Original TD)','Color', 'r')
                axis image; colorbar;  xticks([]);
                
                subtightplot(4,4,5,tdImageSubplotGap,tdImageSubplotMarg_h,tdImageSubplotMarg_w);
                imagesc((cleanedEventCountPerPixel'));
                title('On+Off Event Count  (Cleaned TD)')
                axis image;        colorbar;xticks([]);
                
                subtightplot(4,4,9,tdImageSubplotGap,tdImageSubplotMarg_h,tdImageSubplotMarg_w);
                imagesc(log10(initialEventCountPerPixel)');
                title('log_1_0(On+Off Event Count) (Original TD)','Color', 'r')
                axis image; colorbar;xticks([]);
                
                
                subtightplot(4,4,13,tdImageSubplotGap,tdImageSubplotMarg_h,tdImageSubplotMarg_w);
                imagesc(log10(cleanedEventCountPerPixel'));
                title('log_1_0(On+Off Event Count)   (Cleaned TD)')
                axis image;        colorbar;
                
                subtightplot(4,4,2,tdImageSubplotGap,tdImageSubplotMarg_h,tdImageSubplotMarg_w);
                imagesc((initialEventCountPerPixelPos'));
                title('On Event Count  (Original TD)','Color', 'r')
                axis image;        colorbar; xticks([]); yticks([]);
                
                subtightplot(4,4,6,tdImageSubplotGap,tdImageSubplotMarg_h,tdImageSubplotMarg_w);
                imagesc(cleanedEventCountPerPixelPos');
                title('On Event Count  (Cleaned TD)')
                axis image;        colorbar; xticks([]); yticks([]);
                
                subtightplot(4,4,10,tdImageSubplotGap,tdImageSubplotMarg_h,tdImageSubplotMarg_w);
                imagesc(log10(initialEventCountPerPixelPos'));
                title('log_1_0(On Event Count)  (Original TD)','Color', 'r')
                axis image;        colorbar; xticks([]); yticks([]);
                
                subtightplot(4,4,14,tdImageSubplotGap,tdImageSubplotMarg_h,tdImageSubplotMarg_w);
                imagesc(log10(cleanedEventCountPerPixelPos'));
                title('log_1_0(On Event Count)  (Cleaned TD)')
                axis image;        colorbar; yticks([]);
                
                subtightplot(4,4,3,tdImageSubplotGap,tdImageSubplotMarg_h,tdImageSubplotMarg_w);
                imagesc((initialEventCountPerPixelNeg'));
                title('Off Event Count  (Original TD)','Color', 'r')
                axis image;        colorbar; xticks([]); yticks([]);
                
                subtightplot(4,4,7,tdImageSubplotGap,tdImageSubplotMarg_h,tdImageSubplotMarg_w);
                imagesc((cleanedEventCountPerPixelNeg'));
                title('Off Event Count  (Cleaned TD)')
                axis image;        colorbar;xticks([]); yticks([]);
                
                subtightplot(4,4,11,tdImageSubplotGap,tdImageSubplotMarg_h,tdImageSubplotMarg_w);
                imagesc(log10(initialEventCountPerPixelNeg'));
                title('log10(Off Event Count)  (Original TD)','Color', 'r')
                axis image;        colorbar;xticks([]); yticks([]);
                
                subtightplot(4,4,15,tdImageSubplotGap,tdImageSubplotMarg_h,tdImageSubplotMarg_w);
                imagesc(log10(cleanedEventCountPerPixelNeg'));
                title('log_1_0(Off Event Count)  (Cleaned TD)');
                axis image;        colorbar;yticks([]);
                
                subtightplot(4,4,4,tdImageSubplotGap,tdImageSubplotMarg_h,tdImageSubplotMarg_w);
                imagesc((initialEventCountPerPixelBadPol'));
                title('Bad Polarity Count (Original TD)','Color', 'r')
                axis image;         colorbar;xticks([]); yticks([]);
                
                subtightplot(4,4,8,tdImageSubplotGap,tdImageSubplotMarg_h,tdImageSubplotMarg_w);
                imagesc((cleanedEventCountPerPixelRemoved'));
                title('Suspected Hot Pixels Removed')
                axis image;            cbr = colorbar;
                set(cbr,'YTick',0:1);xticks([]); yticks([]);
                cbr.TickLabels(1) = {'Keep'};
                cbr.TickLabels(2) = {'Drop'};
                
                subtightplot(4,4,12,tdImageSubplotGap,tdImageSubplotMarg_h,tdImageSubplotMarg_w);
                imagesc((initialEventCountPerPixelBadTime'));
                title('Bad Time Stamp Count (Original TD)','Color', 'r')
                axis image;         colorbar;xticks([]); yticks([]);
                
                figure(42342)
                imagesc(initialEventCountPerPixelPos-initialEventCountPerPixelNeg);
                axis image;         colorbar;
            end
        end
    end

    
    if PRE_FILTER_TD
        fprintf('Filtering TD...')
        TD = myFilterTD(TD, preFilterTimeIn_uSec, preFilterRadius);
        fprintf('TD Done! %d events... \n', length(TD.x));
    end
    nEventsInCleanedTd = numel(TD.ts);
    
    
    if SHOW_CLEANED_UP_TD_RESULTS
        
        tdSubplotGap      = 0.05;
        tdSubplotMarg_h   = 0.06;
        tdSubplotMarg_w  = 0.03;
        hotPx =  prctHotPixelsToRemove;
        tdDataSubplotStructure = reshape(1:(6*8),8,6)';
        cleanUpResultPlotFigureNum = 432771;
        figure(cleanUpResultPlotFigureNum); clf ;
        set(gcf,'units','pixels','position',[0 0  1920 1080]);
        subtightplot(6,8,1:8:41,tdSubplotGap,tdSubplotMarg_h,tdSubplotMarg_w); cla; hold on;  %%--------------- Polarity
        inputTdPolarityArray = inputTD.p;
        inputTdPolarityArray(inputTdPolarityArray > 1) = 3;
        inputTdPolarityArray(inputTdPolarityArray < -1) = 3;
        inputTdPolarityArray(inputTdPolarityArray == 0 ) = 3;
        inputTdCategories = categorical(inputTdPolarityArray,[  -1 1  3],{'-1' '1' 'other values'});
        tdPolarityArray = TD.p;
        tdPolarityArray(tdPolarityArray > 1) = 3;
        tdPolarityArray(tdPolarityArray < -1) = 3;
        tdPolarityArray(tdPolarityArray == 0 ) = 3;
        tdCategories = categorical(tdPolarityArray,[  -1 1  3],{'-1' '1' 'other values'});
        histogram(inputTdCategories,'BarWidth',0.9);
        histogram(tdCategories,'BarWidth',0.9);
        legend('Original Time Data','Processed Time Data');
        ylabel('# of Events');
        grid on;
        title(['Event Polarity' newline newline newline]);
        subtightplot(6,8,2:8,tdSubplotGap,tdSubplotMarg_h,tdSubplotMarg_w); hold on;  %%--------------- x
        otherValuesxTickLocation = -10;
        inputTdxArray = inputTD.x;
        inputTdxArray(inputTdxArray < 1)    = otherValuesxTickLocation;
        inputTdxArray(inputTdxArray > xMax) = otherValuesxTickLocation;
        histogram(inputTdxArray)
        histogram(TD.x,ceil(xMax))
        xlim([2*otherValuesxTickLocation, xMax+2] )
        xlabel('x Coordinate of Events (in pixels)');
        ylabel('# of Events');
        set(gca,'yscale','log');
        grid on;
        originalxTickLabels = xticklabels;
        originalxticks = xticks;
        indexOfZeroInxTicks = find(originalxticks==0);
        originalxticks(   indexOfZeroInxTicks ) = 1;
        originalxTickLabels{indexOfZeroInxTicks} = '1';
        originalxticks = originalxticks( indexOfZeroInxTicks:end);
        originalxTickLabels =      originalxTickLabels(indexOfZeroInxTicks:end);
        if ~ismember(yMax,originalxticks)
            originalxticks(end+1) = xMax;    originalxTickLabels{end+1} = num2str(xMax);
        end
        originalxticks(1:end+1) = [otherValuesxTickLocation originalxticks(1:end)];
        originalxTickLabels(2:end+1) =  originalxTickLabels(1:end);
        originalxTickLabels(1) = {'other'};
        xticks(originalxticks)
        xticklabels(originalxTickLabels)
        
        subtightplot(6,8,10:16,tdSubplotGap,tdSubplotMarg_h,tdSubplotMarg_w); hold on;  %%--------------- y
        otherValuesyTickLocation = -10;
        inputTdyArray = inputTD.y;
        inputTdyArray(inputTdyArray < 1) =  otherValuesyTickLocation;
        inputTdyArray(inputTdyArray > yMax) = otherValuesyTickLocation;
        histogram(inputTdyArray)
        histogram(TD.y,yMax)
        xlim([2*otherValuesyTickLocation, yMax+2] )
        xlabel('y Coordinate of Events (in pixels)');
        ylabel('# of Events');
        set(gca,'yscale','log');
        grid on;
        originalxTickLabels = xticklabels;
        originalxticks = xticks;
        indexOfZeroInxTicks = find(originalxticks==0);
        originalxticks(   indexOfZeroInxTicks ) = 1;
        originalxTickLabels{indexOfZeroInxTicks} = '1';
        originalxticks = originalxticks( indexOfZeroInxTicks:end);
        originalxTickLabels =      originalxTickLabels(indexOfZeroInxTicks:end);
        if ~ismember(yMax,originalxticks)
            originalxticks(end+1) = yMax;    originalxTickLabels{end+1} = num2str(yMax);
        end
        originalxticks(1:end+1) = [otherValuesyTickLocation originalxticks(1:end)];
        originalxTickLabels(2:end+1) =  originalxTickLabels(1:end);
        originalxTickLabels(1) = {'other'};
        xticks(originalxticks)
        xticklabels(originalxTickLabels)
        
        subtightplot(6,8,[18:20 26:28 34:36 42:44],tdSubplotGap,tdSubplotMarg_h,tdSubplotMarg_w); hold on;  %%--------------- ts
        plot(1:nEventsInOriginalTd, inputTD.ts);
        plot(initialStartIndex+(1:nEventsInCleanedTd)', TD.ts);
        grid on;
        %set(gca,'yscale','log'),
        legend('Original Time Data timeStamps','Processed Time Data timeStamps','location','northwest')
        ylabel('Time Stamp in (\musec)'); xlabel('Event Index') ;
        
        subtightplot(6,8,[21 22  29 30],tdSubplotGap,tdSubplotMarg_h,tdSubplotMarg_w); hold on;  %%--------------- dt original log
        inputTdDtArray = inputTD.ts(2:end)-inputTD.ts(1:(end-1));
        dt99thPrctile = prctile(inputTdDtArray,99);
        dt99thPrctileRoundedToOrderOfMagnitude = 10^floor(log10(dt99thPrctile));
        inputTdTanhDtArray = tanh(inputTdDtArray/dt99thPrctileRoundedToOrderOfMagnitude);
        tdDtArray =  TD.ts(2:end)-TD.ts(1:(end-1));
        tdDtTanhArray = tanh(tdDtArray/dt99thPrctileRoundedToOrderOfMagnitude);
        histogram(inputTdDtArray);
        ylabel('# of Events');
        xlabel('\Deltats (\musec)');
        grid on;
        set(gca,'yscale','log');
        set(gca,'xscale','log')
        
        subtightplot(6,8,[23 24  31 32],tdSubplotGap,tdSubplotMarg_h,tdSubplotMarg_w); hold on;  %%--------------- dt original tanh
        histogram(inputTdTanhDtArray);
        xlabel(['tanh(\Deltats/' num2str(dt99thPrctileRoundedToOrderOfMagnitude) ')']);
        ylabel('# of Events');
        set(gca,'yscale','log');
        xlim([-1.1 1.1])
        grid on;
        
        subtightplot(6,8,[39 40 47 48],tdSubplotGap,tdSubplotMarg_h,tdSubplotMarg_w); hold on;  %%--------------- dt processed tanh
        histogram(tdDtTanhArray);
        ylabel('# of Events');
        xlabel(['tanh(\Deltats/' num2str(dt99thPrctileRoundedToOrderOfMagnitude) ')']);
        grid on;
        set(gca,'yscale','log');
        xlim([-1.1 1.1])
        
        subtightplot(6,8,[37 38 45 46],tdSubplotGap,tdSubplotMarg_h,tdSubplotMarg_w); hold on;  %%--------------- dt processed log
        histogram(tdDtArray);
        ylabel('# of Events');
        xlabel('\Delta ts (\musec)');
        grid on;
        set(gca,'yscale','log');
        set(gca,'xscale','log')
        %title([ 'Inter-Spike-Interval hotPx:' num2str(hotPx) '% preFilt[Rad,Time]=[' num2str(preFiltRad) ',' num2str(preFiltTime) ']'], 'Interpreter', 'none');
        %title([ ' hotPx:' num2str(hotPx) '% preFilt[Rad,Time]=[' num2str(preFiltRad) ',' num2str(preFiltTime) ']'], 'Interpreter', 'none');
    end
    
    %--- Paramters
    try
        CleanUpTdParameters.prctHotPixelsToRemove = prctHotPixelsToRemove;
    end
    try
        CleanUpTdParameters.givenStartTimeIn_uSec = givenStartTimeIn_uSec;
        CleanUpTdParameters.givenEndTimeIn_uSec   = givenEndTimeIn_uSec;
    end
    try
        CleanUpTdParameters.preFilterTimeIn_uSec  = preFilterTimeIn_uSec;
        CleanUpTdParameters.preFilterRadius       = preFilterRadius;
    end
    %--- Results
    CleanUpTdResults.initialStartTimeIn_uSec        = initialStartTimeIn_uSec;
    CleanUpTdResults.initialEndTimeIn_uSec          = initialEndTimeIn_uSec;
    CleanUpTdResults.initialStartIndex              = initialStartIndex;
    CleanUpTdResults.initialEndIndex                = initialEndIndex;
    
    CleanUpTdResults.nNegTimeEventsRemovedFromTd    = nNegTimeEventsRemovedFromTd;
    CleanUpTdResults.nEventsRemovedDueToBadPolarity = nEventsRemovedDueToBadPolarity;
    
    
    try      
        tdNeg = removePolaritiesFromTd(TD,1);
        negDurationInSeconds = (tdNeg.ts(end)-tdNeg.ts(1))/1e6;
        aa = cleanedEventCountPerPixelNeg(:);
        b = prctile(aa,5);
        c = prctile(aa,95);        
        dd = aa(b<aa & aa<c);
        CleanUpTdResults.meanPixelEventPerSecOff= mean(dd)/negDurationInSeconds;
    catch
    end
    try
        tdPos = removePolaritiesFromTd(TD,-1);
        posDurationInSeconds = (tdPos.ts(end)-tdPos.ts(1))/1e6;
        aa = cleanedEventCountPerPixelPos(:);
        b = prctile(aa,5);
        c = prctile(aa,95);        
        dd = aa(b<aa & aa<c);                
        CleanUpTdResults.meanPixelEventPerSecOn= mean(dd)/posDurationInSeconds;        
            catch

    end
    try
        CleanUpTdResults.nEventsRemovedDueToHigh_x      = nEventsRemovedDueToHigh_x;
        CleanUpTdResults.nEventsRemovedDueToLow_x       = nEventsRemovedDueToLow_x;
        CleanUpTdResults.nEventsRemovedDueToLow_y       = nEventsRemovedDueToLow_y;
        CleanUpTdResults.nEventsRemovedDueToHotPixels   = nEventsRemovedDueToHotPixels;
    end
    try
        CleanUpTdResults.hotPixelRemovedCoordArray      = hotPixelRemovedCoordArray;
    end
end
if nargout >1
    varargout{1} = CleanUpTdResults;
end
if nargout >2
    varargout{2} = CleanUpTdParameters;
end