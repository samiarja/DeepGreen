%% Get event duration and event count and find differences
clc
clear
close all
lineWidth = 2;
fontSize = 20;
markerSize = 10;
addpath("../");

% % initialize parameters
% Parameters.pixelToRemovePercent             = 1;
% Parameters.minimumNumOfEventsToCheckHotNess = 20;
% Parameters.xMax                             = 346;
% Parameters.yMax                             = 260;

eventCountforCircle = [];
eventCountforLine = [];
eventCountforStar = [];
eventCountforTriangle = [];

eventDurationforCircle = [];
eventDurationforLine = [];
eventDurationforStar = [];
eventDurationforTriangle = [];

timeAdvance = 2;

for idx = 1:95
    Circle = load("Data/circle/" + idx + ".mat");
    Line = load("Data/line/" + idx + ".mat");
    Star = load("Data/star/" + idx + ".mat");
    Triangle = load("Data/triangle/" + idx + ".mat");
    
%     % noise fitlering and remove hot pixels for circle
%     tdCircle = struct('x',single(Circle.events(:,2)),'y',single(Circle.events(:,3)),'p',single(Circle.events(:,4)),'ts',Circle.events(:,1));    
%     tdLine = struct('x',single(Line.events(:,2)),'y',single(Line.events(:,3)),'p',single(Line.events(:,4)),'ts',Line.events(:,1));    
%     tdStar = struct('x',single(Star.events(:,2)),'y',single(Star.events(:,3)),'p',single(Star.events(:,4)),'ts',Star.events(:,1));
%     tdTriangle = struct('x',single(Triangle.events(:,2)),'y',single(Triangle.events(:,3)),'p',single(Triangle.events(:,4)),'ts',Triangle.events(:,1));
%     
%     % for circle
%     tdWithHotPixelsRemovedCircle = removeHotPixels(tdCircle,Parameters);
%     FilterEventsCircle = FilterTD(tdWithHotPixelsRemovedCircle, 2e3);
%     
%     % for line
%     tdWithHotPixelsRemovedLine = removeHotPixels(tdLine,Parameters);
%     FilterEventsLine = FilterTD(tdWithHotPixelsRemovedLine, 2e3);
%     
%     % for star
%     tdWithHotPixelsRemovedStar = removeHotPixels(tdStar,Parameters);
%     FilterEventsStar = FilterTD(tdWithHotPixelsRemovedStar, 2e3);
%     
%     % for triangle
%     tdWithHotPixelsRemovedTriangle = removeHotPixels(tdTriangle,Parameters);
%     FilterEventsTriangle = FilterTD(tdWithHotPixelsRemovedTriangle, 2e3);
    
%     Circle = [FilterEventsCircle.ts FilterEventsCircle.x FilterEventsCircle.y FilterEventsCircle.p];
%     Line = [FilterEventsLine.ts FilterEventsLine.x FilterEventsLine.y FilterEventsLine.p];
%     Star = [FilterEventsStar.ts FilterEventsStar.x FilterEventsStar.y FilterEventsStar.p];
%     Triangle = [FilterEventsTriangle.ts FilterEventsTriangle.x FilterEventsTriangle.y FilterEventsTriangle.p];
%     
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
    
    % Triangle
    firstTimeStampT = Triangle.events(1,1)/1e6;
    firstTimeStampPlusTwoSecondsT = firstTimeStampT + timeAdvance;
    findTimeTwoSecondT = find(Triangle.events(:,1)<firstTimeStampPlusTwoSecondsT*1e6);
    
    Circle = Circle.events(findTimeTwoSecondC,:);
    Line = Line.events(findTimeTwoSecondL,:);
    Star = Star.events(findTimeTwoSecondS,:);
    Triangle = Triangle.events(findTimeTwoSecondT,:);
    
    findBoundaryCoordinateC = Circle(:, 2) > 80 & Circle(:, 2) < 280;
    findBoundaryCoordinateL = Line(:, 2) > 80 & Line(:, 2) < 280;
    findBoundaryCoordinateS = Star(:, 2) > 80 & Star(:, 2) < 280;
    findBoundaryCoordinateT = Triangle(:, 2) > 80 & Triangle(:, 2) < 280;
    
    Circle = Circle(findBoundaryCoordinateC,:);
    Line = Line(findBoundaryCoordinateL,:);
    Star = Star(findBoundaryCoordinateS,:);
    Triangle = Triangle(findBoundaryCoordinateT,:);
    
    eventCountforCircle = [eventCountforCircle;numel(Circle(:,1))];
    eventCountforLine = [eventCountforLine;numel(Line(:,1))];
    eventCountforStar = [eventCountforStar;numel(Star(:,1))];
    eventCountforTriangle = [eventCountforTriangle;numel(Triangle(:,1))];
    
    eventDurationforCircle = [eventDurationforCircle;(Circle(end,1)-Circle(1,1))];
    eventDurationforLine = [eventDurationforLine;(Line(end,1)-Line(1,1))];
    eventDurationforStar = [eventDurationforStar;(Star(end,1)-Star(1,1))];
    eventDurationforTriangle = [eventDurationforTriangle;(Triangle(end,1)-Triangle(1,1))];
    
end

% timeDiff = eventDurationforLine - eventDurationforCircle;
figure(1);
subplot(2,2,1)
plot(eventCountforCircle,'b','LineWidth', lineWidth, 'MarkerSize', markerSize);hold on
plot(eventCountforLine,'r','LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(eventCountforStar,'g','LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(eventCountforTriangle,'k','LineWidth', lineWidth, 'MarkerSize', markerSize);
legend("Circle", "Line","Star","Triangle");
xlabel("Number of recorded Data");
ylabel("Number of events");
title("Number of events",'FontSize', fontSize, 'Interpreter', 'None');

subplot(2,2,3)
plot(eventDurationforCircle/1e6,'b','LineWidth', lineWidth, 'MarkerSize', markerSize);hold on
plot(eventDurationforLine/1e6,'r','LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(eventDurationforStar/1e6,'g','LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(eventDurationforTriangle/1e6,'k','LineWidth', lineWidth, 'MarkerSize', markerSize);
legend("Circle", "Line","Star","Triangle");
xlabel("Number of recorded Data");
ylabel("Duration of events (s)");
title("Duration of events",'FontSize', fontSize, 'Interpreter', 'None');

subplot(2,2,[2 4])
y=[eventDurationforCircle/1e6 eventDurationforLine/1e6 eventDurationforStar/1e6 eventDurationforTriangle/1e6];
boxplot(y)
str={'Circle','Line','Star','Triangle'};
ylabel("Duration of events (s)");
set(gca, 'XTickLabel',str, 'XTick',1:numel(str),'fontsize',18, 'YGrid', 'on', 'XGrid', 'off')
title("Box plot",'FontSize', fontSize, 'Interpreter', 'None');
view([90 -90])

%% Generate dataset for each class and for each statistical measure
clc
clear
close all
% the data is structured that way:

% x = events(:,2)
% y = events(:,3)
% p = events(:,4)
% ts = events(:,1)

% For line
ONEventL = [];
OFFEventL = [];
ONOFFRatioL = [];
TotalEventL = [];
DurationL = [];
XmeanL = [];
YmeanL = [];
XstdvL = [];
YstdvL = [];

% For circle
ONEventC = [];
OFFEventC = [];
ONOFFRatioC = [];
TotalEventC = [];
DurationC = [];
XmeanC = [];
YmeanC = [];
XstdvC = [];
YstdvC = [];

% For star
ONEventS = [];
OFFEventS = [];
ONOFFRatioS = [];
TotalEventS = [];
DurationS = [];
XmeanS = [];
YmeanS = [];
XstdvS = [];
YstdvS = [];

% For triangle
ONEventT = [];
OFFEventT = [];
ONOFFRatioT = [];
TotalEventT = [];
DurationT = [];
XmeanT = [];
YmeanT = [];
XstdvT = [];
YstdvT = [];

timeAdvance = 2;

for idx = 1:95
    % Load files for both pattern
    Circle = load("Data/circle/" + idx + ".mat");
    Line = load("Data/line/" + idx + ".mat");
    Star = load("Data/star/" + idx + ".mat");
    Triangle = load("Data/triangle/" + idx + ".mat");
    
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
    
    % Triangle
    firstTimeStampT = Triangle.events(1,1)/1e6;
    firstTimeStampPlusTwoSecondsT = firstTimeStampT + timeAdvance;
    findTimeTwoSecondT = find(Triangle.events(:,1)<firstTimeStampPlusTwoSecondsT*1e6);
    
    Circle = Circle.events(findTimeTwoSecondC,:);
    Line = Line.events(findTimeTwoSecondL,:);
    Star = Star.events(findTimeTwoSecondS,:);
    Triangle = Triangle.events(findTimeTwoSecondS,:);
    
    findBoundaryCoordinateC = Circle(:, 2) > 80 & Circle(:, 2) < 280;
    findBoundaryCoordinateL = Line(:, 2) > 80 & Line(:, 2) < 280;
    findBoundaryCoordinateS = Star(:, 2) > 80 & Star(:, 2) < 280;
    findBoundaryCoordinateT = Triangle(:, 2) > 80 & Triangle(:, 2) < 280;
    
    Circle = Circle(findBoundaryCoordinateC,:);
    Line = Line(findBoundaryCoordinateL,:);
    Star = Star(findBoundaryCoordinateS,:);
    Triangle = Triangle(findBoundaryCoordinateT,:);
    
    % Get stats for circle
    ONEventC = [ONEventC;length(find(Circle(:,4) == 1))];
    OFFEventC = [OFFEventC;length(find(Circle(:,4) == 0))];
    ONOFFRatioC = [ONOFFRatioC;size(find(Circle(:,4) == 1))/size(find(Circle(:,4) == 0))];
    TotalEventC = [TotalEventC;numel(Circle(:,2))];
    DurationC = [DurationC;Circle(end,1) - Circle(1,1)];
    XmeanC = [XmeanC;mean(Circle(:,2))];
    YmeanC = [YmeanC;mean(Circle(:,3))];
    XstdvC = [XstdvC;std(single(Circle(:,2)))];
    YstdvC = [YstdvC;std(single(Circle(:,3)))];
    
    % Get stats for line
    ONEventL = [ONEventL;length(find(Line(:,4) == 1))];
    OFFEventL = [OFFEventL;length(find(Line(:,4) == 0))];
    ONOFFRatioL = [ONOFFRatioL;size(find(Line(:,4) == 1))/size(find(Line(:,4) == 0))];
    TotalEventL = [TotalEventL;numel(Line(:,2))];
    DurationL = [DurationL;Line(end,1) - Line(1,1)];
    XmeanL = [XmeanL;mean(Line(:,2))];
    YmeanL = [YmeanL;mean(Line(:,3))];
    XstdvL = [XstdvL;std(single(Line(:,2)))];
    YstdvL = [YstdvL;std(single(Line(:,3)))];
    
    % Get stats for star
    ONEventS = [ONEventS;length(find(Star(:,4) == 1))];
    OFFEventS = [OFFEventS;length(find(Star(:,4) == 0))];
    ONOFFRatioS = [ONOFFRatioS;size(find(Star(:,4) == 1))/size(find(Star(:,4) == 0))];
    TotalEventS = [TotalEventS;numel(Star(:,2))];
    DurationS = [DurationS;Star(end,1) - Star(1,1)];
    XmeanS = [XmeanS;mean(Star(:,2))];
    YmeanS = [YmeanS;mean(Star(:,3))];
    XstdvS = [XstdvS;std(single(Star(:,2)))];
    YstdvS = [YstdvS;std(single(Star(:,3)))];
    
    % Get stats for triangle
    ONEventT = [ONEventT;length(find(Triangle(:,4) == 1))];
    OFFEventT = [OFFEventT;length(find(Triangle(:,4) == 0))];
    ONOFFRatioT = [ONOFFRatioT;size(find(Triangle(:,4) == 1))/size(find(Triangle(:,4) == 0))];
    TotalEventT = [TotalEventT;numel(Triangle(:,2))];
    DurationT = [DurationT;Triangle(end,1) - Triangle(1,1)];
    XmeanT = [XmeanT;mean(Triangle(:,2))];
    YmeanT = [YmeanT;mean(Triangle(:,3))];
    XstdvT = [XstdvT;std(single(Triangle(:,2)))];
    YstdvT = [YstdvT;std(single(Triangle(:,3)))];
end

%% Plot mean and stdv for all statistics

% ONEventC
% OFFEventC
% ONOFFRatioC
% TotalEventC
% DurationC 
% XmeanC
% YmeanC 
% XstdvC 
% YstdvC

figure(567657);

subplot(3,3,1)
x1 = [mean(ONEventC);mean(ONEventL); mean(ONEventS); mean(ONEventT)];
Stdv1 = [std(ONEventC);std(ONEventL); std(ONEventS); std(ONEventT)];
bar(x1,'facecolor',[.8 .8 .8]);hold on;
% hb(1).FaceColor = 'r';
str={'Circle','Line', 'Star', 'Triangle'};
set(gca, 'XTickLabel',str, 'XTick',1:numel(str),'fontsize',18, 'YGrid', 'on', 'XGrid', 'off')
ylabel('Mean');
errorb(x1,Stdv1);
title("On Events")

subplot(3,3,2)
x2 = [mean(OFFEventC);mean(OFFEventL); mean(OFFEventS); mean(OFFEventT)];
Stdv2 = [std(OFFEventC);std(OFFEventL); std(OFFEventS); std(OFFEventT)];
bar(x2,'facecolor',[.8 .8 .8]);hold on;
% hb(1).FaceColor = 'r';
str={'Circle','Line', 'Star', 'Triangle'};
set(gca, 'XTickLabel',str, 'XTick',1:numel(str),'fontsize',18, 'YGrid', 'on', 'XGrid', 'off')
ylabel('Mean');
errorb(x2,Stdv2);
title("OFF Events")

subplot(3,3,3)
x3 = [mean(ONOFFRatioC);mean(ONOFFRatioL); mean(ONOFFRatioS); mean(ONOFFRatioT)];
Stdv3 = [std(ONOFFRatioC);std(ONOFFRatioL); std(ONOFFRatioS); std(ONOFFRatioT)];
bar(x3,'facecolor',[.8 .8 .8]);hold on;
% hb(1).FaceColor = 'r';
str={'Circle','Line', 'Star', 'Triangle'};
set(gca, 'XTickLabel',str, 'XTick',1:numel(str),'fontsize',18, 'YGrid', 'on', 'XGrid', 'off')
ylabel('Mean');
errorb(x3,Stdv3);
title("ON/OFF Events")

subplot(3,3,4)
x4 = [mean(TotalEventC);mean(TotalEventL); mean(TotalEventS); mean(TotalEventT)];
Stdv4 = [std(TotalEventC);std(TotalEventL); std(TotalEventS); std(TotalEventT)];
bar(x4,'facecolor',[.8 .8 .8]);hold on;
% hb(1).FaceColor = 'r';
str={'Circle','Line', 'Star', 'Triangle'};
set(gca, 'XTickLabel',str, 'XTick',1:numel(str),'fontsize',18, 'YGrid', 'on', 'XGrid', 'off')
ylabel('Mean');
errorb(x4,Stdv4);
title("Number of Events")

subplot(3,3,5)
x5 = [mean(DurationC);mean(DurationL); mean(DurationS); mean(DurationT)];
Stdv5 = [std(DurationC);std(DurationL); std(DurationS); std(DurationT)];
bar(x5,'facecolor',[.8 .8 .8]);hold on;
% hb(1).FaceColor = 'r';
str={'Circle','Line', 'Star', 'Triangle'};
set(gca, 'XTickLabel',str, 'XTick',1:numel(str),'fontsize',18, 'YGrid', 'on', 'XGrid', 'off')
ylabel('Mean');
errorb(x5,Stdv5);
title("Duration of Events")

subplot(3,3,6)
x6 = [mean(XmeanC);mean(XmeanL); mean(XmeanS); mean(XmeanT)];
Stdv6 = [std(XmeanC);std(XmeanL); std(XmeanS); std(XmeanT)];
bar(x6,'facecolor',[.8 .8 .8]);hold on;
% hb(1).FaceColor = 'r';
str={'Circle','Line', 'Star', 'Triangle'};
set(gca, 'XTickLabel',str, 'XTick',1:numel(str),'fontsize',18, 'YGrid', 'on', 'XGrid', 'off')
ylabel('Mean');
errorb(x6,Stdv6);
title("X Mean")

subplot(3,3,7)
x7 = [mean(YmeanC);mean(YmeanL); mean(YmeanS); mean(YmeanT)];
Stdv7 = [std(YmeanC);std(YmeanL); std(YmeanS); std(YmeanT)];
bar(x7,'facecolor',[.8 .8 .8]);hold on;
% hb(1).FaceColor = 'r';
str={'Circle','Line', 'Star', 'Triangle'};
set(gca, 'XTickLabel',str, 'XTick',1:numel(str),'fontsize',18, 'YGrid', 'on', 'XGrid', 'off')
ylabel('Mean');
errorb(x7,Stdv7);
title("Y Mean")

subplot(3,3,8)
x8 = [mean(XstdvC);mean(XstdvL); mean(XstdvS); mean(XstdvT)];
Stdv8 = [std(XstdvC);std(XstdvL); std(XstdvS); std(XstdvT)];
bar(x8,'facecolor',[.8 .8 .8]);hold on;
% hb(1).FaceColor = 'r';
str={'Circle','Line', 'Star', 'Triangle'};
set(gca, 'XTickLabel',str, 'XTick',1:numel(str),'fontsize',18, 'YGrid', 'on', 'XGrid', 'off')
ylabel('Mean');
errorb(x8,Stdv8);
title("X Stdv")

subplot(3,3,9)
x9 = [mean(YstdvC);mean(YstdvL); mean(YstdvS); mean(YstdvT)];
Stdv9 = [std(YstdvC);std(YstdvL); std(YstdvS); std(YstdvT)];
bar(x9,'facecolor',[.8 .8 .8]);hold on;
% hb(1).FaceColor = 'r';
str={'Circle','Line', 'Star', 'Triangle'};
set(gca, 'XTickLabel',str, 'XTick',1:numel(str),'fontsize',18, 'YGrid', 'on', 'XGrid', 'off')
ylabel('Mean');
errorb(x9,Stdv9);
title("Y Stdv")
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
numberOfClasses = 4;

% for k = 1:2:50
statisticalMeasure = "Y-Address Stdv";
circle   =     DurationC;
line     =     DurationL;
star     =     DurationS;
triangle =     DurationT;

% remove the last rows to make the data size even
% circle(end,:)= [];
% line(end,:)= [];
% star(end,:)= [];
triangle(end,:)= [];

lineWidth = 2;
fontSize = 20;
markerSize = 10;

% Number of K
k = round(sqrt(length(circle)*numberOfClasses)); % square root of the number of sample
% k = 3;

% shuffle data
% ONEventC_shuffle = ONEventC(shuffledIndex,:);
% ONEventL_shuffle = ONEventL(shuffledIndex,:);
nEventAfterSkip = round(size(circle,1)*numberOfClasses/2);
trainTestSplitRatio = 1/2;
shuffledIndex = randperm(nEventAfterSkip);

% Make training set
trainingCoords1 = circle(1:length(circle)/2,:);
trainingCoords2 = line(1:length(line)/2,:);
trainingCoords3 = star(1:length(star)/2,:);
trainingCoords4 = triangle(1:length(triangle)/2,:);

data = [trainingCoords1; trainingCoords2; trainingCoords3; trainingCoords4];
data(:,2) = 1:numel(data);
% data = data(shuffledIndex,:);


% Label for the train set
labels = nan(length(data),1);
labels(1:length(trainingCoords1)+1,1) = 1;
labels(length(trainingCoords1):length(trainingCoords1)*2+1,1) = 2;
labels(length(trainingCoords1)*2:length(trainingCoords1)*3,1) = 3;
labels(length(trainingCoords1)*3+1:length(trainingCoords1)*4,1) = 4;
% labels = labels(shuffledIndex,:);

% Test data
testCoords1 = circle(length(circle)/2+1:end,:);
testCoords2 = line(length(line)/2+1:end,:);
testCoords3 = star(length(star)/2+1:end,:);
testCoords4 = triangle(length(triangle)/2+1:end,:);

t_data = [testCoords1; testCoords2; testCoords3; testCoords4];
t_data(:,2) = 1:numel(t_data);
t_label_test = 48:94;
% t_data = t_data(shuffledIndex,:);

% Get stats for the table
trainMean = mean(data(:,1))
trainSigma = std(t_data(:,1))

testMean = mean(data(:,1))
testSigma = std(t_data(:,1))

% make test label
t_labels = nan(length(t_data),1);
% t_labels(1:length(t_data)/2+1,1) = 1;t_labels(length(t_data)/2+1:end,1) = 0;
t_labels(1:length(testCoords1)+1,1) = 1;
t_labels(length(testCoords1):length(testCoords1)*2+1,1) = 2;
t_labels(length(testCoords1)*2+1:length(testCoords1)*3,1) = 3;
t_labels(length(testCoords1)*3+1:length(testCoords1)*4,1) = 4;
% t_labels = t_labels(shuffledIndex,:);

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

% Get index for class with label 4 and group into one matrix
class4 = find(All_data(:,3) > 3 );
classFour = All_data(class4,:);

allDataTestPredicted = [t_data t_labels predicted_labels];

findOne = find(allDataTestPredicted(:,3) ==1);
findTwo = find(allDataTestPredicted(:,3) ==2);
findThree = find(allDataTestPredicted(:,3) ==3);
findFour = find(allDataTestPredicted(:,3) ==4);

t_label1_predicted = allDataTestPredicted(findOne,:);t_label1_predicted(:,5) = length(t_label1_predicted):length(t_label1_predicted)*2-1;
t_label2_predicted = allDataTestPredicted(findTwo,:);t_label2_predicted(:,5) = length(t_label2_predicted):length(t_label2_predicted)*2-1;
t_label3_predicted = allDataTestPredicted(findThree,:);t_label3_predicted(:,5) = length(t_label3_predicted):length(t_label3_predicted)*2-1;
t_label4_predicted = allDataTestPredicted(findFour,:);t_label4_predicted(:,5) = length(t_label4_predicted):length(t_label4_predicted)*2-1;

lineWidth = 2;
fontSize = 20;
markerSize = 10;
% Visualization

findLabelsOne = find(labels==1);
findLabelsTwo = find(labels==2);
findLabelsThree = find(labels==3);
findLabelsFour = find(labels==4);

dataOne = data(findLabelsOne,:);
dataTwo = data(findLabelsTwo,:);
dataThree = data(findLabelsThree,:);
dataFour = data(findLabelsFour,:);

% end
%%
figure(1);
subplot(2,2,1)
plot(data(1:length(data)/4,2), trainingCoords1(:, 1),'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(data(1:length(data)/4,2),trainingCoords2(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(data(1:length(data)/4,2),trainingCoords3(:, 1), 'g*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(data(1:length(data)/4,2),trainingCoords4(:, 1), 'y^', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
xlabel("Number of samples");
ylabel("Statistical Measure: " + "" +  statisticalMeasure);
axis square;
title('Training data only', 'FontSize', fontSize, 'Interpreter', 'None');
legend('Circle', 'Line', 'Star', 'Triangle',  'Location', 'northwest');
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
xlabel("Number of samples");
ylabel("Statistical Measure: " + "" +  statisticalMeasure);
legend('As-of-yet Unknown Class', 'Location', 'northwest');
pos = get(gca, 'Position');
pos(1) = pos(1) - spacing;
pos(2) = pos(2) + spacing2;
set(gca, 'Position', pos);
title('Test Data Before Classification', 'FontSize', fontSize, 'Interpreter', 'None');

subplot(2, 2, 3);
plot(data(1:length(data)/4,2),trainingCoords1(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(data(1:length(data)/4,2),trainingCoords2(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(data(1:length(data)/4,2),trainingCoords3(:, 1), 'g*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(data(1:length(data)/4,2),trainingCoords4(:, 1), 'y^', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(t_label_test(1,:), testCoords1(:, 1),'k*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(t_label_test(1,:),testCoords2(:, 1), 'k*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(t_label_test(1,:),testCoords3(:, 1), 'k*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(t_label_test(1,:),testCoords4(:, 1), 'k*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
xlabel("Number of samples");
ylabel("Statistical Measure: " + "" +  statisticalMeasure);
pos = get(gca, 'Position');
pos(1) = pos(1) + spacing;
% pos(2) = pos(2) + spacing2;
% pos(3) = 0.2157;
set(gca, 'Position', pos);
legend('Circle', 'Line', 'Star', 'Triangle', 'As-of-yet Unknown Class', 'Location', 'northwest');
title('Training and Test Data', 'FontSize', fontSize, 'Interpreter', 'None');

% Now plot what we found.  Each class gets the same marker as the training class.
subplot(2, 2, 4);
plot(t_label1_predicted(:, 5), t_label1_predicted(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(t_label2_predicted(:, 5), t_label2_predicted(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(t_label3_predicted(:, 5), t_label3_predicted(:, 1), 'g*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(t_label4_predicted(:, 5), t_label4_predicted(:, 1), 'y^', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
pos = get(gca, 'Position');
pos(1) = pos(1) - spacing;
% pos(2) = pos(2) + spacing2;
% pos(3) = 0.2157;
set(gca, 'Position', pos);
grid on;
axis square;
xlabel("Number of samples");
ylabel("Statistical Measure: " + "" +  statisticalMeasure);
% xlim([0, 6]);
% ylim([0, 6]);
title('Test Data After Classification', 'FontSize', fontSize, 'Interpreter', 'None');
legend('Estimated to be in Circle', 'Estimated to be in Line', 'Estimated to be in Star', 'Estimated to be in Triangle', 'Location', 'northwest');



%mean training for circle
durationOfRecordingsTrainM = mean(DurationC(1:floor(nEventAfterSkip*trainTestSplitRatio),:));
numberofEventsTrainM = mean(TotalEventC(1:floor(nEventAfterSkip*trainTestSplitRatio),:));
numberOfONEventsTrainM = mean(ONEventC(1:floor(nEventAfterSkip*trainTestSplitRatio),:));
numberOfOFFEventsTrainM = mean(OFFEventC(1:floor(nEventAfterSkip*trainTestSplitRatio),:));
xAddressTrainM = mean(XmeanC(1:floor(nEventAfterSkip*trainTestSplitRatio),:));
yAddressTrainM = mean(YmeanC(1:floor(nEventAfterSkip*trainTestSplitRatio),:));

%mean test for circle
durationOfRecordingsTestM = mean(DurationC((floor(nEventAfterSkip*trainTestSplitRatio)+2):end,:));
numberofEventsTestM = mean(TotalEventC((floor(nEventAfterSkip*trainTestSplitRatio)+2):end,:));
numberOfONEventsTestM = mean(ONEventC((floor(nEventAfterSkip*trainTestSplitRatio)+2):end,:));
numberOfOFFEventsTestM = mean(OFFEventC((floor(nEventAfterSkip*trainTestSplitRatio)+2):end,:));
xAddressTestM = mean(XmeanC((floor(nEventAfterSkip*trainTestSplitRatio)+2):end,:));
yAddressTestM = mean(YmeanC((floor(nEventAfterSkip*trainTestSplitRatio)+2):end,:));


%sigma
durationOfRecordingsTrainS = std(DurationC((floor(nEventAfterSkip*trainTestSplitRatio)+2):end,:));
numberofEventsTrainS = std(TotalEventC((floor(nEventAfterSkip*trainTestSplitRatio)+2):end,:));
numberOfONEventsTrainS = std(ONEventC((floor(nEventAfterSkip*trainTestSplitRatio)+2):end,:));
numberOfOFFEventsTrainS = std(OFFEventC((floor(nEventAfterSkip*trainTestSplitRatio)+2):end,:));
xAddressTrainS = std(XstdvC((floor(nEventAfterSkip*trainTestSplitRatio)+2):end,:));
yAddressTrainS = std(YstdvC((floor(nEventAfterSkip*trainTestSplitRatio)+2):end,:));

% Get overall stats for test
%mean
durationOfRecordingsTestM = mean(DurationL(1:floor(nEventAfterSkip*trainTestSplitRatio),:));
numberofEventsTestM = mean(TotalEventL(1:floor(nEventAfterSkip*trainTestSplitRatio),:));
numberOfONEventsTestM = mean(ONEventL(1:floor(nEventAfterSkip*trainTestSplitRatio),:));
numberOfOFFEventsTestM = mean(OFFEventL(1:floor(nEventAfterSkip*trainTestSplitRatio),:));
xAddressTestM = mean(XstdvL(1:floor(nEventAfterSkip*trainTestSplitRatio),:));
yAddressTestM = mean(YstdvL(1:floor(nEventAfterSkip*trainTestSplitRatio),:));
%sigma
durationOfRecordingsTestS = std(DurationL((floor(nEventAfterSkip*trainTestSplitRatio)+2):end,:));
numberofEventsTestS = std(TotalEventL((floor(nEventAfterSkip*trainTestSplitRatio)+2):end,:));
numberOfONEventsTestS = std(ONEventL((floor(nEventAfterSkip*trainTestSplitRatio)+2):end,:));
numberOfOFFEventsTestS = std(OFFEventL((floor(nEventAfterSkip*trainTestSplitRatio)+2):end,:));
xAddressTestS = std(XstdvL((floor(nEventAfterSkip*trainTestSplitRatio)+2):end,:));
yAddressTestS = std(YstdvL((floor(nEventAfterSkip*trainTestSplitRatio)+2):end,:));


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

figure(2);
subplot(3,3,1)
plot(ONEventC(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(ONEventL(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(ONEventS(:, 1), 'g*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(ONEventT(:, 1), 'y^', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('ON Events', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Total number of ON Events");
% xlabel("Number of samples");
% ylabel("Value");
legend('Circle', 'Line', 'Star', 'Triangle', 'Location', 'northwest');
% Enlarge figure to full screen.
pos = get(gca, 'Position');
pos(1) = pos(1) + spacing;
% pos(3) = 0.2157;
set(gca, 'Position', pos);
% set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,3,2)
plot(OFFEventC(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(OFFEventL(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(OFFEventS(:, 1), 'g*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(OFFEventT(:, 1), 'y^', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('OFF Events', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Total number of OFF Events");
% xlabel("Number of samples");
% ylabel("Value");
legend('Circle', 'Line', 'Star', 'Triangle', 'Location', 'northwest');
% Enlarge figure to full screen.
pos = get(gca, 'Position');
% pos(2) = 0.6703;
set(gca, 'Position', pos);
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,3,3)
plot(ONOFFRatioC(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(ONOFFRatioL(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(ONOFFRatioS(:, 1), 'g*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(ONOFFRatioT(:, 1), 'y^', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('ON/OFF Ratio', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("The ratio of ON/OFF Events Polarities");
% xlabel("Number of samples");
% ylabel("Value");
legend('Circle', 'Line', 'Star', 'Triangle', 'Location', 'northwest');
% Enlarge figure to full screen.
pos = get(gca, 'Position');
pos(1) = pos(1) - spacing;
% pos(2) = 0.6703;
set(gca, 'Position', pos);
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,3,4)
plot(TotalEventC(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(TotalEventL(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(TotalEventS(:, 1), 'g*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(TotalEventT(:, 1), 'y^', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('Number of Events', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
ylabel("Total number of Events");
% xlabel("Number of samples");
% ylabel("Value");
legend('Circle', 'Line', 'Star', 'Triangle', 'Location', 'northwest');
% Enlarge figure to full screen.
pos = get(gca, 'Position');
pos(1) = pos(1) + spacing;
set(gca, 'Position', pos);
% set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,3,5)
plot(DurationC(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(DurationL(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(DurationS(:, 1), 'g*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(DurationT(:, 1), 'y^', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('Duration', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Total Events Duration");
% xlabel("Number of samples");
% ylabel("Value");
legend('Circle', 'Line', 'Star', 'Triangle', 'Location', 'northwest');
% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,3,6)
plot(XmeanC(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(XmeanL(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(XmeanS(:, 1), 'g*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(XmeanT(:, 1), 'y^', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('X mean', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("X-address mean");
% xlabel("Number of samples");
% ylabel("Value");
legend('Circle', 'Line', 'Star', 'Triangle', 'Location', 'northwest');
% Enlarge figure to full screen.
pos = get(gca, 'Position');
pos(1) = pos(1) - spacing;
set(gca, 'Position', pos);
% set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,3,7)
plot(YmeanC(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(YmeanL(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(YmeanS(:, 1), 'g*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(YmeanT(:, 1), 'y^', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('Y mean', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Y-address mean");
% xlabel("Number of samples");
% ylabel("Value");
legend('Circle', 'Line', 'Star', 'Triangle', 'Location', 'northwest');
% Enlarge figure to full screen.
pos = get(gca, 'Position');
pos(1) = pos(1) + spacing;
% pos(2) = spacingTwo;
set(gca, 'Position', pos);
% set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,3,8)
plot(XstdvC(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(XstdvL(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(XstdvS(:, 1), 'g*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(XstdvT(:, 1), 'y^', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('X Stdv', 'FontSize', fontSize, 'Interpreter', 'None');
xlabel("Number of samples");
% ylabel("X-address Standard Deviation");
% xlabel("Number of samples");
% ylabel("Value");
legend('Circle', 'Line', 'Star', 'Triangle', 'Location', 'northwest');
% Enlarge figure to full screen.
pos = get(gca, 'Position');
% pos(1) = pos(1) - spacing;
% pos(2) = spacingTwo;
set(gca, 'Position', pos);
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(3,3,9)
plot(YstdvC(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(YstdvL(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(YstdvS(:, 1), 'g*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(YstdvT(:, 1), 'y^', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('Y Stdv', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Y-address Standard Deviation");
% xlabel("Number of samples");
% ylabel("Value");
legend('Circle', 'Line', 'Star', 'Triangle', 'Location', 'northwest');
% Enlarge figure to full screen.
pos = get(gca, 'Position');
pos(1) = pos(1) - spacing;
% pos(2) = spacingTwo;
set(gca, 'Position', pos);
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);

%% plot bar plot for final accuracy

figure(3);
results = [87.7660 63.8298 99.4681 68.0851 92.5532 97.8723 98.4043 99.4681 98.4043];
bar(results); hold on
text(1:length(results),results,num2str(results'),'vert','bottom','horiz','center','FontSize',20);
yl = yline(100/4,'--','Chance 25 %','fontsize',22,'LineWidth',3);
yl.LabelHorizontalAlignment = 'right';
yl.LabelVerticalAlignment = 'middle';
yl.Color = [.1 0 .40];
str={'ON Events','OFF Events','ON/OFF Ratio','Number of Events','Duration','X mean','Y mean', 'X stdv', 'Y stdv'};
set(gca, 'XTickLabel',str, 'XTick',1:numel(str),'fontsize',18, 'YGrid', 'on', 'XGrid', 'off')
xlabel("Classification Method");
ylabel("Accuracy (% Correct)");
title("kNN Classification Accuracy Using Statistical Properties of Four classes")
xtickangle(45)
xlim([0 12])
ylim([0 105]);