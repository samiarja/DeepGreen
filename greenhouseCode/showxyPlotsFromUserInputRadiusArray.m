function showxyPlotsFromUserInputRadiusArray(userInputRadiusArray,varargin)
interpObjLineWidth = 1;
SHOW_RAW_USER_INPUT_MARKINGS = 1;
userMarkingMarkerSize = 9;
nFrame = size(userInputArray,1);
if nargin>2
    interpedUserInputRadius = varargin{2};
    if isempty(interpedUserInputRadius)
        INTERPED_USER_INPUT_RADIUS_IS_EMPTY = 1;
    else
        INTERPED_USER_INPUT_RADIUS_IS_EMPTY = 0;
    end
else
    interpedUserInputRadius = {};
end
if nargin>1
    iFrame = varargin{1};
    if isempty(iFrame)
         iFrame = nFrame;
    end
else
    iFrame = nFrame;
end

if nargin>3
    selectedObjectIndex = varargin{3};
else
    selectedObjectIndex = [];
end
xMax = max(real(userInputRadiusArray(:)));
if isnan(xMax)
    xMax = 0;
end

numObsPerObject = sum(~isnan(userInputArray),1);
nExistingObjects = find(numObsPerObject>0,1,'last');
if isempty(nExistingObjects)
    nExistingObjects = 0;
end
ax1 =  subtightplot(6,6,25:30);   %subplot(2,1,1);     
hold off;
ax2 =  subtightplot(6,6,31:36);   %subplot(2,1,2);    
hold off;
colorArray=hsv(nExistingObjects);
subtightplot(6,6,25:30);   %subplot(2,1,1);
hold on;
for iToShowObject = 1:nExistingObjects
    if numObsPerObject(iToShowObject)>0

        if ~INTERPED_USER_INPUT_IS_EMPTY
            xInterpObs = real(interpedUserInputArray(:,iToShowObject))';
            yInterpObs = imag(interpedUserInputArray(:,iToShowObject))';
            yInterpObs(yInterpObs==0) = nan; 
            xInterpObsRadius = real(interpedUserInputCellRadiusArray(:,iToShowObject))';
            
          
            viscircles([yInterpObs xInterpObs],xInterpObsRadius,'color',colorArray(iToShowObject,:))
            
%             plot(xInterpObs,':','lineWidth',interpObjLineWidth,'color',colorArray(iToShowObject,:));
     
        end
        
        if SHOW_RAW_USER_INPUT_MARKINGS      
            xObs = real(userInputArray(:,iToShowObject))';
            yObs = imag(userInputArray(:,iToShowObject))';
            yObs(yObs==0) = nan;
            xInterpObsRadius = real(interpedUserInputCellRadiusArray(:,iToShowObject))';
            
            
%             plot(xObs,'.','markerSize',userMarkingMarkerSize,'color',colorArray(iToShowObject,:));
            if selectedObjectIndex == iToShowObject
                viscircles([yInterpObs xInterpObs],xInterpObsRadius,'color',colorArray(iToShowObject,:))
%                 plot(xObs,'o','markerSize',userMarkingMarkerSize,'color',colorArray(iToShowObject,:));
            end
        end
    
    end
end


subtightplot(6,6,31:36);   %subplot(2,1,2);
hold on;
for iToShowObject = 1:nExistingObjects
    if numObsPerObject(iToShowObject)>0
        if ~INTERPED_USER_INPUT_IS_EMPTY
            xInterpObs = real(interpedUserInputArray(:,iToShowObject))';

        plot(yInterpObs,':','lineWidth',interpObjLineWidth,'color',colorArray(iToShowObject,:));
        end
        if SHOW_RAW_USER_INPUT_MARKINGS
            xObs = real(userInputRadiusArray(:,iToShowObject))';
%             yObs = imag(userInputArray(:,iToShowObject))';
            yObs(yObs==0) = nan;
            
            plot(yObs,'.','markerSize',userMarkingMarkerSize,'color',colorArray(iToShowObject,:));
            if selectedObjectIndex == iToShowObject
%                 plot(yObs,'o','markerSize',userMarkingMarkerSize,'color',colorArray(iToShowObject,:));
                viscircles([yInterpObs xInterpObs],xInterpObsRadius,'color',colorArray(iToShowObject,:))
            end
        end
        
    end
end

subtightplot(6,6,25:30);   %subplot(2,1,1);
try
    plot([iFrame iFrame],[1,xMax],'--k','lineWidth',1); grid on;
catch
end

grid on;
try
    ylim([1 xMax])
end
ylabel('x  (pixels)')
xlim([1 nFrame])
subtightplot(6,6,31:36);   %subplot(2,1,2);
try
    plot([iFrame iFrame],[1,yMax],'--k','lineWidth',1); grid on;
catch
end
ylabel('y  (pixels)')
xlim([1 nFrame])
try
    ylim([1 yMax])
end
grid on;




