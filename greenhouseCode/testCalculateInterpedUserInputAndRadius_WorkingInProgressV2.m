%% Label data

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%If DAVIS or ATIS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TD = struct('x',single(TD.x(1:2500000)),'y',single(TD.y(1:2500000)),'p',single(TD.p(1:2500000)),'ts',TD.ts(1:2500000));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%If ColourDAVIS346%%%%%%%%%%%%%%%%%%%%%%%%%%%
TD = struct('x',single(events(:,2)),'y',single(events(:,3)),'p',single(events(:,4)),'ts',events(:,1), 'colour',single(events(:,5)));
TD.ts = TD.ts - TD.ts(1,1);
TD.ts = single(TD.ts);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%If COLORDAVIS346%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
validLabel = 0;
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
%     userInputCellArrayRadius{1,1} = userInputCellArrayRadius{1,1} + 1i*userInputCellArrayRadius{1,1};
    userInputCellArrayRadiusInterped = calculateMeanInterpedUserInputFromUserInputCellArray(userInputCellArrayRadius);
    userInputCellArrayRadiusInterped = real(userInputCellArrayRadiusInterped);
    userInputCellArrayInterped = calculateMeanInterpedUserInputFromUserInputCellArray(userInputCellArray);
else
%     userInputCellArrayRadius{1,1} = userInputCellArrayRadius{1,1} + 1i*userInputCellArrayRadius{1,1};
    userInputCellArrayRadiusInterped = calculateMeanInterpedUserInputFromUserInputCellArray(userInputCellArrayRadius);
    userInputCellArrayRadiusInterped = real(userInputCellArrayRadiusInterped);
    userInputCellArrayInterped = calculateMeanInterpedUserInputFromUserInputCellArray(userInputCellArray);
end
%%% Imagine above data was real lets find which events are fruits
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
        
        [objx; objy; objRadSquared;] % Xtest = Xtest(iFrame,:)
        
    end
    
    
    for iObj = 1:nObj
%         validLabel = validLabel + 1;
        if ((x - objx(iObj))^2 + (y - objy(iObj))^2)<objRadSquared(iObj) % if Ytest==1
            objectEventIndex = objectEventIndex +1;
            % Class name
            objectTd.x(objectEventIndex) = x;
            objectTd.y(objectEventIndex) = y;
            objectTd.ts(objectEventIndex) = t;
            objectTd.p(objectEventIndex) = 1;
            objectTd.n(objectEventIndex) = iObj; 
            TD.c(idx) = 1;
            TD.n(idx) = iObj;
        end
        
    end
    
end
TD.c(isnan(TD.c))=0;

countLabel = [0,1]; % 102 is fruit 'f' and 110 is non-fruit 'n'
labelOccurencesHistorgram = hist(TD.c,countLabel);
resultcountLabel = [countLabel; labelOccurencesHistorgram]
% 
% fig5 = figure(56719);
% bar(resultcountLabel(2,:))
% title("How many event were labeled fruit/non-fruit")
% darkBackground(fig5,[0 0 0],[1 1 1]);


% fig=figure(453451);
% showTdIn3d(objectTd);
% darkBackground(fig,[0 0 0],[1 1 1]);

%figure(6786);bar(countNeuron(1,:))
% for labels = 1:numel(userInputCellArrayInterped(1,:))
%     plot(userInputCellArrayInterped(:,labels));hold on
% end

%%% 3D scatter plot animation
find_all_ground_truth = find(TD.c > 0);
figure(7878);
scatter3(TD.x(find_all_ground_truth,1),TD.y(find_all_ground_truth,1),TD.ts(find_all_ground_truth,1));

% figure(7879);
% scatter3(objectTd.x, objectTd.y, objectTd.ts);

% %% Under Sample class Method 2: More efficient
% % Get the indices of the value which is more common (`0` here)
% zeroIdx = find(~TD.c); % equivalent to find(Y==0)
% % Get random indices to remove
% remIdx = randperm(nnz(~TD.c), nnz(~TD.c) - nnz(TD.c));
% % Remove elements
% TD.x(zeroIdx(remIdx)) = [];
% TD.y(zeroIdx(remIdx)) = [];
% TD.p(zeroIdx(remIdx)) = [];
% TD.ts(zeroIdx(remIdx)) = [];
% TD.c(zeroIdx(remIdx)) = [];
% 
% countLabel2 = [0,1]; 
% labelOccurencesHistorgam2 = hist(TD.c,countLabel2);
% resultcountLabel2 = [countLabel2; labelOccurencesHistorgam2]



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
% 
tau = 1*1e4; % increase or decrease your exponential decay
displayFreq = 3e4; % For speed in units of time
nextTimeSample = TD.ts(1,1)+displayFreq;

thresholdArray_all = [];
% weightArray_all = [];
% capturedevent = [];

R = 7;
D = 2*R + 1; % D = 21
%number of neurons
nNeuron = 9;
binc = 1:nNeuron;
%learning rate
eta = 0.001;
% Adaptive Positive threshold
thresholdRise = 0.0008;
% Adaptive Negative threshold
thresholdFall = 0.005;
%A 15x15 matrix
% S = zeros(xs,ys); T = S; P = double(T);%-inf;%Negative infinite

% S = zeros(xs,ys); T = S; P = double(T);%-inf;

% T = ExcellentS-inf;:,
figure(4); clf;

sqNeuron = ceil(sqrt(nNeuron));
%weight, random numbersof 
% w = rand(D*D,nNeuron);
%w = rand(xs*ys,nNeuron);
for iNeuron = 1:nNeuron
    w(:,iNeuron)       = w(:,iNeuron)./norm(w(:,iNeuron));
end

% x2 = 0:1:15;
% y2 = normpdf(x2,8,2.15);
% plot(x2,y2)
% xlim([-1 17])

%Initialize low threshold
% threshArray = zeros(1,nNeuron)+0.001;

% %Initialize random threshold
threshArray = rand(1,nNeuron);
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
P_F = T_F;
figure(432432);
pp = plot(winnerNeuronArray); grid on;

a = 1:nTD;
ind = randperm(numel(a));
index = a(ind);
missingCount = 0;
% for epoch = 1:1
% nextTimeSample = TD.ts(1,1)+displayFreq;

for epoch = 1:4
    
    for idx = 1:nTD
        x = TD.x(idx)+1;
        y = TD.y(idx)+1;
        t = TD.ts(idx);
        p = TD.p(idx);
%         c = TD.c(idx);
        T(x,y) = t;
        P(x,y) = p;
        
        %         if TD.c(idx) == 0
        %         if TD.c(idx) == 0
        if (x-R>0) && (x+R<xs) && (y-R>0) && (y+R<ys)
            
            ROI = P(x-R:x+R,y-R:y+R).*exp(double((T(x-R:x+R,y-R:y+R)-t))/tau);
            
            %             ROI = exp(double((T-t))/tau);
            ROI_norm             = ROI/norm(ROI);
            ROI_ARRAY       = ROI_norm(:)*ones(1,nNeuron);
            dotProds        = sum(bsxfun(@times,w,ROI_ARRAY),1);
            [C,winnerNeuron ]       = max(dotProds.*(dotProds > threshArray));
            if all(C==0)
                threshArray = threshArray - thresholdFall;  % example value of  thresholdFall  is 0.002
                missingCount = missingCount' + 1;
            else
                w(:,winnerNeuron)           = w(:,winnerNeuron) + eta*(ROI(:));  % example value of  eta  is 0.001
                
                w(:,winnerNeuron)           = w(:,winnerNeuron)./norm(w(:,winnerNeuron));
                threshArray(winnerNeuron)   = threshArray(winnerNeuron) + thresholdRise;     % example value of  thresholdFall is 0.001
                countArray(winnerNeuron) = countArray(winnerNeuron) + 1;
            end
            %             thresholdArray_all(idx,:) = threshArray';
            winnerNeuronArray(idx) = winnerNeuron;
            
            T_F(x,y,winnerNeuron) = t;
            P_F(x,y,winnerNeuron) = p;
            
            if t > nextTimeSample
                idx
                threshArray(winnerNeuron);
                winnerNeuron
                
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
                    %wShow = reshape(w(:,iNeuron),xs,ys);
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
                
                S_F = exp(double((T_F-t))/tau/3);
                %                 %Feature map
                figure(5)
                for iNeuron2 = 1:nNeuron
                    subplot(sqNeuron,sqNeuron,iNeuron2)
                    imagesc(S_F(:,:,iNeuron2)); colormap(hot);
                    view([90 90])
                    set(gca,'visible','off')
                    set(findall(gca, 'type', 'text'), 'visible', 'on')
                end
                
%                 [M, I] = max(countArray);
%                 figure(6)
%                 imagesc(S_F(:,:,I)); colormap(hot);
%                 view([90 90])
%                 set(gca,'visible','off')
%                 set(findall(gca, 'type', 'text'), 'visible', 'on')
                
                
                %resizing
                %             DS_F = imresize(S_F,1/5);
                %
                %             figure(6)
                %             for iNeuron = 1:nNeuron
                %                 subplot(sqNeuron,sqNeuron,iNeuron)
                %                 imagesc(DS_F(:,:,iNeuron)); colormap(hot);
                %                 view([90 90])
                %                 set(gca,'visible','off')
                %                 set(findall(gca, 'type', 'text'), 'visible', 'on')
                %             end
                %             xd = round(x/20);
                %             yd = round(y/20);
                %             xsd = xs/20;
                %             ysd = ys/20;
                %
                %             T_Fd_featureContext_DSF = DS_F((xd-1):(xd+1),(yd-1):(yd+1),:);
                %             if xd>1 && yd>1 &&xd<xsd && yd<ysd
                %                 figure(7);
                %                 for iNeuron = 1:nNeuron
                %                     subplot(sqNeuron,sqNeuron,iNeuron)
                %                     imagesc(T_Fd_featureContext_DSF(:,:,iNeuron)); colormap(hot);
                %                     view([90 90])
                %                     set(gca,'visible','off')
                %                     set(findall(gca, 'type', 'text'), 'visible', 'on')
                %                 end
                %             end
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
    %     end
    %     epoch
    
end

% countsOccurences = hist(winnerNeuronArray',binc);
% result = [binc; countsOccurences];
% fig2 = figure(56799);
% bar(result(2,:))
% xlabel("# Neurons");
% ylabel("Occurences");
% title("How many time each neuron was selected");
% darkBackground(fig2,[0 0 0],[1 1 1]);


% 
% fig4 = figure(567550);
% for thres = 1:numel(thresholdArray_all(1,:))
%     plot(thresholdArray_all(:,thres));hold on
%     darkBackground(fig4,[0 0 0],[1 1 1]);
% end


%% Neuron testing aka inference && create X and Y vectors
tic;
X_original = eye(nEvents,9*nNeuron);
% coordinate = zeros(nEvents, 3);
wFrozen = w;
downSampleFactor = 10;

xdMax = round(xs/downSampleFactor);
ydMax = round(ys/downSampleFactor);

labels = TD.x+NaN;
% labels = [];
% final_matrix = (TD.x+NaN)';
% labels = TD.x+NaN;
% images = zeros(9,9);

% figure(432432);
% pp = plot(winnerNeuronArray); grid on;

% T = T -inf;
% T_F(:,:,nNeuron) = T;
% T_F = T_F-inf;
% P_F = T_F;

Sd = zeros(xdMax,ydMax); Td = Sd; Pd = double(Td);
Td = Td -inf;
T_Fd(:,:,nNeuron) = Td;
T_Fd = T_Fd-inf;T_FdSimple = T_Fd;
P_Fd = T_Fd;P_FdSimple = P_Fd;
nEvents = numel(TD.ts);
beta = 0.5; oneMinusBeta = 1-beta;
Radius = 7;
countNeuron = nan(2,nNeuron);count0 = 0;count1 = 0;
nextTimeSample = TD.ts(1,1)+displayFreq;
% D = 2*Radius + 1;
% nextTimeSample = TD.ts(1,1)+displayFreq;
toc;
%% Flatten features
tic;
Valididx = 0;

for idx = 1:nEvents
    x = TD.x(idx);
    y = TD.y(idx);
    xd = round(x/downSampleFactor);
    yd = round(y/downSampleFactor);
    p = TD.p(idx);
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
            
            Valididx = Valididx + 1;
            winnerNeuronArray(Valididx) = winnerNeuron;
            
            %         if TLook at this oneD.c(idx) == 1
            %             count0 = count0 + 1;
            %             countNeuron(1,winnerNeuron) = count0;
            %         else
            %             count1 = count1 + 1;
            %             countNeuron(2,winnerNeuron) = count1;
            %         end
            %
            
            T_F(x,y,winnerNeuron) = t;
            P_F(x,y,winnerNeuron) = p;
            
            T_FdSimple(xd,yd,winnerNeuron) = t;
            P_FdSimple(xd,yd,winnerNeuron) = p;
            
            if isinf(T_FdSimple(xd,yd,winnerNeuron))
                T_FdSimple(xd,yd,winnerNeuron) = t;
                T_FdSimple(xd,yd,winnerNeuron) = p;
            else
                T_FdSimple(xd,yd,winnerNeuron) = oneMinusBeta*T_FdSimple(xd,yd,winnerNeuron) + beta*t;
                P_FdSimple(xd,yd,winnerNeuron) = oneMinusBeta*P_FdSimple(xd,yd,winnerNeuron) + beta*p;
            end
            
            % at each event (regardless of label) populate X with the
            % neighbouring 8 pixels from the downsampled feature map
            T_Fd_featureContext = T_FdSimple((xd-1):(xd+1),(yd-1):(yd+1),:);
            P_Fd_featureContext = P_FdSimple((xd-1):(xd+1),(yd-1):(yd+1),:);
            
            S_Fd_featureContext = exp(double(T_Fd_featureContext-t)/tau);
            %             S_Fd_featureContext = P_Fd_featureContext.*exp(double(T_Fd_featureContext-t)/tau);
            
            X_original(Valididx,:) = S_Fd_featureContext(:)'; % X matrix. to later be split into Xtrain and Xtest
          
            %             coordinate(Valididx,1)=xd;coordinate(Valididx,2)=yd;coordinate(Valididx,3)=winnerNeuron;
            if TD.c(Valididx) == 0 % Non-fruit label
                labels(Valididx,1) = 0;  %Y vector to later be split into Ytrain and Ytest
            elseif  TD.c(Valididx) == 1 % Fruit label
                labels(Valididx,1) = 1;
            end
        end
    end
end
toc;

% fig3 = figure(56756);
% countNeuronArray = [countNeuron(1,:)' countNeuron(2,:)'];
% bar(countNeuronArray);
% legend("Circles", "Non-circles")
% darkBackground(fig3,[0 0 0],[1 1 1]);

% X_original = single(X_original);
% labels = single(labels);

% X = single(X_original);Youtput
% Y = single(labels);
%% Visualize features for class 1 and 0

tic;
Valididx = 0;

for idx = 1:nEvents
    x = TD.x(idx);
    y = TD.y(idx);
    xd = round(x/downSampleFactor);
    yd = round(y/downSampleFactor);
    p = TD.p(idx);
    t =  TD.ts(idx);
    c = TD.c(idx);
    T(x,y) = t;
    P(x,y) = p;
    
    if c == 1
        
        if (x-Radius>0) && (x+Radius<xs) && (y-Radius>0) && (y+Radius<ys)
            
            ROI = P(x-Radius:x+Radius,y-Radius:y+Radius).*exp(double((T(x-Radius:x+Radius,y-Radius:y+Radius)-t))/tau);
            
            if x>2 && y>2 &&xd<xs && yd<ys  % figure out how to find xydMax
                ROI_norm             = ROI/norm(ROI);
                ROI_ARRAY       = ROI_norm(:)*ones(1,nNeuron);
                dotProds        = sum(bsxfun(@times,wFrozen,ROI_ARRAY),1);
                [C,winnerNeuron ]       = max(dotProds);
                
                Valididx = Valididx + 1;
                winnerNeuronArray(Valididx) = winnerNeuron;
                
                %         if TD.c(idx) == 1
                %             count0 = count0 + 1;
                %             countNeuron(1,winnerNeuron) = count0;
                %         else
                %             count1 = count1 + 1;
                %             countNeuron(2,winnerNeuron) = count1;
                %         end
                %
                
                T_F(x,y,winnerNeuron) = t;
                P_F(x,y,winnerNeuron) = p;
                
                T_FdSimple(xd,yd,winnerNeuron) = t;
                P_FdSimple(xd,yd,winnerNeuron) = p;
                
                if isinf(T_FdSimple(xd,yd,winnerNeuron))
                    T_FdSimple(xd,yd,winnerNeuron) = t;
                    T_FdSimple(xd,yd,winnerNeuron) = p;
                else
                    T_FdSimple(xd,yd,winnerNeuron) = oneMinusBeta*T_FdSimple(xd,yd,winnerNeuron) + beta*t;
                    P_FdSimple(xd,yd,winnerNeuron) = oneMinusBeta*P_FdSimple(xd,yd,winnerNeuron) + beta*p;
                end
                
                % at each event (regardless of label) populate X with the
                % neighbouring 8 pixels from the downsampled feature map
                T_Fd_featureContext = T_F((x-1):(x+1),(y-1):(y+1),:);
                P_Fd_featureContext = P_F((x-1):(x+1),(y-1):(y+1),:);
                
                ST_F = exp((T_FdSimple-t)/tau/2);
                S_Fd_featureContext = exp(double(T_Fd_featureContext-t)/tau);
                
                % S_Fd_featureContext = P_Fd_featureContext.*exp(double(T_Fd_featureContext-t)/tau);
                
                X_original(Valididx,:) = S_Fd_featureContext(:)'; % X matrix. to later be split into Xtrain and Xtest
                
                figure(45746)
                for iNeuron = 1:nNeuron
                    subplot(sqNeuron,sqNeuron,iNeuron)
                    imagesc(S_Fd_featureContext(:,:,iNeuron)); colormap(hot);
                    view([90 90])
                    set(gca,'visible','off')
                    set(findall(gca, 'type', 'text'), 'visible', 'on')
                    %                     colorbar
                end
                
                if t > nextTimeSample
                    idx
                    winnerNeuron
                    
                    nextTimeSample = max(nextTimeSample + displayFreq,t);
                    
                    S_F = exp((T_F-t)/tau/3);
                    figure(8)
                    for iNeuron = 1:nNeuron
                        subplot(sqNeuron,sqNeuron,iNeuron)
                        imagesc(S_F(:,:,iNeuron)); colormap(hot);
                        view([90 90]);
                        set(gca,'visible','off');
                        set(findall(gca, 'type', 'text'), 'visible', 'on');
                        
                    end
                    
                    eta = eta * 0.999;
                    drawnow
                end
                
                
                
                %             %             coordinate(Valididx,1)=xd;coordinate(Valididx,2)=yd;coordinate(Valididx,3)=winnerNeuron;
                %             if TD.c(Valididx) == 0 % Non-fruit label
                %                 labels(Valididx,1) = 0;  %Y vector to later be split into Ytrain and Ytest
                %             elseif  TD.c(Valididx) == 1 % Fruit label
                %                 labels(Valididx,1) = 1;
                %             end
            end
        end
    end
end
toc;

%% Events skipping and data cleaning
tic;
% nEventsToSkip = 1;
% X = single(X_original(1:nEventsToSkip:end,:));
% Y = single(labels(1:nEventsToSkip:end,1));

X = single(X_original);
Y = single(labels);

% xCoordArray = TD.x(1:nEventsToSkip:end,:);
% yCoordArray = TD.y(1:nEventsToSkip:end,:);
% tsCoordArray = TD.ts(1:nEventsToSkip:end,:);

%%%%%%%%%%%%%%%%%%%%%%%%Only for this dataset "LATEST_fruit10_10mData_labelsOnly_25Labels_with_FEAST_VariablesOnly_USETHIS"%%%%%%%%%%%%%%%%%%%%%%%%
findNaN = find(isnan(Y));
% xCoordArray = xCoordArray(1:findNaN(1),:);
X = X(1:findNaN(1)-1,:);
Y = Y(1:findNaN(1)-1,1);

% findZeros = find(Y > 0);
% X = X(findZeros(1):findZeros(end),:);
% Y = Y(findZeros(1):findZeros(end),1);
figure(678678);imagesc(X);
figure(678679);plot(Y);
xlabel("Event Index");
ylabel("Label");

% xCoordArray = xCoordArray(1:findNaN(1),:);20
% yCoordArray = yCoordArray(1:findNaN(1),1);
% tsCoordArray = tsCoordArray(1:findNaN(1),1);

% Ytrain(11866,1)=0;
% Ytest(11480,1)=0;
% Ytest(638706,1)=0;


% xCoordArray = xCoordArray(1:findNaN(1),:);
% yCoordArray = yCoordArray(1:findNaN(1),:);
% tsCoordArray = tsCoordArray(1:findNaN(1),:);
% coordinate = coordinate(1:findNaN(1),:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% fig3 = figure(56791);
% 
% subplot(1,2,1)
% imagesc(Xtrain)
% title("Xtrain");
% colorbar;
% subplot(1,2,2)
% imagesc(Xtest)
% title("Xtest");
% colorbar;
% darkBackground(fig3,[0 0 0],[1 1 1]);

toc;
%% Under Sample class Method 1: Brute Force
tic;

% find_all_fruit_labels = find(Y > 0);
% X = X(find_all_fruit_labels(1):find_all_fruit_labels(end),:);
% Y = Y(find_all_fruit_labels(1):find_all_fruit_labels(end),1);

find_all_nonlabelled =    find(Y == 0);
find_all_labelled    =    find(Y == 1);

Y(find_all_nonlabelled(1:10:end)) = [];
X(find_all_nonlabelled(1:10:end),:) = [];

countLabel2 = [0,1]; % 102 is fruit 'f' and 110 is non-fruit 'n'
labelOccurencesHistorgam2 = hist(Y,countLabel2);
resultcountLabel2 = [countLabel2; labelOccurencesHistorgam2]

toc;
%% Under Sample class Method 2: More efficient
% Get the indices of the value which is more common (`0` here)
zeroIdx = find(~Y); % equivalent to find(Y==0)
% Get random indices to remove
remIdx = randperm(nnz(~Y), nnz(~Y) - nnz(Y));
% Remove elements
Y(zeroIdx(remIdx)) = [];
X(zeroIdx(remIdx),:)=[];

countLabel2 = [0,1]; 
labelOccurencesHistorgam2 = hist(Y,countLabel2);
resultcountLabel2 = [countLabel2; labelOccurencesHistorgam2]
%% Cross validation Train/Test
tic;
nEventAfterSkip = size(X,1);
trainTestSplitRatio = 0.5;

shuffledIndex = randperm(nEventAfterSkip);
X_shuffled = X(shuffledIndex,:);
Y_shuffled = Y(shuffledIndex,:);

% xCoordArray = xCoordArray(shuffledIndex,:);
% yCoordArray = yCoordArray(shuffledIndex,:);
% tsCoordArray = tsCoordArray(shuffledIndex,:);

% coordinate_shuffle = coordinate(randperm(nEventAfterSkip),:);

Xtrain = X_shuffled(1:floor(nEventAfterSkip*trainTestSplitRatio),:);
Xtest = X_shuffled((floor(nEventAfterSkip*trainTestSplitRatio)+1):end,:);

% coordinate_train = coordinate_shuffle(1:floor(nEventAfterSkip*trainTestSplitRatio),:);

Ytrain = Y_shuffled(1:floor(nEventAfterSkip*trainTestSplitRatio),:);
Ytest = Y_shuffled((floor(nEventAfterSkip*trainTestSplitRatio)+1):end,:);

% xCoordArray = xCoordArray((floor(nEventAfterSkip*trainTestSplitRatio)+1):end,:);
% yCoordArray = yCoordArray((floor(nEventAfterSkip*trainTestSplitRatio)+1):end,:);
% tsCoordArray = tsCoordArray((floor(nEventAfterSkip*trainTestSplitRatio)+1):end,:);

% coordinate_test = coordinate_shuffle(1:floor(nEventAfterSkip*trainTestSplitRatio),:);
% 
Ytrain(find(isnan(Ytrain)),1)=0;
Ytest(find(isnan(Ytest)),1)=0;
Ytrain(:,2)   = ~(Ytrain(:,1));
Ytest(:,2) = ~(Ytest(:,1));

% Xtrain(isinf(Xtrain))=1;
% Xtest(isinf(Xtest))=1;

% figure(312311);
% imagesc(X); colorbar
% 
% figure(312312);
% plot(movmean(Y(:,1),100)); colorbar

% Ytrain(isnan(Ytrain))=1;
% Ytest(isnan(Ytest))=1;
toc;

%% Add noise to the data before classification (e.g. 5 very high, 200 low etc.)
tic;
nEventWithNoise = 5;
Xtrain(1:nEventWithNoise:end,:)=0;
Xtest(1:nEventWithNoise:end,:)=0;
toc;
%% Classification linear/ELM

ClassifierParameters.ELM_hiddenLayerSizes           = 500;
ClassifierParameters.NUM_ELM_SIMULATIONS            = 0;

ClassifierParameters.linRegularizationFactors       = 1e-16;
ClassifierParameters.ELM_regularizationFactors      = 1e-6;
ClassifierParameters.rescaleInputsToNonlinearRegion = 4;
ClassifierParameters.ACCURACY_MEASURE               = 'max';   % this can be 'max' for one hot coding or 'corr' for correlation
ClassifierParameters.GENERATE_RESULTS_PLOT          = 0;
ClassifierParameters.SHOW_ELM_STD_PLOTS             = 0;
ClassifierParameters.SHOW_CLASSIFIER_OUTPUT_PLOT    = 0;

[classificationResult] = doClassification(Xtrain,Ytrain,Xtest,Ytest,ClassifierParameters)

 %% Compute RMSE while increasing hidden neurons, ELM
 
 for i=1:200
     [accuracyTestSigmoid(i), rootMeanSquareErrorPerformanceTrain(i),rootMeanSquareErrorPerformanceTest(i),rootMeanSquareErrorPerformanceTrainRBTF(i),rootMeanSquareErrorPerformanceTestRBTF(i)]=ELM_ComputeRMSE(Xtrain,Ytrain,Xtest,Ytest,i);
     fig = figure(6767);
     subplot(2,1,1)
     plot(rootMeanSquareErrorPerformanceTrain,'g','LineWidth',2);hold on
     plot(rootMeanSquareErrorPerformanceTest,'r','LineWidth',2);
     xlabel("Hidden Nodes")
     ylabel("RMSE")
     legend("Train", "Test")
     grid on
     title(append("Epoch: " + num2str(i) + " " + "Sigmoid"))
     
     subplot(2,1,2)
     plot(rootMeanSquareErrorPerformanceTrainRBTF,'g','LineWidth',2);hold on
     plot(rootMeanSquareErrorPerformanceTestRBTF,'r','LineWidth',2);
     xlabel("Hidden Nodes")
     ylabel("RMSE")
     legend("Train", "Test")
     grid on
     title(append("Epoch: " + num2str(i) + " " + "RBF"))
     darkBackground(fig,[0 0 0],[1 1 1])
     
%      fig2 = figure(6768);
% %      plot(accuracyTestSigmoid,'g','LineWidth',2);hold on
%      plot(accuracyTestSigmoid,'r','LineWidth',2);
%      xlabel("Hidden Nodes")
%      ylabel("Accuracy")
% %      legend("Sigmoid", "RBF")
%      grid on
%      title(append("Epoch: " + num2str(i) + " " + "Sigmoid"))
%      darkBackground(fig2,[0 0 0],[1 1 1])
 end
 
 %% Class activation map / Heat map for FEAST feature
tic;
labelTd = [];
indexCoord = numel(xCoordArray);EventIndex=0;

for element = 1:indexCoord
    xcoord = xCoordArray(element);
    ycoord = yCoordArray(element);
    tscoord = tsCoordArray(element);
    
    if Ytest(element,1) > Ytest(element,2)
        EventIndex = EventIndex +1
        labelTd.x(element) = xcoord;
        labelTd.y(element) = ycoord;
        labelTd.p(element) = 1;
        labelTd.ts(element) = tscoord;
    else
        labelTd.x(element) = xcoord;
        labelTd.y(element) = ycoord;
        labelTd.p(element) = -1;
        labelTd.ts(element) = tscoord;
    end
end
toc;
 %% Class activation map / Heat map for FEAST feature
% tic;
% % timeEnd = surfaceSamplingTimeArray(end);
% % nEvents = numel(TD.ts);
% % timeNow = 0;
% validID = 0;
% iFrame = 1; NEWTd = []; EventIndex = 0;
% TD.ts = TD.ts/TD.ts(end)*timeEnd;
% 
% coordinate_testX = NaN;coordinate_testY = NaN;
% 
% for idx = 1:nEvents
%     x = round(TD.x(idx)/20)+1;
%     y = round(TD.y(idx)/20)+1;
%     t =  TD.ts(idx);
%     
%     while t>surfaceSamplingTimeArray(min(iFrame+1,nFrame)) && iFrame < nFrame
%         iFrame = iFrame + 1;
%         coordinate_testX = coordinate_test(iFrame,1);
%         coordinate_testY = coordinate_test(iFrame,2);
%         [coordinate_testX; coordinate_testY;]
%     end
%     % ((x - objx(iObj))^2 + (y - objy(iObj))^2)
%     if ((x - coordinate_testX)^2 + (y - coordinate_testY)^2) < ((coordinate_testX - (coordinate_testX + 1))^2 + (coordinate_testY - (coordinate_testY+1))^2) % when label is fruit
%         validID = validID + 1;
%         if Ytest(validID,1)==1
%             EventIndex = EventIndex +1;
%             NEWTd.x(EventIndex) = x;
%             NEWTd.y(EventIndex) = y;
%             NEWTd.ts(EventIndex) = t;
%             NEWTd.p(EventIndex) = 1;
%         end
%     end
% end
% toc;














