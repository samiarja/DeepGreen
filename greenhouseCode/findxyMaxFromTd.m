function [xMax,yMax] = findxyMaxFromTd(TD,varargin)

%%% Example Usage --------------------------------------------------------------
% [xMax,yMax] = findxyMaxFromTd(TD)
% [xMax,yMax] = findxyMaxFromTd(TD, xyMaxThreshold)      %percentThreshold for finding x y outliers default is 99.999%
  
% This file should be in [myMatlabPath '\ML\data\ATIS\dataAquisitionCode\myAtisLibrary\']


if ~isstruct(TD)  % if TD is a matrix and encoded in Greg's Style.
    TD1         = [];
    [nEvents,~] = size(TD);
    eventIndexArray           = (1:nEvents);
    TD1.x(eventIndexArray)    = TD(eventIndexArray,1);
    TD1.y(eventIndexArray)    = TD(eventIndexArray,2);
    TD1.p(eventIndexArray)    = TD(eventIndexArray,3)*2-1;
    TD1.ts(eventIndexArray)   = TD(eventIndexArray,4);
    TD = TD1;
end
TD.p = single(TD.p);        TD.x = single(TD.x);  TD.y = single(TD.y);      TD.ts = single(TD.ts);

if nargin>1
    xyMaxThreshold = varargin{1};
else    
    xyMaxThreshold = 100;
end
unmodifiedTd = TD;
if xyMaxThreshold == 100
    xStartValueInitial = min(TD.x);
    xEndValueInitial  = max(TD.x);
else
    xStartValueInitial = floor(prctile(TD.x,100-xyMaxThreshold));
    xEndValueInitial   = ceil(prctile(TD.x,xyMaxThreshold));
end
TD.x = TD.x - xStartValueInitial+1;
xMax = xEndValueInitial - xStartValueInitial+1; % TD.x now (except for outliers) mapped from 1 to xMax;

if xyMaxThreshold == 100
    yStartValueInitial = min(TD.y);
    yEndValueInitial  = max(TD.y);
else
    yStartValueInitial = floor(prctile(TD.y,100-xyMaxThreshold));
    yEndValueInitial   = ceil(prctile(TD.y,xyMaxThreshold));
end

TD.y = TD.y - yStartValueInitial+1;
yMax = yEndValueInitial - yStartValueInitial+1; % TD.x now (except for outliers) mapped from 1 to xMax;


% nPixelBinsForHistogram = 1000;
% if  xMax== 240 || xMax== 304 || xMax== 180
%     % everything is fine nothing to see here
% else
%     figure(1771);
%     histogram(unmodifiedTd.x,nPixelBinsForHistogram);
%     xlabel('x');grid on; title(['unexpected xMax value:' num2str(xMax) ' initialx:' num2str(xStartValueInitial)], 'Interpreter', 'none');
% end
%
% if  yMax== 240 || yMax== 304 || yMax== 180
%     % everything is fine nothing to see here
% else
%     figure(1772);
%     histogram(unmodifiedTd.y,nPixelBinsForHistogram);xlabel('y');grid on;
%     title(['unexpected yMax value:' num2str(yMax) ' initialy:' num2str(yStartValueInitial)], 'Interpreter', 'none');
% end
%
