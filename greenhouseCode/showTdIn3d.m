function showTdIn3d(TD,varargin)


if nargin<2 || isempty(varargin{1})
    ShowParameters = [];
else
    ShowParameters = varargin{1};
end
try
    xMin = ShowParameters.xMin;
catch
    xMin = [];
end
try
    xMax = ShowParameters.xMax;
catch
    xMax = [];
end
try
    yMin = ShowParameters.yMin;
catch
    yMin = [];
end
try
    yMax = ShowParameters.yMax;
catch
    yMax = [];
end
try
    tMax = ShowParameters.tMax;
catch
    try
        tMax = TD.ts(end)/1e6;
    end
end
try
    tMin = ShowParameters.tMin;
catch
    tMin = [];
end
try
    tdFileName = ShowParameters.tdFileName;
catch
    tdFileName = [];
end
try
    viewAz = ShowParameters.viewAz;
    viewEl = ShowParameters.viewEl;
catch
      viewAz = 110;
      viewEl =-30;
end
try
    polarityToShow = Parameters.polarityToShow;
catch
    polarityToShow = nan;
end
try
    if isnan(polarityToShow)
        try
            polarityArray = unique(TD.id);
        catch
            polarityArray = unique(TD.p);
        end
    else
        polarityArray = polarityToShow;
    end
catch
    TD.p = TD.x*0+1;
    polarityArray = 1;
    
end
nPolarity = numel(polarityArray);
polarityColorArray = hsv(nPolarity);
try 
    TD.ts;
catch
    TD.ts = TD.t;
end

try
    figureNum =  ShowParameters.figureNum;
    figure(figureNum); clf;
%catch
    %figure(789522); clf;
end

try
    fontSize =  ShowParameters.fontSize;
    
catch
    fontSize = 14;
end

markerSize3d =1;

    

for iPolarity = 1:nPolarity
    thisPolarity = polarityArray(iPolarity);    
    iEventArray = (TD.p ==  thisPolarity );
    thisTd.x =   TD.x(iEventArray);      thisTd.y =   TD.y(iEventArray);          thisTd.ts =   TD.ts(iEventArray);    
    try
        thisTd.p =   TD.p(iEventArray);
    catch
        thisTd.p =   TD.x*0;
    end
    try
        thisTd.ang =   TD.ang(iEventArray);
    end
    nDetEventThisPolarity = numel(thisTd.x); 
    plot3HandleArray(iPolarity) = subplot(1,nPolarity,iPolarity); %hold on;
    plot3(thisTd.x,thisTd.y,thisTd.ts/1e6,'*b','markerSize',markerSize3d);
    
    grid on; xlabel('x');ylabel('y');zlabel('time in sec');
    if ~isempty(tdFileName) && iPolarity == ceil(nPolarity/2)
        titleString =[tdFileName newline 'p = ' num2str(thisPolarity) '  #Events = ' num2str(nDetEventThisPolarity)];
    else
        titleString =['p = ' num2str(thisPolarity) '  #Events = ' num2str(nDetEventThisPolarity)];
    end
    title(titleString,'interpreter','none');
    set(gca,'fontSize',fontSize);
     view(viewAz,viewEl)
end

for iPolarity = 1:nPolarity
    try
        xMinArray(iPolarity) =  plot3HandleArray(iPolarity).XLim(1);
        xMaxArray(iPolarity) =  plot3HandleArray(iPolarity).XLim(2);
        yMinArray(iPolarity) =  plot3HandleArray(iPolarity).YLim(1);
        yMaxArray(iPolarity) =  plot3HandleArray(iPolarity).YLim(2);
        zMinArray(iPolarity) =  plot3HandleArray(iPolarity).ZLim(1);
        zMaxArray(iPolarity) =  plot3HandleArray(iPolarity).ZLim(2);
    catch
    end
    set(gca,'fontSize',fontSize);
end
xMinAll = max([xMinArray(:);xMin]);
xMaxAll = min([xMaxArray(:);xMax]);
yMinAll = max([yMinArray(:);yMin]);
yMaxAll = min([yMaxArray(:);yMax]);
zMinAll = max([zMinArray(:);tMin]);
zMaxAll = min([zMaxArray(:);tMax]);
for iPolarity = 1:nPolarity
    try
        plot3HandleArray(iPolarity).XLim(1) = xMinAll;
        plot3HandleArray(iPolarity).XLim(2) = xMaxAll;
        
        plot3HandleArray(iPolarity).YLim(1) = yMinAll;
        plot3HandleArray(iPolarity).YLim(2) = yMaxAll;
        
        plot3HandleArray(iPolarity).ZLim(1) = zMinAll;
        plot3HandleArray(iPolarity).ZLim(2) = zMaxAll;
    catch
    end
    view(viewAz,viewEl)
    
    set(gca,'fontSize',fontSize);
end

% Link = linkprop([plot3HandleOn1, plot3HandleOff1],{'CameraUpVector', 'CameraOnition', 'CameraTarget'});
% setappdata(gcf, 'StoreTheLink', Link);