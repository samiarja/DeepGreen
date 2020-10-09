function tdClean = removeHotPixels(td,Parameters)
%  Use as following:
% Parameters.pixelToRemovePercent             = 0.01;
% Parameters.minimumNumOfEventsToCheckHotNess = 10;
% Parameters.xMax                             = 600;
% Parameters.yMax                             = 600;
% tdWithHotPixelsRemoved = removeHotPixels(td,Parameters);

try
    xMax =  Parameters.xMax;
    yMax =  Parameters.yMax;
catch    
    try
        addpath([getMyMatlabPath '\ML\data\ATIS\dataAquisitionCode\myAtisLibrary']);
    end
    [xMax, yMax] = findxyMaxFromTd;   
end
try
    PercentPixelsToRemove = Parameters.PercentPixelsToRemove;
catch
    PercentPixelsToRemove = 0.01;
end

try
    minimumNumOfEventsToCheckHotNess = Parameters.minimumNumOfEventsToCheckHotNess;
catch
    minimumNumOfEventsToCheckHotNess = 10;
end
%%%%--------------------------------

bigNumber  = 1e99;
nEvent = numel(td.x);
tCell = cell(xMax,yMax);
eventCount    = zeros(xMax,yMax);
for ii = 1:nEvent
    x = td.x(ii)+1;
    y = td.y(ii)+1;
    t = td.ts(ii);    
    eventCount(x,y) = eventCount(x,y)+1;    
    tCell{x,y}(eventCount(x,y)) = t;
end




duration = zeros(xMax,yMax)-(td.ts(end)-td.ts(1));
errorTime = zeros(xMax,yMax)+bigNumber; 
for x=1:xMax
    for y=1:yMax
        if eventCount(x,y)>minimumNumOfEventsToCheckHotNess
            duration(x,y) = tCell{x,y}(end) -tCell{x,y}(1);
            tCell{x,y};
            errorTime(x,y) =  sum(abs(tCell{x,y} - linspace(   tCell{x,y}(1),  tCell{x,y}(end) , eventCount(x,y))));
        end
    end
end
hotPixelMeasure = eventCount.*duration./errorTime;

hotPixelMeasureThreshold = prctile(mat2vec(hotPixelMeasure),(100-PercentPixelsToRemove));
iHotPixel = 0;
xHotPixelArray = []; yHotPixelArray = [];
hotPixelImage = eventCount*0;
for x=1:xMax
    for y=1:yMax
        if hotPixelMeasure(x,y)>hotPixelMeasureThreshold
            iHotPixel = iHotPixel + 1;
            xHotPixelArray(iHotPixel) = x;
            yHotPixelArray(iHotPixel) = y;
            hotPixelImage(x,y) = 1;
        end
    end
end

display('invalidIndices (td.x(ii) == xHotPixelArray(iHotPixel) & td.y(ii) == yHotPixelArray(iHotPixel))')

invalidIndices = td.x+nan;
iHot  = 0;
fprintf('Number of hot pixels= %d\n',numel(xHotPixelArray));
for ii = 1:nEvent    
    for iHotPixel = 1:numel(xHotPixelArray) 
        
        if td.x(ii) == xHotPixelArray(iHotPixel)
            if td.y(ii) == yHotPixelArray(iHotPixel)
                iHot = iHot  + 1;
                invalidIndices(iHot)  = ii;
                break
            end
        end
    end
end
invalidIndices = invalidIndices(1:iHot);

nEventsRemovedDueToHot = numel(invalidIndices);
tdClean = td;
tdClean.x(invalidIndices) = []; 
tdClean.y(invalidIndices) = [];   
tdClean.p(invalidIndices) = [];  
tdClean.ts(invalidIndices) = [];   
fprintf('%d events from %d hot pixels removed. %d Events left in TD. \n',nEventsRemovedDueToHot, numel(xHotPixelArray), numel(tdClean.x));

% figure(452340);
% imagesc(hotPixelImage);
% colorbar; axis image;
%
%
% showTdOnOffIn3d(td)
% showTdOnOffIn3d(tdCleaned)
%
% figure(452341);
% plot(sortedEventCount); grid on; yLog;
%
% figure(452342);
% imagesc((log(eventCount))); colorbar; axis image;
%
%
% figure(452343);
% imagesc(errorTime.*(errorTime<bigNumber)); colorbar; axis image;
%
%
% figure(452344);
% imagesc(duration); colorbar; axis image;
% %plot(duration(:))
%
%
%
% figure(452345);
% imagesc(  hotPixelMeasure); colorbar; axis image;
