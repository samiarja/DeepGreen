%% Get event duration and event count and find differences
clc
clear
close all
lineWidth = 2;
fontSize = 20;
markerSize = 10;

eventCountforCircle = [];
eventCountforLine = [];
eventCountforStar = [];

eventDurationforCircle = [];
eventDurationforLine = [];
eventDurationforStar = [];

timeAdvance = 2;

for idx = 1:95
    Circle = load("Data/circle/" + idx + ".mat");
    Line = load("Data/line/" + idx + ".mat");
    Star = load("Data/star/" + idx + ".mat");
    
    % Circle
    firstTimeStampC = Circle.events(1,1)/1e6;
    firstTimeStampPlusTwoSecondsC = firstTimeStampC + timeAdvance;
    findTimeTwoSecondC = find(Circle.events(:,1)<firstTimeStampPlusTwoSecondsC*1e6);
    
    % Line
    firstTimeStampL = Line.events(1,1)/1e6;
    firstTimeStampPlusTwoSecondsL = firstTimeStampL + timeAdvance;
    findTimeTwoSecondL = find(Line.events(:,1)<firstTimeStampPlusTwoSecondsL*1e6);
    
    % Star
    firstTimeStampS = Star.events(1,1)/1e6;
    firstTimeStampPlusTwoSecondsS = firstTimeStampS + timeAdvance;
    findTimeTwoSecondS = find(Star.events(:,1)<firstTimeStampPlusTwoSecondsS*1e6);
    
    Circle = Circle.events(findTimeTwoSecondC,:);
    Line = Line.events(findTimeTwoSecondL,:);
    Star = Star.events(findTimeTwoSecondS,:);
    
    findBoundaryCoordinateC = Circle(:, 2) > 80 & Circle(:, 2) < 280;
    findBoundaryCoordinateL = Line(:, 2) > 80 & Line(:, 2) < 280;
    findBoundaryCoordinateS = Star(:, 2) > 80 & Star(:, 2) < 280;
    
    Circle = Circle(findBoundaryCoordinateC,:);
    Line = Line(findBoundaryCoordinateL,:);
    Star = Star(findBoundaryCoordinateS,:);
    
    eventCountforCircle = [eventCountforCircle;numel(Circle(:,1))];
    eventCountforLine = [eventCountforLine;numel(Line(:,1))];
    eventCountforStar = [eventCountforStar;numel(Star(:,1))];
    
    eventDurationforCircle = [eventDurationforCircle;(Circle(end,1)-Circle(1,1))];
    eventDurationforLine = [eventDurationforLine;(Line(end,1)-Line(1,1))];
    eventDurationforStar = [eventDurationforStar;(Star(end,1)-Star(1,1))];
    
end

% timeDiff = eventDurationforLine - eventDurationforCircle;
figure(1);
subplot(1,2,1)
plot(eventCountforCircle,'b','LineWidth', lineWidth, 'MarkerSize', markerSize);hold on
plot(eventCountforLine,'r','LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(eventCountforStar,'g','LineWidth', lineWidth, 'MarkerSize', markerSize);
legend("Pattern 1", "Pattern 2","Pattern 3");
xlabel("Number of recorded Data");
ylabel("Number of events");
title("Number of events",'FontSize', fontSize, 'Interpreter', 'None');

subplot(1,2,2)
plot(eventDurationforCircle/1e6,'b','LineWidth', lineWidth, 'MarkerSize', markerSize);hold on
plot(eventDurationforLine/1e6,'r','LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(eventDurationforStar/1e6,'g','LineWidth', lineWidth, 'MarkerSize', markerSize);
legend("Pattern 1", "Pattern 2","Pattern 3");
xlabel("Number of recorded Data");
ylabel("Duration of events (s)");
title("Duration of events",'FontSize', fontSize, 'Interpreter', 'None');
