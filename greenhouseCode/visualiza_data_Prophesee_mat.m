% clear all;
% close all;

% TD = struct('x',single(events(:,2)),'y',single(events(:,3)),'p',single(events(:,4)),'ts',events(:,1), 'colour',single(events(:,5)));
% TD.ts = TD.ts - TD.ts(1,1);
% TD.ts = single(TD.ts);
% TD = struct('x',single(TD(:,1)),'y',single(TD(:,2)),'p',single(TD(:,3)),'ts',TD(:,4));
% TD.ts = TD.ts - TD.ts(1,1);
% TD.ts = single(TD.ts);

% TD = struct('x',single(coordinate(:,1)),'y',single(coordinate(:,2)),'ts',coordinate(:,3), 'l',single(coordinate(:,4)));

% [file,path] = uigetfile('recordings/',...
%                         'Select an event File');
% if isequal(file,0)
%    disp('User selected Cancel')
% else
%    disp(['User selected ', fullfile(path, file)])
% end
% load(fullfile(path,file));
% load

% TD = load_atis_data("~/sami/Dataset/raw/log_TD.dat");
% TD = struct('x',single(TD.x(:,2)),'y',single(TD.y(:,3)),'p',single(TD.p(:,4)),'ts',TD.ts(:,1));
% TD = struct('x',single(coordinate(:,1)),'y',single(coordinate(:,2)),'ts',single(coordinate(:,3)),'l',single(coordinate(:,4)));
% TD = struct('x',single(TD.x)','y',single(TD.y)','ts',TD.ts');
% testsort = sort(tsCoordArraytest); % Sort arrays

% TD = struct('x',single(xCoordArraytest),'y',single(yCoordArraytest), 'ts',tsCoordArraytest, 'yPred',single(YtestOutputMaxed(:,1)), 'yTest',single(Ytest(:,1)));

% [A,sortIdx] = sort(tsCoordArraytest,'ascend');
% xCoordArraytest2 = xCoordArraytest(sortIdx);
% yCoordArraytest2 = yCoordArraytest(sortIdx);
% YtestOutputMaxed2 = YtestOutputMaxed(sortIdx,1);
% Ytest2 = Ytest(sortIdx,1);
% 
% events = struct('x',single(events(:,1)),'y',single(events(:,2)), 'p',single(events(:,3)), 'ts',events(:,4));
% 
% TD.ts = TD.ts - TD.ts(1,1);
% TD.ts = TD.ts/1e+6;

% Only for lines and circles
% events = TD{5, 1};
% events = struct('x',single(events(:,1)),'y',single(events(:,2)), 'p',single(events(:,3)), 'ts',events(:,4));


e = []; idx = 0;

% % if DAVIS
xs = 346;
ys = 260;

%if Prophesee
% xs = 640;
% ys = 480;

%if DAVIS
S = int64(zeros(xs,ys)); T = S; P = double(T);%-inf;

%if Prophesee
% S = zeros(xs,ys); T = S; P = double(T);

% ON and OFF event input
nTD = numel(events.x);
% seconds = TD.ts/1e6;
tau = 4*1e4;
displayFreq = .9e4; % in units of time
nextTimeSample = events.ts(1,1)+displayFreq;
% map = AdvancedColormap('kwk',150,[200 150 0]/200);
fig = figure(2); clf;ss = imagesc(S);colormap(hot);

writerObj = VideoWriter('~/sami/Dataset/avi/circlespattern.avi');
writerObj.FrameRate = 30;
open(writerObj);

for idx = 8e4:3e5
    x = events.x(idx)+1;
    y = events.y(idx)+1;
    t = events.ts(idx);
    p = events.p(idx);
    %     colour = TD.colour(idx);
    %     label = TD.c(idx);
    %     label = TD.yPred(idx);
    %     if colour == 4
    %         if p == 1
    if x > 80 && x < 280 % only when coloured events are used
        % T maps the time of the most recent event to spatial pixel location
        %     if label == 0
        T(x,y) = t;
        P(x,y) = p;
        if t > nextTimeSample
            nextTimeSample = max(nextTimeSample + displayFreq,t);
            S = exp(double((T-t))/tau);
            set(ss,'CData',S);
            drawnow limitrate;
            xlabel("X-axis");
            ylabel("Y-axis");
            view([90 90]);
            %         colorbar;
            %         title(['\fontsize{14} Ground Truth Class 0 (Lines) ', ...
            %             '\newline \fontsize{10} \color{red} \it Tau = 4*1e4, DispFreq = 0.5e4', ...
            %             '\newline \fontsize{10} \color{red} Timestamp:',num2str(t/1e6)]);
            %             title(['\fontsize{14} ELM Class 1 (Circles) ', ...
            %         '\newline \fontsize{10} \color{red} \it Acc. 93.9%, Tau = 4*1e4, DispFreq = 0.5e4', ...
            %         '\newline \fontsize{10} \color{red} Timestamp:',num2str(t/1e6)]);
            title(['Time',num2str(t), 'idx:',num2str(idx)]);
            %             title(['Time is ',num2str(t/1e6),' s', 'Class 1'; 'Accuracy'; '90%'])
            %             set(gca,'visible','off')
            set(findall(gca, 'type', 'text'), 'visible', 'on');
            %             darkBackground(fig,[0 0 0],[0 0 0])
            F = getframe(gcf) ;
            writeVideo(writerObj, F);
        end
    end
    %     end
    %     end
end
close(writerObj);
fprintf('Sucessfully generated the video\n')

%%
initial = 1360000; % 323000
final = 1683000;
TD12 = struct('x',single(TD.x(initial:final)),'y',single(TD.y(initial:final)), 'p',single(TD.p(initial:final)), 'ts',TD.ts(initial:final));