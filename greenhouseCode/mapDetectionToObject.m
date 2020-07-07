function            Result = mapDetectionToObject(meanInterpedUserInputArray,objectClassArray,surfaceSamplingTimeArray,iFrame,x,y,t,DetectToObjectMappingParameters)
surfaceSampleInterval      = DetectToObjectMappingParameters.surfaceSampleInterval;
plausibleDistanceThreshold = DetectToObjectMappingParameters.plausibleDistanceThreshold;
nPlausibleDistanceThreshold = numel(plausibleDistanceThreshold);
nFrame                      = DetectToObjectMappingParameters.nFrame; % for speed up
nObj                      = DetectToObjectMappingParameters.nObj;% for speed up
%iExistingObjArray     = find(~isnan(meanInterpedUserInputArray(iFrame,:)));
iExistingObjArray   = DetectToObjectMappingParameters.iExistingObjArray;% for speed up

if nObj == 0
    Result = nan;
    return
 end
nExistingObj      = numel(iExistingObjArray);
if nExistingObj == 0
    Result = nan;
    return
end
xUserNow   = nan+iExistingObjArray;
yUserNow   = xUserNow;
distanceFromDetecToUserObjArrary  = xUserNow;
iiObj = 0;
xUserArray = [nan;nan;nan];
yUserArray = xUserArray;
tUserArray = xUserArray;
for iObj = iExistingObjArray
    if ~isnan(meanInterpedUserInputArray(iFrame  ,iObj))
        iiObj = iiObj + 1;
        f = 1;
        if iFrame>1
            lastFrameThisObj = meanInterpedUserInputArray(iFrame-1,iObj);
            if ~isnan(lastFrameThisObj)
                xUserArray(f) =     real(lastFrameThisObj);
                yUserArray(f) = -real(1i*lastFrameThisObj);
                tUserArray(f) =            surfaceSamplingTimeArray(iFrame-1) ;
                f             = f + 1;
            end
        else
            mapDetectXXX = 1
        end
        xUserArray(f) =     real(meanInterpedUserInputArray(iFrame ,iObj));
        yUserArray(f) = -real(1i*meanInterpedUserInputArray(iFrame ,iObj));
        tUserArray(f)       =            surfaceSamplingTimeArray(iFrame) ;
        
        if iFrame<nFrame
            nextFrameThisObj = meanInterpedUserInputArray(iFrame+1  ,iObj);
            if ~isnan(nextFrameThisObj)
                f                   = f + 1;
                xUserArray(f) = real(nextFrameThisObj);
                yUserArray(f) = -real(1i*nextFrameThisObj);
                tUserArray(f)       = surfaceSamplingTimeArray(iFrame+1) ;
            end
        else
            mapDetectXXX = 1
        end
        %         iNoNan = isnan(xUserArray);
        %         xUserArray = xUserArray()
        dt = tUserArray(end)- tUserArray(1);
        if dt <= 0 || isnan(dt)
            xUserNow(1,iiObj) = xUserArray(f);
            yUserNow(1,iiObj) = yUserArray(f);
        else
            xUserNow(1,iiObj) =  xUserArray(1) + (t-tUserArray(1))*(xUserArray(f)- xUserArray(1)) /dt;
            yUserNow(1,iiObj) =  yUserArray(1) + (t-tUserArray(1))*(yUserArray(f)- yUserArray(1)) /dt;
        end
        %         try
        %             xUserNow(1,iiObj) = myInterp1(tUserArray(1:f),xUserArray(1:f),t,'linear','extrap');
        %         catch
        %             [C,ia,~] =unique(tUserArray(1:f));
        %             xUserNow(1,iiObj) = myInterp1(C,xUserArray(ia),t,'linear','extrap');
        %         end
        %         try
        %             yUserNow(1,iiObj) = myInterp1(tUserArray(1:f),yUserArray(1:f),t,'linear','extrap');
        %         catch            [C,ia,~] =unique(tUserArray(1:f));            yUserNow(1,iiObj) = myInterp1(C,yUserArray(ia),t,'linear','extrap');
        %         end
        distanceFromDetecToUserObjArrary(1,iiObj)        = sqrt((x - xUserNow(1,iiObj))^2 + (y - yUserNow(1,iiObj))^2);
    end
end


%[distanceToClosestUserObj , iiClosestUserObj] = min(distanceFromDetecToUserObjArrary);
 
Result  = plausibleDistanceThreshold>distanceFromDetecToUserObjArrary';








%
% [distanceToClosestUserObj , iiClosestUserObj] = min(distanceFromDetecToUserObjArrary);
%
% iClosestUserObj = iExistingObjArray( iiClosestUserObj);
% Result.status  = char(plausibleDistanceThreshold*0);
% for ipd = 1:nPlausibleDistanceThreshold
%     if  distanceToClosestUserObj > plausibleDistanceThreshold(ipd) % detection is too far from any user object
%         Result.status(ipd)                   = 'f'; % far
%     else
%         Result.status(ipd)                   = 'w';
%     end
% end
% Result.iClosestUserObj          = iClosestUserObj;
% Result.distanceToClosestUserObj = distanceToClosestUserObj;



