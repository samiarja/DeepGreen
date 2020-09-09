%% Get event duration and event count and find differences
clc
clear
close all
lineWidth = 2;
fontSize = 20;
markerSize = 10;

eventCountforCircle = [];eventCountforTriangle = [];eventCountforRectangle = [];eventCountforStar = [];

eventDurationforCircle = [];eventDurationforTriangle = [];eventDurationforRectangle = [];eventDurationforStar = [];
timeAdvance = 3;

for idx = 1:55
    allCircle = load("Data/differentobjectdifferentcolour/" + idx + ".mat"); % 1: ts, 2: x, 3: y, 4: p, 5: colour
    
    allCircle.events(:,1) = allCircle.events(:,1) - allCircle.events(1,1); % normalize timestamp
    firstTimeStamp = allCircle.events(1,1)/1e6; % convert timestamp from us to s
    firstTimeStampPlusTwoSeconds = firstTimeStamp + timeAdvance; % add two seconds to the timestamp
    findTimeTwoSecond = allCircle.events(:,1)<firstTimeStampPlusTwoSeconds*1e6; % 
    
    allCircle = allCircle.events(findTimeTwoSecond,:);
    
    findBoundaryCoordinateCircle = find(allCircle(:, 2) > 200 & allCircle(:, 3) < 150); % y > 160 && x < 155 && x > 45
    findBoundaryCoordinateTriangle = find(allCircle(:, 2) > 216 & allCircle(:, 2) < 316 & allCircle(:, 3) > 160); % y > 160 && x > 216 && x < 316
    findBoundaryCoordinateRectangle = find(allCircle(:, 2) > 15 & allCircle(:, 2) < 115 & allCircle(:, 3) < 100); % y < 100 && x < 115 && x > 15
    findBoundaryCoordinateStar = find(allCircle(:, 2) > 35 & allCircle(:, 2) < 135 & allCircle(:, 3) > 160);
    
    circle = allCircle(findBoundaryCoordinateCircle,:);
    triangle = allCircle(findBoundaryCoordinateTriangle,:);
    rectangle = allCircle(findBoundaryCoordinateRectangle,:);
    star = allCircle(findBoundaryCoordinateStar,:);
    
    eventCountforCircle = [eventCountforCircle;numel(circle(:,1))];
    eventCountforTriangle = [eventCountforTriangle;numel(triangle(:,1))];
    eventCountforRectangle = [eventCountforRectangle;numel(rectangle(:,1))];
    eventCountforStar = [eventCountforStar;numel(star(:,1))];
    
    eventDurationforCircle = [eventDurationforCircle;(circle(end,1)-circle(1,1))];
    eventDurationforTriangle = [eventDurationforTriangle;(triangle(end,1)-triangle(1,1))];
    eventDurationforRectangle = [eventDurationforRectangle;(rectangle(end,1)-rectangle(1,1))];   
    eventDurationforStar = [eventDurationforStar;(star(end,1)-star(1,1))]; 
end

figure(1);
subplot(2,2,1)
plot(eventCountforTriangle,'r','LineWidth', lineWidth, 'MarkerSize', markerSize);hold on
plot(eventCountforCircle,'g','LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(eventCountforRectangle,'b','LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(eventCountforStar,'y','LineWidth', lineWidth, 'MarkerSize', markerSize);
legend("Triangle", "Circle", "Rectangle", "Star");
xlabel("Number of recorded Data");
ylabel("Number of events");
title("Number of events",'FontSize', fontSize, 'Interpreter', 'None');

subplot(2,2,3)
plot(eventDurationforTriangle/1e6,'r','LineWidth', lineWidth, 'MarkerSize', markerSize);hold on
plot(eventDurationforCircle/1e6,'g','LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(eventDurationforRectangle/1e6,'b','LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(eventDurationforStar/1e6,'y','LineWidth', lineWidth, 'MarkerSize', markerSize);
legend("Triangle", "Circle", "Rectangle", "Star");
xlabel("Number of recorded Data");
ylabel("Duration of events (s)");
title("Duration of events",'FontSize', fontSize, 'Interpreter', 'None');

subplot(2,2,[2 4])
y=[eventDurationforTriangle/1e6 eventDurationforCircle/1e6 eventDurationforRectangle/1e6 eventDurationforStar/1e6];
boxplot(y)
str={'Triangle','Circle','Rectangle','Star'};
ylabel("Duration of events (s)");
set(gca, 'XTickLabel',str, 'XTick',1:numel(str),'fontsize',18, 'YGrid', 'on', 'XGrid', 'off')
title("Box plot",'FontSize', fontSize, 'Interpreter', 'None');
view([90 90]);
%% Generate dataset for each class and for each statistical measure
clc
clear
close all
addpath("../");

% circle
% trianlge
% rectangle
% star

% For circle
ONEventC_R = [];ONEventC_B = [];ONEventC_G1 = [];ONEventC_G2 = [];
OFFEventC_R = [];OFFEventC_B = [];OFFEventC_G1 = [];OFFEventC_G2 = [];
ONOFFRatioC_R = [];ONOFFRatioC_B = [];ONOFFRatioC_G1 = [];ONOFFRatioC_G2 = [];
TotalEventC_R = [];TotalEventC_B = [];TotalEventC_G1 = [];TotalEventC_G2 = [];
DurationC_R = [];DurationC_B = [];DurationC_G1 = [];DurationC_G2 = [];
XmeanC_R = [];XmeanC_B = [];XmeanC_G1 = [];XmeanC_G2 = [];
YmeanC_R = [];YmeanC_B = [];YmeanC_G1 = [];YmeanC_G2 = [];
XstdvC_R = [];XstdvC_B = [];XstdvC_G1 = [];XstdvC_G2 = [];
YstdvC_R = [];YstdvC_B = [];YstdvC_G1 = [];YstdvC_G2 = [];

% For triangle
ONEventT_R = [];ONEventT_B = [];ONEventT_G1 = [];ONEventT_G2 = [];
OFFEventT_R = [];OFFEventT_B = [];OFFEventT_G1 = [];OFFEventT_G2 = [];
ONOFFRatioT_R = [];ONOFFRatioT_B = [];ONOFFRatioT_G1 = [];ONOFFRatioT_G2 = [];
TotalEventT_R = [];TotalEventT_B = [];TotalEventT_G1 = [];TotalEventT_G2 = [];
DurationT_R = [];DurationT_B = [];DurationT_G1 = [];DurationT_G2 = [];
XmeanT_R = [];XmeanT_B = [];XmeanT_G1 = [];XmeanT_G2 = [];
YmeanT_R = [];YmeanT_B = [];YmeanT_G1 = [];YmeanT_G2 = [];
XstdvT_R = [];XstdvT_B = [];XstdvT_G1 = [];XstdvT_G2 = [];
YstdvT_R = [];YstdvT_B = [];YstdvT_G1 = [];YstdvT_G2 = [];

% For rectangle
ONEventR_R = [];ONEventR_B = [];ONEventR_G1 = [];ONEventR_G2 = [];
OFFEventR_R = [];OFFEventR_B = [];OFFEventR_G1 = [];OFFEventR_G2 = [];
ONOFFRatioR_R = [];ONOFFRatioR_B = [];ONOFFRatioR_G1 = [];ONOFFRatioR_G2 = [];
TotalEventR_R = [];TotalEventR_B = [];TotalEventR_G1 = [];TotalEventR_G2 = [];
DurationR_R = [];DurationR_B = [];DurationR_G1 = [];DurationR_G2 = [];
XmeanR_R = [];XmeanR_B = [];XmeanR_G1 = [];XmeanR_G2 = [];
YmeanR_R = [];YmeanR_B = [];YmeanR_G1 = [];YmeanR_G2 = [];
XstdvR_R = [];XstdvR_B = [];XstdvR_G1 = [];XstdvR_G2 = [];
YstdvR_R = [];YstdvR_B = [];YstdvR_G1 = [];YstdvR_G2 = [];

% For star
ONEventS_R = [];ONEventS_B = [];ONEventS_G1 = [];ONEventS_G2 = [];
OFFEventS_R = [];OFFEventS_B = [];OFFEventS_G1 = [];OFFEventS_G2 = [];
ONOFFRatioS_R = [];ONOFFRatioS_B = [];ONOFFRatioS_G1 = [];ONOFFRatioS_G2 = [];
TotalEventS_R = [];TotalEventS_B = [];TotalEventS_G1 = [];TotalEventS_G2 = [];
DurationS_R = [];DurationS_B = [];DurationS_G1 = [];DurationS_G2 = [];
XmeanS_R = [];XmeanS_B = [];XmeanS_G1 = [];XmeanS_G2 = [];
YmeanS_R = [];YmeanS_B = [];YmeanS_G1 = [];YmeanS_G2 = [];
XstdvS_R = [];XstdvS_B = [];XstdvS_G1 = [];XstdvS_G2 = [];
YstdvS_R = [];YstdvS_B = [];YstdvS_G1 = [];YstdvS_G2 = [];

% For all
ONEventC = [];ONEventT = [];ONEventR = [];ONEventS = [];
OFFEventC = [];OFFEventT = [];OFFEventR = [];OFFEventS = [];
ONOFFRatioC = [];ONOFFRatioT = [];ONOFFRatioR = [];ONOFFRatioS = [];
TotalEventC = [];TotalEventT = [];TotalEventR = [];TotalEventS = [];
DurationC = [];DurationT = [];DurationR = [];DurationS = [];
XmeanC = [];XmeanT = [];XmeanR = [];XmeanS = [];
YmeanC = [];YmeanT = [];YmeanR = [];YmeanS = [];
XstdvC = [];XstdvT = [];XstdvR = [];XstdvS = [];
YstdvC = [];YstdvT = [];YstdvR = [];YstdvS = [];

timeAdvance = 3;

for idx = 1:56
    
    allCircle = load("Data/differentobjectdifferentcolour/" + idx + ".mat"); % 1: ts, 2: x, 3: y, 4: p, 5: colour
    
    allCircle.events(:,1)        = allCircle.events(:,1) - allCircle.events(1,1); % normalize timestamp
    firstTimeStamp               = allCircle.events(1,1)/1e6; % convert timestamp from us to s
    firstTimeStampPlusTwoSeconds = firstTimeStamp + timeAdvance; % add two seconds to the timestamp
    findTimeTwoSecond            = allCircle.events(:,1)<firstTimeStampPlusTwoSeconds*1e6; % 
    
    allCircle = allCircle.events(findTimeTwoSecond,:);
    
    findBoundaryCoordinateCircle      = find(allCircle(:, 2) > 200 & allCircle(:, 3) < 150); % y > 160 && x < 155 && x > 45
    findBoundaryCoordinateTriangle    = find(allCircle(:, 2) > 216 & allCircle(:, 2) < 316 & allCircle(:, 3) > 160); % y > 160 && x > 216 && x < 316
    findBoundaryCoordinateRectangle   = find(allCircle(:, 2) > 15 & allCircle(:, 2) < 115 & allCircle(:, 3) < 100); % y < 100 && x < 115 && x > 15
    findBoundaryCoordinateStar        = find(allCircle(:, 2) > 35 & allCircle(:, 2) < 135 & allCircle(:, 3) > 160);
    
    circle     = allCircle(findBoundaryCoordinateCircle,:);
    triangle   = allCircle(findBoundaryCoordinateTriangle,:);
    rectangle  = allCircle(findBoundaryCoordinateRectangle,:);
    star       = allCircle(findBoundaryCoordinateStar,:);
    
    % for the circle
    circle_redEvents = circle(circle(:,5)==2,:);
    circle_green1Events = circle(circle(:,5)==3,:);
    circle_green2Events = circle(circle(:,5)==4,:);
    circle_blueEvents = circle(circle(:,5)==1,:);
    
     % for the triangle
    triangle_redEvents = triangle(triangle(:,5)==2,:);
    triangle_green1Events = triangle(triangle(:,5)==3,:);
    triangle_green2Events = triangle(triangle(:,5)==4,:);
    triangle_blueEvents = triangle(triangle(:,5)==1,:);
    
     % for the rectangle
    rectangle_redEvents = rectangle(rectangle(:,5)==2,:);
    rectangle_green1Events = rectangle(rectangle(:,5)==3,:);
    rectangle_green2Events = rectangle(rectangle(:,5)==4,:);
    rectangle_blueEvents = rectangle(rectangle(:,5)==1,:);
    
    % for the star
    star_redEvents = star(star(:,5)==2,:);
    star_green1Events = star(star(:,5)==3,:);
    star_green2Events = star(star(:,5)==4,:);
    star_blueEvents = star(star(:,5)==1,:);
    
    % Get for circle
    % for all
    ONEventC         = [ONEventC;length(find(circle(:,4) == 1))];
    OFFEventC        = [OFFEventC;length(find(circle(:,4) == 0))];
    ONOFFRatioC      = [ONOFFRatioC;size(find(circle(:,4) == 1))/size(find(circle(:,4) == 0))];
    TotalEventC      = [TotalEventC;numel(circle(:,2))];
    DurationC        = [DurationC;circle(end,1) - circle(1,1)];
    XmeanC           = [XmeanC;mean(circle(:,2))];
    YmeanC           = [YmeanC;mean(circle(:,3))];
    XstdvC           = [XstdvC;std(single(circle(:,2)))];
    YstdvC           = [YstdvC;std(single(circle(:,3)))];
    % for red
    ONEventC_R         = [ONEventC_R;length(find(circle_redEvents(:,4) == 1))];
    OFFEventC_R        = [OFFEventC_R;length(find(circle_redEvents(:,4) == 0))];
    ONOFFRatioC_R      = [ONOFFRatioC_R;size(find(circle_redEvents(:,4) == 1))/size(find(circle_redEvents(:,4) == 0))];
    TotalEventC_R      = [TotalEventC_R;numel(circle_redEvents(:,2))];
    DurationC_R        = [DurationC_R;circle_redEvents(end,1) - circle_redEvents(1,1)];
    XmeanC_R           = [XmeanC_R;mean(circle_redEvents(:,2))];
    YmeanC_R           = [YmeanC_R;mean(circle_redEvents(:,3))];
    XstdvC_R           = [XstdvC_R;std(single(circle_redEvents(:,2)))];
    YstdvC_R           = [YstdvC_R;std(single(circle_redEvents(:,3)))];
    % for blue
    ONEventC_B         = [ONEventC_B;length(find(circle_blueEvents(:,4) == 1))];
    OFFEventC_B        = [OFFEventC_B;length(find(circle_blueEvents(:,4) == 0))];
    ONOFFRatioC_B      = [ONOFFRatioC_B;size(find(circle_blueEvents(:,4) == 1))/size(find(circle_blueEvents(:,4) == 0))];
    TotalEventC_B      = [TotalEventC_B;numel(circle_blueEvents(:,2))];
    DurationC_B        = [DurationC_B;circle_blueEvents(end,1) - circle_blueEvents(1,1)];
    XmeanC_B           = [XmeanC_B;mean(circle_blueEvents(:,2))];
    YmeanC_B           = [YmeanC_B;mean(circle_blueEvents(:,3))];
    XstdvC_B           = [XstdvC_B;std(single(circle_blueEvents(:,2)))];
    YstdvC_B           = [YstdvC_B;std(single(circle_blueEvents(:,3)))];
    % for green 1
    ONEventC_G1         = [ONEventC_G1;length(find(circle_green1Events(:,4) == 1))];
    OFFEventC_G1        = [OFFEventC_G1;length(find(circle_green1Events(:,4) == 0))];
    ONOFFRatioC_G1      = [ONOFFRatioC_G1;size(find(circle_green1Events(:,4) == 1))/size(find(circle_green1Events(:,4) == 0))];
    TotalEventC_G1      = [TotalEventC_G1;numel(circle_green1Events(:,2))];
    DurationC_G1        = [DurationC_G1;circle_green1Events(end,1) - circle_green1Events(1,1)];
    XmeanC_G1           = [XmeanC_G1;mean(circle_green1Events(:,2))];
    YmeanC_G1           = [YmeanC_G1;mean(circle_green1Events(:,3))];
    XstdvC_G1           = [XstdvC_G1;std(single(circle_green1Events(:,2)))];
    YstdvC_G1           = [YstdvC_G1;std(single(circle_green1Events(:,3)))];
    % for green 2
    ONEventC_G2         = [ONEventC_G2;length(find(circle_green2Events(:,4) == 1))];
    OFFEventC_G2        = [OFFEventC_G2;length(find(circle_green2Events(:,4) == 0))];
    ONOFFRatioC_G2      = [ONOFFRatioC_G2;size(find(circle_green2Events(:,4) == 1))/size(find(circle_green2Events(:,4) == 0))];
    TotalEventC_G2      = [TotalEventC_G2;numel(circle_green2Events(:,2))];
    DurationC_G2        = [DurationC_G2;circle_green2Events(end,1) - circle_green2Events(1,1)];
    XmeanC_G2           = [XmeanC_G2;mean(circle_green2Events(:,2))];
    YmeanC_G2           = [YmeanC_G2;mean(circle_green2Events(:,3))];
    XstdvC_G2           = [XstdvC_G2;std(single(circle_green2Events(:,2)))];
    YstdvC_G2           = [YstdvC_G2;std(single(circle_green2Events(:,3)))];
    
    % Get for triangle
    ONEventT        = [ONEventT;length(find(triangle(:,4) == 1))];
    OFFEventT        = [OFFEventT;length(find(triangle(:,4) == 0))];
    ONOFFRatioT      = [ONOFFRatioT;size(find(triangle(:,4) == 1))/size(find(triangle(:,4) == 0))];
    TotalEventT      = [TotalEventT;numel(triangle(:,2))];
    DurationT        = [DurationT;triangle(end,1) - triangle(1,1)];
    XmeanT           = [XmeanT;mean(triangle(:,2))];
    YmeanT           = [YmeanT;mean(triangle(:,3))];
    XstdvT           = [XstdvT;std(single(triangle(:,2)))];
    YstdvT           = [YstdvT;std(single(triangle(:,3)))];
    % for red
    ONEventT_R         = [ONEventT_R;length(find(triangle_redEvents(:,4) == 1))];
    OFFEventT_R        = [OFFEventT_R;length(find(triangle_redEvents(:,4) == 0))];
    ONOFFRatioT_R      = [ONOFFRatioT_R;size(find(triangle_redEvents(:,4) == 1))/size(find(triangle_redEvents(:,4) == 0))];
    TotalEventT_R      = [TotalEventT_R;numel(triangle_redEvents(:,2))];
    DurationT_R        = [DurationT_R;triangle_redEvents(end,1) - triangle_redEvents(1,1)];
    XmeanT_R           = [XmeanT_R;mean(triangle_redEvents(:,2))];
    YmeanT_R           = [YmeanT_R;mean(triangle_redEvents(:,3))];
    XstdvT_R           = [XstdvT_R;std(single(triangle_redEvents(:,2)))];
    YstdvT_R           = [YstdvT_R;std(single(triangle_redEvents(:,3)))];
    % for blue
    ONEventT_B         = [ONEventT_B;length(find(triangle_blueEvents(:,4) == 1))];
    OFFEventT_B        = [OFFEventT_B;length(find(triangle_blueEvents(:,4) == 0))];
    ONOFFRatioT_B      = [ONOFFRatioT_B;size(find(triangle_blueEvents(:,4) == 1))/size(find(triangle_blueEvents(:,4) == 0))];
    TotalEventT_B      = [TotalEventT_B;numel(triangle_blueEvents(:,2))];
    DurationT_B        = [DurationT_B;triangle_blueEvents(end,1) - triangle_blueEvents(1,1)];
    XmeanT_B           = [XmeanT_B;mean(triangle_blueEvents(:,2))];
    YmeanT_B           = [YmeanT_B;mean(triangle_blueEvents(:,3))];
    XstdvT_B           = [XstdvT_B;std(single(triangle_blueEvents(:,2)))];
    YstdvT_B           = [YstdvT_B;std(single(triangle_blueEvents(:,3)))];
    % for green 1
    ONEventT_G1         = [ONEventT_G1;length(find(triangle_green1Events(:,4) == 1))];
    OFFEventT_G1        = [OFFEventT_G1;length(find(triangle_green1Events(:,4) == 0))];
    ONOFFRatioT_G1      = [ONOFFRatioT_G1;size(find(triangle_green1Events(:,4) == 1))/size(find(triangle_green1Events(:,4) == 0))];
    TotalEventT_G1      = [TotalEventT_G1;numel(triangle_green1Events(:,2))];
    DurationT_G1        = [DurationT_G1;triangle_green1Events(end,1) - triangle_green1Events(1,1)];
    XmeanT_G1           = [XmeanT_G1;mean(triangle_green1Events(:,2))];
    YmeanT_G1           = [YmeanT_G1;mean(triangle_green1Events(:,3))];
    XstdvT_G1           = [XstdvT_G1;std(single(triangle_green1Events(:,2)))];
    YstdvT_G1           = [YstdvT_G1;std(single(triangle_green1Events(:,3)))];
    % for green 2
    ONEventT_G2         = [ONEventT_G2;length(find(triangle_green2Events(:,4) == 1))];
    OFFEventT_G2        = [OFFEventT_G2;length(find(triangle_green2Events(:,4) == 0))];
    ONOFFRatioT_G2      = [ONOFFRatioT_G2;size(find(triangle_green2Events(:,4) == 1))/size(find(triangle_green2Events(:,4) == 0))];
    TotalEventT_G2      = [TotalEventT_G2;numel(triangle_green2Events(:,2))];
    DurationT_G2        = [DurationT_G2;triangle_green2Events(end,1) - triangle_green2Events(1,1)];
    XmeanT_G2           = [XmeanT_G2;mean(triangle_green2Events(:,2))];
    YmeanT_G2           = [YmeanT_G2;mean(triangle_green2Events(:,3))];
    XstdvT_G2           = [XstdvT_G2;std(single(triangle_green2Events(:,2)))];
    YstdvT_G2           = [YstdvT_G2;std(single(triangle_green2Events(:,3)))];
    
    
    % Get for rectangle
    ONEventR         = [ONEventR;length(find(rectangle(:,4) == 1))];
    OFFEventR        = [OFFEventR;length(find(rectangle(:,4) == 0))];
    ONOFFRatioR      = [ONOFFRatioR;size(find(rectangle(:,4) == 1))/size(find(rectangle(:,4) == 0))];
    TotalEventR      = [TotalEventR;numel(rectangle(:,2))];
    DurationR        = [DurationR;rectangle(end,1) - rectangle(1,1)];
    XmeanR           = [XmeanR;mean(rectangle(:,2))];
    YmeanR           = [YmeanR;mean(rectangle(:,3))];
    XstdvR           = [XstdvR;std(single(rectangle(:,2)))];
    YstdvR           = [YstdvR;std(single(rectangle(:,3)))];
    % for red
    ONEventR_R         = [ONEventR_R;length(find(rectangle_redEvents(:,4) == 1))];
    OFFEventR_R        = [OFFEventR_R;length(find(rectangle_redEvents(:,4) == 0))];
    ONOFFRatioR_R      = [ONOFFRatioR_R;size(find(rectangle_redEvents(:,4) == 1))/size(find(rectangle_redEvents(:,4) == 0))];
    TotalEventR_R      = [TotalEventR_R;numel(rectangle_redEvents(:,2))];
    DurationR_R        = [DurationR_R;rectangle_redEvents(end,1) - rectangle_redEvents(1,1)];
    XmeanR_R           = [XmeanR_R;mean(rectangle_redEvents(:,2))];
    YmeanR_R           = [YmeanR_R;mean(rectangle_redEvents(:,3))];
    XstdvR_R           = [XstdvR_R;std(single(rectangle_redEvents(:,2)))];
    YstdvR_R           = [YstdvR_R;std(single(rectangle_redEvents(:,3)))];
    % for blue
    ONEventR_B         = [ONEventR_B;length(find(rectangle_blueEvents(:,4) == 1))];
    OFFEventR_B        = [OFFEventR_B;length(find(rectangle_blueEvents(:,4) == 0))];
    ONOFFRatioR_B      = [ONOFFRatioR_B;size(find(rectangle_blueEvents(:,4) == 1))/size(find(rectangle_blueEvents(:,4) == 0))];
    TotalEventR_B      = [TotalEventR_B;numel(rectangle_blueEvents(:,2))];
    DurationR_B        = [DurationR_B;rectangle_blueEvents(end,1) - rectangle_blueEvents(1,1)];
    XmeanR_B           = [XmeanR_B;mean(rectangle_blueEvents(:,2))];
    YmeanR_B           = [YmeanR_B;mean(rectangle_blueEvents(:,3))];
    XstdvR_B           = [XstdvR_B;std(single(rectangle_blueEvents(:,2)))];
    YstdvR_B           = [YstdvR_B;std(single(rectangle_blueEvents(:,3)))];
    % for green 1
    ONEventR_G1         = [ONEventR_G1;length(find(rectangle_green1Events(:,4) == 1))];
    OFFEventR_G1        = [OFFEventR_G1;length(find(rectangle_green1Events(:,4) == 0))];
    ONOFFRatioR_G1      = [ONOFFRatioR_G1;size(find(rectangle_green1Events(:,4) == 1))/size(find(rectangle_green1Events(:,4) == 0))];
    TotalEventR_G1      = [TotalEventR_G1;numel(rectangle_green1Events(:,2))];
    DurationR_G1        = [DurationR_G1;rectangle_green1Events(end,1) - rectangle_green1Events(1,1)];
    XmeanR_G1           = [XmeanR_G1;mean(rectangle_green1Events(:,2))];
    YmeanR_G1           = [YmeanR_G1;mean(rectangle_green1Events(:,3))];
    XstdvR_G1           = [XstdvR_G1;std(single(rectangle_green1Events(:,2)))];
    YstdvR_G1           = [YstdvR_G1;std(single(rectangle_green1Events(:,3)))];
    % for green 2
    ONEventR_G2         = [ONEventR_G2;length(find(rectangle_green2Events(:,4) == 1))];
    OFFEventR_G2        = [OFFEventR_G2;length(find(rectangle_green2Events(:,4) == 0))];
    ONOFFRatioR_G2      = [ONOFFRatioR_G2;size(find(rectangle_green2Events(:,4) == 1))/size(find(rectangle_green2Events(:,4) == 0))];
    TotalEventR_G2      = [TotalEventR_G2;numel(rectangle_green2Events(:,2))];
    DurationR_G2        = [DurationR_G2;rectangle_green2Events(end,1) - rectangle_green2Events(1,1)];
    XmeanR_G2           = [XmeanR_G2;mean(rectangle_green2Events(:,2))];
    YmeanR_G2           = [YmeanR_G2;mean(rectangle_green2Events(:,3))];
    XstdvR_G2           = [XstdvR_G2;std(single(rectangle_green2Events(:,2)))];
    YstdvR_G2           = [YstdvR_G2;std(single(rectangle_green2Events(:,3)))];
   
    % Get for star
    ONEventS         = [ONEventS;length(find(star(:,4) == 1))];
    OFFEventS        = [OFFEventS;length(find(star(:,4) == 0))];
    ONOFFRatioS      = [ONOFFRatioS;size(find(star(:,4) == 1))/size(find(star(:,4) == 0))];
    TotalEventS      = [TotalEventS;numel(star(:,2))];
    DurationS        = [DurationS;star(end,1) - star(1,1)];
    XmeanS           = [XmeanS;mean(star(:,2))];
    YmeanS           = [YmeanS;mean(star(:,3))];
    XstdvS           = [XstdvS;std(single(star(:,2)))];
    YstdvS           = [YstdvS;std(single(star(:,3)))];
    % for red
    ONEventS_R         = [ONEventS_R;length(find(star_redEvents(:,4) == 1))];
    OFFEventS_R        = [OFFEventS_R;length(find(star_redEvents(:,4) == 0))];
    ONOFFRatioS_R      = [ONOFFRatioS_R;size(find(star_redEvents(:,4) == 1))/size(find(star_redEvents(:,4) == 0))];
    TotalEventS_R      = [TotalEventS_R;numel(star_redEvents(:,2))];
    DurationS_R        = [DurationS_R;star_redEvents(end,1) - star_redEvents(1,1)];
    XmeanS_R           = [XmeanS_R;mean(star_redEvents(:,2))];
    YmeanS_R           = [YmeanS_R;mean(star_redEvents(:,3))];
    XstdvS_R           = [XstdvS_R;std(single(star_redEvents(:,2)))];
    YstdvS_R           = [YstdvS_R;std(single(star_redEvents(:,3)))];
    % for blue
    ONEventS_B         = [ONEventS_B;length(find(star_blueEvents(:,4) == 1))];
    OFFEventS_B        = [OFFEventS_B;length(find(star_blueEvents(:,4) == 0))];
    ONOFFRatioS_B      = [ONOFFRatioS_B;size(find(star_blueEvents(:,4) == 1))/size(find(star_blueEvents(:,4) == 0))];
    TotalEventS_B      = [TotalEventS_B;numel(star_blueEvents(:,2))];
    DurationS_B        = [DurationS_B;star_blueEvents(end,1) - star_blueEvents(1,1)];
    XmeanS_B           = [XmeanS_B;mean(star_blueEvents(:,2))];
    YmeanS_B           = [YmeanS_B;mean(star_blueEvents(:,3))];
    XstdvS_B           = [XstdvS_B;std(single(star_blueEvents(:,2)))];
    YstdvS_B           = [YstdvS_B;std(single(star_blueEvents(:,3)))];
    % for green 1
    ONEventS_G1         = [ONEventS_G1;length(find(star_green1Events(:,4) == 1))];
    OFFEventS_G1        = [OFFEventS_G1;length(find(star_green1Events(:,4) == 0))];
    ONOFFRatioS_G1      = [ONOFFRatioS_G1;size(find(star_green1Events(:,4) == 1))/size(find(star_green1Events(:,4) == 0))];
    TotalEventS_G1      = [TotalEventS_G1;numel(star_green1Events(:,2))];
    DurationS_G1        = [DurationS_G1;star_green1Events(end,1) - star_green1Events(1,1)];
    XmeanS_G1           = [XmeanS_G1;mean(star_green1Events(:,2))];
    YmeanS_G1           = [YmeanS_G1;mean(star_green1Events(:,3))];
    XstdvS_G1           = [XstdvS_G1;std(single(star_green1Events(:,2)))];
    YstdvS_G1           = [YstdvS_G1;std(single(star_green1Events(:,3)))];
    % for green 2
    ONEventS_G2         = [ONEventS_G2;length(find(star_green2Events(:,4) == 1))];
    OFFEventS_G2        = [OFFEventS_G2;length(find(star_green2Events(:,4) == 0))];
    ONOFFRatioS_G2      = [ONOFFRatioS_G2;size(find(star_green2Events(:,4) == 1))/size(find(star_green2Events(:,4) == 0))];
    TotalEventS_G2      = [TotalEventS_G2;numel(star_green2Events(:,2))];
    DurationS_G2        = [DurationS_G2;star_green2Events(end,1) - star_green2Events(1,1)];
    XmeanS_G2           = [XmeanS_G2;mean(star_green2Events(:,2))];
    YmeanS_G2           = [YmeanS_G2;mean(star_green2Events(:,3))];
    XstdvS_G2           = [XstdvS_G2;std(single(star_green2Events(:,2)))];
    YstdvS_G2           = [YstdvS_G2;std(single(star_green2Events(:,3)))];
end
%% Visualize all data
lineWidth = 2;
fontSize = 20;
markerSize = 10;
spacing = 0.06705;
% spacingTwo = 0.1403;

% circle
% trianlge
% rectangle
% star


figure(2);
hAxis(1) = subplot(3,3,1);
plot(ONEventC(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(ONEventT(:, 1), 'b^', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(ONEventR(:, 1), 'gs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(ONEventS(:, 1), 'y*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('ON Events', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Total number of ON Events");
legend('Circle', 'Triangle', 'Rectangle', 'Star', 'northwest');
% Enlarge figure to full screen.
pos = get(gca, 'Position');
pos(1) = pos(1) + spacing;
% pos(3) = 0.2157;
set(gca, 'Position', pos);
% set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hAxis(2) = subplot(3,3,2);
plot(OFFEventC(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(OFFEventT(:, 1), 'b^', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(OFFEventR(:, 1), 'gs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(OFFEventS(:, 1), 'y*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('OFF Events', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Total number of OFF Events");
legend('Circle', 'Triangle', 'Rectangle', 'Star', 'northwest');pos = get(gca, 'Position');
% pos(2) = 0.6703;
set(gca, 'Position', pos);
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hAxis(3) = subplot(3,3,3);
plot(ONOFFRatioC(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(ONOFFRatioT(:, 1), 'b^', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(ONOFFRatioR(:, 1), 'gs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(ONOFFRatioS(:, 1), 'y*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);

grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('ON/OFF Ratio', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("The ratio of ON/OFF Events Polarities");
legend('Circle', 'Triangle', 'Rectangle', 'Star', 'northwest');pos = get(gca, 'Position');
pos(1) = pos(1) - spacing;
% pos(2) = 0.6703;
set(gca, 'Position', pos);
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hAxis(4) = subplot(3,3,4);
plot(TotalEventC(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(TotalEventT(:, 1), 'b^', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(TotalEventR(:, 1), 'gs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(TotalEventS(:, 1), 'y*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);

grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('Number of Event', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
ylabel("Total number of Events" ,"Fontsize", 30);
legend('Circle', 'Triangle', 'Rectangle', 'Star', 'northwest');pos = get(gca, 'Position');
pos(1) = pos(1) + spacing;
set(gca, 'Position', pos);
% set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hAxis(5) = subplot(3,3,5);
plot(DurationC(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(DurationT(:, 1), 'b^', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(DurationR(:, 1), 'gs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(DurationS(:, 1), 'y*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);

grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('Duration', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Total Events Duration");
legend('Circle', 'Triangle', 'Rectangle', 'Star', 'northwest');set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hAxis(6) = subplot(3,3,6);
plot(XmeanC(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(XmeanT(:, 1), 'b^', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(XmeanR(:, 1), 'gs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(XmeanS(:, 1), 'y*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);

grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('X mean', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("X-address mean");
legend('Circle', 'Triangle', 'Rectangle', 'Star', 'northwest');pos = get(gca, 'Position');
pos(1) = pos(1) - spacing;
set(gca, 'Position', pos);
% set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hAxis(7) = subplot(3,3,7);
plot(YmeanC(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(YmeanT(:, 1), 'b^', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(YmeanR(:, 1), 'gs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(YmeanS(:, 1), 'y*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);

grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('Y mean', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Y-address mean");
legend('Circle', 'Triangle', 'Rectangle', 'Star', 'northwest');pos = get(gca, 'Position');
pos(1) = pos(1) + spacing;
% pos(2) = spacingTwo;
set(gca, 'Position', pos);
% set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hAxis(8) = subplot(3,3,8);
plot(XstdvC(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(XstdvT(:, 1), 'b^', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(XstdvR(:, 1), 'gs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(XstdvS(:, 1), 'y*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);

grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('X Stdv', 'FontSize', fontSize, 'Interpreter', 'None');
xlabel("Number of samples","Fontsize", 30);
% ylabel("X-address Standard Deviation");
legend('Circle', 'Triangle', 'Rectangle', 'Star', 'northwest');pos = get(gca, 'Position');
% pos(1) = pos(1) - spacing;
% pos(2) = spacingTwo;
set(gca, 'Position', pos);
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hAxis(9) = subplot(3,3,9);
plot(YstdvC(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(YstdvT(:, 1), 'b^', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(YstdvR(:, 1), 'gs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(YstdvS(:, 1), 'y*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);

grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('Y Stdv', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Y-address Standard Deviation");
legend('Circle', 'Triangle', 'Rectangle', 'Star', 'northwest');pos = get(gca, 'Position');
pos(1) = pos(1) - spacing;
% pos(2) = spacingTwo;
set(gca, 'Position', pos);
% set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);

%% KNN algorithm

% ONEventC
% OFFEventC
% ONOFFRatioC
% TotalEventC
% DurationC
% XmeanC
% YmeanC 
% XstdvC 
% YstdvC 

clc
accuracyArray = [];
spacing = 0.09905;
spacing2 = -0.05;
% for k = 1:2:50

circle      = YmeanC_G2;
trianlge    = YmeanT_G2;
rectangle   = YmeanR_G2;
star        = YmeanS_G2;

% remove the last rows to make the data size even

circle(end,:)= [];
trianlge(end,:)= [];
rectangle(end,:)= [];
star(end,:)= [];

lineWidth = 2;
fontSize = 20;
markerSize = 10;

% Number of K
k = round(sqrt(length(circle)*3)); % square root of the number of sample
% k = 3;

% shuffle data
% ONEventC_shuffle = ONEventC(shuffledIndex,:);
% ONEventL_shuffle = ONEventL(shuffledIndex,:);
nEventAfterSkip = round(size(circle,1)*3/2);
trainTestSplitRatio = 0.5;
shuffledIndex = randperm(nEventAfterSkip);

% Make training set
trainingCoords1 = circle(1:length(circle)/2,:);
trainingCoords2 = trianlge(1:length(trianlge)/2,:);
trainingCoords3 = rectangle(1:length(rectangle)/2,:);
trainingCoords4 = star(1:length(star)/2,:);
data = [trainingCoords1; trainingCoords2; trainingCoords3; trainingCoords4];
data(:,2) = 1:numel(data);
% data(end,:) =[];
% data = data(shuffledIndex,:);

% Get stats for the table
% trainMean = mean(data(1:length(circle)/2,1))
% trainSigma = std(data(1:length(circle)/2,1))
% 
% testMean = mean(data((floor(nEventAfterSkip*trainTestSplitRatio)+2):end,1))
% testSigma = std(data((floor(nEventAfterSkip*trainTestSplitRatio)+2):end,1))

% Label for the train set
labels = nan(length(data),1);
labels(1:length(trainingCoords1)+1,1) = 1;
labels(length(trainingCoords1):length(trainingCoords1)*2+1,1) = 2;
labels(length(trainingCoords1)*2:length(trainingCoords1)*3,1) = 3;
% labels(end,:) = [];
% labels = labels(shuffledIndex,:);

% Test data
testCoords1 = circle(length(circle)/2+1:end,:);
testCoords2 = trianlge(length(trianlge)/2+1:end,:);
testCoords3 = rectangle(length(rectangle)/2+1:end,:);
testCoords4 = star(length(star)/2+1:end,:);

t_data = [testCoords1; testCoords2; testCoords3; testCoords4];
% t_data(end,:) =[];
t_data(:,2) = 1:numel(t_data);
t_label_test = 28:54; % 51:99;
% t_data = t_data(shuffledIndex,:);

% make test label
t_labels = nan(length(t_data),1);
% t_labels(1:length(t_data)/2+1,1) = 1;t_labels(length(t_data)/2+1:end,1) = 0;
t_labels(1:length(testCoords1)+1,1) = 1;
t_labels(length(testCoords1):length(testCoords1)*2+1,1) = 2;
t_labels(length(testCoords1)*2:length(testCoords1)*3,1) = 3;
t_labels(length(testCoords1)*3+1:length(testCoords1)*4,1) = 4;
% t_labels(end,:) = [];
% t_labels = t_labels(shuffledIndex,:);

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
findLabelsFour = find(labels==4);

allDataTestPredicted = [t_data t_labels predicted_labels];

findOne = find(allDataTestPredicted(:,3) ==1);
findTwo = find(allDataTestPredicted(:,3) ==2);
findThree = find(allDataTestPredicted(:,3) ==3);
findFour = find(allDataTestPredicted(:,3) ==4);

t_label1_predicted = allDataTestPredicted(findOne,:);t_label1_predicted(:,5) = length(t_label1_predicted):length(t_label1_predicted)*2-1;
t_label2_predicted = allDataTestPredicted(findTwo,:);t_label2_predicted(:,5) = length(t_label2_predicted):length(t_label2_predicted)*2-1;
t_label3_predicted = allDataTestPredicted(findThree,:);t_label3_predicted(:,5) = length(t_label3_predicted):length(t_label3_predicted)*2-1;
t_label4_predicted = allDataTestPredicted(findFour,:);t_label4_predicted(:,5) = length(t_label4_predicted):length(t_label4_predicted)*2-1;

dataOne   = data(findLabelsOne,:);
dataTwo   = data(findLabelsTwo,:);
dataThree = data(findLabelsThree,:);
dataFour = data(findLabelsFour,:);    
% end
% accuracyArray
%%
figure(1);
subplot(2,2,1)
plot(data(1:length(data)/4,2), trainingCoords1(:, 1),'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(data(1:length(data)/4,2),trainingCoords2(:, 1), 'b^', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(data(1:length(data)/4,2),trainingCoords3(:, 1), 'gs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(data(1:length(data)/4,2),trainingCoords4(:, 1), 'y*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('Training data only', 'FontSize', fontSize, 'Interpreter', 'None');
legend('Circle', 'Triangle', 'Rectangle', 'Star', 'Location', 'northwest');
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
plot(t_label_test(1,:),testCoords4(:, 1), 'k*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
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
plot(data(1:length(data)/4,2),trainingCoords1(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(data(1:length(data)/4,2),trainingCoords2(:, 1), 'b^', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(data(1:length(data)/4,2),trainingCoords3(:, 1), 'gs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(data(1:length(data)/4,2),trainingCoords4(:, 1), 'y*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(t_label_test(1,:), testCoords1(:, 1),'k*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(t_label_test(1,:),testCoords2(:, 1), 'k*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(t_label_test(1,:),testCoords3(:, 1), 'k*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(t_label_test(1,:),testCoords4(:, 1), 'k*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
pos = get(gca, 'Position');
pos(1) = pos(1) + spacing;
% pos(2) = pos(2) + spacing2;
% pos(3) = 0.2157;
set(gca, 'Position', pos);
legend('Circle', 'Triangle', 'Rectangle', 'Star', 'As-of-yet Unknown Class', 'Location', 'northwest');
title('Training and Test Data', 'FontSize', fontSize, 'Interpreter', 'None');

% Now plot what we found.  Each class gets the same marker as the training class.
subplot(2, 2, 4);
plot(t_label1_predicted(:, 5), t_label1_predicted(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(t_label2_predicted(:, 5), t_label2_predicted(:, 1), 'b^', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(t_label3_predicted(:, 5), t_label3_predicted(:, 1), 'gs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(t_label4_predicted(:, 5), t_label4_predicted(:, 1), 'y*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
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
legend('Estimated to be in Circle', 'Estimated to be in Triangle', 'Estimated to be in Rectangle', 'Estimated to be in Star', 'Location', 'northwest');

%% Visualize bar plot for accuracy without colours
figure(3);
results = [73.14 73.14 75 73.14 48.14 73.14 73.14 74.07 74.07];
bar(results); hold on
text(1:length(results),results,num2str(results'),'vert','bottom','horiz','center','FontSize',20); 
box off
yl = yline(100/4,'--','Chance 25 %','fontsize',22,'LineWidth',3);
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

x1 = [73.14 73.14 73.14 73.14;
     73.14 73.14 73.14 73.14;
     75 75 75 75;
     73.14 73.14 73.14 73.14;
     41.66 48.14 39.81 49.07;
     73.14 73.14 73.14 73.14;
     73.95 73.97 73.97 73.97;
     73.97 73.97 73.97 73.97;
     74.48 74.48 74.48 74.48];

% Stdv1 = [std(ONEventRedCircle_redEvent) std(ONEventRedCircle_blueEvent) std(ONEventRedCircle_greenEvent); 
%          std(ONEventBlackCircle_redEvent) std(ONEventBlackCircle_blueEvent) std(ONEventBlackCircle_greenEvent)];
b = bar(x1,'facecolor',[.8 .8 .8]);hold on
% text(1:length(x1),x1,num2str(x1'),'vert','bottom','horiz','center','FontSize',20); 
b(1).FaceColor = [.9 .0 .0];b(2).FaceColor = [.0 .0 .9];b(3).FaceColor = [.0 .9 .0];b(4).FaceColor = [.0 .6 .0];
yl = yline(100/4,'--','Chance 25 %','fontsize',22,'LineWidth',3);
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