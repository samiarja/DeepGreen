%% Get event duration and event count and find differences
clc
clear
close all
lineWidth = 2;
fontSize = 20;
markerSize = 10;

eventCountforRed_red = [];
eventCountforRed_blue = [];
eventCountforRed_green = [];

eventCountforBlack_red = [];
eventCountforBlack_blue = [];
eventCountforBlack_green = [];

eventDurationforRed_red = [];
eventDurationforRed_blue = [];
eventDurationforRed_green = [];

eventDurationforBlack_red = [];
eventDurationforBlack_blue = [];
eventDurationforBlack_green = [];

for idx = 1:49
    redCircle = load("Data/redCircleWhiteBackground/" + idx + ".mat");
    blackCircle = load("Data/blackCircleWhiteBackground/" + idx + ".mat");
    
    
    % for red circle
    findRedEvents_RedCircle = find(redCircle.events(:,5)==2); % find index for red events == 2
    findblueEvents_RedCircle = find(redCircle.events(:,5)==1); % find index for blue events == 1
    findgreenEvents_RedCircle = find(redCircle.events(:,5)==3); % find index for green events == 3
    
    % for black circle
    findRedEvents_BlackCircle = find(blackCircle.events(:,5)==2); % find index for red events == 2
    findblueEvents_BlackCircle = find(blackCircle.events(:,5)==1); % find index for blue events == 1
    findgreenEvents_BlackCircle = find(blackCircle.events(:,5)==3); % find index for green events == 3
    
    
    redCircle_Red = redCircle.events(findRedEvents_RedCircle,:); % select red events from the original stream
    redCircle_Blue = redCircle.events(findblueEvents_RedCircle,:); % select blue events from the original stream
    redCircle_Green = redCircle.events(findgreenEvents_RedCircle,:); % select green events from the original stream
    
    blackCircle_Red = blackCircle.events(findRedEvents_BlackCircle,:); % select red events from the original stream
    blackCircle_Blue = blackCircle.events(findblueEvents_BlackCircle,:); % select blue events from the original stream
    blackCircle_Green = blackCircle.events(findgreenEvents_BlackCircle,:); % select green events from the original stream
    
    
    % fill up matrix for red circle (events count)
    eventCountforRed_red = [eventCountforRed_red;numel(redCircle_Red(:,1))];
    eventCountforRed_blue = [eventCountforRed_blue;numel(redCircle_Blue(:,1))];
    eventCountforRed_green = [eventCountforRed_green;numel(redCircle_Green(:,1))];
    % fill up matrix for black circle (events count)
    eventCountforBlack_red = [eventCountforBlack_red;numel(blackCircle_Red(:,1))];
    eventCountforBlack_blue = [eventCountforBlack_blue;numel(blackCircle_Blue(:,1))];
    eventCountforBlack_green = [eventCountforBlack_green;numel(blackCircle_Green(:,1))];
    
    
    % fill up matrix for red circle (events duration)
    eventDurationforRed_red = [eventDurationforRed_red;(redCircle_Red(end,1)-redCircle_Red(1,1))];
    eventDurationforRed_blue = [eventDurationforRed_blue;(redCircle_Blue(end,1)-redCircle_Blue(1,1))];
    eventDurationforRed_green = [eventDurationforRed_green;(redCircle_Green(end,1)-redCircle_Green(1,1))];
    
    % fill up matrix for black circle (events duration)
    eventDurationforBlack_red = [eventDurationforBlack_red;(blackCircle_Red(end,1)-blackCircle_Red(1,1))];
    eventDurationforBlack_blue = [eventDurationforBlack_blue;(blackCircle_Blue(end,1)-blackCircle_Blue(1,1))];
    eventDurationforBlack_green = [eventDurationforBlack_green;(blackCircle_Green(end,1)-blackCircle_Green(1,1))];
    
end

% timeDiff = eventDurationforblack - eventDurationforred;

figure(1);
% subplot(1,2,1)
plot(eventCountforRed_red,'r','LineWidth', lineWidth, 'MarkerSize', markerSize);hold on
plot(eventCountforRed_blue,'b','LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(eventCountforRed_green,'g','LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(eventCountforBlack_red,'r--','LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(eventCountforBlack_blue,'b--','LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(eventCountforBlack_green,'g--','LineWidth', lineWidth, 'MarkerSize', markerSize);
legend("Red Circle - Red Events", "Red Circle - Blue Events", "Red Circle - Green Events","Black Circle - Red Events", "Black Circle - Blue Events", "Black Circle - Green Events");
xlabel("Number of recorded Data");
ylabel("Number of events");
title("Number of events",'FontSize', fontSize, 'Interpreter', 'None');

% subplot(1,2,2)
% plot(eventDurationforRed/1e6,'b','LineWidth', lineWidth, 'MarkerSize', markerSize);hold on
% plot(eventDurationforBlack/1e6,'r','LineWidth', lineWidth, 'MarkerSize', markerSize);
% legend("Pattern 1", "Pattern 2");
% xlabel("Number of recorded Data");
% ylabel("Duration of events (s)");
% title("Duration of events",'FontSize', fontSize, 'Interpreter', 'None');

%% 
clc
clear
close all
% the data is structured that way:

% x = events(:,2)
% y = events(:,3)
% p = events(:,4)
% ts = events(:,1)

% For red circle white background
% only red events
ONEventRedCircle_redEvent = [];
OFFEventRedCircle_redEvent = [];
ONOFFRatioRedCircle_redEvent = [];
TotalEventRedCircle_redEvent = [];
DurationRedCircle_redEvent = [];
XmeanRedCircle_redEvent = [];
YmeanRedCircle_redEvent = [];
XstdvRedCircle_redEvent = [];
YstdvRedCircle_redEvent = [];
% only blue events
ONEventRedCircle_blueEvent = [];
OFFEventRedCircle_blueEvent = [];
ONOFFRatioRedCircle_blueEvent = [];
TotalEventRedCircle_blueEvent = [];
DurationRedCircle_blueEvent = [];
XmeanRedCircle_blueEvent = [];
YmeanRedCircle_blueEvent = [];
XstdvRedCircle_blueEvent = [];
YstdvRedCircle_blueEvent = [];
% only green events
ONEventRedCircle_greenEvent = [];
OFFEventRedCircle_greenEvent = [];
ONOFFRatioRedCircle_greenEvent = [];
TotalEventRedCircle_greenEvent = [];
DurationRedCircle_greenEvent = [];
XmeanRedCircle_greenEvent = [];
YmeanRedCircle_greenEvent = [];
XstdvRedCircle_greenEvent = [];
YstdvRedCircle_greenEvent = [];


% For black circle white background
% only red events
ONEventBlackCircle_redEvent = [];
OFFEventBlackCircle_redEvent = [];
ONOFFRatioBlackCircle_redEvent = [];
TotalEventBlackCircle_redEvent = [];
DurationBlackCircle_redEvent = [];
XmeanBlackCircle_redEvent = [];
YmeanBlackCircle_redEvent = [];
XstdvBlackCircle_redEvent = [];
YstdvBlackCircle_redEvent = [];
% only blue events
ONEventBlackCircle_blueEvent = [];
OFFEventBlackCircle_blueEvent = [];
ONOFFRatioBlackCircle_blueEvent = [];
TotalEventBlackCircle_blueEvent = [];
DurationBlackCircle_blueEvent = [];
XmeanBlackCircle_blueEvent= [];
YmeanBlackCircle_blueEvent = [];
XstdvBlackCircle_blueEvent = [];
YstdvBlackCircle_blueEvent = [];
% only green events
ONEventBlackCircle_greenEvent = [];
OFFEventBlackCircle_greenEvent = [];
ONOFFRatioBlackCircle_greenEvent = [];
TotalEventBlackCircle_greenEvent = [];
DurationBlackCircle_greenEvent = [];
XmeanBlackCircle_greenEvent = [];
YmeanBlackCircle_greenEvent = [];
XstdvBlackCircle_greenEvent = [];
YstdvBlackCircle_greenEvent = [];

for idx = 1:49
    % Load files for both pattern
    redCircle = load("Data/redCircleWhiteBackground/" + idx + ".mat");
    blackCircle = load("Data/blackCircleWhiteBackground/" + idx + ".mat");    

    % for red circle
    findRedEvents_RedCircle = find(redCircle.events(:,5)==2); % find index for red events == 2
    findblueEvents_RedCircle = find(redCircle.events(:,5)==1); % find index for blue events == 1
    findgreenEvents_RedCircle = find(redCircle.events(:,5)==3); % find index for green events == 3
    
    % for black circle
    findRedEvents_BlackCircle = find(blackCircle.events(:,5)==2); % find index for red events == 2
    findblueEvents_BlackCircle = find(blackCircle.events(:,5)==1); % find index for blue events == 1
    findgreenEvents_BlackCircle = find(blackCircle.events(:,5)==3); % find index for green events == 3
    
    % Divided events (RGB) stream for red circle
    redCircle_Red = redCircle.events(findRedEvents_RedCircle,:); % select red events from the original stream
    redCircle_Blue = redCircle.events(findblueEvents_RedCircle,:); % select blue events from the original stream
    redCircle_Green = redCircle.events(findgreenEvents_RedCircle,:); % select green events from the original stream
    
    % Divided events (RGB) stream for black circle
    blackCircle_Red = blackCircle.events(findRedEvents_BlackCircle,:); % select red events from the original stream
    blackCircle_Blue = blackCircle.events(findblueEvents_BlackCircle,:); % select blue events from the original stream
    blackCircle_Green = blackCircle.events(findgreenEvents_BlackCircle,:); % select green events from the original stream
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % For red circle white background
    % only red events
    % ON events
    ONEventRedCircle_redEvent = [ONEventRedCircle_redEvent;length(find(redCircle_Red(:,4) == 1))];
    ONEventRedCircle_blueEvent = [ONEventRedCircle_blueEvent;length(find(redCircle_Blue(:,4) == 1))];
    ONEventRedCircle_greenEvent = [ONEventRedCircle_greenEvent;length(find(redCircle_Green(:,4) == 1))];
    
    % OFF events
    OFFEventRedCircle_redEvent = [OFFEventRedCircle_redEvent;length(find(redCircle_Red(:,4) == 0))];
    OFFEventRedCircle_blueEvent = [OFFEventRedCircle_blueEvent;length(find(redCircle_Blue(:,4) == 0))];
    OFFEventRedCircle_greenEvent = [OFFEventRedCircle_greenEvent;length(find(redCircle_Green(:,4) == 0))];
    
    % ON/OFF events
    ONOFFRatioRedCircle_redEvent = [ONOFFRatioRedCircle_redEvent;size(find(redCircle_Red(:,4) == 1))/size(find(redCircle_Red(:,4) == 0))];
    ONOFFRatioRedCircle_blueEvent = [ONOFFRatioRedCircle_blueEvent;size(find(redCircle_Blue(:,4) == 1))/size(find(redCircle_Blue(:,4) == 0))];
    ONOFFRatioRedCircle_greenEvent = [ONOFFRatioRedCircle_greenEvent;size(find(redCircle_Green(:,4) == 1))/size(find(redCircle_Green(:,4) == 0))];
    
    % Number of events
    TotalEventRedCircle_redEvent = [TotalEventRedCircle_redEvent;numel(redCircle_Red(:,2))];
    TotalEventRedCircle_blueEvent = [TotalEventRedCircle_blueEvent;numel(redCircle_Blue(:,2))];
    TotalEventRedCircle_greenEvent = [TotalEventRedCircle_greenEvent;numel(redCircle_Green(:,2))];    
    
    % Event duration
    DurationRedCircle_redEvent = [DurationRedCircle_redEvent;redCircle_Red(end,1) - redCircle_Red(1,1)];
    DurationRedCircle_blueEvent = [DurationRedCircle_blueEvent;redCircle_Blue(end,1) - redCircle_Blue(1,1)];
    DurationRedCircle_greenEvent = [DurationRedCircle_greenEvent;redCircle_Green(end,1) - redCircle_Green(1,1)];
    
    % X mean
    XmeanRedCircle_redEvent = [XmeanRedCircle_redEvent;mean(redCircle_Red(:,2))];
    XmeanRedCircle_blueEvent = [XmeanRedCircle_blueEvent;mean(redCircle_Blue(:,2))];
    XmeanRedCircle_greenEvent = [XmeanRedCircle_greenEvent;mean(redCircle_Green(:,2))];
    
    % Y mean
    YmeanRedCircle_redEvent = [YmeanRedCircle_redEvent;mean(redCircle_Red(:,3))];
    YmeanRedCircle_blueEvent = [YmeanRedCircle_blueEvent;mean(redCircle_Blue(:,3))];
    YmeanRedCircle_greenEvent = [YmeanRedCircle_greenEvent;mean(redCircle_Green(:,3))];
    
    % X stdv
    XstdvRedCircle_redEvent = [XstdvRedCircle_redEvent;std(single(redCircle_Red(:,2)))];
    XstdvRedCircle_blueEvent = [XstdvRedCircle_blueEvent;std(single(redCircle_Blue(:,2)))];
    XstdvRedCircle_greenEvent = [XstdvRedCircle_greenEvent;std(single(redCircle_Green(:,2)))];
    
    % Y stdv
    YstdvRedCircle_redEvent = [YstdvRedCircle_redEvent;std(single(redCircle_Red(:,3)))];
    YstdvRedCircle_blueEvent = [YstdvRedCircle_blueEvent;std(single(redCircle_Blue(:,3)))];
    YstdvRedCircle_greenEvent = [YstdvRedCircle_greenEvent;std(single(redCircle_Green(:,3)))];
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % For black circle white background Black
    % only red events
    % ON events
    ONEventBlackCircle_redEvent = [ONEventBlackCircle_redEvent;length(find(blackCircle_Red(:,4) == 1))];
    ONEventBlackCircle_blueEvent = [ONEventBlackCircle_blueEvent;length(find(blackCircle_Blue(:,4) == 1))];
    ONEventBlackCircle_greenEvent = [ONEventBlackCircle_greenEvent;length(find(blackCircle_Green(:,4) == 1))];
    
    % OFF events
    OFFEventBlackCircle_redEvent = [OFFEventBlackCircle_redEvent;length(find(blackCircle_Red(:,4) == 0))];
    OFFEventBlackCircle_blueEvent = [OFFEventBlackCircle_blueEvent;length(find(blackCircle_Blue(:,4) == 0))];
    OFFEventBlackCircle_greenEvent = [OFFEventBlackCircle_greenEvent;length(find(blackCircle_Green(:,4) == 0))];
    
    % ON/OFF events
    ONOFFRatioBlackCircle_redEvent = [ONOFFRatioBlackCircle_redEvent;size(find(blackCircle_Red(:,4) == 1))/size(find(blackCircle_Red(:,4) == 0))];
    ONOFFRatioBlackCircle_blueEvent = [ONOFFRatioBlackCircle_blueEvent;size(find(blackCircle_Blue(:,4) == 1))/size(find(blackCircle_Blue(:,4) == 0))];
    ONOFFRatioBlackCircle_greenEvent = [ONOFFRatioBlackCircle_greenEvent;size(find(blackCircle_Green(:,4) == 1))/size(find(blackCircle_Green(:,4) == 0))];
    
    % Number of events
    TotalEventBlackCircle_redEvent = [TotalEventBlackCircle_redEvent;numel(blackCircle_Red(:,2))];
    TotalEventBlackCircle_blueEvent = [TotalEventBlackCircle_blueEvent;numel(blackCircle_Blue(:,2))];
    TotalEventBlackCircle_greenEvent = [TotalEventBlackCircle_greenEvent;numel(blackCircle_Green(:,2))];    
    
    % Event duration
    DurationBlackCircle_redEvent = [DurationBlackCircle_redEvent;blackCircle_Red(end,1) - blackCircle_Red(1,1)];
    DurationBlackCircle_blueEvent = [DurationBlackCircle_blueEvent;blackCircle_Blue(end,1) - blackCircle_Blue(1,1)];
    DurationBlackCircle_greenEvent = [DurationBlackCircle_greenEvent;blackCircle_Green(end,1) - blackCircle_Green(1,1)];
    
    % X mean
    XmeanBlackCircle_redEvent = [XmeanBlackCircle_redEvent;mean(blackCircle_Red(:,2))];
    XmeanBlackCircle_blueEvent = [XmeanBlackCircle_blueEvent;mean(blackCircle_Blue(:,2))];
    XmeanBlackCircle_greenEvent = [XmeanBlackCircle_greenEvent;mean(blackCircle_Green(:,2))];
    
    % Y mean
    YmeanBlackCircle_redEvent = [YmeanBlackCircle_redEvent;mean(blackCircle_Red(:,3))];
    YmeanBlackCircle_blueEvent = [YmeanBlackCircle_blueEvent;mean(blackCircle_Blue(:,3))];
    YmeanBlackCircle_greenEvent = [YmeanBlackCircle_greenEvent;mean(blackCircle_Green(:,3))];
    
    % X stdv
    XstdvBlackCircle_redEvent = [XstdvBlackCircle_redEvent;std(single(blackCircle_Red(:,2)))];
    XstdvBlackCircle_blueEvent = [XstdvBlackCircle_blueEvent;std(single(blackCircle_Blue(:,2)))];
    XstdvBlackCircle_greenEvent = [XstdvBlackCircle_greenEvent;std(single(blackCircle_Green(:,2)))];
    
    % Y stdv
    YstdvBlackCircle_redEvent = [YstdvBlackCircle_redEvent;std(single(blackCircle_Red(:,3)))];
    YstdvBlackCircle_blueEvent = [YstdvBlackCircle_blueEvent;std(single(blackCircle_Blue(:,3)))];
    YstdvBlackCircle_greenEvent = [YstdvBlackCircle_greenEvent;std(single(blackCircle_Green(:,3)))];
end
%% Plot mean and stdv for all statistics

% ONEventRedCircle_redEvent         ONEventBlackCircle_redEvent
% ONEventRedCircle_blueEvent        ONEventBlackCircle_blueEvent
% ONEventRedCircle_greenEvent       ONEventBlackCircle_greenEvent

% OFFEventRedCircle_redEvent        OFFEventBlackCircle_redEvent 
% OFFEventRedCircle_blueEvent       OFFEventBlackCircle_blueEvent 
% OFFEventRedCircle_greenEvent      OFFEventBlackCircle_greenEvent

% ONOFFRatioRedCircle_redEvent      ONOFFRatioBlackCircle_redEvent
% ONOFFRatioRedCircle_blueEvent     ONOFFRatioBlackCircle_blueEvent
% ONOFFRatioRedCircle_greenEvent    ONOFFRatioBlackCircle_greenEvent

% TotalEventRedCircle_redEvent      TotalEventBlackCircle_redEvent
% TotalEventRedCircle_blueEvent     TotalEventBlackCircle_redEvent
% TotalEventRedCircle_greenEvent    TotalEventBlackCircle_redEvent

% DurationRedCircle_redEvent        DurationBlackCircle_redEvent
% DurationRedCircle_blueEvent       DurationBlackCircle_blueEvent
% DurationRedCircle_greenEvent      DurationBlackCircle_greenEvent

% XmeanRedCircle_redEvent           XmeanBlackCircle_redEvent
% XmeanRedCircle_blueEvent          XmeanBlackCircle_blueEvent
% XmeanRedCircle_greenEvent         XmeanBlackCircle_greenEvent

% YmeanRedCircle_redEvent           YmeanBlackCircle_redEvent 
% YmeanRedCircle_blueEvent          YmeanBlackCircle_blueEvent
% YmeanRedCircle_greenEvent         YmeanBlackCircle_greenEvent

% XstdvRedCircle_redEvent           XstdvBlackCircle_redEvent 
% XstdvRedCircle_blueEvent          XstdvBlackCircle_blueEvent 
% XstdvRedCircle_greenEvent         XstdvBlackCircle_greenEvent

% YstdvRedCircle_redEvent           YstdvBlackCircle_redEvent 
% YstdvRedCircle_blueEvent          YstdvBlackCircle_blueEvent 
% YstdvRedCircle_greenEvent         YstdvBlackCircle_greenEvent

figure(567657);

subplot(3,3,1)
x1 = [mean(ONEventRedCircle_redEvent) mean(ONEventRedCircle_blueEvent) mean(ONEventRedCircle_greenEvent); mean(ONEventBlackCircle_redEvent) mean(ONEventBlackCircle_blueEvent) mean(ONEventBlackCircle_greenEvent)];
Stdv1 = [std(ONEventRedCircle_redEvent) std(ONEventRedCircle_blueEvent) std(ONEventRedCircle_greenEvent); std(ONEventBlackCircle_redEvent) std(ONEventBlackCircle_blueEvent) std(ONEventBlackCircle_greenEvent)];
b = bar(x1,'facecolor',[.8 .8 .8]);hold on
b(1).FaceColor = [.9 .0 .0];b(2).FaceColor = [.0 .0 .9];b(3).FaceColor = [.0 .9 .0];
% hb(1).FaceColor = 'r';
str={'Red Circle','Black Circle'};
set(gca, 'XTickLabel',str, 'XTick',1:numel(str),'fontsize',18, 'YGrid', 'on', 'XGrid', 'off')
ylabel('Mean');
title("ON Events")
ngroups = size(x1, 1);
nbars = size(x1, 2);
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
    % Calculate center of each bar
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, x1(:,i), Stdv1(:,i), 'k', 'linestyle', 'none');
end
hold off
%%For MATLAB 2019b or later releases
hold on
% Calculate the number of bars in each group
nbars = size(x1, 2);
% Get the x coordinate of the bars
x = [];
for i = 1:nbars
    x = [x ; b(i).XEndPoints];
end
% Plot the errorbars
errorbar(x',x1,Stdv1,'k','linestyle','none','CapSize',18);
hold off


subplot(3,3,2)
x2 = [mean(OFFEventRedCircle_redEvent) mean(OFFEventRedCircle_blueEvent) mean(OFFEventRedCircle_greenEvent); mean(OFFEventBlackCircle_redEvent) mean(OFFEventBlackCircle_blueEvent) mean(OFFEventBlackCircle_greenEvent)];
Stdv2 = [std(OFFEventRedCircle_redEvent) std(OFFEventRedCircle_blueEvent) std(OFFEventRedCircle_greenEvent); std(OFFEventBlackCircle_redEvent) std(OFFEventBlackCircle_blueEvent) std(OFFEventBlackCircle_greenEvent)];
b = bar(x2,'facecolor',[.8 .8 .8]);hold on
b(1).FaceColor = [.9 .0 .0];b(2).FaceColor = [.0 .0 .9];b(3).FaceColor = [.0 .9 .0];
% hb(1).FaceColor = 'r';
str={'Red Circle','Black Circle'};
set(gca, 'XTickLabel',str, 'XTick',1:numel(str),'fontsize',18, 'YGrid', 'on', 'XGrid', 'off')
ylabel('Mean');
title("OFF Events")
ngroups = size(x2, 1);
nbars = size(x2, 2);
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
    % Calculate center of each bar
    x_2 = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x_2, x2(:,i), Stdv2(:,i), 'k', 'linestyle', 'none');
end
hold off
%%For MATLAB 2019b or later releases
hold on
% Calculate the number of bars in each group
nbars = size(x2, 2);
% Get the x coordinate of the bars
x_2 = [];
for i = 1:nbars
    x_2 = [x_2 ; b(i).XEndPoints];
end
% Plot the errorbars
errorbar(x_2',x2,Stdv2,'k','linestyle','none','CapSize',18);
hold off

subplot(3,3,3)
x3 = [mean(ONOFFRatioRedCircle_redEvent) mean(ONOFFRatioRedCircle_blueEvent) mean(ONOFFRatioRedCircle_greenEvent); mean(ONOFFRatioBlackCircle_redEvent) mean(ONOFFRatioBlackCircle_blueEvent) mean(ONOFFRatioBlackCircle_greenEvent)];
Stdv3 = [std(ONOFFRatioRedCircle_redEvent) std(ONOFFRatioRedCircle_blueEvent) std(ONOFFRatioRedCircle_greenEvent); std(ONOFFRatioBlackCircle_redEvent) std(ONOFFRatioBlackCircle_blueEvent) std(ONOFFRatioBlackCircle_greenEvent)];
b = bar(x3,'facecolor',[.8 .8 .8]);hold on
b(1).FaceColor = [.9 .0 .0];b(2).FaceColor = [.0 .0 .9];b(3).FaceColor = [.0 .9 .0];
% hb(1).FaceColor = 'r';
str={'Red Circle','Black Circle'};
set(gca, 'XTickLabel',str, 'XTick',1:numel(str),'fontsize',18, 'YGrid', 'on', 'XGrid', 'off')
ylabel('Mean');
title("ON/OFF Ratio")
ngroups = size(x3, 1);
nbars = size(x3, 2);
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
    % Calculate center of each bar
    x_3 = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x_3, x3(:,i), Stdv3(:,i), 'k', 'linestyle', 'none');
end
hold off
%%For MATLAB 2019b or later releases
hold on
% Calculate the number of bars in each group
nbars = size(x3, 2);
% Get the x coordinate of the bars
x_3 = [];
for i = 1:nbars
    x_3 = [x_3 ; b(i).XEndPoints];
end
% Plot the errorbars
errorbar(x_3',x3,Stdv3,'k','linestyle','none','CapSize',18);
hold off

subplot(3,3,4)
x4 = [mean(TotalEventRedCircle_redEvent) mean(TotalEventRedCircle_blueEvent) mean(TotalEventRedCircle_greenEvent); mean(TotalEventBlackCircle_redEvent) mean(TotalEventBlackCircle_redEvent) mean(TotalEventBlackCircle_redEvent)];
Stdv4 = [std(TotalEventRedCircle_redEvent) std(TotalEventRedCircle_blueEvent) std(TotalEventRedCircle_greenEvent); std(TotalEventBlackCircle_redEvent) std(TotalEventBlackCircle_redEvent) std(TotalEventBlackCircle_redEvent)];
b = bar(x4,'facecolor',[.8 .8 .8]);hold on
b(1).FaceColor = [.9 .0 .0];b(2).FaceColor = [.0 .0 .9];b(3).FaceColor = [.0 .9 .0];
% hb(1).FaceColor = 'r';
str={'Red Circle','Black Circle'};
set(gca, 'XTickLabel',str, 'XTick',1:numel(str),'fontsize',18, 'YGrid', 'on', 'XGrid', 'off')
ylabel('Mean');
title("Number of Events")
ngroups = size(x4, 1);
nbars = size(x4, 2);
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
    % Calculate center of each bar
    x_4 = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x_4, x4(:,i), Stdv4(:,i), 'k', 'linestyle', 'none');
end
hold off
%%For MATLAB 2019b or later releases
hold on
% Calculate the number of bars in each group
nbars = size(x4, 2);
% Get the x coordinate of the bars
x_4 = [];
for i = 1:nbars
    x_4 = [x_4 ; b(i).XEndPoints];
end
% Plot the errorbars
errorbar(x_4',x4,Stdv4,'k','linestyle','none','CapSize',18);
hold off

subplot(3,3,5)
x5 = [mean(DurationRedCircle_redEvent) mean(DurationRedCircle_blueEvent) mean(DurationRedCircle_greenEvent); mean(DurationBlackCircle_redEvent) mean(DurationBlackCircle_blueEvent) mean(DurationBlackCircle_greenEvent)];
Stdv5 = [std(DurationRedCircle_redEvent) std(DurationRedCircle_blueEvent) std(DurationRedCircle_greenEvent); std(DurationBlackCircle_redEvent) std(DurationBlackCircle_blueEvent) std(DurationBlackCircle_greenEvent)];
b = bar(x5,'facecolor',[.8 .8 .8]);hold on
b(1).FaceColor = [.9 .0 .0];b(2).FaceColor = [.0 .0 .9];b(3).FaceColor = [.0 .9 .0];
% hb(1).FaceColor = 'r';
str={'Red Circle','Black Circle'};
set(gca, 'XTickLabel',str, 'XTick',1:numel(str),'fontsize',18, 'YGrid', 'on', 'XGrid', 'off')
ylabel('Mean');
title("Events Duration")
ngroups = size(x5, 1);
nbars = size(x5, 2);
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
    % Calculate center of each bar
    x_5 = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x_5, x5(:,i), Stdv5(:,i), 'k', 'linestyle', 'none');
end
hold off
%%For MATLAB 2019b or later releases
hold on
% Calculate the number of bars in each group
nbars = size(x5, 2);
% Get the x coordinate of the bars
x_5 = [];
for i = 1:nbars
    x_5 = [x_5 ; b(i).XEndPoints];
end
% Plot the errorbars
errorbar(x_5',x5,Stdv5,'k','linestyle','none','CapSize',18);
hold off

subplot(3,3,6)
x6 = [mean(XmeanRedCircle_redEvent) mean(XmeanRedCircle_blueEvent) mean(XmeanRedCircle_greenEvent); mean(XmeanBlackCircle_redEvent) mean(XmeanBlackCircle_blueEvent) mean(XmeanBlackCircle_greenEvent)];
Stdv6 = [std(XmeanRedCircle_redEvent) std(XmeanRedCircle_blueEvent) std(XmeanRedCircle_greenEvent); std(XmeanBlackCircle_redEvent) std(XmeanBlackCircle_blueEvent) std(XmeanBlackCircle_greenEvent)];
b = bar(x6,'facecolor',[.8 .8 .8]);hold on
b(1).FaceColor = [.9 .0 .0];b(2).FaceColor = [.0 .0 .9];b(3).FaceColor = [.0 .9 .0];
% hb(1).FaceColor = 'r';
str={'Red Circle','Black Circle'};
set(gca, 'XTickLabel',str, 'XTick',1:numel(str),'fontsize',18, 'YGrid', 'on', 'XGrid', 'off')
ylabel('Mean');
title("X Mean")
ngroups = size(x6, 1);
nbars = size(x6, 2);
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
    % Calculate center of each bar
    x_6 = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x_6, x6(:,i), Stdv6(:,i), 'k', 'linestyle', 'none');
end
hold off
%%For MATLAB 2019b or later releases
hold on
% Calculate the number of bars in each group
nbars = size(x6, 2);
% Get the x coordinate of the bars
x_6 = [];
for i = 1:nbars
    x_6 = [x_6 ; b(i).XEndPoints];
end
% Plot the errorbars
errorbar(x_6',x6,Stdv6,'k','linestyle','none','CapSize',18);
hold off

subplot(3,3,7)
x7 = [mean(YmeanRedCircle_redEvent) mean(YmeanRedCircle_blueEvent) mean(YmeanRedCircle_greenEvent); mean(YmeanBlackCircle_redEvent) mean(YmeanBlackCircle_blueEvent) mean(YmeanBlackCircle_greenEvent)];
Stdv7 = [std(YmeanRedCircle_redEvent) std(YmeanRedCircle_blueEvent) std(YmeanRedCircle_greenEvent); std(YmeanBlackCircle_redEvent) std(YmeanBlackCircle_blueEvent) std(YmeanBlackCircle_greenEvent)];
b = bar(x7,'facecolor',[.8 .8 .8]);hold on
b(1).FaceColor = [.9 .0 .0];b(2).FaceColor = [.0 .0 .9];b(3).FaceColor = [.0 .9 .0];
% hb(1).FaceColor = 'r';
str={'Red Circle','Black Circle'};
set(gca, 'XTickLabel',str, 'XTick',1:numel(str),'fontsize',18, 'YGrid', 'on', 'XGrid', 'off')
ylabel('Mean');
title("Y Mean")
ngroups = size(x7, 1);
nbars = size(x7, 2);
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
    % Calculate center of each bar
    x_7 = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x_7, x7(:,i), Stdv7(:,i), 'k', 'linestyle', 'none');
end
hold off
%%For MATLAB 2019b or later releases
hold on
% Calculate the number of bars in each group
nbars = size(x7, 2);
% Get the x coordinate of the bars
x_7 = [];
for i = 1:nbars
    x_7 = [x_7 ; b(i).XEndPoints];
end
% Plot the errorbars
errorbar(x_7',x7,Stdv7,'k','linestyle','none','CapSize',18);
hold off

subplot(3,3,8)
x8 = [mean(XstdvRedCircle_redEvent) mean(XstdvRedCircle_blueEvent) mean(XstdvRedCircle_greenEvent); mean(XstdvBlackCircle_redEvent) mean(XstdvBlackCircle_blueEvent) mean(XstdvBlackCircle_greenEvent)];
Stdv8 = [std(XstdvRedCircle_redEvent) std(XstdvRedCircle_blueEvent) std(XstdvRedCircle_greenEvent); std(XstdvBlackCircle_redEvent) std(XstdvBlackCircle_blueEvent) std(XstdvBlackCircle_greenEvent)];
b = bar(x8,'facecolor',[.8 .8 .8]);hold on
b(1).FaceColor = [.9 .0 .0];b(2).FaceColor = [.0 .0 .9];b(3).FaceColor = [.0 .9 .0];
% hb(1).FaceColor = 'r';
str={'Red Circle','Black Circle'};
set(gca, 'XTickLabel',str, 'XTick',1:numel(str),'fontsize',18, 'YGrid', 'on', 'XGrid', 'off')
ylabel('Mean');
title("X Stdv")
ngroups = size(x8, 1);
nbars = size(x8, 2);
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
    % Calculate center of each bar
    x_8 = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x_8, x8(:,i), Stdv8(:,i), 'k', 'linestyle', 'none');
end
hold off
%%For MATLAB 2019b or later releases
hold on
% Calculate the number of bars in each group
nbars = size(x8, 2);
% Get the x coordinate of the bars
x_8 = [];
for i = 1:nbars
    x_8 = [x_8 ; b(i).XEndPoints];
end
% Plot the errorbars
errorbar(x_8',x8,Stdv8,'k','linestyle','none','CapSize',18);
hold off

subplot(3,3,9)
x9 = [mean(YstdvRedCircle_redEvent) mean(YstdvRedCircle_blueEvent) mean(YstdvRedCircle_greenEvent); mean(YstdvBlackCircle_redEvent) mean(YstdvBlackCircle_blueEvent) mean(YstdvBlackCircle_greenEvent)];
Stdv9 = [std(YstdvRedCircle_redEvent) std(YstdvRedCircle_blueEvent) std(YstdvRedCircle_greenEvent); std(YstdvBlackCircle_redEvent) std(YstdvBlackCircle_blueEvent) std(YstdvBlackCircle_greenEvent)];
b = bar(x9,'facecolor',[.8 .8 .8]);hold on
b(1).FaceColor = [.9 .0 .0];b(2).FaceColor = [.0 .0 .9];b(3).FaceColor = [.0 .9 .0];
% hb(1).FaceColor = 'r';
str={'Red Circle','Black Circle'};
set(gca, 'XTickLabel',str, 'XTick',1:numel(str),'fontsize',18, 'YGrid', 'on', 'XGrid', 'off')
ylabel('Mean');
title("X Stdv")
ngroups = size(x9, 1);
nbars = size(x9, 2);
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
    % Calculate center of each bar
    x_9 = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x_9, x9(:,i), Stdv9(:,i), 'k', 'linestyle', 'none');
end
hold off
%%For MATLAB 2019b or later releases
hold on
% Calculate the number of bars in each group
nbars = size(x9, 2);
% Get the x coordinate of the bars
x_9 = [];
for i = 1:nbars
    x_9 = [x_9 ; b(i).XEndPoints];
end
% Plot the errorbars
errorbar(x_9',x9,Stdv9,'k','linestyle','none','CapSize',18);
hold off
%% KNN algorithm

% ONEventRedCircle_redEvent         ONEventBlackCircle_redEvent
% ONEventRedCircle_blueEvent        ONEventBlackCircle_blueEvent
% ONEventRedCircle_greenEvent       ONEventBlackCircle_greenEvent

% OFFEventRedCircle_redEvent        OFFEventBlackCircle_redEvent 
% OFFEventRedCircle_blueEvent       OFFEventBlackCircle_blueEvent 
% OFFEventRedCircle_greenEvent      OFFEventBlackCircle_greenEvent

% ONOFFRatioRedCircle_redEvent      ONOFFRatioBlackCircle_redEvent
% ONOFFRatioRedCircle_blueEvent     ONOFFRatioBlackCircle_blueEvent
% ONOFFRatioRedCircle_greenEvent    ONOFFRatioBlackCircle_greenEvent

% TotalEventRedCircle_redEvent      TotalEventBlackCircle_redEvent
% TotalEventRedCircle_blueEvent     TotalEventBlackCircle_redEvent
% TotalEventRedCircle_greenEvent    TotalEventBlackCircle_redEvent

% DurationRedCircle_redEvent        DurationBlackCircle_redEvent
% DurationRedCircle_blueEvent       DurationBlackCircle_blueEvent
% DurationRedCircle_greenEvent      DurationBlackCircle_greenEvent

% XmeanRedCircle_redEvent           XmeanBlackCircle_redEvent
% XmeanRedCircle_blueEvent          XmeanBlackCircle_blueEvent
% XmeanRedCircle_greenEvent         XmeanBlackCircle_greenEvent

% YmeanRedCircle_redEvent           YmeanBlackCircle_redEvent 
% YmeanRedCircle_blueEvent          YmeanBlackCircle_blueEvent
% YmeanRedCircle_greenEvent         YmeanBlackCircle_greenEvent

% XstdvRedCircle_redEvent           XstdvBlackCircle_redEvent 
% XstdvRedCircle_blueEvent          XstdvBlackCircle_blueEvent 
% XstdvRedCircle_greenEvent         XstdvBlackCircle_greenEvent

% YstdvRedCircle_redEvent           YstdvBlackCircle_redEvent 
% YstdvRedCircle_blueEvent          YstdvBlackCircle_blueEvent 
% YstdvRedCircle_greenEvent         YstdvBlackCircle_greenEvent

clc

accuracyArray = [];
% for k = 1:2:50

redCircle       =       YstdvRedCircle_redEvent;
blackCircle     =       YstdvBlackCircle_redEvent;

redCircle(end,:) = [];
blackCircle(end,:) = [];

lineWidth = 2;
fontSize = 20;
markerSize = 10;

% Number of K
k = round(sqrt(length(redCircle)*3)); % square root of the number of sample
% k = 3;

nEventAfterSkip = round(size(redCircle,1));
trainTestSplitRatio = 0.5;
shuffledIndex = randperm(nEventAfterSkip);

% shuffle data
% ONEventC_shuffle = ONEventC(shuffledIndex,:);
% ONEventL_shuffle = ONEventL(shuffledIndex,:);

trainingCoords1 = redCircle(1:length(redCircle)/2,:);
trainingCoords2 = blackCircle(1:length(redCircle)/2,:);
data = [trainingCoords1; trainingCoords2];
data(:,2) = 1:numel(data);
data = data(shuffledIndex,:);

% Get stats for the table
trainMean = mean(data(:,1))
trainSigma = std(t_data(:,1))

testMean = mean(data(:,1))
testSigma = std(t_data(:,1))

% Label for the train set
labels = nan(length(data),1);
labels(1:length(data)/2+1,1) = 1;labels(length(data)/2+1:end,1) = 0;
labels = labels(shuffledIndex,:);

% Test data
testCoords1 = redCircle(length(redCircle)/2+1:end,:);
testCoords2 = blackCircle(length(redCircle)/2+1:end,:);
t_data = [testCoords1; testCoords2];
t_data(:,2) = 1:numel(t_data);
t_data = t_data(shuffledIndex,:);

% make test label
t_labels = nan(length(t_data),1);
t_labels(1:length(t_data)/2+1,1) = 1;t_labels(length(t_data)/2+1:end,1) = 0;
t_labels = t_labels(shuffledIndex,:);

%initialization
predicted_labels=zeros(size(t_data,1),1);
ed=zeros(size(t_data,1),size(data,1)); %ed: (MxN) euclidean distances
ind=zeros(size(t_data,1),size(data,1)); %corresponding indices (MxN)
k_nn=zeros(size(t_data,1),k); %k-nearest neighbors for testing sample (Mxk)

%calc euclidean distances between each testing data point and the training
%data samples
for test_point=1:size(t_data,1)
    for train_point=1:size(data,1)
        %calc and store sorted euclidean distances with corresponding indices
        ed(test_point,train_point)=sqrt(...
            sum((t_data(test_point,:)-data(train_point,:)).^2));
    end
    [ed(test_point,:),ind(test_point,:)]=sort(ed(test_point,:));
end

%find the nearest k for each data point of the testing data
k_nn=ind(:,1:k);
nn_index=k_nn(:,1);
%get the majority vote
for i=1:size(k_nn,1)
    options=unique(labels(k_nn(i,:)'));
    max_count=0;
    max_label=0;
    for j=1:length(options)
        L=length(find(labels(k_nn(i,:)')==options(j)));
        if L>max_count
            max_label=options(j);
            max_count=L;
        end
    end
    predicted_labels(i)=max_label;
end

% Compute accuracy
accuracy=length(find(predicted_labels==t_labels))/size(t_data,1);
accuracyArray = [accuracyArray;accuracy*100]
final_data = [data;t_data];
final_label = [labels;predicted_labels];
All_data = [final_data final_label];

% Get index for class with label 0 and group into one matrix
class0 = find(All_data(:,3) < 1);
classZero = All_data(class0,:);

% Get index for class with label 1 and group into one matrix
class1 = find(All_data(:,3) > 0);
classOne = All_data(class1,:);

lineWidth = 2;
fontSize = 20;
markerSize = 10;
% Visualization

findLabelsOne = find(labels==1);
findLabelsZero = find(labels==0);

dataOne = data(findLabelsOne,:);
dataZero = data(findLabelsZero,:);

% end
%%
figure(1);
subplot(2,2,1)
plot(dataOne(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(dataZero(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('Training data.  Points have known, defined class.', 'FontSize', fontSize, 'Interpreter', 'None');
legend('Class 1', 'Class 2', 'Location', 'northwest');
% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);

subplot(2, 2, 2);
plot(t_data(:, 1), 'k*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
legend('As-of-yet Unknown Class', 'Location', 'northwest');
title('Test Data Before Classification', 'FontSize', fontSize, 'Interpreter', 'None');

subplot(2, 2, 3);
plot(dataOne(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(dataZero(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
% Plot the test data points with as-of-yet unknown class all in black asterisks.
plot(t_data(:, 1), 'k*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
legend('Class 1', 'Class 2', 'As-of-yet Unknown Class', 'Location', 'northwest');
title('Both Training Data and Test Data of Unknown Class', 'FontSize', fontSize, 'Interpreter', 'None');

% Now plot what we found.  Each class gets the same marker as the training class.
subplot(2, 2, 4);
plot(classOne(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(classZero(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
axis square;
% xlim([0, 6]);
% ylim([0, 6]);
title('Test Data After Classification', 'FontSize', fontSize, 'Interpreter', 'None');
legend('Estimated to be in Class 1', 'Estimated to be in Class 2', 'Location', 'northwest');

%% Visualize all datapoints for Red
lineWidth = 2;
fontSize = 20;
markerSize = 10;
figure(2);
subplot(3,3,1)
plot(ONEventRedCircle_redEvent(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(ONEventBlackCircle_redEvent(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('ON Events', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Value");
legend('Red Circle', 'Black Circle', 'Class 3', 'Class 4', 'Location', 'northwest');
% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,3,2)
plot(OFFEventRedCircle_redEvent(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(OFFEventBlackCircle_redEvent(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('OFF Events', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Value");
legend('Red Circle', 'Black Circle', 'Class 3', 'Class 4', 'Location', 'northwest');% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,3,3)
plot(ONOFFRatioRedCircle_redEvent(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(ONOFFRatioBlackCircle_redEvent(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('ON/OFF Ratio', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Value");
legend('Red Circle', 'Black Circle', 'Class 3', 'Class 4', 'Location', 'northwest');% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,3,4)
plot(TotalEventRedCircle_redEvent(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(TotalEventBlackCircle_redEvent(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('Event Count', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Value");
legend('Red Circle', 'Black Circle', 'Class 3', 'Class 4', 'Location', 'northwest');% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,3,5)
plot(DurationRedCircle_redEvent(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(DurationBlackCircle_redEvent(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('Duration', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Value");
legend('Red Circle', 'Black Circle', 'Class 3', 'Class 4', 'Location', 'northwest');% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,3,6)
plot(XmeanRedCircle_redEvent(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(XmeanBlackCircle_redEvent(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('X mean', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Value");
legend('Red Circle', 'Black Circle', 'Class 3', 'Class 4', 'Location', 'northwest');% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,3,7)
plot(YmeanRedCircle_redEvent(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(YmeanBlackCircle_redEvent(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('Y mean', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Value");
legend('Red Circle', 'Black Circle', 'Class 3', 'Class 4', 'Location', 'northwest');% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,3,8)
plot(XstdvRedCircle_redEvent(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(XstdvBlackCircle_redEvent(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('X Stdv', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Value");
legend('Red Circle', 'Black Circle', 'Class 3', 'Class 4', 'Location', 'northwest');% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,3,9)
plot(YstdvRedCircle_redEvent(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(YstdvBlackCircle_redEvent(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('Y Stdv', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Value");
legend('Red Circle', 'Black Circle', 'Class 3', 'Class 4', 'Location', 'northwest');% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);

%% Visualize all datapoints for blue
lineWidth = 2;
fontSize = 20;
markerSize = 10;
figure(2);
subplot(3,3,1)
plot(ONEventRedCircle_blueEvent(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(ONEventBlackCircle_blueEvent(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('ON Events', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Value");
legend('Red Circle', 'Black Circle', 'Class 3', 'Class 4', 'Location', 'northwest');
% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,3,2)
plot(OFFEventRedCircle_blueEvent(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(OFFEventBlackCircle_blueEvent(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('OFF Events', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Value");
legend('Red Circle', 'Black Circle', 'Class 3', 'Class 4', 'Location', 'northwest');% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,3,3)
plot(ONOFFRatioRedCircle_blueEvent(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(ONOFFRatioBlackCircle_blueEvent(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('ON/OFF Ratio', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Value");
legend('Red Circle', 'Black Circle', 'Class 3', 'Class 4', 'Location', 'northwest');% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,3,4)
plot(TotalEventRedCircle_blueEvent(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(TotalEventBlackCircle_redEvent(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('Event Count', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Value");
legend('Red Circle', 'Black Circle', 'Class 3', 'Class 4', 'Location', 'northwest');% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,3,5)
plot(DurationRedCircle_blueEvent(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(DurationBlackCircle_blueEvent(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('Duration', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Value");
legend('Red Circle', 'Black Circle', 'Class 3', 'Class 4', 'Location', 'northwest');% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,3,6)
plot(XmeanRedCircle_blueEvent(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(XmeanBlackCircle_blueEvent(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('X mean', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Value");
legend('Red Circle', 'Black Circle', 'Class 3', 'Class 4', 'Location', 'northwest');% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,3,7)
plot(YmeanRedCircle_blueEvent(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(YmeanBlackCircle_blueEvent(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('Y mean', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Value");
legend('Red Circle', 'Black Circle', 'Class 3', 'Class 4', 'Location', 'northwest');% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,3,8)
plot(XstdvRedCircle_blueEvent(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(XstdvBlackCircle_blueEvent(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('X Stdv', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Value");
legend('Red Circle', 'Black Circle', 'Class 3', 'Class 4', 'Location', 'northwest');% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,3,9)
plot(YstdvRedCircle_blueEvent(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(YstdvBlackCircle_blueEvent(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('Y Stdv', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Value");
legend('Red Circle', 'Black Circle', 'Class 3', 'Class 4', 'Location', 'northwest');% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);

%% Visualize all datapoints for green
lineWidth = 2;
fontSize = 20;
markerSize = 10;
figure(2);
subplot(3,3,1)
plot(ONEventRedCircle_greenEvent(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(ONEventBlackCircle_greenEvent(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('ON Events', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Value");
legend('Red Circle', 'Black Circle', 'Class 3', 'Class 4', 'Location', 'northwest');
% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,3,2)
plot(OFFEventRedCircle_greenEvent(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(OFFEventBlackCircle_greenEvent(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('OFF Events', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Value");
legend('Red Circle', 'Black Circle', 'Class 3', 'Class 4', 'Location', 'northwest');% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,3,3)
plot(ONOFFRatioRedCircle_greenEvent(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(ONOFFRatioBlackCircle_greenEvent(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('ON/OFF Ratio', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Value");
legend('Red Circle', 'Black Circle', 'Class 3', 'Class 4', 'Location', 'northwest');% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,3,4)
plot(TotalEventRedCircle_greenEvent(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(TotalEventBlackCircle_redEvent(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('Event Count', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Value");
legend('Red Circle', 'Black Circle', 'Class 3', 'Class 4', 'Location', 'northwest');% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,3,5)
plot(DurationRedCircle_greenEvent(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(DurationBlackCircle_greenEvent(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('Duration', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Value");
legend('Red Circle', 'Black Circle', 'Class 3', 'Class 4', 'Location', 'northwest');% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,3,6)
plot(XmeanRedCircle_greenEvent(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(XmeanBlackCircle_greenEvent(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('X mean', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Value");
legend('Red Circle', 'Black Circle', 'Class 3', 'Class 4', 'Location', 'northwest');% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,3,7)
plot(YmeanRedCircle_greenEvent(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(YmeanBlackCircle_greenEvent(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('Y mean', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Value");
legend('Red Circle', 'Black Circle', 'Class 3', 'Class 4', 'Location', 'northwest');% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,3,8)
plot(XstdvRedCircle_greenEvent(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(XstdvBlackCircle_greenEvent(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('X Stdv', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Value");
legend('Red Circle', 'Black Circle', 'Class 3', 'Class 4', 'Location', 'northwest');% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,3,9)
plot(YstdvRedCircle_greenEvent(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(YstdvBlackCircle_greenEvent(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('Y Stdv', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Value");
legend('Red Circle', 'Black Circle', 'Class 3', 'Class 4', 'Location', 'northwest');% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);

%% Visualize accuracy plot
x1 = [100 100 100;
     100 100 100;
     100 100 100;
     100 100 100;
     60.4167 66.6667 50;
     100 100 100;
     100 100 100;
     100 100 100;
     100 100 100];

% Stdv1 = [std(ONEventRedCircle_redEvent) std(ONEventRedCircle_blueEvent) std(ONEventRedCircle_greenEvent); 
%          std(ONEventBlackCircle_redEvent) std(ONEventBlackCircle_blueEvent) std(ONEventBlackCircle_greenEvent)];
b = bar(x1,'facecolor',[.8 .8 .8]);hold on
% text(1:length(x1),x1,num2str(x1'),'vert','bottom','horiz','center','FontSize',20); 
b(1).FaceColor = [.9 .0 .0];b(2).FaceColor = [.0 .0 .9];b(3).FaceColor = [.0 .9 .0];
yl = yline(50,'--','Chance 50 %','fontsize',22,'LineWidth',3);
yl.LabelHorizontalAlignment = 'right';
yl.LabelVerticalAlignment = 'middle';
yl.Color = [.1 0 .40];
str={'ON Events','OFF Events','ON/OFF Ratio','Events Count','Duration','X mean','Y mean', 'X stdv', 'Y stdv'};
set(gca, 'XTickLabel',str, 'XTick',1:numel(str),'fontsize',18, 'YGrid', 'on', 'XGrid', 'off')

xlabel("Classification Method");
ylabel("Accuracy (% Correct)");
title("kNN Classification Accuracy Using Statistical Properties of Circle and Line");
xtickangle(45)
xlim([0 12])
ylim([0 105]);