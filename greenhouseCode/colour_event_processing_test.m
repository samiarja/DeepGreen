load("E:\mat\labeller\epaper_project\RED_DOT_White_Background-2020_03_11_13_46_19.mat.mat")
events = events;
events = struct('x',events(:,1),'y',events(:,2),'p',events(:,3),'ts',events(:,4));

xRGB = events.x;
yRGB = events.y;
events.c = events.p+NaN;
nEvents = numel(events.x);
%%
for idx = 10000:nEvents
    if xRGB(idx) < 346 && yRGB(idx) < 260
        if rem(xRGB(idx),2) == 0 && rem(yRGB(idx),2) == 0
            % 1 == blue
            events.c(idx) = 1;
        end
        if ~rem(xRGB(idx),2) == 0 && ~rem(yRGB(idx),2) == 0
            % 2 == red
            events.c(idx) = 2;
        end
        if ~rem(xRGB(idx),2) == 0 && rem(yRGB(idx),2) == 0
            % 3 == green 1
            events.c(idx) = 3;
        end
        if rem(xRGB(idx),2) == 0 && ~rem(yRGB(idx),2) == 0
            % 3 == green 2
            events.c(idx) = 4;
        end
    end
end

events.ts = events.ts - events.ts(1,1);

% [cnt_unique, unique_a] = hist(double(events.c),unique(double(events.c)));
%%
figure(665);
z = fliplr(events.ts(90000:200000));

scatter3(events.x(90000:200000),events.y(90000:200000),events.ts(90000:200000),2,z)
xlabel("x")
ylabel("y")
xlim([150 346])
ylim([50 300])
%%
RedCount = size(find(events.c == 2));
GreenCount1 = size(find(events.c == 3));
GreenCount2 = size(find(events.c == 4));
BlueCount = size(find(events.c == 1));

f1 = figure(434);
hold on
h=bar(1,RedCount(1,1));
set(h,'FaceColor','r');

h=bar(2,GreenCount1(1,1));
set(h,'FaceColor','g');

h=bar(3,GreenCount2(1,1));
set(h,'FaceColor','g');

h=bar(4,BlueCount(1,1));
set(h,'FaceColor','b');

darkBackground(f1,[0.2 0.2 0.2],[0 0 0])

xlabel("Color Filters")
ylabel("Event Counts")
hold off

%%
idx = 0;

% xs = 200;
% ys = 200;

xs = 346; % xs = round(346/2);
ys = 260; % ys = round(260/2);
% 
S = zeros(xs,ys); T = S; P = double(T);%-inf;
S2 = zeros(xs,ys); T2 = S2; P2 = double(T2);%-inf;
S3 = zeros(xs,ys); T3 = S3; P3 = double(T3);%-inf;

tau = 1*1e4;
displayFreq = 0.5e4; % in units of time
nextTimeSample = events.ts(1,1)+displayFreq;
nevents = numel(events.x);

% colormap( gca , [0 0 0; 1 0 0; 0 1 0])
% colormap( flipud(gray(256)))

figure(5); clf;ss = imagesc(gca,S);colormap(gca , [0 0 0; 0 1 0; 1 1 1])
% figure(6); clf;ss2 = imagesc(gca,S2);colormap(gca , [0 0 0; 0 1 0; 1 1 1])
% figure(7); clf;ss3 = imagesc(gca,S3);colormap(gca , [0 0 0; 0 1 0; 1 1 1])
writerObj = VideoWriter('~/sami/Dataset/avi/green.avi');
% writerObj.FrameRate = 30;
open(writerObj);
% figure(6);
for idx = 1:nevents
    x = events.x(idx)+1;
    y = events.y(idx)+1;
    t = events.ts(idx);
    p = events.p(idx);
    %     l = events.colour(idx);
    % (1 red, 2 blue, 3 green)
    %     if l == 1
    T(x,y) = t;
    P(x,y)=p;
    
    if t > nextTimeSample
        
        nextTimeSample = max(nextTimeSample + displayFreq,t);
        S = exp(double((T-t))/tau);
%         S = S(1:2:end,1:2:end);% only for red 1 (green for matlab)
%         S = S(2:2:end,2:2:end); % only for blue 2 (blue)
%         S = S(2:2:end,1:2:end); % only for green 3 (red for matlab)
        set(gcf,'position',[700,1200,xs*4,ys*4])
        set(ss,'CData',S)
        drawnow limitrate
        %             surf(S);
        view([90 -90])
        title([num2str(idx) '/' num2str(nevents) '----' 'All Event'])
        F = getframe(gcf) ;
        writeVideo(writerObj, F);
    end
    %     end
end
close(writerObj);
fprintf('Sucessfully generated the video\n')
%%
TD = struct('x',single(events(:,2)),'y',single(events(:,3)),'p',single(events(:,4)),'ts',events(:,1), 'colour',single(events(:,5)));
TD.ts = TD.ts - TD.ts(1,1);
TD.ts = single(TD.ts);

% Find all events index that belong to each colour filter
bluePixel = find(TD.colour==1);
redPixel = find(TD.colour==2);
green1Pixel = find(TD.colour==3);
green2Pixel = find(TD.colour==4);

% Group red event only
redevents = [];
redevents.x = TD.x(redPixel);
redevents.y = TD.y(redPixel);
redevents.p = TD.p(redPixel);
redevents.ts = TD.ts(redPixel);

% Group green 1 event only
green1events = [];
green1events.x = TD.x(green1Pixel);
green1events.y = TD.y(green1Pixel);
green1events.p = TD.p(green1Pixel);
green1events.ts = TD.ts(green1Pixel);

% Group green 2 event only
green2events = [];
green2events.x = TD.x(green2Pixel);
green2events.y = TD.y(green2Pixel);
green2events.p = TD.p(green2Pixel);
green2events.ts = TD.ts(green2Pixel);

% Group blue event only
bluevents = [];
bluevents.x = TD.x(bluePixel);
bluevents.y = TD.y(bluePixel);
bluevents.p = TD.p(bluePixel);
bluevents.ts = TD.ts(bluePixel);

% Count polarities in each colour filter

% countLabel = [0,1]; % 102 is fruit 'f' and 110 is non-fruit 'n'
% labelOccurencesHistorgram = hist(bluevents.p,countLabel);
% resultcountLabel = [countLabel; labelOccurencesHistorgram]
% 
% fig=figure(453451);
% showTdIn3d(bluevents);
% darkBackground(fig,[0 0 0],[1 1 1]);
%% 3D chart animation

bluepolarityzero = find(bluevents.x > 85 & bluevents.x < 270 & bluevents.y > 80 & bluevents.y < 200 & bluevents.p==0);
bluepolarityone = find(bluevents.x > 85 & bluevents.x < 270 & bluevents.y > 80 & bluevents.y < 200 & bluevents.p==1);

redpolarityzero = find(redevents.x > 85 & redevents.x < 270 & redevents.y > 80 & redevents.y < 200 & redevents.p==0);
redpolarityone = find(redevents.x > 85 & redevents.x < 270 & redevents.y > 80 & redevents.y < 200 & redevents.p==1);

green1polarityzero = find(green1events.x > 85 & green1events.x < 270 & green1events.y > 80 & green1events.y < 200 & green1events.p==0);
green1polarityone = find(green1events.x > 85 & green1events.x < 270 & green1events.y > 80 & green1events.y < 200 & green1events.p==1);

green2polarityzero = find(green2events.x > 85 & green2events.x < 270 & green2events.y > 80 & green2events.y < 200 & green2events.p==0);
green2polarityone = find(green2events.x > 85 & green2events.x < 270 & green2events.y > 80 & green2events.y < 200 & green2events.p==1);

figure(7878);
subplot(4,2,1)
scatter3(bluevents.x(bluepolarityzero,1),bluevents.y(bluepolarityzero,1),bluevents.ts(bluepolarityzero,1),'b');
title("Polarity OFF")
grid off

subplot(4,2,2)
scatter3(bluevents.x(bluepolarityone,1),bluevents.y(bluepolarityone,1),bluevents.ts(bluepolarityone,1),'b');
title("Polarity ON")
grid off

subplot(4,2,3)
scatter3(redevents.x(redpolarityzero,1),redevents.y(redpolarityzero,1),redevents.ts(redpolarityzero,1),'r');
title("Polarity OFF")
grid off

subplot(4,2,4)
scatter3(redevents.x(redpolarityone,1),redevents.y(redpolarityone,1),redevents.ts(redpolarityone,1),'r');
title("Polarity ON")
grid off

subplot(4,2,5)
scatter3(green1events.x(green1polarityzero,1),green1events.y(green1polarityzero,1),green1events.ts(green1polarityzero,1),'g');
title("Polarity OFF")
grid off

subplot(4,2,6)
scatter3(green1events.x(green1polarityone,1),green1events.y(green1polarityone,1),green1events.ts(green1polarityone,1),'g');
title("Polarity ON")
grid off

subplot(4,2,7)
scatter3(green2events.x(green2polarityzero,1),green2events.y(green2polarityzero,1),green2events.ts(green2polarityzero,1),'g');
title("Polarity OFF")
grid off

subplot(4,2,8)
scatter3(green2events.x(green2polarityone,1),green2events.y(green2polarityone,1),green2events.ts(green2polarityone,1),'g');
title("Polarity ON")
grid off
%% RGB FEAST

idx = 0;
nTD = numel(TD.x);

% if DAVIS
% xs = 240;
% ys = 180;

%if Prophesee
xs = 250;
ys = 200;

%if DAVIS
% S = int64(zeros(xs,ys)); T = S; P = double(T);%-inf;
% 
%if Prophesee
S = zeros(xs,ys); T = S; P = double(T);
% 
tau = 1*1e4; % increase or decrease your exponential decay
displayFreq = 2e4; % For speed in units of time
nextTimeSample = TD.ts(1,1)+displayFreq;

thresholdArray_all = [];
% weightArray_all = [];
% capturedevent = [];

R = 7;
D = 2*R + 1; % D = 15
%number of neurons
nNeuron = 9;
binc = 1:nNeuron;
%learning rate
eta = 0.001;
% Adaptive Positive threshold
thresholdRise = 0.0008;
% Adaptive Negative threshold
thresholdFall = 0.005;
%A 15x15 matrix
% S = zeros(xs,ys); T = S; P = double(T);%-inf;%Negative infinite

% S = zeros(xs,ys); T = S; P = double(T);%-inf;

% T = ExcellentS-inf;:,
figure(4); clf;

sqNeuron = ceil(sqrt(nNeuron));
%weight, random numbersof 
w = rand(D*D,nNeuron);
%w = rand(xs*ys,nNeuron);
for iNeuron = 1:nNeuron
    w(:,iNeuron)       = w(:,iNeuron)./norm(w(:,iNeuron));
end

% x2 = 0:1:15;
% y2 = normpdf(x2,8,2.15);
% plot(x2,y2)
% xlim([-1 17])

%Initialize low threshold
% threshArray = zeros(1,nNeuron)+0.001;

% %Initialize random threshold
threshArray = rand(1,nNeuron);
% 
% %Initialize gaussian distribution threshold
% threshArray = y2;
% 
% %Initialize high threhold
countArray = zeros(1,nNeuron) + 10;

winnerNeuronArray = TD.x + nan;
% k = 0.5; K_next = 0.5; K_prev = 0.5;
T = T -inf;
T_F(:,:,nNeuron) = T;
T_F = T_F-inf;
P_F = T_F;
figure(432432);
pp = plot(winnerNeuronArray); grid on;
validthres = 0;
a = 1:nTD;
ind = randperm(numel(a));
index = a(ind);
missingCount = 0;
% for epoch = 1:1
% nextTimeSample = TD.ts(1,1)+displayFreq;

for epoch = 1:4
    
    for idx = 1:nTD
        x = TD.x(idx)+1;
        y = TD.y(idx)+1;
        t = TD.ts(idx);
        p = TD.p(idx);
        colour = TD.colour(idx);
        T(x,y) = t;
        P(x,y) = p;
        
        if x > 85 && x < 270 && y > 80 && y < 200 % only when coloured events are used
            if (x-R>0) && (x+R<xs) && (y-R>0) && (y+R<ys)
                if colour == 3 % 1 for blue, 2 for red, 3 for green1 and 4 for green2
                    ROI = P(x-R:x+R,y-R:y+R).*exp(double((T(x-R:x+R,y-R:y+R)-t))/tau);
                    
                    %             ROI = exp(double((T-t))/tau);
                    ROI_norm             = ROI/norm(ROI);
                    ROI_ARRAY       = ROI_norm(:)*ones(1,nNeuron);
                    dotProds        = sum(bsxfun(@times,w,ROI_ARRAY),1);
                    [C,winnerNeuron ]       = max(dotProds.*(dotProds > threshArray));
                    if all(C==0)
                        threshArray = threshArray - thresholdFall;  % example value of  thresholdFall  is 0.002
                        missingCount = missingCount' + 1;
                    else
                        w(:,winnerNeuron)           = w(:,winnerNeuron) + eta*(ROI(:));  % example value of  eta  is 0.001
                        
                        w(:,winnerNeuron)           = w(:,winnerNeuron)./norm(w(:,winnerNeuron));
                        threshArray(winnerNeuron)   = threshArray(winnerNeuron) + thresholdRise;     % example value of  thresholdFall is 0.001
                        countArray(winnerNeuron) = countArray(winnerNeuron) + 1;
                    end
                    %             thresholdArray_all(idx,:) = threshArray';
                    winnerNeuronArray(idx) = winnerNeuron;
                    
                    T_F(x,y,winnerNeuron) = t;
                    P_F(x,y,winnerNeuron) = p;
                    
                    if t > nextTimeSample
                        idx
                        threshArray(winnerNeuron);
                        winnerNeuron
                        
                        validthres = validthres + 1;
                        thresholdArray_all(validthres,:) = threshArray;
                        %                 thresholdArray_all = [thresholdArray_all, threshArray(winnerNeuron)];
                        %                 capturedevent = [capturedevent, countArray(winnerNeuron)];
                        %                 missingevent = idx - capturedevent(1,:);
                        %                 weightArray_all = [weightArray_all, w(:,winnerNeuron)];
                        
                        set(pp,'YData',winnerNeuronArray(max(idx-1e7,1):idx))
                        
                        nextTimeSample = max(nextTimeSample + displayFreq,t);
                        
                        figure(4)
                        for iNeuron = 1:nNeuron
                            subplot(sqNeuron,sqNeuron,iNeuron)
                            %subplot(1,nNeuron,iNeuron)
                            %wShow = reshape(w(:,iNeuron),xs,ys);
                            wShow = reshape(w(:,iNeuron),D,D);
                            wShow(R+1,R+1) = nan;
                            imagesc(wShow);colormap(gca , [0 0 0; 0 1 0; 1 1 1]);
                            view([90 90])
                            %                     title(append(num2str(threshArray(iNeuron),2),'-',num2str(countArray(iNeuron))))
                            title([ num2str(threshArray(iNeuron),2)   '-'  num2str(countArray(iNeuron))])
                            set(gca,'visible','off')
                            set(findall(gca, 'type', 'text'), 'visible', 'on')
                            
%                             colorbar
                        end
                        
                        S_F = exp(double((T_F-t))/tau/3);
                        %                 %Feature map
                        figure(5)
                        for iNeuron2 = 1:nNeuron
                            subplot(sqNeuron,sqNeuron,iNeuron2)
                            imagesc(S_F(:,:,iNeuron2)); colormap(gca , [0 0 0; 0 1 0; 1 1 1]);
                            view([90 90])
                            set(gca,'visible','off')
                            set(findall(gca, 'type', 'text'), 'visible', 'on')
                        end
                        
                        eta = eta * 0.999;
                        drawnow
                    end
                end
            end
        end
    end
end

% Visualize threshold

figure(45435);
for thresholdvalue = 1:nNeuron
    plot(thresholdArray_all(:,thresholdvalue),"LineWidth",2);hold on
%     legend("Neuron" + thresholdvalue)
end
xlabel("Iteration")
ylabel("Threshold value")
title("Blue events")

%% Inference

wFrozen = wgreen;
% downSampleFactor = 10;
% figure(432432);
% pp = plot(winnerNeuronArray); grid on;
% T = T -inf;
% T_F(:,:,nNeuron) = T;
% T_F = T_F-inf;
% P_F = zeros(size(T_F));
tau = 1*1e4;
% countNeuron = nan(2,nNeuron);count0 = 0;count1 = 0;
displayFreq = 3e4; % For speed in units of time
nextTimeSample = TD.ts(1,1)+displayFreq;
nTD = numel(TD.x);
nNeuron = 9;
sqNeuron = ceil(sqrt(nNeuron));
% T_Fd = zeros(round(size(T_F)./downSampleFactor))-inf;
% P_Fd = zeros(round(size(T_Fd))); 
% T_FdSimple = T_Fd;
% P_FdSimple = P_Fd;
% beta = 0.5; oneMinusBeta = 1-beta;

for idx = 1:nTD
    x = TD.x(idx)+1;
    y = TD.y(idx)+1;
    t = TD.ts(idx);
    p = TD.p(idx);
    colour = TD.colour(idx);
    T(x,y) = t;
    P(x,y) = p;
    
    %     if l == 0
    if (x-R>0) && (x+R<xs) && (y-R>0) && (y+R<ys)
        if x > 85 && x < 270 && y > 80 && y < 200 % only when coloured events are used
            if colour == 2 % 1 for blue, 2 for red, 3 for green1 and 4 for green2
                ROI = P(x-R:x+R,y-R:y+R).*exp(double((T(x-R:x+R,y-R:y+R)-t))/tau);
                
                ROI_norm             = ROI/norm(ROI);
                ROI_ARRAY       = ROI_norm(:)*ones(1,nNeuron);
                dotProds        = sum(bsxfun(@times,wFrozen,ROI_ARRAY),1);
                [C,winnerNeuron ]       = max(dotProds);
                
                winnerNeuronArray(idx) = winnerNeuron;
                
                %         if TD.c(idx) == 1
                %             count0 = count0 + 1;
                %             countNeuron(1,winnerNeuron) = count0;
                %         else
                %             count1 = count1 + 1;
                %             countNeuron(2,winnerNeuron) = count1;
                %         end
                
                T_F(x,y,winnerNeuron) = t;
                P_F(x,y,winnerNeuron) = p;
                
                if t > nextTimeSample
                    idx
                    winnerNeuron
                    
                    nextTimeSample = max(nextTimeSample + displayFreq,t);
                    
                    S_F = exp((T_F-t)/tau/3);
                    figure(8)
                    for iNeuron = 1:nNeuron
                        subplot(sqNeuron,sqNeuron,iNeuron)
                        imagesc(S_F(:,:,iNeuron));
                        colormap(gca , [0 0 0; 0 1 0; 1 1 1]);
                        view([90 90]);
                        set(gca,'visible','off');
                        set(findall(gca, 'type', 'text'), 'visible', 'on');
                        
                    end
                    
                    eta = eta * 0.999;
                    drawnow
                end
            end
        end
    end
end