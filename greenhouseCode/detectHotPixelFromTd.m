% % function [TD,varargout] = detectHotPixelFromTd(inputTD,varargin)
% % %%% Example Usage --------------------------------------------------------------
% % % [TD] = cleanUpTd(TD)
% % % [TD] = cleanUpTd(TD,[startTime EndTime])         % times in uSec                     eg: [2.8e6 12e6] uSec
% % % [TD] = cleanUpTd(TD,__,prctHotPixelsToRemove)    % Remove % most active pixels       eg: 2  (percent)
% % % [TD] = cleanUpTd(TD,__,__,FilterTimeWindow)      % FilterTimeWindow in uSec          eg: 50000 uSec
% % % [TD] = cleanUpTd(TD,__,__,__,FilterRadius)       % FilterRad in pixels               eg: 2 pixels
% % % [ __ , [initialStartTimeIn_uSec ,initialEndTimeIn_uSec]]  = cleanUpTd( __ )
% % % [ __ ,__ ,[initialStartIndex, initialEndIndex]]           = cleanUpTd( __ )
% %
% % % This file should be in [myMatlabPath '\ML\data\ATIS\dataAquisitionCode\myAtisLibrary\']
% %
% % if ~isstruct(inputTD)  % Check if TD is a matrix and encoded in Gregory Cohens's Style. If so make it a struct
% %     TD1         = [];
% %     [nEvents,~] = size(inputTD);
% %     eventIndexArray           = (1:nEvents);
% %     TD1.x(eventIndexArray)    = inputTD(eventIndexArray,1);
% %     TD1.y(eventIndexArray)    = inputTD(eventIndexArray,2);
% %     TD1.p(eventIndexArray)    = inputTD(eventIndexArray,3)*2-1;
% %     TD1.ts(eventIndexArray)   = inputTD(eventIndexArray,4);
% %     inputTD = TD1;
% % end
% % try
% %     inputTD.x(1) = single(inputTD.x(1));
% % catch
% %     nEventsInBadTd = numel(inputTD);
% %     try
% %         tempInputTD = [];
% %         for idx = 1:nEventsInBadTd
% %             tempInputTD.x(idx,1)  = inputTD(idx).x;
% %             tempInputTD.y(idx,1)  = inputTD(idx).y;
% %             tempInputTD.p(idx,1)  = inputTD(idx).p;
% %             tempInputTD.ts(idx,1) = inputTD(idx).ts;
% %         end
% %     end
% %     inputTD = tempInputTD;
% % end
% %
% % inputTD.x = single(inputTD.x);
% % inputTD.y = single(inputTD.y);
% % inputTD.p = single(inputTD.p);
% % inputTD.ts = single(inputTD.ts);
% %
% %
% % nEventsInOriginalTd      = numel(inputTD.ts);
% % originalStartTimeIn_uSec = inputTD.ts(1);
% % originalEndTimeIn_uSec   = inputTD.ts(nEventsInOriginalTd);
% %
% % TD = inputTD;
% %
% %
% %
% %
% %

%[xMax ,yMax ]= findxyMaxFromTd(inputTD)
if rand>5
    inputTD = cleanUpTdWithParamters(TD);
    nEventsInOriginalTd      = numel(inputTD.ts);
    nEventsExpectedPerPixel  = ceil(nEventsInOriginalTd/(xMax*yMax));
    eventTimeStampArray      = nan(xMax,yMax,nEventsExpectedPerPixel,'single');
    eventCountPerPixel       = zeros(xMax,yMax,'single');
    maxEventCountPerPixel    = -inf;
    for idx = 1:nEventsInOriginalTd
        x = inputTD.x(idx);
        y = inputTD.y(idx);
        t = inputTD.ts(idx);
        eventCountPerPixel(x,y)  =  eventCountPerPixel(x,y) + 1;
        eventTimeStampArray(x,y,eventCountPerPixel(x,y)) = t;
        if  maxEventCountPerPixel < eventCountPerPixel(x,y)
            maxEventCountPerPixel = eventCountPerPixel(x,y);
            if maxEventCountPerPixel >= nEventsExpectedPerPixel
                nEventsExpectedPerPixelNew = nEventsExpectedPerPixel*2;
                % extend eventTimeStampArray in third dimension by
                eventTimeStampArray(:,:,nEventsExpectedPerPixel:nEventsExpectedPerPixelNew) = nan;
                nEventsExpectedPerPixel = nEventsExpectedPerPixelNew;
            end
            maxEventCountPerPixel =  eventCountPerPixel(x,y);
        end
    end
    
end
activeThreshold = prctile(eventCountPerPixel(:),90);
iActiveArray = find(eventCountPerPixel>activeThreshold);
[rActiveArray, cActiveArray] =  ind2sub([xMax, yMax],iActiveArray);
meanNormedIsi = iActiveArray+nan;stdNormedIsi  = iActiveArray+nan;
for iiAct = 1:numel(iActiveArray)
    r = rActiveArray(iiAct);
    c = cActiveArray(iiAct);
    thisActPixelTimeStamps = eventTimeStampArray(r,c,1:eventCountPerPixel(r,c));
    thisIsi = diff(thisActPixelTimeStamps(:));
    thisIsiNormed = thisIsi/prctile(thisIsi,90);
    thisIsiNormed = thisIsiNormed(thisIsiNormed<=1);
    meanNormedIsi(iiAct)=mean(thisIsiNormed,'omitnan');
    stdNormedIsi(iiAct) = std(thisIsiNormed,'omitnan');
end

figure(53532); clf; hold on;
plot(-2*stdNormedIsi+meanNormedIsi,'.r')
grid on;

iHotArray = find(-2*stdNormedIsi+meanNormedIsi>0);
iNotArray = find(-2*stdNormedIsi+meanNormedIsi<0);
sum(sum(eventCountPerPixel(rActiveArray(iHotArray),cActiveArray(iHotArray))))/224

sum(sum(eventCountPerPixel(rActiveArray(iNotArray),cActiveArray(iNotArray))))/3857
iActiveArray(iHotArray)'

figure(64564)
imagesc(log10(eventCountPerPixel));
colorbar

figure(64565)
imagesc(eventCountPerPixel>activeThreshold);
colorbar



% isi = eventTimeStampArray;
% for x = 1:xMax
%     for y = 1:yMax
%         xxx = eventTimeStampArray(x,y,1:eventCountPerPixel(x,y));
%          aaa = diff(xxx(:));
%          isi(x,y,1:(eventCountPerPixel(x,y)-1)) = aaa;
%     end
% end

eventTimeStampArraySorted2 = eventTimeStampArray+nan;
[eventCountPerPixelSorted, I] = sort(eventCountPerPixel(:));
J = flipud(I);
[sRow, sCol ] = ind2sub([xMax, yMax],I);
eventCountPerPixelSorted2 = eventCountPerPixel;
eventCountPerPixelSorted3 =   eventCountPerPixelSorted2;
for ii = numel(sRow):-1:1
    [r(ii), c(ii)] = ind2sub([xMax, yMax],ii);
    bbb = eventCountPerPixel(sRow(ii),sCol(ii));
    eventCountPerPixelSorted2(ii) =  bbb;
    eventCountPerPixelSorted3(r(ii),c(ii)) =  bbb;
    yyy = eventTimeStampArray(sRow(ii),sCol(ii),1:bbb);
    eventTimeStampArraySorted2(r(ii), c(ii),1:bbb) = yyy;
    thisIsi = diff(yyy(:));
    uuu = thisIsi/prctile(thisIsi,90);
    uuu = uuu(uuu<=1);
    
    
    figure(53544);clf; hold on;
    histogram(zzz);       set(gca,'yscale','log');    ylim([.1 1e4]);    grid on;
    figure(53545);clf; hold on;
    histogram(uuu);    set(gca,'yscale','log');    ylim([.1 1e4]);    grid on;
    figure(53453);    plot(yyy(:));    grid on;
    
    
    zzz1 = uuu;
    %     mean(zzz1,'omitnan')
    %     std(zzz1,'omitnan')
    %     skewness(zzz1,'omitnan')
    %     kurtosis(zzz1,'omitnan')
    meanNormedIsi(ii)=mean(zzz1,'omitnan');
    stdNormedIsi(ii) = std(zzz1,'omitnan');
    skisi(ii) = skewness(zzz1,'omitnan');
    kuisi(ii) = kurtosis(zzz1,'omitnan');
    numel(sRow) -ii+1;
end


% figure(53530); clf; hold on;
% plot(-5*stdNormedIsi(hp1)-skisi(hp1)+5*meanNormedIsi(hp1)-.2*kuisi(hp1),'.r')
% plot(-5*stdNormedIsi(np)-skisi(np)+5*meanNormedIsi(np)-.2*kuisi(np),'og')
% 
figure(53531); clf; hold on;
plot(-2*stdNormedIsi(hp1)+meanNormedIsi(hp1),'.r')
plot(-2*stdNormedIsi(np)+meanNormedIsi(np),'og')

figure(53532); clf; hold on;
plot(-2*stdNormedIsi+meanNormedIsi,'.r')
grid on;

figure(53540); clf; hold on;
plot3(stdNormedIsi(hp1),skisi(hp1),meanNormedIsi(hp1),'.r')
plot3(stdNormedIsi(np),skisi(np),meanNormedIsi(np),'og')
xlabel('std'); ylabel('skewness'); zlabel('mean');
grid on;

figure(53550); clf; hold on;
plot3(stdNormedIsi(hp1),skisi(hp1),kuisi(hp1),'.r')
plot3(stdNormedIsi(np),skisi(np),kuisi(np),'og')
xlabel('std'); ylabel('skewness'); zlabel('kur');
grid on;



% set(gca,'xscale','log')
% set(gca,'yscale','log')
% set(gca,'zscale','log')


figure(53541);
imagesc(log10(sum(isnan(eventTimeStampArraySorted2),3)));
colorbar

figure(53542);
imagesc(log10(eventCountPerPixelSorted2));
colorbar

figure(53543);
imagesc(log10(eventCountPerPixelSorted3));
colorbar






































































