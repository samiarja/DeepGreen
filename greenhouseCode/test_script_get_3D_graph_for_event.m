load("E:\mat\labeller\epaper_project\RED_DOT_White_Background-2020_03_11_13_46_19.mat.mat")
TD = events;
TD = struct('x',TD(:,1),'y',TD(:,2),'p',TD(:,3),'ts',TD(:,4));

xRGB = TD.x;
yRGB = TD.y;
TD.c = TD.p+NaN;
nEvents = numel(TD.x);
%%
for idx = 10000:nEvents
    if xRGB(idx) < 346 && yRGB(idx) < 260
        if rem(xRGB(idx),2) == 0 && rem(yRGB(idx),2) == 0
            % 1 == blue
            TD.c(idx) = 1;
        end
        if ~rem(xRGB(idx),2) == 0 && ~rem(yRGB(idx),2) == 0
            % 2 == red
            TD.c(idx) = 2;
        end
        if ~rem(xRGB(idx),2) == 0 && rem(yRGB(idx),2) == 0
            % 3 == green 1
            TD.c(idx) = 3;
        end
        if rem(xRGB(idx),2) == 0 && ~rem(yRGB(idx),2) == 0
            % 3 == green 2
            TD.c(idx) = 4;
        end
    end
end

TD.ts = TD.ts - TD.ts(1,1);

% [cnt_unique, unique_a] = hist(double(TD.c),unique(double(TD.c)));
%%
figure(665);
z = fliplr(TD.ts(90000:200000));

scatter3(TD.x(90000:200000),TD.y(90000:200000),TD.ts(90000:200000),2,z)
xlabel("x")
ylabel("y")
xlim([150 346])
ylim([50 300])
%%
RedCount = size(find(TD.c == 2));
GreenCount1 = size(find(TD.c == 3));
GreenCount2 = size(find(TD.c == 4));
BlueCount = size(find(TD.c == 1));

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

xs = 173;
ys = 130/2;

S = int64(zeros(xs,ys)); T = S; P = double(T);%-inf;
nevents = numel(TD.ts);
tau = 1*1e5;
displayFreq = 10e4; % in units of time
nextTimeSample = TD.ts(1,1)+displayFreq;

% colormap( gca , [0 0 0; 1 0 0; 0 1 0] )
% colormap( flipud(gray(256)) )

figure(5); clf;ss = imagesc(gca,S);colormap(gca , [0 0 0; 0 1 0; 1 1 1])
% figure(6);
for idx = 10000:611854
    x = TD.x(idx)+1;
    y = TD.y(idx)+1;
    t = TD.ts(idx);
    p = TD.p(idx);
    l = TD.c(idx);
    if l == 3 % (1 red, 2 blue, 3 green)
        T(x,y) = t;
        P(x,y)=p;
        if t > nextTimeSample
            nextTimeSample = max(nextTimeSample + displayFreq,t);
            S = exp(double((T-t))/tau);
%             S = S(1:2:end,1:2:end); % only for red 1
%                                           S = S(2:2:end,2:2:end); % only for blue 2
                                          S = S(2:2:end,1:2:end); % only for green 3
            set(gcf,'position',[700,1200,xs*3,ys*3])
            set(ss,'CData',S)
            drawnow limitrate
            %             surf(S);
            view([90 -90])
            title([num2str(idx) '/' num2str(nevents) '----' 'All Event'])
        end
    end
end
%%
figure(464676);
subplot(1,2,1)
plot(sum(S')',"LineWidth",2)
ylabel("Event Summation across Rows")

subplot(1,2,2)
plot(sum(S),"LineWidth",2)
ylabel("Event Summationacross Columns")
