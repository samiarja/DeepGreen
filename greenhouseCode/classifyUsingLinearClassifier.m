function [linClassifierResults, varargout] = classifyUsingLinearClassifier(Xtrain,Ytrain,Xtest,YtestGroundTruth,varargin)
%function [linearClassifierAccuracy, varargout] = classifyUsingLinearClassifier(Xtrain,Ytrain,Xtest,YtestGroundTruth,LinClassifierParameters)
% Xtrain = [0 1 0 1
%           0 0 1 1]'
% Ytrain = [0 1 1 0   % XOR
%           1 0 0 1]'  % XNOR
% %%%%%%%%----------------------------------------
% Xtest =  [0  1  0
%           0  0  1]'
% YtestGroundTruth =[0  1  1   % XOR
%           1  0  0]' % XNOR
linStartTic = tic;
if nargin==5
    linClassifierParameters = varargin{1};
    ACCURACY_MEASURE        = linClassifierParameters.ACCURACY_MEASURE;
    SHOW_OUTPUT_PLOT        = linClassifierParameters.SHOW_CLASSIFIER_OUTPUT_PLOT;
    regularizationFactor    = linClassifierParameters.regularizationFactor;
    if isfield(linClassifierParameters, 'OUTPUT_DETAILED_RESULT')  
        OUTPUT_DETAILED_RESULT   = linClassifierParameters.OUTPUT_DETAILED_RESULT; 
    else
        OUTPUT_DETAILED_RESULT   = 0;
    end  % This can sometimes consume a lot of memory and cause problems so use carefully
else
    regularizationFactor   = 1e-6;
    ACCURACY_MEASURE       = 'max';
    SHOW_OUTPUT_PLOT       = 0;
    OUTPUT_DETAILED_RESULT = 0; 
end

% [trainingPresentations,inputChannels]=size(Xtrain);
% [trainingPresentations,outputChannels]=size(Ytrain);
[testingPresentations,inputChannels]=size(Xtest);
numLabels = size(YtestGroundTruth,2);

linearInputToOutputMapping = (Xtrain'*Ytrain)'/(Xtrain'*Xtrain + regularizationFactor*eye(inputChannels,inputChannels)); %Wo = (X'*Y)'/(X'*X+1e-6*eye(size_xall(2),size_xall(2)));
% YtestOutputTrain=Xtrain*linearInputToOutputMapping'; 
YtestOutput=Xtest*linearInputToOutputMapping';

% Softmax function
YtestOutput_softmax = softmax(YtestOutput);

% Cross entropy loss function
cost_function = crossentropy(YtestGroundTruth, YtestOutput_softmax)

%%% Find the accuracy of the classifier based on what accuracy measure was requested
if strcmpi(ACCURACY_MEASURE,'corr')||strcmpi(ACCURACY_MEASURE,'correlation') % This option is typically for analog time series data
    
    correlationWithYtestGT=nan(1,numLabels);
    for ilabel = 1:numLabels
        if all(YtestOutput(:,ilabel)==0)  || all(YtestGroundTruth(:,ilabel)==0)
            warning('Attempting to calculate correlation using a zero vector as input has resulted in a NaN accuracy measure.')
        end
        correlationWithYtestGT(ilabel)= corr(YtestOutput(:,ilabel) ,(YtestGroundTruth(:,ilabel)));
    end
    linClassifierResults.linearClassifierAccuracy   = single(mean(correlationWithYtestGT));
    linClassifierResults.correlationWithYtestGT     = single(correlationWithYtestGT);            
    linClassifierResults.confusionMatrix            = single(nan);  % confusion matrix is not defined when using correlation as an accuracy measure    
    linClassifierResults.linearInputToOutputMapping = single(linearInputToOutputMapping);
    if OUTPUT_DETAILED_RESULT
        linClassifierResults.YtestOutput                = single(YtestOutput);
        linClassifierResults.misclassifiedTestInputs    = single(nan); % misclassifiedTestInputs is not defined when using correlation as an accuracy measure
    end
    
elseif strcmpi(ACCURACY_MEASURE,'max') % This option is typically used for choose ONE class from a bunch of classes
    [linearClassifierAccuracy , linearClassifierRMSE, misclassifiedTestInputs,YtestMaxed] = measureOneHotCodingAccuracy(YtestGroundTruth,YtestOutput);
    [confusionMatrix]                            = generateConfusionMatrix(YtestGroundTruth,YtestMaxed);
    
    linClassifierResults.linearClassifierAccuracy   = single(linearClassifierAccuracy);
    linClassifierResults.linearClassifierRMSE       = single(linearClassifierRMSE);
    linClassifierResults.correlationWithYtestGT     = single(nan); % Not defined when using 'max' as an accuracy measure
    linClassifierResults.confusionMatrix            = single(confusionMatrix);    
    linClassifierResults.linearInputToOutputMapping = single(linearInputToOutputMapping);
    if OUTPUT_DETAILED_RESULT
        linClassifierResults.YtestOutput                = single(YtestMaxed);
        linClassifierResults.misclassifiedTestInputs    = misclassifiedTestInputs;
    end
end
linClassifierResults.timeTakenToRunOneLinClassifier = toc(linStartTic);

if SHOW_OUTPUT_PLOT
    figure(234231); clf; hold on;
    for ilabel = 1:numLabels
        stairs(ilabel+.8*(YtestOutput(:,ilabel)/max(abs(YtestOutput(:,ilabel)))),'b')
        stairs(ilabel+.8*(YtestGroundTruth(:,ilabel)/max(abs(YtestGroundTruth(:,ilabel)))),'g')
        if strcmpi(ACCURACY_MEASURE,'max')
            stairs(ilabel+ .8*(YtestMaxed(:,ilabel)/max(abs(YtestMaxed(:,ilabel)))),'r')
        end
    end
end


% s                               = whos('Xtrain');
% memoryUsageLinearClassifier = [s.bytes];

