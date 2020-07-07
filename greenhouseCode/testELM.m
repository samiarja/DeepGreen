function [ Ytest ] = testELM( Xtest, hiddenLayerWeights , outputWeights,rescaleInputsToNonlinearRegion )

% Xtest = [linspace(-1,2,100); linspace(-1,2,100)];
% YGT   = Xtest(1,:).*Xtest(2,:);
% size(Xtest)
% size(hiddenLayerWeights)
hiddenLayerWeightedInputsForXtest = Xtest*hiddenLayerWeights;     % calculate linear inputs
hiddenLayerOutputsForTest         = 1 ./ (1 + exp(-rescaleInputsToNonlinearRegion*hiddenLayerWeightedInputsForXtest))-0.5;   % sigmoid activation, zero mean           
% size(hiddenLayerOutputsForTest)
% size(outputWeights)
Ytest                             = hiddenLayerOutputsForTest*outputWeights';

%Ytest = Ytest'; 