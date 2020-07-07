function Result = getObjAgreementStatsFromUserInputCellArray(userInputCellArray,xMax,yMax,varargin )
%getObjStatsFromUserInputCellArray Summary of this function goes here
%   Detailed explanation goes here
if ~(isempty(userInputCellArray) || size(userInputCellArray{1},2) == 0)  % no users  || no objs
    CALCULATE_PAIR_WISE_DISTANCE = rand>5;
    nUser                = numel(userInputCellArray);
    [nFrame, nObj]       = size(userInputCellArray{1});
    if nargin<4 || isempty(varargin{1})
        objectClassArray = -ones(1,nObj);
    else
        objectClassArray =  varargin{1};
    end
    if nargin<5 || isempty(varargin{2})
        SHOW = 1;
    else
        SHOW =  varargin{2};
    end
    if iscell(objectClassArray)
        objectClassCellArray = objectClassArray;
        objectClassArray = objectClassCellArray{1};
    end
    interpedUserInputCellArray = interpolateUserInputCellArray(userInputCellArray,xMax,yMax,objectClassArray);
    
    xObjUserArray        = nan(nFrame,nUser,nObj);
    yObjUserArray        = xObjUserArray;
    for iObj = 1:nObj
        for iUser = 1:nUser
            interpedUserInputArray      = interpedUserInputCellArray{iUser};
            xObjUserArray(:,iUser,iObj) = real(interpedUserInputArray(:,iObj));
            yObjUserArray(:,iUser,iObj) = -real(interpedUserInputArray(:,iObj)*1i);
        end
    end
    mostConcurrentUserArray            = nan(1,nObj);
    firstDetectFrame               = nan(1,nObj);
    lastDetectFrame                = nan(1,nObj);
    firstAllUserDetectFrame        = nan(1,nObj);
    lastAllUserDetectFrame         = nan(1,nObj);
    nFramesWhereAllUsersSawObjects = nan(1,nObj);
    sumOfNonNansAcrossUsers        = zeros(nFrame,nObj,'uint8');
    
    for iObj = 1:nObj
        xAcrossUsersAndFrames                = xObjUserArray(:,:,iObj);
        sumOfNonNansAcrossUsers(:,iObj)      = sum(~isnan(xAcrossUsersAndFrames),2);
        mostConcurrentUserArray(iObj)        = max(sumOfNonNansAcrossUsers(:,iObj) ); % hopefully this is equal to nUser
        
        aa                                   = find(sumOfNonNansAcrossUsers(:,iObj) > 0  ,1,'first');
        bb                                   = find(sumOfNonNansAcrossUsers(:,iObj) > 0  ,1,'last');
        cc                                   = find(sumOfNonNansAcrossUsers(:,iObj) == nUser  ,1,'first');
        dd                                   = find(sumOfNonNansAcrossUsers(:,iObj) == nUser  ,1,'last');
        
        if ~isempty(aa)
            firstDetectFrame(iObj)               = aa;
            lastDetectFrame(iObj)                = bb;
        else
            firstDetectFrame(iObj)               = nan;
            lastDetectFrame(iObj)                = nan;
        end
        if ~isempty(cc)
            firstAllUserDetectFrame(iObj)        = cc;
            lastAllUserDetectFrame(iObj)         = dd;
            nFramesWhereAllUsersSawObjects(iObj) = lastAllUserDetectFrame(iObj) - firstAllUserDetectFrame(iObj);
        else
            firstAllUserDetectFrame(iObj)        = nan;
            lastAllUserDetectFrame(iObj)         = nan;
            nFramesWhereAllUsersSawObjects(iObj) = 0;
        end
    end
    
    
    lineObjArray  = [];
    for iObj = 1:nObj
        if objectClassArray(iObj)==1
            lineObjArray  = [lineObjArray iObj]; %#ok<AGROW>
        end
    end
    
    nTotalAllOnFrame               = sum(nFramesWhereAllUsersSawObjects);
    maxNumFramesToComparePerObject = 1000;
    nResampledFramesUsed            = nan(1,nObj);
    stdAllTogetherArray            = nan(nTotalAllOnFrame,1);
    stdAllLinesTogetherArray       = nan(sum(nFramesWhereAllUsersSawObjects(lineObjArray)),1);
    
    
    meanStdArray                   = nan(1,nObj);
    xyStdCellArray                 = cell(1,nObj);
    iFrameResampledCellArray       = cell(1,nObj);
    totalFrameCount                = 0;
    lineFrameCount                 = 0;
    for iObj = 1:nObj
        if ~isnan(firstAllUserDetectFrame(iObj))
            xxAll = xObjUserArray(firstAllUserDetectFrame(iObj):lastAllUserDetectFrame(iObj),:,iObj);
            yyAll = yObjUserArray(firstAllUserDetectFrame(iObj):lastAllUserDetectFrame(iObj),:,iObj);
            dxxAll = xxAll-mean(xxAll,2);
            dyyAll = yyAll-mean(yyAll,2);
            stdAll = sqrt(mean(dxxAll.^2 + dyyAll.^2,2));% mean(Sqrd(Err))
            if nFramesWhereAllUsersSawObjects(iObj)<maxNumFramesToComparePerObject
                iFrameResampledCellArray{iObj} = single(mat2vec(1:nFramesWhereAllUsersSawObjects(iObj)));
            else
                iFrameResampledCellArray{iObj} = single(mat2vec(round(linspace(1,nFramesWhereAllUsersSawObjects(iObj),maxNumFramesToComparePerObject))));
            end
            nResampledFramesUsed(iObj)         = numel(iFrameResampledCellArray{iObj});
            thisObjStdArray                   = nan(nResampledFramesUsed(iObj),1);
            for iFrameResampled = 1:nResampledFramesUsed(iObj)
                totalFrameCount                             = totalFrameCount + 1;
                iFrame                                      = iFrameResampledCellArray{iObj}(iFrameResampled);
                thisObjStdArray(iFrameResampled)            = stdAll(iFrame);
                stdAllTogetherArray(totalFrameCount)        = stdAll(iFrame);
                if CALCULATE_PAIR_WISE_DISTANCE
                    xyThisFrameThisObjAllUsers                = [xxAll(iFrame,:)' yyAll(iFrame,:)'];
                    pp                                        = pdist(xyThisFrameThisObjAllUsers);
                    pDistArray( : , iFrame ,iObj)             = pp'; %#ok<AGROW>
                end
            end
            if objectClassArray(iObj)==1
                for iFrameResampled = 1:nResampledFramesUsed(iObj)
                    lineFrameCount                            = lineFrameCount + 1;
                    iFrame                                    = iFrameResampledCellArray{iObj}(iFrameResampled);
                    stdAllLinesTogetherArray(lineFrameCount)  = stdAll(iFrame);
                    
                end
            end
            meanStdArray(iObj)   = mean(thisObjStdArray);
            xyStdCellArray{iObj} = single(thisObjStdArray);
        end
    end
    stdAllTogetherArray      = stdAllTogetherArray(1:totalFrameCount);
    stdAllLinesTogetherArray = stdAllLinesTogetherArray(1:lineFrameCount);
    if SHOW
        figure(42341);
        for iObj = nObj:-1:1
            subtightplot(2,nObj,iObj+nObj);
            imagesc(yObjUserArray(:,:,iObj));
            if ~isnan(firstDetectFrame(iObj))
                ylim([firstDetectFrame(iObj) lastDetectFrame(iObj)]);
            end
            colorbar;
            subtightplot(2,nObj,iObj)
            imagesc(xObjUserArray(:,:,iObj))
            if ~isnan(firstDetectFrame(iObj))
                ylim([firstDetectFrame(iObj) lastDetectFrame(iObj)]);
            end
            colorbar;
            title(['obj' num2str(iObj) ' :  ' num2str(objectClassArray(iObj))]);
            
            if iObj== 1 || iObj== nObj+1
                ylabel('iFrame')
            end
            if iObj== (nObj+1)
                xlabel('iUser')
            end
        end
        title('x y heatmap')
        
        figure(1423242);clf; hold on;
        plot(sumOfNonNansAcrossUsers);
        xlim([0 nFrame+1])
        ylim([-1 nUser+1])
        xlabel('Frames');ylabel('Users')
        title('sum Of User Detections')
        
        figure(1523542);clf; hold on;
        [nSubplotRow,nSubplotCol] = goodSubPlotRowCols(nObj);
        for iObj = 1:nObj
            subplot(nSubplotRow,nSubplotCol,iObj)
            histogram(xyStdCellArray{iObj}')
            grid on;
            title(['obj' num2str(iObj) ' :  ' num2str(objectClassArray(iObj))])
        end
        subplot(nSubplotRow,nSubplotCol,1)
        ylabel('nObs')
        xlabel('rmse (Pixels)')
        
        figure(1523543);clf; hold on;
        subplot(2,1,1)
        histogram(stdAllTogetherArray(:))
        grid on;
        ylabel('nObs')
        xlabel('rmse (Pixels)')
        subplot(2,1,2)
        histogram(stdAllLinesTogetherArray(:))
        grid on;
        ylabel('nObs')
        xlabel('line rmse (Pixels)')
        title('line rmse')
        if  CALCULATE_PAIR_WISE_DISTANCE
            figure(5235421);clf; hold on;
            [nSubplotRow,nSubplotCol] = goodSubPlotRowCols(nObj);
            for iObj = 1:nObj
                subplot(nSubplotRow,nSubplotCol,iObj)
                histogram(pDistArray(:, iFrameArray{iObj},iObj)')
                title(['obj' num2str(iObj) ' :  ' num2str(objectClassArray(iObj))])
                grid on;
            end
            subplot(nSubplotRow,nSubplotCol,1)
            ylabel('nObs')
            xlabel('Pair-Wise Distance (Pixels)')
            
            figure(5235431);clf;
            subplot(2,1,1)
            histogram(pDistArray(:))
            grid on;
            ylabel('nObs')
            xlabel('Pair-Wise Distance (Pixels)')
            title(tdFileName,'interpreter','none')
            
            subplot(2,1,2)
            histogram(mat2vec(pDistArray(:,:,lineObjArray)))
            grid on;
            ylabel('nObs')
            xlabel('Line Pair-Wise Distance (Pixels)')
        end
    end
    
    %-Results Calculation -----------------------
    onTogetherCountArray   = nan(1,nObj);
    offTogetherCountArray  = nan(1,nObj);
    disagreementCountArray = nan(1,nObj);
    for iObj = 1:nObj
        onTogetherCountArray(iObj)   =  sum(sumOfNonNansAcrossUsers(:,iObj)==nUser);
        offTogetherCountArray(iObj)  =  sum(sumOfNonNansAcrossUsers(:,iObj)==0);
        disagreementCountArray(iObj) =  sum(sumOfNonNansAcrossUsers(:,iObj)>0 & sumOfNonNansAcrossUsers(:,iObj)<nUser);
    end
    onTogetherRateArray   = onTogetherCountArray/nFrame;
    offTogetherRateArray  = offTogetherCountArray/nFrame;
    agreementRateArray    = (onTogetherCountArray + offTogetherCountArray)/nFrame;
    disagreementRateArray = disagreementCountArray/nFrame;
    allOnVsAnyOnRateArray = onTogetherCountArray./(onTogetherCountArray + disagreementCountArray);
    %-Results -----------------------
    Result.objectClassArray                = objectClassArray;
    Result.meanStdArray                    = meanStdArray;
    Result.xyStdCellArray                  = xyStdCellArray;
    Result.iFrameResampledCellArray        = iFrameResampledCellArray;
    Result.stdAllTogetherArray             = single(stdAllTogetherArray);
    Result.stdAllLinesTogetherArray        = single(stdAllLinesTogetherArray);
    Result.AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA  = '--------------------------------';
    Result.sumOfNonNansAcrossUsers         = sumOfNonNansAcrossUsers;
    Result.nFramesWhereAllUsersSawObjects  = nFramesWhereAllUsersSawObjects;
    Result.firstDetectFrame                = firstDetectFrame;
    Result.lastDetectFrame                 = lastDetectFrame;
    Result.mostConcurrentUserArray         = mostConcurrentUserArray;
    Result.firstAllUserDetectFrame         = firstAllUserDetectFrame;
    Result.lastAllUserDetectFrame          = lastAllUserDetectFrame;
    Result.maxNumFramesToComparePerObject  = maxNumFramesToComparePerObject;
    Result.ZZZZZZZZZZZZZZZZZZZZZZZ = '--------------------------------';
    Result.onTogetherCountArray    = onTogetherCountArray;
    Result.offTogetherCountArray   = offTogetherCountArray;
    Result.agreementCountArray     = onTogetherCountArray + offTogetherCountArray;
    Result.disagreementCountArray  = disagreementCountArray;
    Result.XXXXXXXXXXXXXXXXXXXXXXX = '--------------------------------';
    Result.onTogetherRateArray     = onTogetherRateArray;
    Result.offTogetherRateArray    = offTogetherRateArray;
    Result.agreementRateArray      = agreementRateArray;
    Result.disagreementRateArray   = disagreementRateArray;
    Result.allOnVsAnyOnRateArray   = allOnVsAnyOnRateArray;
    Result.OOOOOOOOOOOOOOOOOOOOOO  = '--------------------------------';
else
    Result = [];
end








