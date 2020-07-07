function [accuracy, varargout]= measureOneHotCodingAccuracy(YtestGroundTruth,YtestOutput)
% Example:

%  accuracy  = measureOneHotCodingAccuracy(YtestGroundTruth,YtestOutputBest);

% [accuracy , misclassifiedTestInputs ] = measureOneHotCodingAccuracy(YtestGroundTruth,YtestOutputBest);

% [accuracy , misclassifiedTestInputs,YtestOutputMaxed] = measureOneHotCodingAccuracy(YtestGroundTruth,YtestOutput);


if ~isequal(size(YtestGroundTruth),size(YtestGroundTruth))
    error('isequal(size(YtestGroundTruth),size(YtestGroundTruth)) failed'); %#ok<ERTAG>
end
[testingPresentations,numLabels]=size(YtestGroundTruth);
misclassifiedTestInputs.index                 = nan(1,testingPresentations,'single');% preallocate missclassifieds to worst the case of everything being wrong. (this is for speed optimization)
misclassifiedTestInputs.correctLabel          = nan(testingPresentations,numLabels,'single');
misclassifiedTestInputs.incorrectOutputLabel  = nan(testingPresentations,numLabels,'single');
YtestOutputMaxed                                    = YtestGroundTruth+nan;
%%%% find all the misclassified cases
misclassifiedCount = 0;
for pres=1:testingPresentations
    maxYtestOutputValue = max(YtestOutput(pres,:));
    if all(YtestOutput(pres,:) == 0)
        YtestOutputMaxed(pres,:)=zeros(size(YtestOutput(pres,:)));
    elseif all(YtestOutput(pres,:) ==   maxYtestOutputValue)
        YtestOutputMaxed(pres,:)=ones(size(YtestOutput(pres,:)));
    else
        YtestOutputMaxed(pres,:)=(YtestOutput(pres,:)==max(YtestOutput(pres,:)));
    end
    if ~isequal(YtestOutputMaxed(pres,:),YtestGroundTruth(pres,:))
        misclassifiedCount                                               = misclassifiedCount + 1;
        misclassifiedTestInputs.index(misclassifiedCount)                = pres;
        %[~,thisCorrectLabel]                                             = max(YtestGroundTruth(pres,:));
        %[~,thisIncorrectOutputLabel]                                     = max(YtestMaxed(pres,:));
        %find(YtestMaxed(pres,:)==1)
        misclassifiedTestInputs.correctLabel(misclassifiedCount,:)         = YtestGroundTruth(pres,:);%thisCorrectLabel;
        misclassifiedTestInputs.incorrectOutputLabel(misclassifiedCount,:) = YtestOutputMaxed(pres,:);%thisIncorrectOutputLabel;
    end
end
misclassifiedTestInputs.index                = misclassifiedTestInputs.index(1:misclassifiedCount);  %%% cut off all the unneeded nans at the end
misclassifiedTestInputs.correctLabel         = misclassifiedTestInputs.correctLabel(1:misclassifiedCount,:);
misclassifiedTestInputs.incorrectOutputLabel = misclassifiedTestInputs.incorrectOutputLabel(1:misclassifiedCount,:);

% [allObservation channels] = size(YtestOutputMaxed);

% confusionMatrix = generateConfusionMatrix(YtestGroundTruth,YtestOutputMaxed);
% confusionmat(YtestGroundTruth(:,1),YtestOutputMaxed(:,1))
% confusionchart(confusionmat(YtestGroundTruth(:,1),YtestOutputMaxed(:,1)))

% confusionMatrixPercent = 100*confusionMatrix/allObservation;
correctlyLabeledPositives_TP = sum(and(YtestGroundTruth,YtestOutputMaxed),1); % TP
correctlyLabeledNegatives_TN = sum(and(~YtestGroundTruth,~YtestOutputMaxed),1); % TN

actualpositives = sum(YtestGroundTruth,1); % 
actualnegatives = sum(~YtestGroundTruth,1); % 

sensitivity = correctlyLabeledPositives_TP ./ actualpositives % TP/TP+FN
specificity = correctlyLabeledNegatives_TN ./ actualnegatives % TN/TN+FP
informedness = sensitivity + specificity - 1
rmse = sqrt(mse(YtestGroundTruth-YtestOutput))
accuracy   = (1 -   misclassifiedCount/testingPresentations)*100



%linearClassifierAccuracy                     = 1 - sum(abs(YtestMaxed(:) - YtestGroundTruth(:)))/testingPresentations/2;
%linearClassifierAccuracy                     = 1 -   misclassifiedCount/testingPresentations;

if nargout>1
    varargout{1} =  rmse;
end
if nargout>2
    varargout{2} =  misclassifiedCount;
end
if nargout>3
    varargout{3} =  YtestOutputMaxed;
end



