clc
clear
close
% Initialization
numTrainingPoints = 150; % Number of sample for train set
numUnknownPoints = 120; % Number of sample for test set
lineWidth = 2;
fontSize = 20;
markerSize = 10;

% Number of K
k = 50;

% Training data MxD, M is number of sample, D is dimension
trainingCoords1 = rand(numTrainingPoints, 2) *3 + 0.2;
trainingCoords2 = rand(numTrainingPoints, 2) * 3 + 3;
data = [trainingCoords1; trainingCoords2];

% Label for the train set
labels = nan(length(data),1);
labels(1:length(data)/2+1,1) = 1;labels(length(data)/2+1:end,1) = 0;

% Test data
t_data = 3 * (rand(numUnknownPoints, 2) - 0.5) + 3;
t_labels = [];
for idx = 1:numel(t_data(:,1))
    if t_data(idx,1) < 4 && t_data(idx,2) < 4
        t_labels(idx) = 1;
    else
        t_labels(idx) = 0;
    end
end

% labels for the test set


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
accuracy=length(find(predicted_labels==t_labels))/size(t_data,1)

final_data = [data;t_data];
final_label = [labels;predicted_labels];
All_data = [final_data final_label];

% Get index for class with label 0 and group into one matrix
class0 = find(All_data(:,3) > 0);
classZero = All_data(class0,:);

% Get index for class with label 1 and group into one matrix
class1 = find(All_data(:,3) < 1);
classOne = All_data(class1,:);

% Visualization
figure(1);
subplot(2,2,1)
plot(trainingCoords1(:, 1), trainingCoords1(:, 2), 'rs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(trainingCoords2(:, 1), trainingCoords2(:, 2), 'b^', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
xlim([0, 6]);
ylim([0, 6]);
axis square;
title('Training data.  Points have known, defined class.', 'FontSize', fontSize, 'Interpreter', 'None');
legend('Class 1', 'Class 2', 'Location', 'northwest');
% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);

subplot(2, 2, 2);
plot(t_data(:, 1), t_data(:, 2), 'k*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
xlim([0, 6]);
ylim([0, 6]);
axis square;
legend('As-of-yet Unknown Class', 'Location', 'northwest');
title('Test Data Before Classification', 'FontSize', fontSize, 'Interpreter', 'None');

subplot(2, 2, 3);
plot(trainingCoords1(:, 1), trainingCoords1(:, 2), 'rs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(trainingCoords2(:, 1), trainingCoords2(:, 2), 'b^', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
% Plot the test data points with as-of-yet unknown class all in black asterisks.
plot(t_data(:, 1), t_data(:, 2), 'k*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
xlim([0, 6]);
ylim([0, 6]);
axis square;
legend('Class 1', 'Class 2', 'As-of-yet Unknown Class', 'Location', 'northwest');
title('Both Training Data and Test Data of Unknown Class', 'FontSize', fontSize, 'Interpreter', 'None');

% Now plot what we found.  Each class gets the same marker as the training class.
subplot(2, 2, 4);
plot(classZero(:, 1), classZero(:, 2), 'rs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(classOne(:, 1), classOne(:, 2), 'b^', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
axis square;
xlim([0, 6]);
ylim([0, 6]);
title('Test Data After Classification', 'FontSize', fontSize, 'Interpreter', 'None');
legend('Estimated to be in Class 1', 'Estimated to be in Class 2', 'Location', 'northwest');


%% plot bar plot

figure(2);
results = [59.7 63.9 64.4 68.5 66.06 63.26 63.33];
bar(results); hold on
yline(50);
str={'k=2','k=4','k=8','k=12','k=20','k=30','k=50'};
set(gca, 'XTickLabel',str, 'XTick',1:numel(str))
xlabel("K value");
ylabel("Accuracy (%)");
title("KNN accuracy for Two classes across different K")

%% TD split data to multiple files
% TD = struct('x',single(events(:,1)),'y',single(events(:,2)), 'p',single(events(:,3)), 'ts',events(:,4));
initial = 0;
valid = 1;
for index = 8e4:3e5:numel(events(:,1))
    valid = valid + 1;
    initial = 3e5;
    TD{valid,1} = [events(index:initial+index,1),events(index:initial+index,2),events(index:initial+index,3),events(index:initial+index,4)];
end

%% Prepare dataset
% Combine all lines events data in one matrix
TDLINE = [];
for i = 1:7
    load("KNN/Data/Lines/LINE" + i)
    TDLINE = [TDLINE;TD];
end

% Combine all circles events data in one matrix
TDCIRCLE = [];
for i = 1:4
    load("KNN/Data/Circles/CIRCLE" + i)
    TDCIRCLE = [TDCIRCLE;TD];
end

%% Extract Statistics for Lines data
tic;
ONEventL = [];
OFFEventL = [];
ONOFFRatioL = [];
TotalEventL = [];
DurationL = [];
XmeanL = [];
YmeanL = [];
XstdvL = [];
YstdvL = [];

for i = 1:numel(TDLINE)
    Line = TDLINE{i, 1};
    ONEventL = [ONEventL;size(find(Line(:,3) == 1))];
    OFFEventL = [OFFEventL;size(find(Line(:,3) == -1))];
    ONOFFRatioL = [ONOFFRatioL;size(find(Line(:,3) == 1))/size(find(Line(:,3) == -1))];
    TotalEventL = [TotalEventL;numel(Line(:,2))];
    DurationL = [DurationL;Line(end,4) - Line(1,4)];
    XmeanL = [XmeanL;mean(Line(:,1))];
    YmeanL = [YmeanL;mean(Line(:,2))];
    XstdvL = [XstdvL;std(single(Line(:,1)))];
    YstdvL = [YstdvL;std(single(Line(:,2)))];
end
toc;
%% Extract Statistics for Circles data
tic;
ONEventC = [];
OFFEventC = [];
ONOFFRatioC = [];
TotalEventC = [];
DurationC = [];
XmeanC = [];
YmeanC = [];
XstdvC = [];
YstdvC = [];

for i = 1:numel(TDLCIRCLE)
    Circle = TDLCIRCLE{i, 1};
    ONEventC = [ONEventC;size(find(Circle(:,3) == 1))];
    OFFEventC = [OFFEventC;size(find(Circle(:,3) == -1))];
    ONOFFRatioC = [ONOFFRatioC;size(find(Circle(:,3) == 1))/size(find(Circle(:,3) == -1))];
    TotalEventC = [TotalEventC;numel(Circle(:,2))];
    DurationC = [DurationC;Circle(end,4) - Circle(1,4)];
    XmeanC = [XmeanC;mean(Circle(:,1))];
    YmeanC = [YmeanC;mean(Circle(:,2))];
    XstdvC = [XstdvC;std(single(Circle(:,1)))];
    YstdvC = [YstdvC;std(single(Circle(:,2)))];
end
toc;
