function [Result,varargout] = compareDetectionTdToUserInput(TD,userInputCellArray,surfaceSamplingTimeArray,DetectToObjectMappingParameters,varargin)
%[Result]                  = compareDetectionTdToUserInput(detTd,userInputCellArray,surfaceSamplingTimeArray,DetectToObjectMappingParameters,objectClassCellArray)
%[Result,detTdWithMapping] = compareDetectionTdToUserInput(detTd,userInputCellArray,surfaceSamplingTimeArray,DetectToObjectMappingParameters,objectClassCellArray)

%%% DetectToObjectMappingParameters  --------------------------------------------------------------------------------------------------------
xMax = DetectToObjectMappingParameters.xMax;
yMax = DetectToObjectMappingParameters.yMax;
surfaceSampleInterval = DetectToObjectMappingParameters.surfaceSampleInterval; %#ok<NASGU> % for 100Hz : 10000*
plausibleDistanceThreshold = double(DetectToObjectMappingParameters.plausibleDistanceThreshold); % = 10;
nPlausibleDistanceThreshold = numel(plausibleDistanceThreshold);

try    meanMethod  = DetectToObjectMappingParameters.meanMethod;
catch  meanMethod = 'nanmean';
end
try    SHOW_COMPARISON_FIGURES = DetectToObjectMappingParameters.SHOW_COMPARISON_FIGURES;
catch  SHOW_COMPARISON_FIGURES = 0;
end
try    RECORD_DETAILED_RESULTS =  DetectToObjectMappingParameters.RECORD_DETAILED_RESULTS;
catch  RECORD_DETAILED_RESULTS = 1;
end
try    tdFileName              = DetectToObjectMappingParameters.FeatureDetectionParameters.tdFileName;
catch
    try        tdFileName      = DetectToObjectMappingParameters.UserInputGettingParameters.fullTdFileName;
    catch      tdFileName      = '';
    end
end
try   densityFactorSweepArray = DetectToObjectMappingParameters.densityFactorSweepArray;
catch     densityFactorSweepArray = 1;
end

totalSensorArea = xMax*yMax;
interFrameInterval =  mode(diff(surfaceSamplingTimeArray));
oneFrameTotalVolume = interFrameInterval*totalSensorArea;
trueArea = pi*plausibleDistanceThreshold.^2;
trueVolume   = trueArea*interFrameInterval;

recordingDuration = surfaceSamplingTimeArray(end)-surfaceSamplingTimeArray(1);
totalVolume = totalSensorArea*recordingDuration;

nEventsInDetTd                       = numel(TD.ts);
 meanDensity        =  nEventsInDetTd/totalVolume;

try
    polarityOfDetTd = 2*(TD.p(1)==1)-1;
catch
    polarityOfDetTd = 1;
end
objectClassCellArray                 = {};
%%% Check if each object's class was given else assume irregular clss for all -----------------------------------------
EMPTY_USER_INPUT_FLAG = 0;
if isempty(userInputCellArray)
    EMPTY_USER_INPUT_FLAG = 1;
    nFrame                = numel(surfaceSamplingTimeArray);
    nObj                  = 0;
else
    nFrame                = numel(surfaceSamplingTimeArray);
    [~, nObj]        = size(userInputCellArray{1});
    if nObj == 0
        EMPTY_USER_INPUT_FLAG = 1;
    end
end

%if 1%~EMPTY_USER_INPUT_FLAG
if nargin<5 || isempty(varargin{1})
    objectClassCellArray = {-ones(1,nObj)}; % irregular objects are the default
else
    objectClassCellArray =  varargin{1};
end



DetectToObjectMappingParameters.nFrame = nFrame;     % FOR SPEED UP! DONT REMOVE.
DetectToObjectMappingParameters.nObj    = nObj; % FOR SPEED UP! DONT REMOVE.

meanInterpedUserInputArray                = calculateMeanInterpedUserInputFromUserInputCellArray(userInputCellArray,xMax,yMax,objectClassCellArray,meanMethod);
userObjectPresentPerFrame                 = ~isnan(meanInterpedUserInputArray);

%surfaceSamplingTimeArray1 = surfaceSamplingTimeArray(1):1000:surfaceSamplingTimeArray(end);

noiseDetectCountPerFrame                  = zeros(nFrame,1);
objectDetectCountPerFrame                 = zeros(nFrame,nObj,nPlausibleDistanceThreshold);
tooFarDetectCountPerFrame                 = objectDetectCountPerFrame;
truePositiveRatioPerFrame                 = objectDetectCountPerFrame;
trueNegativeRatioPerFrame                 = objectDetectCountPerFrame;
falsePositiveRatioPerFrame                = objectDetectCountPerFrame;
falseNegativeRatioPerFrame                = objectDetectCountPerFrame;

iEventPerFrame = cell(nFrame,1);
iFrame  = 1;
idxStart = 1;
%tFrameStart =  0;
tFrameEnd   =  surfaceSamplingTimeArray(1);
while iFrame <= (nFrame)
    % get all the events in this frame
    %idxEndPlusOne       = idxStart-1+find(detTd.ts(idxStart:end)>=tFrameEnd,1,'first');
    
    ii = idxStart;
    try
        while  TD.ts(ii)<tFrameEnd
            ii = ii +1;
        end
    catch
        ii = nEventsInDetTd+1;
    end
    
    idxEnd = ii - 1;
    idxThisFrameArray = idxStart:idxEnd;
    if isempty(idxThisFrameArray)
        iEventPerFrame{iFrame} = [];
        iFrame = iFrame +1;
        %tFrameStart  =  surfaceSamplingTimeArray(iFrame);
        try
            tFrameEnd    =  surfaceSamplingTimeArray(iFrame+1);
        catch
        end
        continue
    else
        iEventPerFrame{iFrame} = idxThisFrameArray;
    end
    %         idxThisFrameArrayNormed = idxThisFrameArray - min(idxThisFrameArray);
    %         idxThisFrameArrayNormed = idxThisFrameArrayNormed/max(idxThisFrameArrayNormed);
    %         if isnan(idxThisFrameArrayNormed)
    %             idxThisFrameArrayNormed = 0.5
    %         end
    %         try
    %             lastTs = detTd.ts(idxStart-1)
    %         end
    %         tFrameStart
    %         thisFrameTs = detTd.ts(idxThisFrameArray)'
    %         tFrameEnd
    %         nextTs = detTd.ts(idxEnd+1)
    %         iEventPerFrame{iFrame}
    %             figure(42342); clf; hold on;
    %             plot(surfaceSamplingTimeArray,'.b-')
    %             plot(idxThisFrameArrayNormed+iFrame,detTd.ts(idxThisFrameArray),'-m.')
    %             plot(iFrame,detTd.ts(idxStart),'or')
    %             plot(iFrame+1,detTd.ts(idxEnd),'or')
    %             plot(iFrame,tFrameStart,'bd')
    %             plot(iFrame+1,tFrameEnd,'bd')
    %             xlim([iFrame-.5,iFrame+1.5])
    %             ylim([0.9999*(tFrameStart - 10),1.0001*(tFrameEnd + 10)])
    %             grid on;
    %             drawnow
    idxStart     = idxEnd+1 ;
    if idxStart == nEventsInDetTd
        break % all the other frames will be be empty of events
    end
    iFrame       = iFrame + 1;
    %tFrameStart  =  surfaceSamplingTimeArray(iFrame);
    try
        tFrameEnd    =  surfaceSamplingTimeArray(iFrame+1);
    catch
        tFrameEnd    =  surfaceSamplingTimeArray(nFrame);
        idxEnd       = idxStart-1+find(TD.ts(idxStart:end)<=tFrameEnd,1,'last');
        idxThisFrameArray = idxStart:idxEnd;
        if isempty(idxThisFrameArray)
            iEventPerFrame{iFrame} = [];
        else
            iEventPerFrame{iFrame} =  idxThisFrameArray;
        end
    end
end
trueVolumePerObjPerDistPerFrame     = nan(nObj,nPlausibleDistanceThreshold,nFrame);
falseVolumePerDistPerFrame          = nan(nPlausibleDistanceThreshold,nFrame);
trueCountPerObjPerDistPerFrame      = zeros(nObj,nPlausibleDistanceThreshold,nFrame);
falseCountPerDistPerFrame           = zeros(nPlausibleDistanceThreshold,nFrame);
trueVolumePerObjPerDistArrayInitial = ones(nObj,1)*(pi*plausibleDistanceThreshold.^2)*interFrameInterval; %pixel^2*timeUnit


noEventTrueVolumeArray          = zeros(nObj,nPlausibleDistanceThreshold);
noEventFalseVolumeArray          = zeros(nPlausibleDistanceThreshold,1);
maxNumSimultaneousObjects = 0;
for iFrame = 1:nFrame
    if ~EMPTY_USER_INPUT_FLAG
        iExistingObjArray     = find(~isnan(meanInterpedUserInputArray(iFrame,:)));
    else
        iExistingObjArray = [];
    end
    nExistingObjectsThisFrame = numel(iExistingObjArray);
    if nExistingObjectsThisFrame>maxNumSimultaneousObjects
        maxNumSimultaneousObjects = nExistingObjectsThisFrame;
    end
    trueVolumePerObjPerDistArray = min(trueVolumePerObjPerDistArrayInitial,oneFrameTotalVolume/nExistingObjectsThisFrame);
    DetectToObjectMappingParameters.iExistingObjArray = iExistingObjArray;% for speed up
    iEventsThisFrame = iEventPerFrame{iFrame};
    % calculate the false and true volumes for this frame  --------------------------
    if nExistingObjectsThisFrame==0% if no object right now
        falseCountPerDistPerFrame(:,iFrame) =   numel(iEventsThisFrame);% all events are in false volume
        falseVolumePerDistPerFrame(:,iFrame)   = oneFrameTotalVolume;              % false volume is all
    else
        trueVolumePerObjPerDistPerFrame(iExistingObjArray,:,iFrame) = trueVolumePerObjPerDistArray(iExistingObjArray,:); % the true volumes for each space
        
        falseVolumePerDistPerFrame(:,iFrame)     = max(oneFrameTotalVolume - nansum(trueVolumePerObjPerDistPerFrame(:,:,iFrame),1),0);
        %         if numel(iExistingObjArray)>1
        %         end
        if any(falseVolumePerDistPerFrame(:,iFrame)<eps)
        end
        % there is atleast one object in this frame then  calculate the false and true volumes for this frame
        for idx = iEventsThisFrame
            t    = TD.ts(idx);
            x    = TD.x (idx);
            y    = TD.y (idx);
            MapResult = mapDetectionToObject(meanInterpedUserInputArray,objectClassCellArray{1},surfaceSamplingTimeArray,iFrame,x,y,t,DetectToObjectMappingParameters);
            if size(MapResult,1)>1
                ss = sum(MapResult,2);
                if any(ss(1)<ss(2:end))
                end
            end
            %if isnan(MapResult(1)) % Don't need no object right now  (taken care of above) %falseSpaceCount(iFrame)  = falseSpaceCount(iFrame) + 1;% add it to the false space
            % add it to the corresponding counts
            %trueVolumePerObjPerDistPerFrame(:,:,iFrame) = min(MapResult.*trueVolume,oneFrameTotalVolume/nExistingObjectsThisFrame);
            %falseVolumePerPerDistPerFrame(:,iFrame)   = max(oneFrameTotalVolume - sum(trueVolumePerObjPerDistPerFrame(:,:,iFrame)),0);
            
            
             %   trueCountPerObjPerDistPerFrame(1:nExistingObjectsThisFrame,:,iFrame) = trueCountPerObjPerDistPerFrame(1:nExistingObjectsThisFrame,:,iFrame) + MapResult;
                trueCountPerObjPerDistPerFrame( iExistingObjArray,:,iFrame) = trueCountPerObjPerDistPerFrame( iExistingObjArray,:,iFrame) + MapResult;
      
            falseCountPerDistPerFrame(:,iFrame) =     falseCountPerDistPerFrame(:,iFrame)  + ~any(MapResult,1)';
        end
    end
    
end
try
    if oneFrameTotalVolume<trueVolumePerObjPerDistArrayInitial(end)*maxNumSimultaneousObjects
        display('-----True volume was bigger than total oneFrameTotalVolume------------')
    end
end

  
      
trueCountPerDistPerFramePerObj   = permute(trueCountPerObjPerDistPerFrame,[2 3 1]);
trueVolumePerDistPerFramePerObj  = permute(trueVolumePerObjPerDistPerFrame,[2 3 1]);
trueDensityPerObjPerDistPerFrame = trueCountPerDistPerFramePerObj./trueVolumePerDistPerFramePerObj;
falseDensityPerDistPerFrame      = falseCountPerDistPerFrame./ falseVolumePerDistPerFrame;
iDensity = 0;

%for densityToTest = densityFactorSweepArray*meanDensity
for densityToTest = meanDensity
    iDensity = iDensity + 1;
    tpPerDistPerFramePerObj          = (trueDensityPerObjPerDistPerFrame> densityToTest) + trueDensityPerObjPerDistPerFrame*0;
    fnPerDistPerFramePerObj          = (trueDensityPerObjPerDistPerFrame<= densityToTest)  + trueDensityPerObjPerDistPerFrame*0;
    
    fpPerDistPerFrame                = falseDensityPerDistPerFrame> densityToTest;
    tnPerDistPerFrame                = ~fpPerDistPerFrame;
    tpPerDistPerFrame                = nanmean(tpPerDistPerFramePerObj,3);       
    fnPerDistPerFrame                = nanmean(fnPerDistPerFramePerObj,3);
    tpPerDistPerObj                  = permute(nanmean(tpPerDistPerFramePerObj,2),[1 3 2]);
    fnPerDistPerObj                  = permute(nanmean(fnPerDistPerFramePerObj,2),[1 3 2]);
    
    if EMPTY_USER_INPUT_FLAG
        tpPerDistPerFrame = fpPerDistPerFrame*0+1;
        fnPerDistPerFrame = fpPerDistPerFrame*0+0;
    end
    tpPerDist                = nanmean(tpPerDistPerFrame,2);
    tnPerDist                = nanmean(tnPerDistPerFrame,2);
    fnPerDist                = nanmean(fnPerDistPerFrame,2);
    fpPerDist                = nanmean(fpPerDistPerFrame,2);

        
    Result(iDensity).meanDensity       = meanDensity;
    Result(iDensity).densityThreshold  = densityToTest;
    Result(iDensity).tpPerDistPerObj   = single(tpPerDistPerObj);
    Result(iDensity).fnPerDistPerObj   = single(fnPerDistPerObj);
    Result(iDensity).tpPerDist         = single(tpPerDist);
    Result(iDensity).tnPerDist         = single(tnPerDist);
    Result(iDensity).fnPerDist         = single(fnPerDist);
    Result(iDensity).fpPerDist         = single(fpPerDist);
    Result(iDensity).sensitivity       = single(tpPerDist./(tpPerDist + fnPerDist));
    Result(iDensity).specificity       = single(nanmean(tnPerDistPerFrame./(tnPerDistPerFrame + fpPerDistPerFrame),2)); % tn/ false
    Result(iDensity).informedness      = single(Result(iDensity).sensitivity + Result(iDensity).specificity - 1);
    Result(iDensity).precision         = single(nanmean(tpPerDistPerFrame./(tpPerDistPerFrame+fpPerDistPerFrame),2));
    Result(iDensity).f1                = single(nanmean(2./(1./Result(iDensity).precision + 1./Result(iDensity).sensitivity),2));
end
totalProb = tpPerDist + tnPerDist + fpPerDist + fnPerDist;
if any(1e-5 < abs(diff(totalProb(:))))
    figure(534543); imagesc( totalProb ); colorbar;
end

if nObj >1
    
end
DetailedResults = [];

if nargout > 1
    varargout{1} = DetailedResults;
end

%display([meanDensity Result.informedness'])
% % % % % if rand>-1
% % % % %     return
% % % % % end


% figure(54353); clf; hold on;
% plot(plausibleDistanceThreshold',Result.sensitivity)
% plot(plausibleDistanceThreshold',Result.specificity)
% plot(plausibleDistanceThreshold',Result.informedness)
% plot(plausibleDistanceThreshold',Result.f1)
% plot(plausibleDistanceThreshold',Result.precision)
% grid on;
% legend('sns','spc','info','f1','precision')
% 
% 

% % % % % 
% % % % % % 
% % % % % % 
% % % % % % for ip = 1:nPlausibleDistanceThreshold
% % % % % %     figure(53543); clf; hold on;
% % % % % %     histogram(squeeze(trueCountPerObjPerDistPerFrame(1,ip,:)))
% % % % % %     histogram(squeeze(falseCountPerDistPerFrame(ip,:)))
% % % % % %     set(gca,'yscale','log')
% % % % % %     grid on;
% % % % % %     drawnow
% % % % % % end
% % % % % try
% % % % % xxx = 50;
% % % % % figure(4330);clf;
% % % % % subplot(4,1,1);  hold on;
% % % % % plot(plausibleDistanceThreshold', mean(squeeze(trueCountPerObjPerDistPerFrame(1,:,:)),2),'.')
% % % % % plot(plausibleDistanceThreshold', mean(falseCountPerDistPerFrame',1),'o')
% % % % % grid on; xlim([0 xxx]); ylabel('mean event count per frame'); legend('true', 'false')
% % % % % title(['total area: 100x100  mean event density= .1 event/(pixel^2 * frame)'])
% % % % % subplot(4,1,2);  hold on;
% % % % % plot(plausibleDistanceThreshold', mean(squeeze(trueVolumePerObjPerDistPerFrame(1,:,:)),2),'.')
% % % % % plot(plausibleDistanceThreshold', mean(falseVolumePerDistPerFrame',1),'o')
% % % % % grid on; xlim([0 xxx]); ylabel('mean event volume per frame'); legend('true', 'false')
% % % % % subplot(4,1,3);  hold on;
% % % % % plot(plausibleDistanceThreshold', mean(squeeze(trueDensityPerObjPerDistPerFrame(:,:,1)),2),'.')
% % % % % plot(plausibleDistanceThreshold', nanmean(falseDensityPerDistPerFrame,2)','o');
% % % % % grid on; xlim([0 xxx]); ylabel('mean event density'); legend('true', 'false')
% % % % % subplot(4,1,4);  hold on;
% % % % % fdm = falseDensityPerDistPerFrame'>meanDensity;
% % % % % tdm = (squeeze(trueDensityPerObjPerDistPerFrame(:,:,1))>meanDensity)';
% % % % % plot(plausibleDistanceThreshold', nanmean(tdm,1),'.')
% % % % % plot(plausibleDistanceThreshold', nanmean(fdm,1),'o')
% % % % % grid on; xlim([0 xxx]); ylabel('mean TP and TN '); legend('Mean higher than expected density in true region (over frames) = TP','Mean higher than expected density in false region (over frames) = FP')
% % % % % xlabel('Acceptance radius from label (pixels)')
% % % % % 
% % % % % 
% % % % % 
% % % % % figure(4341);clf; hold on;
% % % % % plot(plausibleDistanceThreshold', nanmean(falseDensityPerDistPerFrame,2)','o');
% % % % % plot(plausibleDistanceThreshold', mean(squeeze(trueDensityPerObjPerDistPerFrame(:,:,1)),2),'.')
% % % % % try
% % % % %     
% % % % %     plot(plausibleDistanceThreshold', mean(squeeze(trueDensityPerObjPerDistPerFrame(:,:,1)),2),'.')
% % % % % end
% % % % % title('density1')
% % % % % 
% % % % % figure(4342);clf; hold on;
% % % % % fdm = falseDensityPerDistPerFrame'>meanDensity;
% % % % % tdm = (squeeze(trueDensityPerObjPerDistPerFrame(1,:,:))>meanDensity)';
% % % % % plot(plausibleDistanceThreshold', nanmean(fdm,1),'ro')
% % % % % %plot(plausibleDistanceThreshold', -nanstd(fdm,1) + nanmean(fdm,1),'r-')
% % % % % %plot(plausibleDistanceThreshold', +nanstd(fdm,1) + nanmean(fdm,1),'r-')
% % % % % plot(plausibleDistanceThreshold', nanmean(tdm,1),'b.')
% % % % % %plot(plausibleDistanceThreshold',+nanstd(tdm,1) + nanmean(tdm,1),'b-')
% % % % % %plot(plausibleDistanceThreshold',-nanstd(tdm,1) + nanmean(tdm,1),'b-')
% % % % % grid on;
% % % % % 
% % % % % 
% % % % % try
% % % % %     plot(plausibleDistanceThreshold', nanmean(squeeze(trueDensityPerObjPerDistPerFrame(2,:,:))>meanDensity,2),'s')
% % % % % end
% % % % % 
% % % % % figure(4343);clf; hold on;
% % % % % plot(plausibleDistanceThreshold', mean(falseCountPerDistPerFrame',1),'o')
% % % % % plot(plausibleDistanceThreshold', mean(squeeze(trueCountPerObjPerDistPerFrame(1,:,:)),2),'.')
% % % % % try
% % % % %     plot(plausibleDistanceThreshold', mean(squeeze(trueCountPerObjPerDistPerFrame(2,:,:)),2),'s')
% % % % % end
% % % % % 
% % % % % figure(4344);clf; hold on;
% % % % % plot(plausibleDistanceThreshold', mean(falseVolumePerDistPerFrame',1),'o')
% % % % % plot(plausibleDistanceThreshold', mean(squeeze(trueVolumePerObjPerDistPerFrame(1,:,:)),2),'.')
% % % % % try
% % % % %     plot(plausibleDistanceThreshold', mean(squeeze(trueVolumePerObjPerDistPerFrame(2,:,:)),2),'s')
% % % % % end
% % % % % 
% % % % % 
% % % % % 
% % % % % figure(4345);clf; hold on;
% % % % % plot(plausibleDistanceThreshold', nanmean((falseCountPerDistPerFrame./falseVolumePerDistPerFrame)',1),'o')
% % % % % plot(plausibleDistanceThreshold', mean(squeeze(trueCountPerObjPerDistPerFrame(1,:,:)./trueVolumePerObjPerDistPerFrame(1,:,:)),2),'.')
% % % % % try
% % % % %     plot(plausibleDistanceThreshold', mean(squeeze(trueCountPerObjPerDistPerFrame(2,:,:)./trueVolumePerObjPerDistPerFrame(2,:,:)),2),'s')
% % % % % end
% % % % % title('density2')
% % % % % 
% % % % % 
% % % % % figure(4346);clf; hold on;
% % % % % plot(plausibleDistanceThreshold', prctile(falseDensityPerDistPerFrame',1),'.')
% % % % % plot(plausibleDistanceThreshold', prctile(falseDensityPerDistPerFrame',25),'^')
% % % % % 
% % % % % plot(plausibleDistanceThreshold', prctile(falseDensityPerDistPerFrame',35),'*')
% % % % % plot(plausibleDistanceThreshold', prctile(falseDensityPerDistPerFrame',50),'+')
% % % % % plot(plausibleDistanceThreshold', prctile(falseDensityPerDistPerFrame',65),'*')
% % % % % plot(plausibleDistanceThreshold', prctile(falseDensityPerDistPerFrame',75),'v')
% % % % % plot(plausibleDistanceThreshold', prctile(falseDensityPerDistPerFrame',99),'.')
% % % % % 
% % % % % plot(plausibleDistanceThreshold', mean(falseDensityPerDistPerFrame'),'o')
% % % % % plot(plausibleDistanceThreshold', mean(squeeze(trueCountPerObjPerDistPerFrame(1,:,:)./trueVolumePerObjPerDistPerFrame(1,:,:)),2),'.')
% % % % % end
% % % % % 
% % % % % 
% % % % % drawnow