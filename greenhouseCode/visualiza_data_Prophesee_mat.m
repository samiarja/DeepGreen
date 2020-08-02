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
% TD = struct('x',single(TD(:,1)),'y',single(TD(:,2)), 'ts',TD(:,3));
% 
% TD.ts = TD.ts - TD.ts(1,1);
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

% ON and OFF eventinput
nTD = numel(TD.x);
seconds = TD.ts/1e6;
tau = 4*1e4;
displayFreq = 0.5e4; % in units of time
nextTimeSample = TD.ts(1,1)+displayFreq;
% map = AdvancedColormap('kwk',150,[200 150 0]/200);
fig = figure(2); clf;ss = imagesc(S);colormap(hot);

writerObj = VideoWriter('~/sami/Dataset/avi/c0groundtruth.avi');
writerObj.FrameRate = 30;
open(writerObj);

for idx = 60000:nTD
    
    x = TD.x(idx)+1;
    y = TD.y(idx)+1;
    t = TD.ts(idx);
        label = TD.c(idx);
    %     p = TD.p(idx);
    %     colour = TD.colour(idx);
%     label = TD.yPred(idx);
    %     if colour == 4
    %         if p == 1
    %     if x > 85 && x < 270 && y > 80 && y < 200 % only when coloured events are used
    % T maps the time of the most recent event to spatial pixel location
    if label == 0
        T(x,y) = t;
        % P maps the polarity of the most recent event to spatial pixel location
        %         P(x,y) = p;
        if t > nextTimeSample
            nextTimeSample = max(nextTimeSample + displayFreq,t);
            S = exp(double((T-t))/tau);
            set(ss,'CData',S)
            drawnow limitrate
            xlabel("X-axis")
            ylabel("Y-axis")
            view([90 90])
            colorbar
            
            title(['\fontsize{14} Ground Truth Class 0 (Lines) ', ...
        '\newline \fontsize{10} \color{red} \it Tau = 4*1e4, DispFreq = 0.5e4', ...
        '\newline \fontsize{10} \color{red} Timestamp:',num2str(t/1e6)]);
    
%             title(['\fontsize{14} ELM Class 1 (Circles) ', ...
%         '\newline \fontsize{10} \color{red} \it Acc. 93.9%, Tau = 4*1e4, DispFreq = 0.5e4', ...
%         '\newline \fontsize{10} \color{red} Timestamp:',num2str(t/1e6)]);
    
%             title([num2str(t/1e6), 'Class 1'])
%             title(['Time is ',num2str(t/1e6),' s', 'Class 1'; 'Accuracy'; '90%'])
%             set(gca,'visible','off')
            set(findall(gca, 'type', 'text'), 'visible', 'on')
%             darkBackground(fig,[0 0 0],[0 0 0])
            F = getframe(gcf) ;
            writeVideo(writerObj, F);
        end
        %             end
    end
    %     end
end
close(writerObj);
fprintf('Sucessfully generated the video\n')