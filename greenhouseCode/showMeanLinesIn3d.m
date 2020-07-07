function varargout = showMeanLinesIn3d(userInputCellArray,varargin)
% showMeanLinesIn3d(userInputCellArray,objectClassCellArray,surfaceSamplingTimeArray,meanMethod)
% showMeanLinesIn3d(userInputCellArray,objectClassCellArray,surfaceSamplingTimeArray,meanMethod,figureNum)
% showMeanLinesIn3d(userInputCellArray,objectClassCellArray,surfaceSamplingTimeArray,meanMethod,figureNum,xMax,yMax,tdFileName)

nUser                       = numel(userInputCellArray);
try
[nFrame, nObj]             = size(userInputCellArray{1});
catch
    nFrame  = 0;
    nObj    = 0;
end
if nargin<2 || isempty(varargin{1})
    objectClassArray = -ones(1,nObj);
else
    objectClassArray =  varargin{1};
    if iscell(objectClassArray)
        objectClassCellArray = objectClassArray;
        objectClassArray     = objectClassCellArray{1};
    end
end

if nargin<3 || isempty(varargin{2})
    surfaceSamplingTimeArray = (1:nFrame)'/100;
else
    surfaceSamplingTimeArray = varargin{2};
end

surfaceSamplingTimeArray  = surfaceSamplingTimeArray(:);
if nargin<4 ||  isempty(varargin{3})
    meanMethod = 'nanmean'; % default
else
    meanMethod = varargin{3};
end

if nargin<5 ||  isempty(varargin{4})
    figureNum = 42423; % default
else
    figureNum = varargin{4};
end
% showMeanLinesIn3d(userInputCellArray,objectClassCellArray,surfaceSamplingTimeArray,meanMethod,figureNum,xMax,yMax)
%%% xMax   %%% yMax  --------------------------------------------------------------------------------------------------------
if nargin<6 || isempty(varargin{5})
    xMax = 500; % excessively big image size to highlight the missing xMax input (without crashing old code)
else
    xMax = varargin{5};
end
if nargin<7 || isempty(varargin{6})
    yMax = 500; % excessively big image size to highlight the missing xMax input (without crashing old code)
else
    yMax = varargin{6};
end

if nargin<8 || isempty(varargin{7})
    tdFileName = '';
else
    tdFileName = varargin{7};
end

fh = figure(figureNum); clf; %combined mean and obs
sh = subplot(1,1,1);
if ~(isempty(userInputCellArray) || size(userInputCellArray{1},2) == 0)  % no users  || no objs
    nUser                       = numel(userInputCellArray);
    [nFrame, nObj]             = size(userInputCellArray{1});
    
    showUserInputDataIn3d(userInputCellArray,surfaceSamplingTimeArray, objectClassArray,{},figureNum)
    
    %objectClassArray = -ones(1,nObj);
    meanIntepredUserInputArray = calculateMeanInterpedUserInputFromUserInputCellArray(userInputCellArray,xMax,yMax,objectClassArray,meanMethod);
    if ~isempty(meanIntepredUserInputArray)
        %showUserInputCellArray(userInputSingleCell,{nanMeanIntepredUserInput},timeSurfaceArray,surfaceSamplingTimeArray,surfaceSamplingIndexArray,iFrame,UserInputGettingParameters,[],2)
        xMeanIntepredUserInput = real(meanIntepredUserInputArray);
        %         yMeanIntepredUserInput = imag(meanIntepredUserInputArray);
        %         yMeanIntepredUserInput(yMeanIntepredUserInput == 0) = nan;
        yMeanIntepredUserInput = -real(meanIntepredUserInputArray*1i);
        
        surfaceSamplingTimeArray1 = zeros(size(meanIntepredUserInputArray))+surfaceSamplingTimeArray(:);
        plot3(xMeanIntepredUserInput,yMeanIntepredUserInput,surfaceSamplingTimeArray1,'.k','MarkerSize',3)
        plot3(xMeanIntepredUserInput,yMeanIntepredUserInput,surfaceSamplingTimeArray1,'-','color',[1 1 1]/2)
    end
end


grid on;
zlabel('time (in MicroSeconds)')
if xMax == 500
    xMaxNotGivenWarning = ' (xMax yMax Not Given)';
else
    xMaxNotGivenWarning = '';
end
xlabel(['x (pixels)' xMaxNotGivenWarning])
ylabel(['y (pixels)' xMaxNotGivenWarning])
if ~isempty(tdFileName)
    title(tdFileName,'interpreter','none');
end
view(40,10)

if nargout>0    
    varargout{1} = fh;
end
if nargout>1    
    varargout{2} = sh;
end

