% clear all;
% close all;


% TD = struct('x',single(TD(:,1)),'y',single(TD(:,2)),'p',single(TD(:,3)),'ts',TD(:,4));
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

% TD = load_atis_data("~/sami/Dataset/raw/log_td.dat");
% TD = struct('x',single(TD.x(:,2)),'y',single(TD.y(:,3)),'p',single(TD.p(:,4)),'ts',TD.ts(:,1));
% TD = struct('x',single(TD(:,1)),'y',single(TD(:,2)),'p',TD(:,3),'ts',TD(:,4));


TD.ts = TD.ts - TD.ts(1,1);

% TD.ts = TD.ts/1e+6;

e = []; idx = 0;

% % if DAVIS
% xs = 240;
% ys = 180;

%if Prophesee
xs = 346;
ys = 260;

%if DAVIS
% S = int64(zeros(xs,ys)); T = S; P = double(T);%-inf;

%if Prophesee
S = zeros(xs,ys); T = S; P = double(T);

% ON and OFF eventinput
nTD = numel(TD.x);
seconds = TD.ts/1e6;
tau = 4*1e4;
displayFreq = 2e4; % in units of time
nextTimeSample = TD.ts(1,1)+displayFreq;
% map = AdvancedColormap('kwk',150,[200 150 0]/200);
fig = figure(2); clf;ss = imagesc(S);colormap(hot);

writerObj = VideoWriter('~/sami/Dataset/avi/newdata0.avi');
writerObj.FrameRate = 30;
open(writerObj);

for idx = 1:nTD
    
    x = TD.x(idx)+1;
    y = TD.y(idx)+1;
    t = TD.ts(idx);
    p = TD.p(idx);
    colour = TD.colour(idx);
    %     label = TD.c(idx);
    
    if x > 85 && x < 270 && y > 80 && y < 200 % only when coloured events are used
        % T maps the time of the most recent event to spatial pixel location
        %         if label == 0
        T(x,y) = t;
        % P maps the polarity of the most recent event to spatial pixel location
        P(x,y) = p;
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
    end
    %     end
end
close(writerObj);
fprintf('Sucessfully generated the video\n')