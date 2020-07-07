function showTdOnOffIn3d(TD,varargin)

if nargin<2 || isempty(varargin{1})
    ShowParamters = [];
else
    ShowParamters = varargin{1};
end
try
    xMin = ShowParamters.xMin;
catch
    xMin = [];
end
try
    xMax = ShowParamters.xMax;
catch
    xMax = [];
end
try
    yMin = ShowParamters.yMin;
catch
    yMin = [];
end
try
    yMax = ShowParamters.yMax;
catch
    yMax = [];
end
try
    tMax = ShowParamters.tMax;
catch
    tMax = [];
end
try
    tMin = ShowParamters.tMin;
catch
    tMin = [];
end
try
    tdFileName = ShowParamters.tdFileName;
catch
    tdFileName = [];
end
iOnEventArray = TD.p==1;
tdOn.x =   TD.x(iOnEventArray);      tdOn.y =   TD.y(iOnEventArray);        tdOn.p =   TD.p(iOnEventArray);      tdOn.ts =   TD.ts(iOnEventArray);    
try 
tdOn.ang =   TD.ang(iOnEventArray);
end
tdOff.x =   TD.x(~iOnEventArray);     tdOff.y =   TD.y(~iOnEventArray);       tdOff.p =   TD.p(~iOnEventArray);     tdOff.ts =   TD.ts(~iOnEventArray);
try
    tdOff.ang =   TD.ang(~iOnEventArray);
end
nDetEventOn = numel(tdOn.x); nDetEventOff = numel(tdOff.x);
try
    figureNum =  ShowParamters.figureNum;
    figure(figureNum); clf;
catch
    figure(789521); clf;
end
markerSize3d =1;

plot3HandleOff1 = subplot(1,2,1); %hold on;
plot3(tdOn.x,tdOn.y,tdOn.ts/1e6,'.r','markerSize',markerSize3d);
grid on; xlabel('x');ylabel('y');zlabel('time (seconds)');
if ~isempty(tdFileName)
    titleString =[tdFileName newline 'ON Events = ' num2str(nDetEventOn)];
else
    titleString =['ON Events = ' num2str(nDetEventOn)];
end
title(titleString,'interpreter','none');
view(60,20);
plot3HandleOn1 = subplot(1,2,2); %hold on;
plot3(tdOff.x,tdOff.y,tdOff.ts/1e6,'.b','markerSize',markerSize3d);
grid on; xlabel('x');ylabel('y');zlabel('time (seconds)');
view(60,20);
titleString =['OFF Events = ' num2str(nDetEventOff)];
title(titleString,'interpreter','none');
try
plot3HandleOn1.XLim(1) = min([plot3HandleOn1.XLim(1),plot3HandleOff1.XLim(1),xMin]);
plot3HandleOn1.XLim(2) = max([plot3HandleOn1.XLim(2),plot3HandleOff1.XLim(2),xMax]);
plot3HandleOn1.YLim(1) = min([plot3HandleOn1.YLim(1),plot3HandleOff1.YLim(1),yMin]);
plot3HandleOn1.YLim(2) = max([plot3HandleOn1.YLim(2),plot3HandleOff1.YLim(2),yMax]);
plot3HandleOn1.ZLim(1) = min([plot3HandleOn1.ZLim(1),plot3HandleOff1.ZLim(1),tMin]);
plot3HandleOn1.ZLim(2) = max([plot3HandleOn1.ZLim(2),plot3HandleOff1.ZLim(2),tMax]);

plot3HandleOff1.XLim(1) = min([plot3HandleOn1.XLim(1),plot3HandleOff1.XLim(1),xMin]);
plot3HandleOff1.XLim(2) = max([plot3HandleOn1.XLim(2),plot3HandleOff1.XLim(2),xMax]);
plot3HandleOff1.YLim(1) = min([plot3HandleOn1.YLim(1),plot3HandleOff1.YLim(1),yMin]);
plot3HandleOff1.YLim(2) = max([plot3HandleOn1.YLim(2),plot3HandleOff1.YLim(2),yMax]);
plot3HandleOff1.ZLim(1) = min([plot3HandleOn1.ZLim(1),plot3HandleOff1.ZLim(1),tMin]);
plot3HandleOff1.ZLim(2) = max([plot3HandleOn1.ZLim(2),plot3HandleOff1.ZLim(2),tMax]);
end
% try
%     linkaxes([plot3HandleOn1, plot3HandleOff1],'xy')
% end
% 
% try
%     Link = linkprop([plot3HandleOn1, plot3HandleOff1],{'CameraUpVector', 'CameraOnition', 'CameraTarget'});
% end
% % setappdata(gcf, 'StoreTheLink', Link);