function    [classificationResult] = doClassification(Xtrain,Ytrain,Xtest,YtestGroundTruth,ClassifierParameters,varargin)
%%%% Do linear classification find the regularizationFactor with the highest accuracy and return it along with the accuracy%----------------------------------------
% ----------------------------------------
% Example: XOR XNOR problem
% ----------------------------------------
% Xtrain = [0 1 0 1 0 0 
%           0 0 1 1 0 0]'
%
% Ytrain = [0 1 1 0 0 0    % XOR
%           1 0 0 1 1 1]'  % XNOR
% ----------------------------------------
% Xtest =  [0  1  0
%           0  0  1]'
% YtestGT =[0  1  1   % XOR
%           1  0  0]' % XNOR
% ----------------------------------------
% classifierParameters.ELM_hiddenLayerSizes           = 2000;
% classifierParameters.ELM_regularizationFactors        = 1e-6;
% classifierParameters.NUM_ELM_SIMULATIONS            = 10;
% classifierParameters.rescaleInputsToNonlinearRegion = 5;
% classifierParameters.ACCURACY_MEASURE               = 'max';   % this can be 'max' for one hot coding or 'corr' for correlation
% classifierParameters.GENERATE_RESULTS_PLOT          = 0;
% classifierParameters.SHOW_ELM_STD_PLOTS             = 0;
% classifierParameters.SHOW_CLASSIFIER_OUTPUT_PLOT    = 0;
%%%% ----------------------------------------
if nargin > 5
    ELM_NETWORK_WAS_GIVEN_AS_INPUT = 1;
    givenElmNetwork                = varargin{1};    
else
    ELM_NETWORK_WAS_GIVEN_AS_INPUT = 0;
end
if isfield(ClassifierParameters, 'linRegularizationFactors') linRegularizationFactors = ClassifierParameters.linRegularizationFactors; else  linRegularizationFactors = 10.^[-9 -6 -3 0 3 6 9]; end %#ok<SEPEX>
if isfield(ClassifierParameters, 'OUTPUT_DETAILED_RESULT')   OUTPUT_DETAILED_RESULT   = ClassifierParameters.OUTPUT_DETAILED_RESULT;   else  OUTPUT_DETAILED_RESULT   = 0;                      end %#ok<SEPEX>
if isfield(ClassifierParameters, 'GET_ELM_NETWORK')          GET_ELM_NETWORK          = ClassifierParameters.GET_ELM_NETWORK;          else  GET_ELM_NETWORK =0;                                end %#ok<SEPEX>

accuracyFinal = [];
rmseFinal = [];
ELM_hiddenLayerSizes            = ClassifierParameters.ELM_hiddenLayerSizes;
ELM_regularizationFactors       = ClassifierParameters.ELM_regularizationFactors;
NUM_ELM_SIMULATIONS             = ClassifierParameters.NUM_ELM_SIMULATIONS;
rescaleInputsToNonlinearRegion  = ClassifierParameters.rescaleInputsToNonlinearRegion;
ACCURACY_MEASURE                = ClassifierParameters.ACCURACY_MEASURE;   % this can be 'max' for one hot coding (uses max function) or 'corr' for regression (uses corr function)

SHOW_CLASSIFIER_OUTPUT_PLOT     = ClassifierParameters.SHOW_CLASSIFIER_OUTPUT_PLOT;
try 
    SHOW_ACCURACY_PLOT              = ClassifierParameters.SHOW_ACCURACY_PLOT;
catch
    SHOW_ACCURACY_PLOT              = 0;
end
SHOW_ELM_STD_PLOTS              = ClassifierParameters.SHOW_ELM_STD_PLOTS;

%linearClassifierAccuracies      = [];%nan+linRegularizationFactors;
%linConfusionMatrixArray         = nan(size(Ytrain,2),size(Ytrain,2),numel(linRegularizationFactors));
%linYtestArray                   = nan(size(YtestGroundTruth,1),size(YtestGroundTruth,2),numel(linRegularizationFactors));
if ~isempty(linRegularizationFactors)
    for linRegIndex                             = 1:numel(linRegularizationFactors)
        linClassifierParameters.regularizationFactor        = linRegularizationFactors(linRegIndex);
        linClassifierParameters.ACCURACY_MEASURE            = ACCURACY_MEASURE;
        linClassifierParameters.SHOW_CLASSIFIER_OUTPUT_PLOT = SHOW_CLASSIFIER_OUTPUT_PLOT;
        linClassifierParameters.OUTPUT_DETAILED_RESULTS     = OUTPUT_DETAILED_RESULT ;   % This can sometimes consume a lot of memory and cause problems so use carefully
        linClassifierResultArray(linRegIndex )              = classifyUsingLinearClassifier(Xtrain,Ytrain,Xtest,YtestGroundTruth,linClassifierParameters); %#ok<AGROW>
    end
    linearClassifierAccuracies                        = [linClassifierResultArray.linearClassifierAccuracy];
    
    highestLinAccuracy                                     = max(linearClassifierAccuracies);                             %
    linRegIndexWithHighestAccuracy                         = find(linearClassifierAccuracies==highestLinAccuracy, 1 ,'last');          %  we take the last of the best performing regularization factor results because a higher regularization should generalize better
    linRegFactorWithHighestAccuracy                        = linRegularizationFactors(linRegIndexWithHighestAccuracy);      %
    %highestLinAccuracyConfusionMatrix                      = linConfusionMatrixArray(:,:,linRegIndexWithHighestAccuracy );
    %highestLinAccuracyYtestOutput                          = linYtestArray(:,:,linRegIndexWithHighestAccuracy );
    %classificationResult.highestLinAccuracy                = double(highestLinAccuracy);
    %classificationResult.highestLinAccuracyConfusionMatrix = double(highestLinAccuracyConfusionMatrix);
    %classificationResult.highestLinAccuracyYtestOutput     = double(highestLinAccuracyYtestOutput);
    classificationResult.linearClassifierAccuracy        = single(highestLinAccuracy);
    classificationResult.linRegFactorWithHighestAccuracy = single(linRegFactorWithHighestAccuracy);
    classificationResult.highestLinAccuracy              = single(highestLinAccuracy);
    classificationResult.linClassifierResultArray        = linClassifierResultArray;
    
    linMapBest = linClassifierResultArray(linRegIndexWithHighestAccuracy).linearInputToOutputMapping;
    YtestOutputBest=Xtest*linMapBest';
    [testingPresentations,inputChannels]=size(Xtest);
    if strcmpi(ACCURACY_MEASURE,'corr')||strcmpi(ACCURACY_MEASURE,'correlation') % This option is typically for analog time series data
        classificationResult.YtestBestLinear                 = YtestOutputBest;
    elseif strcmpi(ACCURACY_MEASURE,'max') % This option is typically used for choosing ONE class from a bunch of classes
        %     for pres=1:testingPresentations
        %         maxYtestOutputValue = max(YtestOutputBest(pres,:));
        %         if all(YtestOutputBest(pres,:) == 0)
        %             YtestOutputBestMaxed(pres,:)=zeros(size(YtestOutputBest(pres,:)));
        %         elseif all(YtestOutputBest(pres,:) ==   maxYtestOutputValue)
        %             YtestOutputBestMaxed(pres,:)=ones(size(YtestOutputBest(pres,:)));
        %         else
        %             YtestOutputBestMaxed(pres,:)=(YtestOutputBest(pres,:)==max(YtestOutputBest(pres,:)));
        %         end
        %     end
        [~ , ~,YtestOutputBestMaxed] = measureOneHotCodingAccuracy(YtestGroundTruth,YtestOutputBest);
        
        classificationResult.YtestBestLinear = YtestOutputBestMaxed;
    end
else
    classificationResult.linearClassifierAccuracy        = single(nan);
    classificationResult.linRegFactorWithHighestAccuracy = single(nan);
    classificationResult.highestLinAccuracy              = single(nan);
    classificationResult.linClassifierResultArray        = [];
    classificationResult.YtestBestLinear                 = [];
end
%%% classify using ELM ----------------
if NUM_ELM_SIMULATIONS > 0
    startTimeForRunningAllElms = cputime;
    ELM_accuracyArray          = zeros(numel(ELM_hiddenLayerSizes),numel(ELM_regularizationFactors),NUM_ELM_SIMULATIONS);
    ELM_RMSEArray          = zeros(numel(ELM_hiddenLayerSizes),numel(ELM_regularizationFactors),NUM_ELM_SIMULATIONS);
    nELM_regulatizationFactors = numel(ELM_regularizationFactors);
    nELM_hiddenLayerSizes       =  numel(ELM_hiddenLayerSizes);
    
    for simELMIndex = 1:NUM_ELM_SIMULATIONS
        for regFacIndex = 1:nELM_regulatizationFactors
            for hiddenLayerSizeIndex = 1:nELM_hiddenLayerSizes
                clear ELM_Parameters
                ELM_Parameters.regularizationFactor           = ELM_regularizationFactors(regFacIndex);
                ELM_Parameters.hiddenLayerSize                = ELM_hiddenLayerSizes(hiddenLayerSizeIndex);
                ELM_Parameters.rescaleInputsToNonlinearRegion = rescaleInputsToNonlinearRegion;
                ELM_Parameters.ACCURACY_MEASURE               = ACCURACY_MEASURE;
                ELM_Parameters.GET_ELM_NETWORK                = GET_ELM_NETWORK;
                ELM_Parameters.SHOW_CLASSIFIER_OUTPUT_PLOT    = SHOW_CLASSIFIER_OUTPUT_PLOT;
                ELM_Parameters.OUTPUT_DETAILED_RESULT         = OUTPUT_DETAILED_RESULT;
                %[ELM_accuracy , ~ , ~ ]                                                             = classifyUsingELM( Xtrain, Ytrain, Xtest,YtestGroundTruth ,ELM_Paramters );
                %log10regFac_HLNk_accuracy                                                           = [log10(ELM_Paramters.regularizationFactor) ELM_Paramters.hiddenLayerSize/1000 ELM_accuracy] %#ok<NOPRT,NASGU>
                %ELM_accuracies(regFacIndex,hiddenLayerSizeIndex,simELMIndex)                        = ELM_accuracy;
                if ELM_NETWORK_WAS_GIVEN_AS_INPUT
                    [ELM_resultArray(hiddenLayerSizeIndex,regFacIndex,simELMIndex)]  = classifyUsingELM( Xtrain, Ytrain, Xtest,YtestGroundTruth, ELM_Parameters,givenElmNetwork);
                else
                    [ELM_resultArray(hiddenLayerSizeIndex,regFacIndex,simELMIndex)]  = classifyUsingELM( Xtrain, Ytrain, Xtest,YtestGroundTruth, ELM_Parameters);
                end
                iSimElm_log10regFac_HLNk_ELM_accuracy                            = [simELMIndex log10(ELM_Parameters.regularizationFactor) ELM_Parameters.hiddenLayerSize/1000 ELM_resultArray(hiddenLayerSizeIndex,regFacIndex,simELMIndex).ELM_accuracy ELM_resultArray(hiddenLayerSizeIndex,regFacIndex,simELMIndex).ELM_RMSE] %#ok<NOPRT,NASGU>
                ELM_accuracyArray(hiddenLayerSizeIndex,regFacIndex,simELMIndex ) =  ELM_resultArray(hiddenLayerSizeIndex,regFacIndex,simELMIndex).ELM_accuracy;
                ELM_RMSEArray(hiddenLayerSizeIndex,regFacIndex,simELMIndex ) =  ELM_resultArray(hiddenLayerSizeIndex,regFacIndex,simELMIndex).ELM_RMSE;
                
                accuracyFinal = [accuracyFinal,ELM_resultArray(hiddenLayerSizeIndex,regFacIndex,simELMIndex).ELM_accuracy];
                figure(56769);
                plot(accuracyFinal)
                
                rmseFinal = [rmseFinal,ELM_resultArray(hiddenLayerSizeIndex,regFacIndex,simELMIndex).ELM_RMSE];
                figure(56770);
                plot(rmseFinal)
                
                %ELM_results.ELM_accuracy                    = ELM_accuracy;
                %ELM_results.hiddenLayerWeights              = hiddenLayerWeights;
                %ELM_results.outputWeights                   = outputWeights;
                %ELM_results.memoryUsageOfHiddenLayerOutputs = memoryUsageOfHiddenLayerOutputs;
                %ELM_results.correlationWithYtestGT          = correlationWithYtestGT;
                %ELM_results.Ytest                           = Ytest;
                %ELM_results.confusionMatrix                 = confusionMatrix;
                %ELM_results.misclassifiedTestInputs         = misclassifiedTestInputs;
                %ELM_results.timeTakenToRunOneELM            = toc;
            end
        end
    end
    endTimeForRunningAllElms               = cputime;
    timeTakenToRunAllELMs                  = endTimeForRunningAllElms-startTimeForRunningAllElms;
    mean_ELM_accuracies                    = mean(ELM_accuracyArray,3); % take the mean across the ELM simulations dimension
    std_ELM_accuracies                     = std (ELM_accuracyArray,0,3); %  take the std across the ELM simulations dimension
    
    [bestHLNsIndex, bestELMRegFactIndex ] = find(mean_ELM_accuracies==max(mean_ELM_accuracies(:)),1,'first');  %%% find the highest ELM accuracy result.
    highestMean_ELM_accuracy              = mean_ELM_accuracies(bestHLNsIndex,bestELMRegFactIndex);
    stdOfbestMean_ELM_accuracy            = std_ELM_accuracies (bestHLNsIndex,bestELMRegFactIndex);
    bestELMRegFact                        = ELM_regularizationFactors(bestELMRegFactIndex);
    bestHLNs                              = ELM_hiddenLayerSizes(bestHLNsIndex);
    
    
    classificationResult.ELM_resultArray            = ELM_resultArray;
    classificationResult.ELM_RMSEArray              = ELM_RMSEArray;
    classificationResult.mean_ELM_accuracies        = double(mean_ELM_accuracies);
    classificationResult.std_ELM_accuracies         = double(std_ELM_accuracies);
    classificationResult.bestMean_ELM_accuracy      = double(highestMean_ELM_accuracy);
    classificationResult.stdOfbestMean_ELM_accuracy = double(stdOfbestMean_ELM_accuracy);
    classificationResult.bestELMRegFact             = double(bestELMRegFact);
    classificationResult.bestELMRegFactIndex        = double(bestELMRegFactIndex);
    classificationResult.bestHLNs                   = double(bestHLNs);
    classificationResult.bestHLNsIndex              = double(bestHLNsIndex);
    classificationResult.timeTakenToRunAllELMs      = double(timeTakenToRunAllELMs);
    
    %squeeze(classificationResult.ELM_resultArray(:,bestELMRegFactIndex,:).ELM_accuracy)
    
    
    if SHOW_ACCURACY_PLOT        %%%%% Generate Results Plot
        SHOW_MEAN_TIME_TAKEN_TO_RUN_EACH_ELM = 1;
        if  SHOW_MEAN_TIME_TAKEN_TO_RUN_EACH_ELM
            meanTimeTakenToRunEachElm     = nan(nELM_hiddenLayerSizes,nELM_regulatizationFactors);
            stdTimeTakenToRunEachElm     = nan(nELM_hiddenLayerSizes,nELM_regulatizationFactors);
            timeTakenToRunThisElmArray    =nan(1,NUM_ELM_SIMULATIONS);
            for ihln=1:nELM_hiddenLayerSizes
                for iRegFact=1:nELM_regulatizationFactors
                    for iSim=1:NUM_ELM_SIMULATIONS
                        timeTakenToRunThisElmArray(iSim) = classificationResult.ELM_resultArray(ihln,bestELMRegFactIndex,iSim).timeTakenToRunOneELM;
                    end
                    meanTimeTakenToRunEachElm(ihln,iRegFact) = mean(timeTakenToRunThisElmArray);
                    stdTimeTakenToRunEachElm(ihln,iRegFact)  = std(timeTakenToRunThisElmArray);
                end
            end
            meanTimeTakenForBestAccuracy = meanTimeTakenToRunEachElm(bestHLNsIndex,bestELMRegFactIndex);
            stdTimeTakenForBestAccuracy = stdTimeTakenToRunEachElm(bestHLNsIndex,bestELMRegFactIndex);
            figure(2344211); clf
            subplot(3,1,1)
            imagesc(ELM_hiddenLayerSizes,log10(ELM_regularizationFactors),meanTimeTakenToRunEachElm');
            ylabel('log10(ELM regularization factor)'); xlabel('hidden layer size')
            title(['mean time taken to run each ELM (n=' num2str(NUM_ELM_SIMULATIONS) ')  Total:' num2str(timeTakenToRunAllELMs,'%.2f') 'sec'])
            h = colorbar;  ylabel(h, 'mean time taken to run each ELM (sec)','fontsize',12)
            text(bestHLNs,log10(bestELMRegFact),[num2str(meanTimeTakenForBestAccuracy) 'sec\bullet'],'HorizontalAlignment','right')
            subplot(3,1,2)
            imagesc(ELM_hiddenLayerSizes,log10(ELM_regularizationFactors),stdTimeTakenToRunEachElm');
            ylabel('log10(ELM regularization factor)'); xlabel('hidden layer size')
            h = colorbar;  ylabel(h, 'std time taken to run each ELM (sec)','fontsize',12)
            title(['std  time taken to run each ELM (n=' num2str(NUM_ELM_SIMULATIONS) ')'])
            text(bestHLNs,log10(bestELMRegFact),[num2str(stdTimeTakenForBestAccuracy) 'sec\bullet'],'HorizontalAlignment','right')
            
            meanMemoryUsageOfEachElm  = nan(nELM_hiddenLayerSizes,nELM_regulatizationFactors);
            stdMemoryUsageOfEachElm   = nan(nELM_hiddenLayerSizes,nELM_regulatizationFactors);
            memoryUsageofThisElmArray = nan(1,NUM_ELM_SIMULATIONS);
            for ihln=1:nELM_hiddenLayerSizes
                for iRegFact=1:nELM_regulatizationFactors
                    for iSim=1:NUM_ELM_SIMULATIONS
                        memoryUsageofThisElmArray(iSim) = classificationResult.ELM_resultArray(ihln,bestELMRegFactIndex,iSim).memoryUsageOfHiddenLayerOutputs/1e6;
                    end
                    meanMemoryUsageOfEachElm(ihln,iRegFact) = mean(memoryUsageofThisElmArray);
                    stdMemoryUsageOfEachElm(ihln,iRegFact)  = std(memoryUsageofThisElmArray);
                end
            end
            memoryUsageOfElmWithBestAccuracy = meanMemoryUsageOfEachElm(bestHLNsIndex,bestELMRegFactIndex);
            stdOfMemoryUsageOfElmWithBestAccuracy  = stdMemoryUsageOfEachElm(bestHLNsIndex,bestELMRegFactIndex);
            subplot(3,1,3);
            imagesc(ELM_hiddenLayerSizes,log10(ELM_regularizationFactors),meanMemoryUsageOfEachElm');
            ylabel('log10(ELM regularization factor)'); xlabel('hidden layer size')
            title(['memoryUsage for each ELM in MB'])
            h = colorbar;  ylabel(h, 'memoryUsage in MB','fontsize',12)
            text(bestHLNs,log10(bestELMRegFact),[num2str(memoryUsageOfElmWithBestAccuracy) 'MB\bullet'],'HorizontalAlignment','right')
        end
        
        SHOW_BOXPLOT_OF_BEST_ELM_REG_FACTOR_ACCURACY    = 1;
        if SHOW_BOXPLOT_OF_BEST_ELM_REG_FACTOR_ACCURACY
            bestRefFactElmAcc=nan;
            for ihln=1:size(classificationResult.ELM_resultArray,1)
                for iSim=1:size(classificationResult.ELM_resultArray,3)
                    bestRefFactElmAcc(ihln,iSim) = classificationResult.ELM_resultArray(ihln,bestELMRegFactIndex,iSim).ELM_accuracy;
                end
            end
            figure(23423); clf; hold on
            boxplot(bestRefFactElmAcc', 'labels', ELM_hiddenLayerSizes')
            plot(mean(bestRefFactElmAcc,2),'x')
            plot([1 nELM_hiddenLayerSizes],[highestLinAccuracy, highestLinAccuracy],'--k')
            title(['result from regularization factor:' num2str(bestELMRegFact) '(i=' num2str(bestELMRegFactIndex) ')' ]);xlabel('hidden layer size','fontsize',13);    ylabel(' ELM recognition accuracy','fontsize',13)
            legend('mean accuracy','linear accuracy')
        end
        
        SHOW_ACCURACY_IMAGE                          = 1;
        if SHOW_ACCURACY_IMAGE
            figure(2344311); clf
            subplot(2,1,1)
            imagesc(ELM_hiddenLayerSizes,log10(ELM_regularizationFactors),mean_ELM_accuracies');
            imagesc(ELM_hiddenLayerSizes,log10(ELM_regularizationFactors),mean_ELM_accuracies');
            ylabel('log10(ELM regularization factor)'); xlabel('hidden layer size')
            title(['mean ELM recognition accuracy (n=' num2str(NUM_ELM_SIMULATIONS) ') linear accuracy:' num2str(highestLinAccuracy)])
            h = colorbar;
            ylabel(h, 'mean recognition accuracy','fontsize',13)
            text(bestHLNs,log10(bestELMRegFact),[ num2str(100*highestMean_ELM_accuracy,'%.2f') '%\bullet'],'HorizontalAlignment','right')
            
            
            subplot(2,1,2)
            imagesc(ELM_hiddenLayerSizes,log10(ELM_regularizationFactors),std_ELM_accuracies');
            ylabel('log10(ELM regularization factor)'); xlabel('hidden layer size')
            h = colorbar;
            ylabel(h, 'std recognition accuracy','fontsize',13)
            title(['std ELM recognition accuracy (n=' num2str(NUM_ELM_SIMULATIONS) ')'])
            
            text(bestHLNs,log10(bestELMRegFact),[ num2str(100*stdOfbestMean_ELM_accuracy,'%.2f') '%\bullet'],'HorizontalAlignment','right')
        end
        
        
        SHOW_ALL_ACCURACY_PLOTS                      = 1;
        if SHOW_ALL_ACCURACY_PLOTS
            figure(2344312); clf
            subplot(2,1,1); hold on;
            plot(ELM_hiddenLayerSizes,mean_ELM_accuracies);
            title(['mean ELM recognition accuracy (n=' num2str(NUM_ELM_SIMULATIONS) ') linear accuracy:' num2str(highestLinAccuracy)])
            plot([min(ELM_hiddenLayerSizes),max(ELM_hiddenLayerSizes)],[highestLinAccuracy,highestLinAccuracy],'k--');
            legendCell = cellstr(num2str(ELM_regularizationFactors', 'ELM regFact=%g'));
            legendCell{numel(legendCell)+1} ='linear classifier';
            legend( legendCell,'Location', 'EastOutside');    ylabel( 'mean recognition accuracy');xlabel('hidden layer size')
            
            
            subplot(2,1,2);hold on;
            plot(ELM_hiddenLayerSizes,std_ELM_accuracies);
            legendCell = cellstr(num2str(ELM_regularizationFactors', 'ELM regFact=%g'));
            legend( legendCell,'Location', 'EastOutside');
            
            %set(h,'Location','NorthEastOutside');
            ylabel( 'std recognition accuracy');xlabel('hidden layer size')
            if SHOW_ELM_STD_PLOTS
                numOfColorsInMatlab = 10;
                for k=1:numel(ELM_regularizationFactors)
                    a0 = gca;
                    a0.ColorOrderIndex = mod(k,numOfColorsInMatlab)+1;
                    meanPlot = plot(ELM_hiddenLayerSizes,mean_ELM_accuracies(k,:),'lineWidth',3);
                    posStdPlot = plot(ELM_hiddenLayerSizes,mean_ELM_accuracies(k,:)+std_ELM_accuracies(k,:));
                    posStdPlot.Color = min(meanPlot.Color + .4,1);
                    negStdPlot         = plot(ELM_hiddenLayerSizes,mean_ELM_accuracies(k,:)-std_ELM_accuracies(k,:));
                    negStdPlot.Color   = min(meanPlot.Color + .4,1);
                    a3                 = gca;
                    a3.ColorOrderIndex = mod(k,numOfColorsInMatlab)+1;
                end
                
                plot(ELM_hiddenLayerSizes,highestLinAccuracy*ones(size(ELM_hiddenLayerSizes)));
                ELM_PlotAxis = gca; % current axes
                ELM_PlotAxis.XColor = 'k';
                ELM_PlotAxis.YColor = 'k';
                ylimit = max(ylim);
                text(max(xlim) , ylimit ,['bestEr:' num2str(highestMean_ELM_accuracy) '+/-' num2str(stdOfbestMean_ELM_accuracy) ' HLN(' num2str(bestHLNs) ') regFact(' num2str(bestELMRegFact) ')GB      toc: ' num2str(timeTakenToRunAllELMs)   's '  ],'horizontalAlignment','right','verticalAlignment','top')
                ylabel(ELM_PlotAxis,'ELM recognition accuracy')
                xlabel(ELM_PlotAxis,'hidden layer size')
            end
        end
    end
    
    
    
end



