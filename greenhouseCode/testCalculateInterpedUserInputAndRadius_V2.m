%% Label data

% load("E:\mat\labeller\Today\R-FEAST.mat");
% TD=single(TD);
% TD = struct('x',TD(:,1),'y',TD(:,2),'p',TD(:,3),'ts',TD(:,4))
% TD.x = single(TD.x);TD.y = single(TD.y);TD.p = single(TD.p);TD.ts = single(TD.ts);
% single(TD.ts); 
% save("E:\mat\labeller\Today\TD.mat")

run test_getUserInputForStarTds.m

%% plot ground truth label (spatial coordinate and size) interpolation
%%% making fake user data ---------------------------

if ~isempty(userInputCellArray)
    [nFrame, nObj]      = size(userInputCellArray{1})
end

% userInputCellArray = {nan(nFrame,nObj)};
% userInputCellArray{1}(3,1) = 20+30i;
% userInputCellArray{1}(7,1) = 30+10i;
% userInputCellArray{1}(5,2) = 5   + 10i;
% userInputCellArray{1}(9,2) = 10  + 5i;
% userInputCellArrayRadius =  {nan(10,2)};
%
% userInputCellArrayRadius{1}
% userInputCellArrayRadius{1}(3,1) = 20;
% userInputCellArrayRadius{1}(7,1) = 15 ;
% userInputCellArrayRadius{1}(5,2) = 5  ;
% userInputCellArrayRadius{1}(9,2) = 5 ;
% userInputCellArray = ()
% userInputRadiusArray = ()
%%% making fake Recording data ---------------------------
% sampleIntervalInSeconds = UserInputGettingParameters.sampleIntervalInSeconds;
% sampleIntervalIn_uSecs = sampleIntervalInSeconds*1e6;
% sampleIntervalIn_uSecs = UserInputGettingParameters.surfaceSampleInterval;
% surfaceSamplingTimeArray = (0:(nFrame-1))*sampleIntervalIn_uSecs;
timeEnd = surfaceSamplingTimeArray(end);
nEvents = numel(TD.ts);
timeNow = 0;

% TD = [];
% for idx = 1:nEvents
%     timeNow = timeNow + round(rand*10);
%     TD.x(idx) = ceil(rand*40);
%     TD.y(idx) = ceil(rand*40);
%     TD.p(idx)  = 1;
%     TD.ts(idx)  = timeNow;
% end
TD.ts = TD.ts/TD.ts(end)*timeEnd;
% figure(453453)
% showTdIn3d(TD);

%%% interpolating  ---------------------------
if ~exist('userInputCellArrayRadius','var')
    userInputCellArrayRadius{1,1} = userInputCellArrayRadius{1,1} + 1i*userInputCellArrayRadius{1,1};
    userInputCellArrayRadiusInterped = calculateMeanInterpedUserInputFromUserInputCellArray(userInputCellArrayRadius);
    userInputCellArrayRadiusInterped = real(userInputCellArrayRadiusInterped);
    userInputCellArrayInterped = calculateMeanInterpedUserInputFromUserInputCellArray(userInputCellArray);
else
    userInputCellArrayRadius{1,1} = userInputCellArrayRadius{1,1} + 1i*userInputCellArrayRadius{1,1};
    userInputCellArrayRadiusInterped = calculateMeanInterpedUserInputFromUserInputCellArray(userInputCellArrayRadius);
    userInputCellArrayRadiusInterped = real(userInputCellArrayRadiusInterped);
    userInputCellArrayInterped = calculateMeanInterpedUserInputFromUserInputCellArray(userInputCellArray);
end
%%% Imagine above data was real lets find which events are fruit
% surfaceSamplingTimeArray
% userInputCellArrayInterped
% userInputCellArrayRadiusInterped
if max(TD.ts)>max(surfaceSamplingTimeArray)
    error('')
end
iFrame = 1; objectTd = []; objectEventIndex = 0;
TD.c = TD.x+nan;
TD.n = TD.x+nan;



for iObj = 1:nObj
    objx(iObj) = real(userInputCellArrayInterped(iFrame,iObj));
    objy(iObj) = -real(1i*userInputCellArrayInterped(iFrame,iObj));
    objRadSquared(iObj) = userInputCellArrayRadiusInterped(iFrame,iObj)^2;
end
for idx = 1:nEvents
    x = TD.x(idx);
    y = TD.y(idx);
    t =  TD.ts(idx);
    while t>surfaceSamplingTimeArray(min(iFrame+1,nFrame)) && iFrame < nFrame
        
        iFrame = iFrame + 1;
        for iObj = 1:nObj
            
            objx(iObj) = real(userInputCellArrayInterped(iFrame,iObj));
            objy(iObj) = -real(1i*userInputCellArrayInterped(iFrame,iObj));
            objRadSquared(iObj) = userInputCellArrayRadiusInterped(iFrame,iObj)^2;
            
        end
        
        [objx; objy; objRadSquared;]
        
    end
    
    for iObj = 1:nObj
        if ((x - objx(iObj))^2 + (y - objy(iObj))^2)<objRadSquared(iObj)
            % Class name
            TD.c(idx) = char('f');
            % Class index
            TD.n(idx) = iObj;
            objectEventIndex = objectEventIndex +1;
            objectTd.x(objectEventIndex) = x;
            objectTd.y(objectEventIndex) = y;
            objectTd.ts(objectEventIndex) = t;
            objectTd.p(objectEventIndex) = 1;
            objectTd.n(objectEventIndex) = iObj;
            
        else
            TD.c(idx) = char('n');
            TD.n(idx) = nan;
           
        end
        
    end
    
end

% figure(453451)
% showTdIn3d(objectTd);
%% FEAST Algorithm, Unsupervised feature extraction
idx = 0;
nTD = numel(TD.x);

% if DAVIS
% xs = 240;
% ys = 180;

%if Prophesee
xs = 640;
ys = 480;

%if DAVIS
% S = int64(zeros(xs,ys)); T = S; P = double(T);%-inf;
% 
%if Prophesee
S = zeros(xs,ys); T = S; P = double(T);

tau = 1*1e4; % increase or decrease your exponential decay
displayFreq = 10e4; % For speed in units of time
nextTimeSample = TD.ts(1,1)+displayFreq;

thresholdArray_all = [];
weightArray_all = [];
capturedevent = [];

R = 7;
D = 2*R + 1; % D = 15
%number of neurons
nNeuron = 16;
%learning rate
eta = 0.001;
% Adaptive Positive threshold
thresholdRise = 0.001;
% Adaptive Negative threshold
thresholdFall = 0.002;
%A 15x15 matrix
% S = zeros(xs,ys); T = S; P = double(T);%-inf;%Negative infinite

% S = zeros(xs,ys); T = S; P = double(T);%-inf;

% T = ExcellentS-inf;:,
figure(4); clf;

sqNeuron = ceil(sqrt(nNeuron));
%weight, random numbersof 
w = rand(D*D,nNeuron);
%w = rand(xs*ys,nNeuron);
for iNeuron = 1:nNeuron
    w(:,iNeuron)       = w(:,iNeuron)./norm(w(:,iNeuron));
end

x2 = 0:1:15;
y2 = normpdf(x2,8,2.15);
% plot(x2,y2)
% xlim([-1 17])

%Initialize low threshold
threshArray = zeros(1,nNeuron)+0.001;

% %Initialize random threshold
% threshArray = rand(1,nNeuron);
% 
% %Initialize gaussian distribution threshold
% threshArray = y2;
% 
% %Initialize high threhold
countArray = zeros(1,nNeuron) + 10;

winnerNeuronArray = TD.x + nan;
% k = 0.5; K_next = 0.5; K_prev = 0.5;
T = T -inf;
T_F(:,:,nNeuron) = T;
T_F = T_F-inf;
P_F = zeros(size(T_F));

figure(432432);
pp = plot(winnerNeuronArray); grid on;

a = 1:nTD;
ind = randperm(numel(a));
index = a(ind);

% for epoch = 1:1
    nextTimeSample = TD.ts(1,1)+displayFreq;
    
    for idx = 1:nTD
        x = TD.x(idx)+1;
        y = TD.y(idx)+1;
        
        t = TD.ts(idx);
        p = TD.p(idx)*2-1;
        T(x,y) = t;
        P(x,y) = p;
        
        if p>0
            
            if (x-R>0) && (x+R<xs) && (y-R>0) && (y+R<ys)
                
                ROI = P(x-R:x+R,y-R:y+R).*exp(double((T(x-R:x+R,y-R:y+R)-t))/tau);
                
                %             ROI = exp(double((T-t))/tau);
                ROI_norm             = ROI/norm(ROI);
                ROI_ARRAY       = ROI_norm(:)*ones(1,nNeuron);
                dotProds        = sum(bsxfun(@times,w,ROI_ARRAY),1);
                [C,winnerNeuron ]       = max(dotProds.*(dotProds > threshArray));
                if all(C==0)
                    threshArray = threshArray - thresholdFall;  % example value of  thresholdFall  is 0.002
                else
                    w(:,winnerNeuron)           = w(:,winnerNeuron) + eta*(ROI(:));  % example value of  eta  is 0.001
                    
                    w(:,winnerNeuron)           = w(:,winnerNeuron)./norm(w(:,winnerNeuron));
                    threshArray(winnerNeuron)   = threshArray(winnerNeuron) + thresholdRise;     % example value of  thresholdFall  is 0.001
                    countArray(winnerNeuron) = countArray(winnerNeuron) + 1;
                    %                 ROI_FS = exp((T_F-winnerNeuron)/tau);
                end
                winnerNeuronArray(idx) = winnerNeuron;
                T_F(x,y,winnerNeuron) = t;
                P_F(x,y,winnerNeuron) = p;
                
                if t > nextTimeSample
                    idx
                    threshArray(winnerNeuron);
                    winnerNeuron;
                    
                    %                 thresholdArray_all = [thresholdArray_all, threshArray(winnerNeuron)];
                    %                 capturedevent = [capturedevent, countArray(winnerNeuron)];
                    %                 missingevent = idx - capturedevent(1,:);
                    %                 weightArray_all = [weightArray_all, w(:,winnerNeuron)];
                    
                    set(pp,'YData',winnerNeuronArray(max(idx-1e7,1):idx))
                    
                    nextTimeSample = max(nextTimeSample + displayFreq,t);
                    
                    figure(4)
                    for iNeuron = 1:nNeuron
                        subplot(sqNeuron,sqNeuron,iNeuron)
                        %subplot(1,nNeuron,iNeuron)
                        %                     wShow = reshape(w(:,iNeuron),xs,ys);
                        wShow = reshape(w(:,iNeuron),D,D);
                        wShow(R+1,R+1) = nan;
                        imagesc(wShow);colormap(hot);
                        view([90 90])
                        %                     title(append(num2str(threshArray(iNeuron),2),'-',num2str(countArray(iNeuron))))
                        title([ num2str(threshArray(iNeuron),2)   '-'  num2str(countArray(iNeuron))])
                        set(gca,'visible','off')
                        set(findall(gca, 'type', 'text'), 'visible', 'on')
                        
                        %                 colorbar
                    end
                    
                    S_F = exp((T_F-t)/tau/3);
                    %                 %Feature map
                    figure(5)
                    for iNeuron = 1:nNeuron
                        subplot(sqNeuron,sqNeuron,iNeuron)
                        imagesc(S_F(:,:,iNeuron)); colormap(hot);
                        view([90 90])
                        set(gca,'visible','off')
                        set(findall(gca, 'type', 'text'), 'visible', 'on')
                    end
                    %resizing
                    DS_F = imresize(S_F,1/40);
                    figure(6)
                    for iNeuron = 1:nNeuron
                        subplot(sqNeuron,sqNeuron,iNeuron)
                        imagesc(DS_F(:,:,iNeuron)); colormap(hot);
                        view([90 90])
                        set(gca,'visible','off')
                        set(findall(gca, 'type', 'text'), 'visible', 'on')
                    end
                    
                    %summation across column (1x24)
                    %                     figure(7)
                    %                     for iNeuron = 1:nNeuron
                    %                         subplot(sqNeuron,sqNeuron,iNeuron)
                    %                         DS_F_count_column = sum(DS_F(:,:,iNeuron));
                    %                         plot(DS_F_count_column);
                    %                     end
                    %summation across row (32x1)
                    %                     figure(8)
                    %                     for iNeuron = 1:nNeuron
                    %                         subplot(sqNeuron,sqNeuron,iNeuron)
                    %                         DS_F_count_row = sum(DS_F(:,:,iNeuron)')';
                    %                         plot(DS_F_count_row);
                    %                     end
                    %flatten layer 32x24 = 768
                    %                 figure(9)
                    %                 for iNeuron = 1:nNeuron
                    %                     F_DS_F = DS_F(:,:,iNeuron);
                    %                     F_DS_F = F_DS_F(:);
                    %                     subplot(sqNeuron,sqNeuron,iNeuron)
                    %                     imagesc(F_DS_F(:,1)); colormap(hot);
                    %                 end
                    
                    
                    eta = eta * 0.999;
                    drawnow
                end
            end
            
            
            
        end
    end
% end


%% Load all variables
% load('recordings/variables1.mat')
%% Neuron testing aka inference && create X and Y vectors

X_original = eye(nEvents,9*nNeuron);

wFrozen = w;
downSampleFactor = 20;

xdMax = xs/downSampleFactor;
ydMax = ys/downSampleFactor;

labels = TD.x+NaN;
% labels = [];
% final_matrix = (TD.x+NaN)';
% labels = TD.x+NaN;
% images = zeros(9,9);

% figure(432432);
% pp = plot(winnerNeuronArray); grid on;
T = T -inf;
T_F(:,:,nNeuron) = T;
T_F = T_F-inf;
P_F = zeros(size(T_F));

Sd = zeros(xdMax,ydMax); Td = Sd; Pd = double(Td);

Td = Td -inf;
T_Fd(:,:,nNeuron) = Td;
T_Fd = T_Fd-inf;
P_Fd = zeros(size(T_Fd));

% T_Fd = zeros(round(T_F(:,:,nNeuron)./downSampleFactor))-inf;
% P_Fd = zeros(round(size(T_Fd)));

T_FdSimple = T_Fd;
P_FdSimple = P_Fd;
beta = 0.5; oneMinusBeta = 1-beta;
Radius = 7;
D = 2*Radius + 1;
nextTimeSample = TD.ts(1,1)+displayFreq;
tic;
for idx = 1:nEvents
    x = TD.x(idx);
    y = TD.y(idx);
    xd = round(x/downSampleFactor);
    yd = round(y/downSampleFactor);
    p = TD.p(idx)*2-1;
    t =  TD.ts(idx);
    T(x,y) = t;
    P(x,y) = p;
    
    if (x-Radius>0) && (x+Radius<xs) && (y-Radius>0) && (y+Radius<ys)
        
        ROI = P(x-Radius:x+Radius,y-Radius:y+Radius).*exp(double((T(x-Radius:x+Radius,y-Radius:y+Radius)-t))/tau);
        if xd>1 && yd>1 &&xd<xdMax && yd<ydMax  % figure out how to find xydMax
        ROI_norm             = ROI/norm(ROI);
        ROI_ARRAY       = ROI_norm(:)*ones(1,nNeuron);
        dotProds        = sum(bsxfun(@times,wFrozen,ROI_ARRAY),1);
        [C,winnerNeuron ]       = max(dotProds);
        
        winnerNeuronArray(idx) = winnerNeuron;
        
        T_F(x,y,winnerNeuron) = t;
        P_F(x,y,winnerNeuron) = p;
        
        T_FdSimple(xd,yd,winnerNeuron) = t;
        P_FdSimple(xd,yd,winnerNeuron) = p;
        
        if isinf(T_FdSimple(xd,yd,winnerNeuron))
            T_FdSimple(xd,yd,winnerNeuron) = t;
            T_FdSimple(xd,yd,winnerNeuron) = p;
        else
            T_FdSimple(xd,yd,winnerNeuron) = oneMinusBeta*T_FdSimple(xd,yd,winnerNeuron) + beta*t;
            T_FdSimple(xd,yd,winnerNeuron) = oneMinusBeta*T_FdSimple(xd,yd,winnerNeuron) + beta*p;
        end
        
            % at each event (regardless of label) populate X with the
            % neighbouring 8 pixels from the downsampled feature map
            T_Fd_featureContext = T_FdSimple((xd-1):(xd+1),(yd-1):(yd+1),:);
            X_original(idx,:) = T_Fd_featureContext(:)'; % X matrix. to later be split into Xtrain and Xtest
            
            if TD.c(idx) == 'n'
                labels(:,idx) = 0;  %Y vector to later be split into Ytrain and Ytest
            elseif  TD.c(idx) == 'f'
                labels(:,idx) = 1;
            end
        end
    end
end
toc;

nEventsToSkip = 100;
X = X_original(1:nEventsToSkip:end,:);
Y = labels(:,1:nEventsToSkip:end);

%%
nEventAfterSkip = size(X,1);
trainTestSplitRatio = 1/2;

X_shuffled = X(randperm(nEventAfterSkip),:);
Y_shuffled = Y(:,randperm(nEventAfterSkip));

Xtrain = X_shuffled(1:floor(nEventAfterSkip*trainTestSplitRatio),:);
Xtest = X_shuffled((floor(nEventAfterSkip*trainTestSplitRatio)+2):end,:);

Ytrain = Y_shuffled(:,1:floor(nEventAfterSkip*trainTestSplitRatio))';
Ytest = Y_shuffled(:,(floor(nEventAfterSkip*trainTestSplitRatio)+2):end)';

Ytrain(isnan(Ytrain))=1;
Ytest(isnan(Ytest))=1;


% find_TD_equal_f = numel(find(TD.c=='f'));find_labels_equal_one = numel(find(labels==1)); % they should be equal
%% only for testing!: Pseudo-inverse Onput to output map
inputChannels = 1;
regularizationFactor = 1e-10;
%no more than billion data points
nData = 700000;
Xtrain = rand(nData,144);
Ytrain = nan(nData,1);
for ii = 1:nData
    if Xtrain(ii,1) >Xtrain(ii,2)
%         Ytrain(ii,2)   = 1;
        Ytrain(ii,1)   = 0;
    else
%         Ytrain(ii,2)   = 0;
        Ytrain(ii,1)   = 1;
    end
end

linearInputToOutputMapping = (Xtrain'*Ytrain)'/(Xtrain'*Xtrain + regularizationFactor*eye(inputChannels,inputChannels)) %Wo = (X'*Y)'/(X'*X+1e-6*eye(size_xall(2),size_xall(2)));

%% Classification

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