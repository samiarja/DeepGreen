% clear
% nSamplesForTraining =40000;
% nSamplesForTesting =10000; 
% nInputChannels = 144;
% 
% Xtrain        = rand(nSamplesForTraining,nInputChannels);
% Xtrain(:,3)   = 1;
% XtrainRounded = round(Xtrain);
% Ytrain(:,1)   = XtrainRounded(:,1) & XtrainRounded(:,2);
% Ytrain(:,2)   = ~(XtrainRounded(:,1) & XtrainRounded(:,2));
% 
% Xtest         = rand(nSamplesForTesting,nInputChannels);
% Xtest(:,3)    = 1;
% XtestRounded          = round(Xtest);
% Ytest(:,1) = (XtestRounded(:,1) & XtestRounded(:,2));  % GT = ground truth
% Ytest(:,2) = ~(XtestRounded(:,1) & XtestRounded(:,2));

%%

load("/media/sami/USB DISK/mat/data/X.mat");
load("/media/sami/USB DISK/mat/data/Y.mat");

labels = labels(:,1:1194592);
en2 = single(en2);

Xtrain = en2(:,1:700000)';
Xtest = en2(:,700000+1:end)';

Ytrain = labels(:,1:700000)';
Ytest = labels(:,700000+1:end)';

% X = load('inference/Flatten_X.mat');
% Y = load('inference/TD.mat');
% trainingSetY = TD.c';
% 
% trainingSetY(trainingSetY==110)=0;
% trainingSetY(trainingSetY==102)=1;
%%

ClassifierParameters.ELM_hiddenLayerSizes           = 500;
ClassifierParameters.NUM_ELM_SIMULATIONS            = 5;

ClassifierParameters.linRegularizationFactors       = 1e-6; 
ClassifierParameters.ELM_regularizationFactors      = 1e-6;
ClassifierParameters.rescaleInputsToNonlinearRegion = 4;
ClassifierParameters.ACCURACY_MEASURE               = 'max';   % this can be 'max' for one hot coding or 'corr' for correlation
ClassifierParameters.GENERATE_RESULTS_PLOT          = 0;
ClassifierParameters.SHOW_ELM_STD_PLOTS             = 0;
ClassifierParameters.SHOW_CLASSIFIER_OUTPUT_PLOT    = 0;

 [classificationResult] = doClassification(Xtrain,Ytrain,Xtest,Ytest,ClassifierParameters)