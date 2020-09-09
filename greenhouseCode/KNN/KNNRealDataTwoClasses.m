%% Get event duration and event count and find differences
clc
clear
close all
lineWidth = 2;
fontSize = 20;
markerSize = 10;
addpath("../");

eventCountforGreenCircle = [];
eventCountforLine = [];

eventDurationforGreenCircle = [];
eventDurationforLine = [];

timeAdvance = 2;

for idx = 1:95
    tic;
    circle = load("Data/circle/" + idx + ".mat");
    line = load("Data/line/" + idx + ".mat");
    
    firstTimeStampC = circle.events(1,1)/1e6;
    firstTimeStampPlusTwoSecondsC = firstTimeStampC + timeAdvance;
    findTimeTwoSecondC = find(circle.events(:,1)<firstTimeStampPlusTwoSecondsC*1e6);
    
    firstTimeStampL = line.events(1,1)/1e6;
    firstTimeStampPlusTwoSecondsL = firstTimeStampL + timeAdvance;
    findTimeTwoSecondL = find(line.events(:,1)<firstTimeStampPlusTwoSecondsL*1e6);
    
    circle = circle.events(findTimeTwoSecondC,:);
    line = line.events(findTimeTwoSecondL,:);
%     findxyAddress = GreenCircle.events(:,2) < 150 & GreenCircle.events(:,3) > 150;
    
%     GreenCircleIndex = GreenCircle.events(findxyAddress,:);
    
    eventCountforGreenCircle = [eventCountforGreenCircle;numel(circle(:,1))];
    eventCountforLine = [eventCountforLine;numel(line(:,1))];
    
    eventDurationforGreenCircle = [eventDurationforGreenCircle;(circle(end,1)-circle(1,1))];
    eventDurationforLine = [eventDurationforLine;(line(end,1)-line(1,1))];
    toc;
end

% timeDiff = eventDurationforLine - eventDurationforCircle;

figure(1);
subplot(2,2,1)
plot(eventCountforGreenCircle,'b','LineWidth', lineWidth, 'MarkerSize', markerSize);hold on
plot(eventCountforLine,'r','LineWidth', lineWidth, 'MarkerSize', markerSize);
legend("Circle", "Line");
xlabel("Number of recorded Data");
ylabel("Number of events");
title("Number of events",'FontSize', fontSize, 'Interpreter', 'None');

subplot(2,2,3)
plot(eventDurationforGreenCircle/1e6,'b','LineWidth', lineWidth, 'MarkerSize', markerSize);hold on
plot(eventDurationforLine/1e6,'r','LineWidth', lineWidth, 'MarkerSize', markerSize);
legend("Circle", "Line");
xlabel("Number of recorded Data");
ylabel("Duration of events (s)");
title("Duration of events",'FontSize', fontSize, 'Interpreter', 'None');

subplot(2,2,[2 4])
y=[eventDurationforGreenCircle/1e6 eventDurationforLine/1e6];
boxplot(y)
str={'Circle','Line'};
ylabel("Duration of events (s)");
set(gca, 'XTickLabel',str, 'XTick',1:numel(str),'fontsize',18, 'YGrid', 'on', 'XGrid', 'off')
view([90 -90])
title("Box plot",'FontSize', fontSize, 'Interpreter', 'None');
%% 
clc
clear
close all
% the data is structured that way:

% x = events(:,2)
% y = events(:,3)
% p = events(:,4)
% ts = events(:,1)
timeAdvance = 2;
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

for idx = 1:95
    % Load files for both pattern
    Circle = load("Data/circle/" + idx + ".mat");
    Line = load("Data/line/" + idx + ".mat");
    Star = load("Data/star/" + idx + ".mat");
    
    firstTimeStampC = Circle.events(1,1)/1e6;
    firstTimeStampPlusTwoSecondsC = firstTimeStampC + timeAdvance;
    findTimeTwoSecondC = find(Circle.events(:,1)<firstTimeStampPlusTwoSecondsC*1e6);
    
    firstTimeStampL = Line.events(1,1)/1e6;
    firstTimeStampPlusTwoSecondsL = firstTimeStampL + timeAdvance;
    findTimeTwoSecondL = find(Line.events(:,1)<firstTimeStampPlusTwoSecondsL*1e6);
    
    Circle = Circle.events(findTimeTwoSecondC,:);
    Line = Line.events(findTimeTwoSecondL,:);
    
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
    ONEventS = [ONEventS;length(find(Line(:,4) == 1))];
    OFFEventS = [OFFEventS;length(find(Line(:,4) == 0))];
    ONOFFRatioS = [ONOFFRatioS;size(find(Line(:,4) == 1))/size(find(Line(:,4) == 0))];
    TotalEventS = [TotalEventS;numel(Line(:,2))];
    DurationS = [DurationS;Line(end,1) - Line(1,1)];
    XmeanS = [XmeanS;mean(Line(:,2))];
    YmeanS = [YmeanS;mean(Line(:,3))];
    XstdvS = [XstdvS;std(single(Line(:,2)))];
    YstdvS = [YstdvS;std(single(Line(:,3)))];
end

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
statisticalMeasure = "ON Event";

accuracyArray = [];
% for k = 1:2:50
spacing = 0.09905;
spacing2 = -0.05;

circle = TotalEventC;
line = TotalEventL;
% star = YmeanS;

lineWidth = 2;
fontSize = 20;
markerSize = 10;

% Number of K
k = round(sqrt(length(circle)*3)); % square root of the number of sample
% k = 3;
circle(end,:) = [];
line(end,:)   = [];
% star(end,:)   = [];

nEventAfterSkip = round(size(circle,1)/2);
trainTestSplitRatio = 0.5;
shuffledIndex = randperm(nEventAfterSkip);

% shuffle data
% ONEventC_shuffle = ONEventC(shuffledIndex,:);
% ONEventL_shuffle = ONEventL(shuffledIndex,:);

trainingCoords1 = circle(1:length(circle)/2,:);
trainingCoords2 = line(1:length(line)/2,:);
% trainingCoords3 = star(1:length(star)/2,:);
data = [trainingCoords1; trainingCoords2];
data(:,2) = 1:length(data);
% data = data(shuffledIndex,:);

% Get stats for the table
% trainMean = mean(data(1:length(circle)/2,1))
% trainSigma = std(data(1:length(circle)/2,1))
% 
% testMean = mean(data(length(circle)/2)+1:end,1);
% testSigma = std(data(length(circle)/2)+1:end,1);

% Label for the train set
labels = nan(length(data),1);
labels(1:length(trainingCoords1),1) = 1;
labels(length(trainingCoords1)+1:length(trainingCoords1)*2,1) = 2;
% labels(length(trainingCoords1)*2:length(trainingCoords1)*3,1) = 3;
% labels(length(trainingCoords1)*3+1:length(trainingCoords1)*4,1) = 4;

% Test data
testCoords1 = circle((length(circle)/2)+1:end,:);
testCoords2 = line((length(line)/2)+1:end,:);
% testCoords3 = star((length(star)/2)+1:end,:);

t_data = [testCoords1; testCoords2];
t_data(:,2) = 1:numel(t_data);
t_label_test = 48:94;


t_labels = nan(length(t_data),1);
% t_labels(1:length(t_data)/2+1,1) = 1;t_labels(length(t_data)/2+1:end,1) = 0;
t_labels(1:length(testCoords1),1) = 1;
t_labels(length(testCoords1)+1:length(testCoords1)*2,1) = 2;
% t_labels(length(testCoords1)*2+1:length(testCoords1)*3,1) = 3;
% t_labels(length(testCoords1)*3+1:length(testCoords1)*4,1) = 4;
% make test label
% t_labels = nan(length(t_data),1);
% t_labels(1:length(t_data)/2+1,1) = 1;t_labels(length(t_data)/2+1:end,1) = 0;


% t_labels = t_labels(shuffledIndex,:);

trainMean = mean(data(:,1));
trainSigma = std(t_data(:,1));

testMean = mean(data(:,1));
testSigma = std(t_data(:,1));

% mean and stdv for training and testing
% trainMean = mean(data(:,1))
% trainStd = std(t_data(:,1))
% 
% testMean = std(data(:,1))
% testStd = std(t_data(:,1))

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
% predicted_labels
% Compute accuracy
accuracy=length(find(predicted_labels==t_labels))/size(t_data,1);
accuracyArray = [accuracyArray;accuracy*100]
final_data = [data;t_data];
final_label = [labels;predicted_labels];
All_data = [final_data final_label];

allDataTestPredicted = [t_data t_labels predicted_labels];

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
% class4 = find(All_data(:,3) > 3 );
% classFour = All_data(class4,:);

allDataTestPredicted = [t_data t_labels predicted_labels];

findOne = find(allDataTestPredicted(:,3) ==1);
findTwo = find(allDataTestPredicted(:,3) ==2);
findThree = find(allDataTestPredicted(:,3) ==3);
% findFour = find(allDataTestPredicted(:,3) ==4);

t_label1_predicted = allDataTestPredicted(findOne,:);t_label1_predicted(:,5) = length(t_label1_predicted):length(t_label1_predicted)*2-1;
t_label2_predicted = allDataTestPredicted(findTwo,:);t_label2_predicted(:,5) = length(t_label2_predicted):length(t_label2_predicted)*2-1;
t_label3_predicted = allDataTestPredicted(findThree,:);t_label3_predicted(:,5) = length(t_label3_predicted):length(t_label3_predicted)*2-1;
% t_label4_predicted = allDataTestPredicted(findFour,:);t_label4_predicted(:,5) = length(t_label4_predicted):length(t_label4_predicted)*2-1;

lineWidth = 2;
fontSize = 20;
markerSize = 10;
% Visualization

findLabelsOne = find(labels==1);
findLabelsTwo = find(labels==2);
findLabelsThree = find(labels==3);
% findLabelsFour = find(labels==4);

dataOne = data(findLabelsOne,:);
dataTwo = data(findLabelsTwo,:);
dataThree = data(findLabelsThree,:);
% dataFour = data(findLabelsFour,:);

% end
%%
figure(1);
subplot(2,2,1)
plot(data(1:length(data)/3,2), trainingCoords1(:, 1),'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(data(1:length(data)/3,2),trainingCoords2(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(data(1:length(data)/3,2),trainingCoords3(:, 1), 'g*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
% plot(data(1:length(data)/4,2),trainingCoords4(:, 1), 'y^', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
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
% plot(t_label_test(1,:),testCoords4(:, 1), 'k*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
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
plot(data(1:length(data)/3,2),trainingCoords1(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(data(1:length(data)/3,2),trainingCoords2(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(data(1:length(data)/3,2),trainingCoords3(:, 1), 'g*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
% plot(data(1:length(data)/4,2),trainingCoords4(:, 1), 'y^', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(t_label_test(1,:), testCoords1(:, 1),'k*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(t_label_test(1,:),testCoords2(:, 1), 'k*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
plot(t_label_test(1,:),testCoords3(:, 1), 'k*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
% plot(t_label_test(1,:),testCoords4(:, 1), 'k*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
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
% plot(t_label4_predicted(:, 5), t_label4_predicted(:, 1), 'y^', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
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

% Get overall stats for training
%mean
% durationOfRecordingsTrainM = mean(DurationC(1:floor(nEventAfterSkip*trainTestSplitRatio),:));
% numberofEventsTrainM = mean(TotalEventC(1:floor(nEventAfterSkip*trainTestSplitRatio),:));
% numberOfONEventsTrainM = mean(ONEventC(1:floor(nEventAfterSkip*trainTestSplitRatio),:));
% numberOfOFFEventsTrainM = mean(OFFEventC(1:floor(nEventAfterSkip*trainTestSplitRatio),:));
% xAddressTrainM = mean(XmeanC(1:floor(nEventAfterSkip*trainTestSplitRatio),:));
% yAddressTrainM = mean(YmeanC(1:floor(nEventAfterSkip*trainTestSplitRatio),:));
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
% 
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
plot(ONEventC(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(ONEventL(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('ON Events', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Total number of ON Events");
legend('Circle', 'Line', 'Location', 'northwest');
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
plot(OFFEventL(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('OFF Events', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Total number of OFF Events");
legend('Circle', 'Line', 'Location', 'northwest');
% Enlarge figure to full screen.
pos = get(gca, 'Position');
% pos(2) = 0.6703;
set(gca, 'Position', pos);
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hAxis(3) = subplot(3,3,3);
plot(ONOFFRatioC(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(ONOFFRatioL(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('ON/OFF Ratio', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("The ratio of ON/OFF Events Polarities");
legend('Circle', 'Line', 'Location', 'northwest');
% Enlarge figure to full screen.
pos = get(gca, 'Position');
pos(1) = pos(1) - spacing;
% pos(2) = 0.6703;
set(gca, 'Position', pos);
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hAxis(4) = subplot(3,3,4);
plot(TotalEventC(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(TotalEventL(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('Number of Event', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
ylabel("Total number of Events");
legend('Circle', 'Line', 'Location', 'northwest');
% Enlarge figure to full screen.
pos = get(gca, 'Position');
pos(1) = pos(1) + spacing;
set(gca, 'Position', pos);
% set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hAxis(5) = subplot(3,3,5);
plot(DurationC(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(DurationL(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('Duration', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Total Events Duration");
legend('Circle', 'Line', 'Location', 'northwest');
% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hAxis(6) = subplot(3,3,6);
plot(XmeanC(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(XmeanL(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('X mean', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("X-address mean");
legend('Circle', 'Line', 'Location', 'northwest');
% Enlarge figure to full screen.
pos = get(gca, 'Position');
pos(1) = pos(1) - spacing;
set(gca, 'Position', pos);
% set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hAxis(7) = subplot(3,3,7);
plot(YmeanC(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(YmeanL(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('Y mean', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Y-address mean");
legend('Circle', 'Line', 'Location', 'northwest');
% Enlarge figure to full screen.
pos = get(gca, 'Position');
pos(1) = pos(1) + spacing;
% pos(2) = spacingTwo;
set(gca, 'Position', pos);
% set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hAxis(8) = subplot(3,3,8);
plot(XstdvC(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(XstdvL(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('X Stdv', 'FontSize', fontSize, 'Interpreter', 'None');
xlabel("Number of samples");
% ylabel("X-address Standard Deviation");
legend('Circle', 'Line', 'Location', 'northwest');
% Enlarge figure to full screen.
pos = get(gca, 'Position');
% pos(1) = pos(1) - spacing;
% pos(2) = spacingTwo;
set(gca, 'Position', pos);
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hAxis(9) = subplot(3,3,9);
plot(YstdvC(:, 1), 'ro', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(YstdvL(:, 1), 'bs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
% xlim([0, 6]);
% ylim([0, 6]);
axis square;
title('Y Stdv', 'FontSize', fontSize, 'Interpreter', 'None');
% xlabel("Number of samples");
% ylabel("Y-address Standard Deviation");
legend('Circle', 'Line', 'Location', 'northwest');
% Enlarge figure to full screen.
pos = get(gca, 'Position');
pos(1) = pos(1) - spacing;
% pos(2) = spacingTwo;
set(gca, 'Position', pos);
% set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
%% plot bar plot for final accuracy

figure(3);
results = [100 65.96 100 74.47 64.89 95.74 98.94 96.81 98.94];
bar(results); hold on
text(1:length(results),results,num2str(results'),'vert','bottom','horiz','center','FontSize',20);
yl = yline(50,'--','Chance 50 %','fontsize',22,'LineWidth',3);
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