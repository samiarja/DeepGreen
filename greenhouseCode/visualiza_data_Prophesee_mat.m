% clear all;
% close all;


% TD = struct('x',single(events(:,1)),'y',single(events(:,2)),'p',single(events(:,3)),'ts',events(:,4));
% TD.ts = TD.ts - TD.ts(1,1);
% TD.ts = single(TD.ts);


% [file,path] = uigetfile('recordings/',...
%                         'Select an event File');
% if isequal(file,0)
%    disp('User selected Cancel')
% else
%    disp(['User selected ', fullfile(path, file)])
% end
% load(fullfile(path,file));
% load
TD.ts = TD.ts - TD.ts(1,1);

% TD.ts = TD.ts/1e+6;

e = []; idx = 0;

% % if DAVIS
% xs = 240;
% ys = 180;

%if Prophesee
xs = 640;
ys = 480;

%if DAVIS
% S = int64(zeros(xs,ys)); T = S; P = double(T);%-inf;

%if Prophesee
S = zeros(xs,ys); T = S; P = double(T);

% ON and OFF event
nTD = numel(TD.x);
seconds = TD.ts/1e6;
tau = 4*1e4;
displayFreq = 2e4; % in units of time
nextTimeSample = TD.ts(1,1)+displayFreq;
% map = AdvancedColormap('kwk',150,[200 150 0]/200);
fig = figure(2); clf;ss = imagesc(S);colormap(hot);

writerObj = VideoWriter('~/sami/Dataset/avi/case1.avi');
writerObj.FrameRate = 30;
open(writerObj);

for idx = 1:2500000
    
    x = TD.x(idx)+1;
    y = TD.y(idx)+1;
    t = TD.ts(idx);
    p = TD.p(idx);
%     label = TD.c(idx);
    % T maps the time of the most recent event to spatial pixel location
    %     if label == 1
    T(x,y) = t;
    % P maps the polarity of the most recent event to spatial pixel location
    %     P(x,y) = p;
    if t > nextTimeSample
        nextTimeSample = max(nextTimeSample + displayFreq,t);
        %exponential decay index surface
        S = exp(double((T-t))/tau);
        %         subplot(2,1,1)
        set(ss,'CData',S)
        drawnow limitrate
        view([90 90])
        title([num2str(idx,'%10.2e')])
        set(gca,'visible','off')
        set(findall(gca, 'type', 'text'), 'visible', 'on')
        %         title('Time Surface - Blue Filter')
        darkBackground(fig,[0 0 0],[0 0 0])
        F = getframe(gcf) ;
        writeVideo(writerObj, F);
    end
    %     end
end
close(writerObj);
fprintf('Sucessfully generated the video\n')