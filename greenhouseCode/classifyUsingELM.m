function [ELM_results] = classifyUsingELM( Xtrain, Ytrain, Xtest,YtestGroundTruth, ELM_Parameters,varargin)
%function [ELM_accuracy , hiddenLayerWeights , outputWeights , varargout] = classifyUsingELM( Xtrain, Ytrain, Xtest,YtestGroundTruth, ELM_Parameters)
% performanceMatrix=  [];
if nargin>5
    ELM_NETWORK_WAS_GIVEN_AS_INPUT = 1;
    givenElmNetwork = varargin{6};
else
    ELM_NETWORK_WAS_GIVEN_AS_INPUT = 0;
end
elmStartTic                   = tic;
hiddenLayerSize                = ELM_Parameters.hiddenLayerSize;
rescaleInputsToNonlinearRegion = ELM_Parameters.rescaleInputsToNonlinearRegion;
regularizationFactor           = ELM_Parameters.regularizationFactor;

ACCURACY_MEASURE               = ELM_Parameters.ACCURACY_MEASURE;
SHOW_CLASSIFIER_OUTPUT_PLOT    = ELM_Parameters.SHOW_CLASSIFIER_OUTPUT_PLOT;

if isfield(ELM_Parameters, 'OUTPUT_DETAILED_RESULT')   OUTPUT_DETAILED_RESULT   = ELM_Parameters.OUTPUT_DETAILED_RESULT;   else  OUTPUT_DETAILED_RESULT   = 0;                      end %#ok<SEPEX>
if isfield(ELM_Parameters, 'GET_ELM_NETWORK')          GET_ELM_NETWORK          = ELM_Parameters.GET_ELM_NETWORK;          else  GET_ELM_NETWORK          = 0;                      end %#ok<SEPEX>

numLabels                            = size(YtestGroundTruth,2);
[testingPresentations,inputChannels] = size(Xtest); %#ok<ASGLU>

misclassifiedTestInputs.index                 = nan(1,testingPresentations);% preallocate missclassifieds to worst the case of everything being wrong. (this is for speed optimization)
misclassifiedTestInputs.correctLabel          = nan(testingPresentations,numLabels);
misclassifiedTestInputs.incorrectOutputLabel  = nan(testingPresentations,numLabels);


if ELM_NETWORK_WAS_GIVEN_AS_INPUT
    hiddenLayerWeights = givenElmNetwork.hiddenLayerWeights;
    outputWeights      = givenElmNetwork.outputWeights;
    memoryUsageOfHiddenLayerOutputs = nan;
else
    %%% Train ELM output weights (return the weights in case we want to use them later outside this function)
    [ hiddenLayerWeights , outputWeights ,memoryUsageOfHiddenLayerOutputs] = trainELM_outputWeights(Xtrain,Ytrain,hiddenLayerSize,rescaleInputsToNonlinearRegion,regularizationFactor);
end
%%% Test ELM on Xtest (test part of dataset)
[ YtestOutput ] = testELM( Xtest, hiddenLayerWeights , outputWeights,rescaleInputsToNonlinearRegion );

% performanceTest = sqrt(mse(YtestGroundTruth-YtestOutput));
% figure(6765);
% performanceMatrix = [performanceMatrix, performanceTest];
% plot(performanceMatrix)


%%% Find the accuracy of the classifier based on what accuracy measure was requested %%% Find the error between Ytest and YtestGroundTruth and return
if strcmpi(ACCURACY_MEASURE,'corr')||strcmpi(ACCURACY_MEASURE,'correlation') % This option is typically for analog time series data    
    correlationWithYtestGT=nan(1,numLabels);
    
    for label = 1:numLabels
        if all(YtestOutput(:,label)==0)  || all(YtestGroundTruth(:,label)==0) 
            warning('Attempting to calculate correlation using a zero vector as input has resulted in a NaN accuracy measure.')
        end
        correlationWithYtestGT(label)= corr(YtestOutput(:,label) ,(YtestGroundTruth(:,label)));
    end
    ELM_accuracy            = mean(correlationWithYtestGT);
    confusionMatrix         = nan; % confusion matrix is not defined for case ACCURACY_MEASURE is MAX
    misclassifiedTestInputs = nan;
elseif strcmpi(ACCURACY_MEASURE,'max') % This option is typically for vision like in hmax
    [ELM_accuracy ,ELM_RMSE, misclassifiedTestInputs,YtestMaxed] = measureOneHotCodingAccuracy(YtestGroundTruth,YtestOutput);
    
    correlationWithYtestGT = nan;
%     ELM_RMSE=nan(1,numLabels);% In case ACCURACY_MEASURE == MAX, correlationWithYtestGT is not defined and will be set to nan.
    [confusionMatrix]=generateConfusionMatrix(YtestGroundTruth, YtestMaxed);
    YtestOutput = YtestMaxed; % rename  YtestMaxed to Ytest for reporting result
end

ELM_results.ELM_accuracy                    = single(ELM_accuracy);
ELM_results.ELM_RMSE                        = single(ELM_RMSE);
ELM_results.memoryUsageOfHiddenLayerOutputs = single(memoryUsageOfHiddenLayerOutputs);
ELM_results.correlationWithYtestGT          = single(correlationWithYtestGT);
ELM_results.confusionMatrix                 = single(confusionMatrix);
timeTakenToRunElm                           = toc(elmStartTic);
ELM_results.timeTakenToRunOneELM            = timeTakenToRunElm ;

if OUTPUT_DETAILED_RESULT    
    ELM_results.YtestOutput                     = single(YtestOutput);
    ELM_results.misclassifiedTestInputs         = misclassifiedTestInputs;
end
if GET_ELM_NETWORK
        ELM_results.hiddenLayerWeights              = single(hiddenLayerWeights);
        ELM_results.outputWeights                   = single(outputWeights);
end
if SHOW_CLASSIFIER_OUTPUT_PLOT
    figure(234232); clf; hold on;
    for label = 1:numLabels
        stairs(label+.8*(YtestOutput(:,label)/max(abs(YtestOutput(:,label)))),'b')
        stairs(label+.8*(YtestGroundTruth(:,label)/max(abs(YtestGroundTruth(:,label)))),'g')
        if strcmpi(ACCURACY_MEASURE,'max')
            stairs(label+ .8*(YtestMaxed(:,label)/max(abs(YtestMaxed(:,label)))),'r')
        end
    end    
end