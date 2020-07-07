function varargout = showUserInputDataIn3d(userInputCellArray,userInputCellArrayRadius,varargin)

if ~(isempty(userInputCellArray) || size(userInputCellArray{1},2) == 0 && isempty(userInputCellArrayRadius) || size(userInputCellArrayRadius{1},2) == 0)  % no users  || no objs
    
    nUser                       = numel(userInputCellArray);
    [nFrame, nObj]             = size(userInputCellArray{1});
  
    
    if nargin<3 || isempty(varargin{1})
        surfaceSamplingTimeArray = (1:nFrame)';
    else
        surfaceSamplingTimeArray = varargin{1};
    end
    surfaceSamplingTimeArray=  surfaceSamplingTimeArray(:);
    
    
    if nargin<4 || isempty(varargin{2})
        objectClassArray    = {-ones(1,nObj)}; % Assume non-regular stars and only
        %objectClassArray(2) = -1;  %         objectClassArray(12) = 2;%archenar_leos_11_33_atis_td.mat DONE
        %objectClassArray(1) = -1;%archenar_leos_11_33_davis_td.mat   % two missing stars in all 10
    else
        objectClassArray = varargin{2};
        if iscell(objectClassArray)
            objectClassCellArray = objectClassArray;
            objectClassArray     = objectClassCellArray{1};
        end
    end
    

    if nargin<5 || isempty(varargin{3})
        interpedUserInputArrayIsEmpty = 1;
        interpedUserInputCellArray = {};
        
        interpedUserRadiusInputArrayIsEmpty = 1;
        interpedUserInputRadiusArray = {};
    else
        interpedUserInputArrayIsEmpty = 0;
        interpedUserInputCellArray = varargin{3};
        
        interpedUserRadiusInputArrayIsEmpty = 0;
        interpedUserInputRadiusArray = varargin{3};
      
    end
    
    if nargin<6 || isempty(varargin{4})
        figureNumber = 345612431;
    else
        figureNumber = varargin{4};
    end

    
    figure(figureNumber); clf; hold on;
    for iUser=1:nUser
        % try
        userInputArray = userInputCellArray{iUser};
        
        userInputRadiusArray = userInputCellArrayRadius{iUser};
        try
            surfaceSamplingTimeArraySurf = zeros(size(userInputArray))+surfaceSamplingTimeArray(:);
        catch
            size(surfaceSamplingTimeArray)
            size(userInputArray)
            error('surfaceSamplingTimeArray doesn''t match the user data nFrame');
        end
        if ~interpedUserInputArrayIsEmpty
            interpedUserInputArray = interpedUserInputCellArray{iUser};
        end
        if ~interpedUserRadiusInputArrayIsEmpty
            interpedUserInputRadius = interpedUserInputRadiusArray{iUser};
        end
      
        numObsPerObject     = sum(~isnan(userInputArray),1);
        nExistingObject  = find(numObsPerObject>0,1,'last');
        if isempty(nExistingObject)
            nExistingObject = 0;
        end
        if isempty(userInputArray)
            continue
        end
        if isempty(userInputRadiusArray)
            continue
        end
        colorArray=hsv(nExistingObject);
        for iToShowObject = 1:nExistingObject
            xUserInputArray = real(userInputArray(:,iToShowObject));

            yUserInputArray = -real(userInputArray(:,iToShowObject)*1i);
            
            xUserInputRadiusArray = real(userInputRadiusArray(:,iToShowObject));
            
            plot3(xUserInputArray,yUserInputArray,surfaceSamplingTimeArraySurf,'.','color',colorArray(iToShowObject,:),'markersize',7)
            
            for k=1:numel(xUserInputArray)
                if any(~isnan(xUserInputArray(k)))
                    plot3(xUserInputArray(k),yUserInputArray(k),surfaceSamplingTimeArraySurf(k),'o','color',colorArray(iToShowObject,:),'markersize',xUserInputRadiusArray(k), 'LineWidth',2)
                end
            end
%             for k=1:numel(xUserInputArray)
%                 if xUserInputArray == any(~isnan(xUserInputArray))
%                     
%                     %                 if ~isnan(xUserInputArray) && ~isnan(yUserInputArray) && ~isnan(surfaceSamplingTimeArraySurf) && ~isnan(xUserInputRadiusArray)
%                     plot3(xUserInputArray(k),yUserInputArray(k),surfaceSamplingTimeArraySurf(k),'o','color',colorArray(iToShowObject,:),'markersize',xUserInputRadiusArray(k), 'LineWidth',3)
%                     %                 h=scatter3(xUserInputArray(k),yUserInputArray(k),surfaceSamplingTimeArraySurf(k),'marker','o','linewidth',xUserInputRadiusArray(k),'MarkerEdgeColor',colorArray(iToShowObject,:));
%                     
%                 end
%             end
            
            %             end
%             plot3(xUserInputArray,yUserInputArray,surfaceSamplingTimeArraySurf,'o','color',colorArray(iToShowObject,:),'markersize',xUserInputRadiusArray, 'LineWidth', 5)
%             
%             figure
%             x=1:4;
%             y=[10 20 30 40];
%             z = [1 4 8 12];
%             plot3(x,y,z);
%             A=[2 4 6 8]; %sizes
%             hold on
%             for k=1:numel(A)
%               h=scatter3(x(k),y(k),z(k),'marker','o','linewidth',A(k));
%             end

%             circle3([xUserInputArray,yUserInputArray,surfaceSamplingTimeArraySurf],xUserInputRadiusArray,2000,'-')
%             plotCircle3D([xUserInputArray,yUserInputArray,surfaceSamplingTimeArraySurf],[0,1,0],xUserInputRadiusArray)
%             viscircles([xUserInputArray yUserInputArray],xUserInputRadiusArray,'color',colorArray(iToShowObject,:))
           
            if ~interpedUserInputArrayIsEmpty && ~interpedUserRadiusInputArrayIsEmpty
                xInterpedUserInputArray = real(interpedUserInputArray(:,iToShowObject));
                yInterpedUserInputArray = -real(interpedUserInputArray(:,iToShowObject)*1i);
                
                
                plot3(xInterpedUserInputArray,yInterpedUserInputArray,surfaceSamplingTimeArraySurf,':','color',colorArray(iToShowObject,:));hold on
%                 circles(xUserInputArray,yUserInputArray,xUserInputRadiusArray);
            end
        end
%         figure(2147483645);
%         plot(userInputRadiusArray, 'color',colorArray(iToShowObject,:), 'LineWidth',4);
    end
    
    try
        meanIntepredUserInputArray = calculateMeanInterpedUserInputFromUserInputCellArray(userInputCellArray,objectClassArray);
        xMeanIntepredUserInput = real(meanIntepredUserInputArray);
        yMeanIntepredUserInput = imag(meanIntepredUserInputArray);
        
        yMeanIntepredUserInput(yMeanIntepredUserInput == 0) = nan;
        for iToShowObject = 1:nExistingObject
            plot3(xMeanIntepredUserInput(:,iToShowObject),yMeanIntepredUserInput(:,iToShowObject),surfaceSamplingTimeArraySurf,'-','color',colorArray(iToShowObject,:));hold on
%             circles(xUserInputArray,yUserInputArray,xUserInputRadiusArray);
        end
    catch
    end
    
    
    grid on;
end
if nargout>0
    varargout{1} = [];
end




