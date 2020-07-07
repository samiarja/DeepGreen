function [ hiddenLayerWeights , outputWeights ,varargout] = trainELM_outputWeights( Xtrain, Ytrain ,hiddenLayerSize,rescaleInputsToNonlinearRegion,regularizationFactor)
%%%% Example inputs: Find Xor relationship
% Xtrain= round(rand(100,2))
% Ytrain= xor(Xtrain(:,1),Xtrain(:,2));
% regularizationFactor = 1e-2;% 1e3;
% hiddenLayerSize  = 1000;
% rescaleInputsToNonlinearRegion=5;% scale inputs to push into nonlinearity

[trainingPresentations,inputChannels] = size(Xtrain);        % size of input

hiddenLayerWeights                 = rand(inputChannels,hiddenLayerSize)-0.5;                                                    % initialise with
%hiddenLayerWeightedInputsForXtrain = Xtrain*hiddenLayerWeights;                                                                  % calculate linear inputs
%hiddenLayerOutputs                 = 1 ./ (1 + exp(-rescaleInputsToNonlinearRegion*hiddenLayerWeightedInputsForXtrain))-0.5;     % logistic?sigmoid? activation, zero mean
%%%% Replace with single line to save memory                                                              % calculate linear inputs
hiddenLayerOutputs                 = 1 ./ (1 + exp(-rescaleInputsToNonlinearRegion*Xtrain*hiddenLayerWeights))-0.5;     % logistic?sigmoid? activation, zero mean
outputWeights                      = (hiddenLayerOutputs'*Ytrain)'/(hiddenLayerOutputs'*hiddenLayerOutputs+regularizationFactor*eye(hiddenLayerSize,hiddenLayerSize));

%%%  If the memory usage of 'hiddenLayerOutputs' is requested from outside (via a third output variable) then give it
if nargout == 3
    s                               = whos('hiddenLayerOutputs');
    memoryUsageOfHiddenLayerOutputs = [s.bytes];
    varargout{1}  = memoryUsageOfHiddenLayerOutputs;
end




