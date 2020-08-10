% Demo to illustrate K Nearest Neighbor classification for (x,y) coordinate points.
% Setup, clean up, and initialization:
clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
fontSize = 20;
markerSize = 10;
lineWidth = 2;

numTrainingPoints = 10;

%-----------------------------------------------------------------------------------------------------------------
% Make up coordinates that we'll define as class 1.
trainingCoords1 = rand(numTrainingPoints, 2) + 1;
% Make up coordinates that we'll define as class 2.
trainingCoords2 = rand(numTrainingPoints, 2) * 1.75 + 4;
% Plot both classes of training points.
subplot(2, 2, 1);
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

%-----------------------------------------------------------------------------------------------------------------
% Now make up unknown data.
numUnknownPoints = 50;
unknownCoords = 3 * (rand(numUnknownPoints, 2) - 0.5) + 3;
% Plot the test data points with as-of-yet unknown class all in black asterisks.
subplot(2, 2, 2);
plot(unknownCoords(:, 1), unknownCoords(:, 2), 'k*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
xlim([0, 6]);
ylim([0, 6]);
axis square;
legend('As-of-yet Unknown Class', 'Location', 'northwest');
title('Test Data Before Classification', 'FontSize', fontSize, 'Interpreter', 'None');

%-----------------------------------------------------------------------------------------------------------------
% Now, let's plot both the training data and the test data on the same plot in the lower left of the GUI.
% Plot both classes of training points.
subplot(2, 2, 3);
plot(trainingCoords1(:, 1), trainingCoords1(:, 2), 'rs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(trainingCoords2(:, 1), trainingCoords2(:, 2), 'b^', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
% Plot the test data points with as-of-yet unknown class all in black asterisks.
plot(unknownCoords(:, 1), unknownCoords(:, 2), 'k*', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
xlim([0, 6]);
ylim([0, 6]);
axis square;
legend('Class 1', 'Class 2', 'As-of-yet Unknown Class', 'Location', 'northwest');
title('Both Training Data and Test Data of Unknown Class', 'FontSize', fontSize, 'Interpreter', 'None');

%-----------------------------------------------------------------------------------------------------------------
% Now do a K Nearest Neighbor Search.
% Get the classes of the unknown data.
% First collect all the training data into one tall array
trainingCoords = [trainingCoords1; trainingCoords2];
[indexes, distancesOfTheIndexes] = knnsearch(trainingCoords, unknownCoords, ...
	'NSMethod', 'exhaustive',...
	'k', 5,... % Get indexes of the 5 nearest points
	'distance', 'euclidean'); % Regular Pythagorean formula for distance
% Extract the classes
% The way I defined the classes is if the index is <= numTrainingPoints, it's class 1, otherwise it's class 2.
class1Map = indexes <= numTrainingPoints;
class2Map = indexes > numTrainingPoints;
% Now sum the maps horizontally to count the number of each class that was found:
class1Count = sum(class1Map, 2);
class2Count = sum(class2Map, 2);
% Now determine which rows got more class 1 "votes"
% so we'll know whether this coordinate of our unknown test data
% "belongs" to class 1 or class 2.
itIsClass1 = class1Count >= class2Count;
itIsClass2 = class1Count <  class2Count;
% Extract the test coordinates into two arrays, one for class 1 and one for class 2.
class1 = unknownCoords(itIsClass1, :);
class2 = unknownCoords(itIsClass2, :);

%-----------------------------------------------------------------------------------------------------------------
% Now plot what we found.  Each class gets the same marker as the training class.
subplot(2, 2, 4);
plot(class1(:, 1), class1(:, 2), 'rs', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
hold on;
plot(class2(:, 1), class2(:, 2), 'b^', 'LineWidth', lineWidth, 'MarkerSize', markerSize);
grid on;
axis square;
xlim([0, 6]);
ylim([0, 6]);
title('Test Data After Classification', 'FontSize', fontSize, 'Interpreter', 'None');
legend('Estimated to be in Class 1', 'Estimated to be in Class 2', 'Location', 'northwest');




