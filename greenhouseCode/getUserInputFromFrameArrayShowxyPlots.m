function getUserInputFromFrameArrayShowxyPlots(userInputCellArray,varargin)

if iscell(userInputCellArray)
    nUserInputs = numel(userInputCellArray);
else
    
end
nFrame = size(userInputArray,1);
if nargin>1
    iFrame = varargin{1};
else
    iFrame = nFrame;
end
numObsPerObject = sum(~isnan(userInputArray),1);
nExistingObjects = find(numObsPerObject>0,1,'last');
if isempty(nExistingObjects)
    nExistingObjects = 0;
end
figure(5343453); clf;
subplot(2,1,1); cla;
subplot(2,1,2); cla;
for iToShowObject = 1:nExistingObjects
    if numObsPerObject(iToShowObject)>0
        xObs = real(userInputArray(:,iToShowObject))';
        yObs = imag(userInputArray(:,iToShowObject))';
        yObs(yObs==0) = nan;
        subplot(2,1,1); hold on;
        %plot(xObs,'.','color',colorArray(:,iToShowObject));
        
        if iToShowObject==iObject
            plot(xObs,'o','markerSize',6);
            indexOfFramesOfLastObs = find(~isnan(userInputArray(1:iFrame,iToShowObject)),nObservationsToShow,'last');
            for iObs = 1:numel(indexOfFramesOfLastObs)
                xRecent = real(userInputArray(indexOfFramesOfLastObs(iObs),iToShowObject));
                plot(indexOfFramesOfLastObs(iObs),xRecent,'*k');
            end
        else
            plot(xObs,'.','markerSize',9);
        end
        
        grid on;
        subplot(2,1,2); hold on;
        if iToShowObject==iObject
            plot(yObs,'o','markerSize',6);
            indexOfFramesOfLastObs = find(~isnan(userInputArray(1:iFrame,iToShowObject)),nObservationsToShow,'last');
            for iObs = 1:numel(indexOfFramesOfLastObs)
                yRecent = imag(userInputArray(indexOfFramesOfLastObs(iObs),iToShowObject));
                plot(indexOfFramesOfLastObs(iObs),yRecent,'*k');
            end
        else
            plot(yObs,'.','markerSize',9);
        end
        grid on;
    end
end
subplot(2,1,1);
plot([iFrame iFrame],[xMax,xMax],':k')
subplot(2,1,2);
plot([iFrame iFrame],[yMax,yMax],':k')