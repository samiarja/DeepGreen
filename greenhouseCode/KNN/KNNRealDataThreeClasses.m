%% Get event duration and event count and find differences
clc
clear
close all
lineWidth = 2;
fontSize = 20;
markerSize = 10;

eventCountforGreenCircle = [];
eventCountforBlueCircle = [];
eventCountforRedCircle = [];

eventDurationforGreenCircle = [];
eventDurationforBlueCircle = [];
eventDurationforRedCircle = [];

timeAdvance = 3;

for idx = 1:99
    allCircle = load("Data/sameobjectdifferentcolour/" + idx + ".mat"); % 1: ts, 2: x, 3: y, 4: p, 5: colour
    
    allCircle.events(:,1) = allCircle.events(:,1) - allCircle.events(1,1);
    
    firstTimeStamp = allCircle.events(1,1);
    firstTimeStampPlusTwoSeconds = firstTimeStamp + timeAdvance;
    findTimeTwoSecond = find(allCircle.events(:,1)<firstTimeStampPlusTwoSeconds*1e6);
    
    allCircle = allCircle.events(findTimeTwoSecond,:);
    
    findBoundaryCoordinateGreenCircle = allCircle(:, 2) < 246 & allCircle(:, 3) > 160; % y > 160 && x < 246
    findBoundaryCoordinateBlueCircle = allCircle(:, 2) > 70 & allCircle(:, 2) < 170 & allCircle(:, 3) > 15 & allCircle(:, 3) < 115; %y > 15 && y < 115 && x > 70 && x < 170
    findBoundaryCoordinateRedCircle = allCircle(:, 2) > 246 & allCircle(:, 3) > 15 & allCircle(:, 3) < 115; % y > 15 && y < 115 && x > 256
    
    greenCircle = allCircle(findBoundaryCoordinateGreenCircle,:);
    blueCircle = allCircle(findBoundaryCoordinateBlueCircle,:);
    redCircle = allCircle(findBoundaryCoordinateRedCircle,:);
    
    eventCountforGreenCircle = [eventCountforGreenCircle;numel(greenCircle(:,1))];
    eventCountforBlueCircle = [eventCountforBlueCircle;numel(blueCircle(:,1))];
    eventCountforRedCircle = [eventCountforRedCircle;numel(redCircle(:,1))];
    
    eventDurationforGreenCircle = [eventDurationforGreenCircle;(greenCircle(end,1)-greenCircle(1,1))];
    eventDurationforBlueCircle = [eventDurationforBlueCircle;(blueCircle(end,1)-blueCircle(1,1))];
    eventDurationforRedCircle = [eventDurationforRedCircle;(redCircle(end,1)-redCircle(1,1))];    
end

figure(1);
subplot(2,2,1)
plot(eventCountforBlueCircle,'b','LineWidth', lineWidth, 'MarkerSize', markerSize);hold on
plot(eventCountforGreenCircle,'g','LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(eventCountforRedCircle,'r','LineWidth', lineWidth, 'MarkerSize', markerSize);
legend("Blue Circle", "Green Circle", "Red Circle");
xlabel("Number of recorded Data");
ylabel("Number of events");
title("Number of events",'FontSize', fontSize, 'Interpreter', 'None');

subplot(2,2,3)
plot(eventDurationforBlueCircle/1e6,'b','LineWidth', lineWidth, 'MarkerSize', markerSize);hold on
plot(eventDurationforGreenCircle/1e6,'g','LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(eventDurationforRedCircle/1e6,'r','LineWidth', lineWidth, 'MarkerSize', markerSize);
legend("Blue Circle", "Green Circle", "Red Circle");
xlabel("Number of recorded Data");
ylabel("Duration of events (s)");
title("Duration of events",'FontSize', fontSize, 'Interpreter', 'None');

subplot(2,2,[2 4])
y=[eventDurationforBlueCircle/1e6 eventDurationforGreenCircle/1e6 eventDurationforRedCircle/1e6];
boxplot(y)
str={'Blue Circle','Green Circle','Red Circle'};
ylabel("Duration of events (s)");
set(gca, 'XTickLabel',str, 'XTick',1:numel(str),'fontsize',18, 'YGrid', 'on', 'XGrid', 'off')
title("Box plot",'FontSize', fontSize, 'Interpreter', 'None');
view([90 90])

%% Generate dataset for each class and for each statistical measure
clc
clear
close all
% the data is structured that way:

% x = events(:,2)
% y = events(:,3)
% p = events(:,4)
% ts = events(:,1)

% For all
ONEventAllR = [];ONEventAllG = [];ONEventAllB = [];
OFFEventAllR = [];OFFEventAllG = [];OFFEventAllB = [];
ONOFFRatioAllR = [];ONOFFRatioAllG = [];ONOFFRatioAllB = [];
TotalEventAllR = [];TotalEventAllG = [];TotalEventAllB = [];
DurationAllR = [];DurationAllG = [];DurationAllB = [];
XmeanAllR = [];XmeanAllG = [];XmeanAllB = [];
YmeanAllR = [];YmeanAllG = [];YmeanAllB = [];
XstdvAllR = [];XstdvAllG = [];XstdvAllB = [];
YstdvAllR = [];YstdvAllG = [];YstdvAllB = [];

% For Red circle
ONEventR_R     = [];ONEventR_B     = [];ONEventR_G1     = [];ONEventR_G2     = [];
OFFEventR_R    = [];OFFEventR_B     = [];OFFEventR_G1    = [];OFFEventR_G2     = [];
ONOFFRatioR_R  = [];ONOFFRatioR_B   = [];ONOFFRatioR_G1  = [];ONOFFRatioR_G2     = [];
TotalEventR_R  = [];TotalEventR_B   = [];TotalEventR_G1  = [];TotalEventR_G2     = [];
DurationR_R    = [];DurationR_B     = [];DurationR_G1    = [];DurationR_G2     = [];
XmeanR_R       = [];XmeanR_B        = [];XmeanR_G1       = [];XmeanR_G2     = [];
YmeanR_R       = [];YmeanR_B        = [];YmeanR_G1       = [];YmeanR_G2     = [];
XstdvR_R       = [];XstdvR_B        = [];XstdvR_G1       = [];XstdvR_G2     = [];
YstdvR_R       = [];YstdvR_B        = [];YstdvR_G1       = [];YstdvR_G2     = [];

% For green circle
ONEventG_R     = [];ONEventG_B     = [];ONEventG_G1     = [];ONEventG_G2     = [];
OFFEventG_R    = [];OFFEventG_B    = [];OFFEventG_G1    = [];OFFEventG_G2    = [];
ONOFFRatioG_R  = [];ONOFFRatioG_B  = [];ONOFFRatioG_G1  = [];ONOFFRatioG_G2  = [];
TotalEventG_R  = [];TotalEventG_B  = [];TotalEventG_G1  = [];TotalEventG_G2  = [];
DurationG_R    = [];DurationG_B    = [];DurationG_G1    = [];DurationG_G2    = [];
XmeanG_R       = [];XmeanG_B       = [];XmeanG_G1       = [];XmeanG_G2       = [];
YmeanG_R       = [];YmeanG_B       = [];YmeanG_G1       = [];YmeanG_G2       = [];
XstdvG_R       = [];XstdvG_B       = [];XstdvG_G1       = [];XstdvG_G2       = [];
YstdvG_R       = [];YstdvG_B       = [];YstdvG_G1       = [];YstdvG_G2       = [];

% For blue circle
ONEventB_R     = [];ONEventB_B      = [];ONEventB_G1     = [];ONEventB_G2     = [];
OFFEventB_R    = [];OFFEventB_B     = [];OFFEventB_G1    = [];OFFEventB_G2    = [];
ONOFFRatioB_R  = [];ONOFFRatioB_B   = [];ONOFFRatioB_G1  = [];ONOFFRatioB_G2  = [];
TotalEventB_R  = [];TotalEventB_B   = [];TotalEventB_G1  = [];TotalEventB_G2  = [];
DurationB_R    = [];DurationB_B     = [];DurationB_G1    = [];DurationB_G2    = [];
XmeanB_R       = [];XmeanB_B        = [];XmeanB_G1       = [];XmeanB_G2       = [];
YmeanB_R       = [];YmeanB_B        = [];YmeanB_G1       = [];YmeanB_G2       = [];
XstdvB_R       = [];XstdvB_B        = [];XstdvB_G1       = [];XstdvB_G2       = [];
YstdvB_R       = [];YstdvB_B        = [];YstdvB_G1       = [];YstdvB_G2       = [];

timeAdvance = 3;

for idx = 1:99
    allCircle = load("Data/sameobjectdifferentcolour/" + idx + ".mat"); % 1: ts, 2: x, 3: y, 4: p, 5: colour

    firstTimeStamp = allCircle.events(1,1)/1e6;
    firstTimeStampPlusTwoSeconds = firstTimeStamp + timeAdvance;
    findTimeTwoSecond = find(allCircle.events(:,1)<firstTimeStampPlusTwoSeconds*1e6);
    
    allCircle = allCircle.events(findTimeTwoSecond,:);
    
    findBoundaryCoordinateGreenCircle = find(allCircle(:, 2) < 246 & allCircle(:, 3) > 160); % y > 160 && x < 246
    findBoundaryCoordinateBlueCircle = find(allCircle(:, 2) > 70 & allCircle(:, 2) < 170 & allCircle(:, 3) > 15 & allCircle(:, 3) < 115); %y > 15 && y < 115 && x > 70 && x < 170
    findBoundaryCoordinateRedCircle = find(allCircle(:, 2) > 246 & allCircle(:, 3) > 15 & allCircle(:, 3) < 115); % y > 15 && y < 115 && x > 256
    
    greenCircle = allCircle(findBoundaryCoordinateGreenCircle,:);
    blueCircle = allCircle(findBoundaryCoordinateBlueCircle,:);
    redCircle = allCircle(findBoundaryCoordinateRedCircle,:);
    
    % for the green circle
    greenCircle_redEvents = greenCircle(greenCircle(:,5)==2,:);
    greenCircle_green1Events = greenCircle(greenCircle(:,5)==3,:);
    greenCircle_green2Events = greenCircle(greenCircle(:,5)==4,:);
    greenCircle_blueEvents = greenCircle(greenCircle(:,5)==1,:);
    
     % for the blue circle
    blueCircle_redEvents = blueCircle(blueCircle(:,5)==2,:);
    blueCircle_green1Events = blueCircle(blueCircle(:,5)==3,:);
    blueCircle_green2Events = blueCircle(blueCircle(:,5)==4,:);
    blueCircle_blueEvents = blueCircle(blueCircle(:,5)==1,:);
    
     % for the red circle
    redCircle_redEvents = redCircle(redCircle(:,5)==2,:);
    redCircle_green1Events = redCircle(redCircle(:,5)==3,:);
    redCircle_green2Events = redCircle(redCircle(:,5)==4,:);
    redCircle_blueEvents = redCircle(redCircle(:,5)==1,:);
    
    % Get for green circle
    ONEventG_R = [ONEventG_R;length(find(greenCircle_redEvents(:,4) == 1))];
    ONEventG_G1 = [ONEventG_G1;length(find(greenCircle_green1Events(:,4) == 1))];
    ONEventG_G2 = [ONEventG_G2;length(find(greenCircle_green2Events(:,4) == 1))];
    ONEventG_B = [ONEventG_B;length(find(greenCircle_blueEvents(:,4) == 1))];
    ONEventAllR = [ONEventAllR;length(find(redCircle(:,4) == 1))]; % All
    ONEventAllG = [ONEventAllG;length(find(greenCircle(:,4) == 1))]; % All
    ONEventAllB = [ONEventAllB;length(find(blueCircle(:,4) == 1))]; % All
    
    OFFEventG_R = [OFFEventG_R;length(find(greenCircle_redEvents(:,4) == 0))];
    OFFEventG_G1 = [OFFEventG_G1;length(find(greenCircle_green1Events(:,4) == 0))];
    OFFEventG_G2 = [OFFEventG_G2;length(find(greenCircle_green2Events(:,4) == 0))];
    OFFEventG_B = [OFFEventG_B;length(find(greenCircle_blueEvents(:,4) == 0))];
    OFFEventAllR = [OFFEventAllR;length(find(redCircle(:,4) == 0))]; % All
    OFFEventAllG = [OFFEventAllG;length(find(greenCircle(:,4) == 0))]; % All
    OFFEventAllB = [OFFEventAllB;length(find(blueCircle(:,4) == 0))]; % All
    
    ONOFFRatioG_R = [ONOFFRatioG_R;size(find(greenCircle_redEvents(:,4) == 1))/size(find(greenCircle_redEvents(:,4) == 0))];
    ONOFFRatioG_G1 = [ONOFFRatioG_G1;size(find(greenCircle_green1Events(:,4) == 1))/size(find(greenCircle_green1Events(:,4) == 0))];
    ONOFFRatioG_G2 = [ONOFFRatioG_G2;size(find(greenCircle_green2Events(:,4) == 1))/size(find(greenCircle_green2Events(:,4) == 0))];
    ONOFFRatioG_B = [ONOFFRatioG_B;size(find(greenCircle_blueEvents(:,4) == 1))/size(find(greenCircle_blueEvents(:,4) == 0))];
    ONOFFRatioAllR = [ONOFFRatioAllR;size(find(redCircle(:,4) == 1))/size(find(redCircle(:,4) == 0))]; % All
    ONOFFRatioAllG = [ONOFFRatioAllG;size(find(greenCircle(:,4) == 1))/size(find(greenCircle(:,4) == 0))]; % All
    ONOFFRatioAllB = [ONOFFRatioAllB;size(find(blueCircle(:,4) == 1))/size(find(blueCircle(:,4) == 0))]; % All
    
    TotalEventG_R = [TotalEventG_R;numel(greenCircle_redEvents(:,2))];
    TotalEventG_G1 = [TotalEventG_G1;numel(greenCircle_green1Events(:,2))];
    TotalEventG_G2 = [TotalEventG_G2;numel(greenCircle_green2Events(:,2))];
    TotalEventG_B = [TotalEventG_B;numel(greenCircle_blueEvents(:,2))];
    TotalEventAllR = [TotalEventAllR;numel(redCircle(:,2))]; % All
    TotalEventAllG = [TotalEventAllG;numel(greenCircle(:,2))]; % All
    TotalEventAllB = [TotalEventAllB;numel(blueCircle(:,2))]; % All
    
    DurationG_R = [DurationG_R;greenCircle_redEvents(end,1) - greenCircle_redEvents(1,1)];
    DurationG_G1 = [DurationG_G1;greenCircle_green1Events(end,1) - greenCircle_green1Events(1,1)];
    DurationG_G2 = [DurationG_G2;greenCircle_green2Events(end,1) - greenCircle_green2Events(1,1)];
    DurationG_B = [DurationG_B;greenCircle_blueEvents(end,1) - greenCircle_blueEvents(1,1)];
    DurationAllR = [DurationAllR;redCircle(end,1) - redCircle(1,1)]; % All
    DurationAllG = [DurationAllG;greenCircle(end,1) - greenCircle(1,1)]; % All
    DurationAllB = [DurationAllB;blueCircle(end,1) - blueCircle(1,1)]; % All
    
    XmeanG_R = [XmeanG_R;mean(greenCircle_redEvents(:,2))]; % 
    XmeanG_G1 = [XmeanG_G1;mean(greenCircle_green1Events(:,2))];
    XmeanG_G2 = [XmeanG_G2;mean(greenCircle_green2Events(:,2))];
    XmeanG_B = [XmeanG_B;mean(greenCircle_blueEvents(:,2))];
    XmeanAllR = [XmeanAllR;mean(redCircle(:,2))]; % All
    XmeanAllG = [XmeanAllG;mean(greenCircle(:,2))]; % All
    XmeanAllB = [XmeanAllB;mean(blueCircle(:,2))]; % All
    
    YmeanG_R = [YmeanG_R;mean(greenCircle_redEvents(:,3))];
    YmeanG_G1 = [YmeanG_G1;mean(greenCircle_green1Events(:,3))];
    YmeanG_G2 = [YmeanG_G2;mean(greenCircle_green2Events(:,3))];
    YmeanG_B = [YmeanG_B;mean(greenCircle_blueEvents(:,3))];
    YmeanAllR = [YmeanAllR;mean(redCircle(:,3))]; % All
    YmeanAllG = [YmeanAllG;mean(greenCircle(:,3))]; % All
    YmeanAllB = [YmeanAllB;mean(blueCircle(:,3))]; % All
    
    XstdvG_R = [XstdvG_R;std(single(greenCircle_redEvents(:,2)))];
    XstdvG_G1 = [XstdvG_G1;std(single(greenCircle_green1Events(:,2)))];
    XstdvG_G2 = [XstdvG_G2;std(single(greenCircle_green2Events(:,2)))];
    XstdvG_B = [XstdvG_B;std(single(greenCircle_blueEvents(:,2)))];
    XstdvAllR = [XstdvAllR;std(single(redCircle(:,2)))]; % All
    XstdvAllG = [XstdvAllG;std(single(greenCircle(:,2)))]; % All
    XstdvAllB = [XstdvAllB;std(single(blueCircle(:,2)))]; % All
    
    YstdvG_R = [YstdvG_R;std(single(greenCircle_redEvents(:,3)))];
    YstdvG_G1 = [YstdvG_G1;std(single(greenCircle_green1Events(:,3)))];
    YstdvG_G2 = [YstdvG_G2;std(single(greenCircle_green2Events(:,3)))];
    YstdvG_B = [YstdvG_B;std(single(greenCircle_blueEvents(:,3)))];
    YstdvAllR = [YstdvAllR;std(single(redCircle(:,3)))]; % All
    YstdvAllG = [YstdvAllG;std(single(greenCircle(:,3)))]; % All
    YstdvAllB = [YstdvAllB;std(single(blueCircle(:,3)))]; % All
    
    % Get for blue circle
    ONEventB_R = [ONEventB_R;length(find(blueCircle_redEvents(:,4) == 1))];
    ONEventB_G1 = [ONEventB_G1;length(find(blueCircle_green1Events(:,4) == 1))];
    ONEventB_G2 = [ONEventB_G2;length(find(blueCircle_green2Events(:,4) == 1))];
    ONEventB_B = [ONEventB_B;length(find(blueCircle_blueEvents(:,4) == 1))];
    
    OFFEventB_R = [OFFEventB_R;length(find(blueCircle_redEvents(:,4) == 0))];
    OFFEventB_G1 = [OFFEventB_G1;length(find(blueCircle_green1Events(:,4) == 0))];
    OFFEventB_G2 = [OFFEventB_G2;length(find(blueCircle_green2Events(:,4) == 0))];
    OFFEventB_B = [OFFEventB_B;length(find(blueCircle_blueEvents(:,4) == 0))];
    
    ONOFFRatioB_R = [ONOFFRatioB_R;size(find(blueCircle_redEvents(:,4) == 1))/size(find(blueCircle_redEvents(:,4) == 0))];
    ONOFFRatioB_G1 = [ONOFFRatioB_G1;size(find(blueCircle_green1Events(:,4) == 1))/size(find(blueCircle_green1Events(:,4) == 0))];
    ONOFFRatioB_G2 = [ONOFFRatioB_G2;size(find(blueCircle_green2Events(:,4) == 1))/size(find(blueCircle_green2Events(:,4) == 0))];
    ONOFFRatioB_B = [ONOFFRatioB_B;size(find(blueCircle_blueEvents(:,4) == 1))/size(find(blueCircle_blueEvents(:,4) == 0))];
    
    TotalEventB_R = [TotalEventB_R;numel(blueCircle_redEvents(:,2))];
    TotalEventB_G1 = [TotalEventB_G1;numel(blueCircle_green1Events(:,2))];
    TotalEventB_G2 = [TotalEventB_G2;numel(blueCircle_green2Events(:,2))];
    TotalEventB_B = [TotalEventB_B;numel(blueCircle_blueEvents(:,2))];
    
    DurationB_R = [DurationB_R;blueCircle_redEvents(end,1) - blueCircle_redEvents(1,1)];
    DurationB_G1 = [DurationB_G1;blueCircle_green1Events(end,1) - blueCircle_green1Events(1,1)];
    DurationB_G2 = [DurationB_G2;blueCircle_green2Events(end,1) - blueCircle_green2Events(1,1)];
    DurationB_B = [DurationB_B;blueCircle_blueEvents(end,1) - blueCircle_blueEvents(1,1)];
    
    XmeanB_R = [XmeanB_R;mean(blueCircle_redEvents(:,2))];
    XmeanB_G1 = [XmeanB_G1;mean(blueCircle_green1Events(:,2))];
    XmeanB_G2 = [XmeanB_G2;mean(blueCircle_green2Events(:,2))];
    XmeanB_B = [XmeanB_B;mean(blueCircle_blueEvents(:,2))];
    
    YmeanB_R = [YmeanB_R;mean(blueCircle_redEvents(:,3))];
    YmeanB_G1 = [YmeanB_G1;mean(blueCircle_green1Events(:,3))];
    YmeanB_G2 = [YmeanB_G2;mean(blueCircle_green2Events(:,3))];
    YmeanB_B = [YmeanB_B;mean(blueCircle_blueEvents(:,3))];
    
    XstdvB_R = [XstdvB_R;std(single(blueCircle_redEvents(:,2)))];
    XstdvB_G1 = [XstdvB_G1;std(single(blueCircle_green1Events(:,2)))];
    XstdvB_G2 = [XstdvB_G2;std(single(blueCircle_green2Events(:,2)))];
    XstdvB_B = [XstdvB_B;std(single(blueCircle_blueEvents(:,2)))];
    
    YstdvB_R = [YstdvB_R;std(single(blueCircle_redEvents(:,3)))];
    YstdvB_G1 = [YstdvB_G1;std(single(blueCircle_green1Events(:,3)))];
    YstdvB_G2 = [YstdvB_G2;std(single(blueCircle_green2Events(:,3)))];
    YstdvB_B = [YstdvB_B;std(single(blueCircle_blueEvents(:,3)))];
    
    % Get for red circle
    ONEventR_R = [ONEventR_R;length(find(redCircle_redEvents(:,4) == 1))];
    ONEventR_G1 = [ONEventR_G1;length(find(redCircle_green1Events(:,4) == 1))];
    ONEventR_G2 = [ONEventR_G2;length(find(redCircle_green2Events(:,4) == 1))];
    ONEventR_B = [ONEventR_B;length(find(redCircle_blueEvents(:,4) == 1))];
    
    OFFEventR_R = [OFFEventR_R;length(find(redCircle_redEvents(:,4) == 0))];
    OFFEventR_G1 = [OFFEventR_G1;length(find(redCircle_green1Events(:,4) == 0))];
    OFFEventR_G2 = [OFFEventR_G2;length(find(redCircle_green2Events(:,4) == 0))];
    OFFEventR_B = [OFFEventR_B;length(find(redCircle_blueEvents(:,4) == 0))];
    
    ONOFFRatioR_R = [ONOFFRatioR_R;size(find(redCircle_redEvents(:,4) == 1))/size(find(redCircle_redEvents(:,4) == 0))];
    ONOFFRatioR_G1 = [ONOFFRatioR_G1;size(find(redCircle_green1Events(:,4) == 1))/size(find(redCircle_green1Events(:,4) == 0))];
    ONOFFRatioR_G2 = [ONOFFRatioR_G2;size(find(redCircle_green2Events(:,4) == 1))/size(find(redCircle_green2Events(:,4) == 0))];
    ONOFFRatioR_B = [ONOFFRatioR_B;size(find(redCircle_blueEvents(:,4) == 1))/size(find(redCircle_blueEvents(:,4) == 0))];
    
    TotalEventR_R = [TotalEventR_R;numel(redCircle_redEvents(:,2))];
    TotalEventR_G1 = [TotalEventR_G1;numel(redCircle_green1Events(:,2))];
    TotalEventR_G2 = [TotalEventR_G2;numel(redCircle_green2Events(:,2))];
    TotalEventR_B = [TotalEventR_B;numel(redCircle_blueEvents(:,2))];
    
    DurationR_R = [DurationR_R;redCircle_redEvents(end,1) - redCircle_redEvents(1,1)];
    DurationR_G1 = [DurationR_G1;redCircle_green1Events(end,1) - redCircle_green1Events(1,1)];
    DurationR_G2 = [DurationR_G2;redCircle_green2Events(end,1) - redCircle_green2Events(1,1)];
    DurationR_B = [DurationR_B;redCircle_blueEvents(end,1) - redCircle_blueEvents(1,1)];
    
    XmeanR_R = [XmeanR_R;mean(redCircle_redEvents(:,2))];
    XmeanR_G1 = [XmeanR_G1;mean(redCircle_green1Events(:,2))];
    XmeanR_G2 = [XmeanR_G2;mean(redCircle_green2Events(:,2))];
    XmeanR_B = [XmeanR_B;mean(redCircle_blueEvents(:,2))];
    
    YmeanR_R = [YmeanR_R;mean(redCircle_redEvents(:,3))];
    YmeanR_G1 = [YmeanR_G1;mean(redCircle_green1Events(:,3))];
    YmeanR_G2 = [YmeanR_G2;mean(redCircle_green2Events(:,3))];
    YmeanR_B = [YmeanR_B;mean(redCircle_blueEvents(:,3))];
    
    XstdvR_R = [XstdvR_R;std(single(redCircle_redEvents(:,2)))];
    XstdvR_G1 = [XstdvR_G1;std(single(redCircle_green1Events(:,2)))];
    XstdvR_G2 = [XstdvR_G2;std(single(redCircle_green2Events(:,2)))];
    XstdvR_B = [XstdvR_B;std(single(redCircle_blueEvents(:,2)))];
    
    YstdvR_R = [YstdvR_R;std(single(redCircle_redEvents(:,3)))];
    YstdvR_G1 = [YstdvR_G1;std(single(redCircle_green1Events(:,3)))];
    YstdvR_G2 = [YstdvR_G2;std(single(redCircle_green2Events(:,3)))];
    YstdvR_B = [YstdvR_B;std(single(redCircle_blueEvents(:,3)))];
end

%% KNN algorithm

% ONEventAllR
% OFFEventAllR
% ONOFFRatioAllR 
% TotalEventAllR 
% DurationAllR
% XmeanAllR
% YmeanAllR 
% XstdvAllR 
% YstdvAllR 

clc
accuracyArray = [];
spacing = 0.09905;
spacing2 = -0.05;
% for k = 1:2:50

Redcircle   = YmeanR_R;
GreenCircle = YmeanG_R;
BlueCircle  = YmeanB_R;

% remove the last rows to make the data size even

Redcircle(end,:)= [];
GreenCircle(end,:)= [];
BlueCircle(end,:)= [];

lineWidth = 2;
fontSize = 20;
markerSize = 10;

% Number of K
k = round(sqrt(length(Redcircle)*3)); % square root of the number of sample
% k = 3;

% shuffle data
% ONEventC_shuffle = ONEventC(shuffledIndex,:);
% ONEventL_shuffle = ONEventL(shuffledIndex,:);
nEventAfterSkip = round(size(Redcircle,1)*3/2);
trainTestSplitRatio = 0.5;
shuffledIndex = randperm(nEventAfterSkip);

% Make training set
trainingCoords1 = Redcircle(1:length(Redcircle)/2,:);
trainingCoords2 = GreenCircle(1:length(GreenCircle)/2,:);
trainingCoords3 = BlueCircle(1:length(BlueCircle)/2,:);
data = [trainingCoords1; trainingCoords2; trainingCoords3];
data(:,2) = 1:numel(data);
% data(end,:) =[];
% data = data(shuffledIndex,:);



% Label for the train set
labels = nan(length(data),1);
labels(1:length(trainingCoords1)+1,1) = 1;
labels(length(trainingCoords1):length(trainingCoords1)*2+1,1) = 2;
labels(length(trainingCoords1)*2:length(trainingCoords1)*3,1) = 3;
% labels(end,:) = [];
% labels = labels(shuffledIndex,:);

% Test data
testCoords1 = Redcircle(length(Redcircle)/2+1:end,:);
testCoords2 = GreenCircle(length(GreenCircle)/2+1:end,:);
testCoords3 = BlueCircle(length(BlueCircle)/2+1:end,:);

t_data = [testCoords1; testCoords2; testCoords3];
% t_data(end,:) =[];
t_data(:,2) = 1:numel(t_data);
t_label_test = 51:99;
% t_data = t_data(shuffledIndex,:);

% make test label
t_labels = nan(length(t_data),1);
% t_labels(1:length(t_data)/2+1,1) = 1;t_labels(length(t_data)/2+1:end,1) = 0;
t_labels(1:length(testCoords1)+1,1) = 1;t_labels(length(testCoords1):length(testCoords1)*2+1,1) = 2;t_labels(length(testCoords1)*2:length(testCoords1)*3,1) = 3;
% t_labels(end,:) = [];
% t_labels = t_labels(shuffledIndex,:);


% Get stats for the table
trainMean = mean(data(:,1))
trainSigma = std(t_data(:,1))

testMean = mean(data(:,1))
testSigma = std(t_data(:,1))


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

% Get index for class with label 1 and group into one matrix
class1 = find(All_data(:,3) < 2);
classOne = All_data(class1,:);

% Get index for class with label 2 and group into one matrix
class2 = find(All_data(:,3) < 3 & All_data(:,3) > 1);
classTwo = All_data(class2,:);

% Get index for class with label 3 and group into one matrix
class3 = find(All_data(:,3) > 2);
classThree = All_data(class3,:);

lineWidth = 2;
fontSize = 20;
markerSize = 10;

% Visualization
findLabelsOne = find(labels==1);
findLabelsTwo = find(labels==2);
findLabelsThree = find(labels==3);

allDataTestPredicted = [t_data t_labels predicted_labels];

findOne = find(allDataTestPredicted(:,3) ==1);
findTwo = find(allDataTestPredicted(:,3) ==2);
findThree = find(allDataTestPredicted(:,3) ==3);

t_label1_predicted = allDataTestPredicted(findOne,:);t_label1_predicted(:,5) = length(t_label1_predicted):length(t_label1_predicted)*2-1;
t_label2_predicted = allDataTestPredicted(findTwo,:);t_label2_predicted(:,5) = length(t_label2_predicted):length(t_label2_predicted)*2-1;
t_label3_predicted = allDataTestPredicted(findThree,:);t_label3_predicted(:,5) = length(t_label3_predicted):length(t_label3_predicted)*2-1;

dataOne   = data(findLabelsOne,:);
dataTwo   = data(findLabelsTwo,:);
dataThree = data(findLabelsThree,:);
    
% end
% accuracyArray
%%
figure(1);
subplot(2,2,1)
plot(data(1:length(data)/3,2), trainingCoords1(:, 1),'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(data(1:length(data)/3,2),trainingCoords2(:, 1), 'bo', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(data(1:length(data)/3,2),trainingCoords3(:, 1), 'go', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('Training data only', 'FontSize', fontSize, 'Interpreter', 'None');
legend('Red Circle', 'Green Circle', 'Blue Circle', 'Location', 'northwest');
% Enlarge figure to full screen.
pos = get(gca, 'Position');
pos(1) = pos(1) + spacing;
pos(2) = pos(2) + spacing2;
% pos(3) = 0.2157;
set(gca, 'Position', pos);
% set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);

subplot(2, 2, 2);
plot(t_label_test(1,:), testCoords1(:, 1),'k*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(t_label_test(1,:),testCoords2(:, 1), 'k*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(t_label_test(1,:),testCoords3(:, 1), 'k*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
legend('As-of-yet Unknown Class', 'Location', 'northwest');
pos = get(gca, 'Position');
pos(1) = pos(1) - spacing;
pos(2) = pos(2) + spacing2;
set(gca, 'Position', pos);
title('Test Data Before Classification', 'FontSize', fontSize, 'Interpreter', 'None');

subplot(2, 2, 3);
plot(data(1:length(data)/3,2),trainingCoords1(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(data(1:length(data)/3,2),trainingCoords2(:, 1), 'bo', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(data(1:length(data)/3,2),trainingCoords3(:, 1), 'go', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(t_label_test(1,:), testCoords1(:, 1),'k*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(t_label_test(1,:),testCoords2(:, 1), 'k*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(t_label_test(1,:),testCoords3(:, 1), 'k*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
pos = get(gca, 'Position');
pos(1) = pos(1) + spacing;
% pos(2) = pos(2) + spacing2;
% pos(3) = 0.2157;
set(gca, 'Position', pos);
legend('Red Circle', 'Green Circle', 'Blue Circle', 'As-of-yet Unknown Class', 'Location', 'northwest');
title('Training and Test Data', 'FontSize', fontSize, 'Interpreter', 'None');

% Now plot what we found.  Each class gets the same marker as the training class.
subplot(2, 2, 4);
plot(t_label1_predicted(:, 5), t_label1_predicted(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(t_label2_predicted(:, 5), t_label2_predicted(:, 1), 'bo', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(t_label3_predicted(:, 5), t_label3_predicted(:, 1), 'go', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
axis square;
% xlim([0, 6]);
% ylim([0, 6]);
pos = get(gca, 'Position');
pos(1) = pos(1) - spacing;
% pos(2) = pos(2) + spacing2;
% pos(3) = 0.2157;
set(gca, 'Position', pos);
title('Test Data After Classification', 'FontSize', fontSize, 'Interpreter', 'None');
legend('Estimated to be in Red Circle', 'Estimated to be in Green Circle', 'Estimated to be in Blue Circle', 'Location', 'northwest');


% %mean training for circle
% durationOfRecordingsTrainM = mean(DurationC(1:floor(nEventAfterSkip*trainTestSplitRatio),:));
% numberofEventsTrainM = mean(TotalEventC(1:floor(nEventAfterSkip*trainTestSplitRatio),:));
% numberOfONEventsTrainM = mean(ONEventC(1:floor(nEventAfterSkip*trainTestSplitRatio),:));
% numberOfOFFEventsTrainM = mean(OFFEventC(1:floor(nEventAfterSkip*trainTestSplitRatio),:));
% xAddressTrainM = mean(XmeanC(1:floor(nEventAfterSkip*trainTestSplitRatio),:));
% yAddressTrainM = mean(YmeanC(1:floor(nEventAfterSkip*trainTestSplitRatio),:));
% 
% %mean test for circle
% durationOfRecordingsTestM = mean(DurationC((floor(nEventAfterSkip*trainTestSplitRatio)+2):end,:));
% numberofEventsTestM = mean(TotalEventC((floor(nEventAfterSkip*trainTestSplitRatio)+2):end,:));
% numberOfONEventsTestM = mean(ONEventC((floor(nEventAfterSkip*trainTestSplitRatio)+2):end,:));
% numberOfOFFEventsTestM = mean(OFFEventC((floor(nEventAfterSkip*trainTestSplitRatio)+2):end,:));
% xAddressTestM = mean(XmeanC((floor(nEventAfterSkip*trainTestSplitRatio)+2):end,:));
% yAddressTestM = mean(YmeanC((floor(nEventAfterSkip*trainTestSplitRatio)+2):end,:));
% 
% 
% %sigma
% durationOfRecordingsTrainS = std(DurationC((floor(nEventAfterSkip*trainTestSplitRatio)+2):end,:));
% numberofEventsTrainS = std(TotalEventC((floor(nEventAfterSkip*trainTestSplitRatio)+2):end,:));
% numberOfONEventsTrainS = std(ONEventC((floor(nEventAfterSkip*trainTestSplitRatio)+2):end,:));
% numberOfOFFEventsTrainS = std(OFFEventC((floor(nEventAfterSkip*trainTestSplitRatio)+2):end,:));
% xAddressTrainS = std(XstdvC((floor(nEventAfterSkip*trainTestSplitRatio)+2):end,:));
% yAddressTrainS = std(YstdvC((floor(nEventAfterSkip*trainTestSplitRatio)+2):end,:));
% 
% % Get overall stats for test
% %mean
% durationOfRecordingsTestM = mean(DurationL(1:floor(nEventAfterSkip*trainTestSplitRatio),:));
% numberofEventsTestM = mean(TotalEventL(1:floor(nEventAfterSkip*trainTestSplitRatio),:));
% numberOfONEventsTestM = mean(ONEventL(1:floor(nEventAfterSkip*trainTestSplitRatio),:));
% numberOfOFFEventsTestM = mean(OFFEventL(1:floor(nEventAfterSkip*trainTestSplitRatio),:));
% xAddressTestM = mean(XstdvL(1:floor(nEventAfterSkip*trainTestSplitRatio),:));
% yAddressTestM = mean(YstdvL(1:floor(nEventAfterSkip*trainTestSplitRatio),:));
% %sigma
% durationOfRecordingsTestS = std(DurationL((floor(nEventAfterSkip*trainTestSplitRatio)+2):end,:));
% numberofEventsTestS = std(TotalEventL((floor(nEventAfterSkip*trainTestSplitRatio)+2):end,:));
% numberOfONEventsTestS = std(ONEventL((floor(nEventAfterSkip*trainTestSplitRatio)+2):end,:));
% numberOfOFFEventsTestS = std(OFFEventL((floor(nEventAfterSkip*trainTestSplitRatio)+2):end,:));
% xAddressTestS = std(XstdvL((floor(nEventAfterSkip*trainTestSplitRatio)+2):end,:));
% yAddressTestS = std(YstdvL((floor(nEventAfterSkip*trainTestSplitRatio)+2):end,:));


% ONEventC = [];
% OFFEventC = [];
% ONOFFRatioC = [];
% TotalEventC = [];
% DurationC = [];
% XmeanC = [];
% YmeanC = [];
% XstdvC = [];
% YstdvC = [];
%% Visualize all data
lineWidth = 2;
fontSize = 20;
markerSize = 10;
spacing = 0.06705;
% spacingTwo = 0.1403;

figure(2);
hAxis(1) = subplot(3,3,1);
plot(ONEventAllG(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(ONEventAllR(:, 1), 'bo', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(ONEventAllB(:, 1), 'go', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('ON Events', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Total number of ON Events");
legend('Green Circle', 'Red Circle', 'Blue Circle', 'northwest');
% Enlarge figure to full screen.
pos = get(gca, 'Position');
pos(1) = pos(1) + spacing;
% pos(3) = 0.2157;
set(gca, 'Position', pos);
% set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hAxis(2) = subplot(3,3,2);
plot(OFFEventAllG(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(OFFEventAllR(:, 1), 'bo', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(OFFEventAllB(:, 1), 'go', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('OFF Events', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Total number of OFF Events");
legend('Green Circle', 'Red Circle', 'Blue Circle', 'northwest');% Enlarge figure to full screen.
pos = get(gca, 'Position');
% pos(2) = 0.6703;
set(gca, 'Position', pos);
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hAxis(3) = subplot(3,3,3);
plot(ONOFFRatioAllG(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(ONOFFRatioAllR(:, 1), 'bo', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(ONOFFRatioAllB(:, 1), 'go', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('ON/OFF Ratio', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("The ratio of ON/OFF Events Polarities");
legend('Green Circle', 'Red Circle', 'Blue Circle', 'northwest');pos = get(gca, 'Position');
pos(1) = pos(1) - spacing;
% pos(2) = 0.6703;
set(gca, 'Position', pos);
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hAxis(4) = subplot(3,3,4);
plot(TotalEventAllG(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(TotalEventAllR(:, 1), 'bo', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(TotalEventAllB(:, 1), 'go', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('Number of Event', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
ylabel("Total number of Events" ,"Fontsize", 30);
legend('Green Circle', 'Red Circle', 'Blue Circle', 'northwest');pos = get(gca, 'Position');
pos(1) = pos(1) + spacing;
set(gca, 'Position', pos);
% set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hAxis(5) = subplot(3,3,5);
plot(DurationAllG(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(DurationAllR(:, 1), 'bo', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(DurationAllB(:, 1), 'go', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('Duration', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Total Events Duration");
legend('Green Circle', 'Red Circle', 'Blue Circle', 'northwest');set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hAxis(6) = subplot(3,3,6);
plot(XmeanAllG(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(XmeanAllR(:, 1), 'bo', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(XmeanAllB(:, 1), 'go', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('X mean', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("X-address mean");
legend('Green Circle', 'Red Circle', 'Blue Circle', 'northwest');pos = get(gca, 'Position');
pos(1) = pos(1) - spacing;
set(gca, 'Position', pos);
% set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hAxis(7) = subplot(3,3,7);
plot(YmeanAllG(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(YmeanAllR(:, 1), 'bo', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(YmeanAllB(:, 1), 'go', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('Y mean', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Y-address mean");
legend('Green Circle', 'Red Circle', 'Blue Circle', 'northwest');pos = get(gca, 'Position');
pos(1) = pos(1) + spacing;
% pos(2) = spacingTwo;
set(gca, 'Position', pos);
% set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hAxis(8) = subplot(3,3,8);
plot(XstdvAllG(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(XstdvAllR(:, 1), 'bo', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(XstdvAllB(:, 1), 'go', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('X Stdv', 'FontSize', fontSize, 'Interpreter', 'None');
xlabel("Number of samples","Fontsize", 30);
% ylabel("X-address Standard Deviation");
legend('Green Circle', 'Red Circle', 'Blue Circle', 'northwest');pos = get(gca, 'Position');
% pos(1) = pos(1) - spacing;
% pos(2) = spacingTwo;
set(gca, 'Position', pos);
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hAxis(9) = subplot(3,3,9);
plot(YstdvAllG(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(YstdvAllR(:, 1), 'bo', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(YstdvAllB(:, 1), 'go', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('Y Stdv', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Y-address Standard Deviation");
legend('Green Circle', 'Red Circle', 'Blue Circle', 'northwest');pos = get(gca, 'Position');
pos(1) = pos(1) - spacing;
% pos(2) = spacingTwo;
set(gca, 'Position', pos);
% set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%% Visualize bar plot for accuracy without colours

figure(3);
results = [98.63 98.63 98.63 98.63 52.38 98.63 98.63 100 100];
bar(results); hold on
text(1:length(results),results,num2str(results'),'vert','bottom','horiz','center','FontSize',20); 
box off
yl = yline(100/3,'--','Chance 33.33 %','fontsize',22,'LineWidth',3);
yl.LabelHorizontalAlignment = 'right';
yl.LabelVerticalAlignment = 'middle';
yl.Color = [.1 0 .40];
str={'ON Events','OFF Events','ON/OFF Ratio','Number of Events','Duration','X mean','Y mean', 'X stdv', 'Y stdv'};
set(gca, 'XTickLabel',str, 'XTick',1:numel(str),'fontsize',18, 'YGrid', 'on', 'XGrid', 'off')
xlabel("Classification Method");
ylabel("Accuracy (% Correct)");
title("kNN Classification Accuracy Using Statistical Properties of Circle and Line")
xtickangle(45)
xlim([0 12])
ylim([0 105]);
% grid on

%% Visualize bar plot for accuracy with colours

x1 = [98.63 98.63 98.63 98.63;
     98.63 97.95 98.63 98.63;
     100 100 100 100;
     98.63 98.63 98.63 98.63;
     56.4626 49.65 48.97 44.89;
     98.63 98.63 98.63 98.63;
     98.63 98.63 98.63 98.63;
     100 100 100 100;
     100 100 100 100];

% Stdv1 = [std(ONEventRedCircle_redEvent) std(ONEventRedCircle_blueEvent) std(ONEventRedCircle_greenEvent); 
%          std(ONEventBlackCircle_redEvent) std(ONEventBlackCircle_blueEvent) std(ONEventBlackCircle_greenEvent)];
b = bar(x1,'facecolor',[.8 .8 .8]);hold on
% text(1:length(x1),x1,num2str(x1'),'vert','bottom','horiz','center','FontSize',20); 
b(1).FaceColor = [.9 .0 .0];b(2).FaceColor = [.0 .0 .9];b(3).FaceColor = [.0 .9 .0];b(4).FaceColor = [.0 .6 .0];
yl = yline(100/3,'--','Chance 33.33 %','fontsize',22,'LineWidth',3);
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