function [accuracyTestSigmoid, rootMeanSquareErrorPerformanceTrainSigmoid,rootMeanSquareErrorPerformanceTestSigmoid, rootMeanSquareErrorPerformanceTrainRBTF,rootMeanSquareErrorPerformanceTestRBTF]=elm_train(Xtrain,Ytrain,Xtest,Ytest,number_neurons)

%%%% 1st step: Parameters initialization
rescaleInputsToNonlinearRegion = 4;
regularizationFactor = 1e-6;
[trainingPresentations,inputChannels] = size(Xtrain);

%%%% 2nd step: generate a random input weights
W_inputLayer = rand(inputChannels,number_neurons)-0.5; 

%%%% 3rd step: Project the weight to a non-linear activation function
hiddenLayerOutputsSigmoid = 1 ./ (1 + exp(-rescaleInputsToNonlinearRegion*Xtrain*W_inputLayer))-0.5; 
hiddenLayerOutputsRBTF = radbas(Xtrain*W_inputLayer);

%%%% 4th step: calculate the output layer weights for the train set
hiddenLayerOutputsweightForXTrainSigmoid = (hiddenLayerOutputsSigmoid'*Ytrain)'/(hiddenLayerOutputsSigmoid'*hiddenLayerOutputsSigmoid+regularizationFactor*eye(number_neurons,number_neurons));
hiddenLayerOutputsweightForXTrainRBTF = (hiddenLayerOutputsRBTF'*Ytrain)'/(hiddenLayerOutputsRBTF'*hiddenLayerOutputsRBTF+regularizationFactor*eye(number_neurons,number_neurons));

%%%% 5th step: calculate the output prediction labels for train set
outputPredictionTrainSigmoid = (hiddenLayerOutputsSigmoid * hiddenLayerOutputsweightForXTrainSigmoid')';
outputPredictionTrainRBTF = (hiddenLayerOutputsRBTF * hiddenLayerOutputsweightForXTrainRBTF')';

%%%% 6th step: calculate the weight for the test set
hiddenLayerOutputsForTestSigmoid = 1 ./ (1 + exp(-rescaleInputsToNonlinearRegion*Xtest*W_inputLayer))-0.5;
hiddenLayerOutputsForTestRBTF = radbas(Xtest*W_inputLayer)';

%%%% 7th step: calculate the output prediction labels for test set
outputPredictionTestSigmoid = hiddenLayerOutputsForTestSigmoid*hiddenLayerOutputsweightForXTrainSigmoid';
outputPredictionTestRBTF = hiddenLayerOutputsForTestRBTF'*hiddenLayerOutputsweightForXTrainRBTF';

%%%%%%%%%%%%%%%%calculate the prefomance for train and test%%%
rootMeanSquareErrorPerformanceTrainSigmoid=sqrt(mse(Ytrain'-outputPredictionTrainSigmoid));
rootMeanSquareErrorPerformanceTestSigmoid=sqrt(mse(Ytest-outputPredictionTestSigmoid));

rootMeanSquareErrorPerformanceTrainRBTF=sqrt(mse(Ytrain'-outputPredictionTrainRBTF));
rootMeanSquareErrorPerformanceTestRBTF=sqrt(mse(Ytest-outputPredictionTestRBTF));

% accuracyTestRBTF = measureOneHotCodingAccuracy(Ytest,outputPredictionTestRBTF);
% accuracyTestSigmoid = measureOneHotCodingAccuracy(Ytest,outputPredictionTestSigmoid);


[accuracyTestSigmoid ,rmseTestsigmoid, misclassifiedTestInputs,YtestMaxed] = measureOneHotCodingAccuracy(Ytest,outputPredictionTestSigmoid);


end



