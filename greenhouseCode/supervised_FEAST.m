%% plot ground truth label (spatial coordinate and size) interpolation

if ~isempty(userInputCellArray)
    [nFrame, nObj]      = size(userInputCellArray{1})
end

timeEnd = surfaceSamplingTimeArray(end);
nEvents = numel(TD.ts);
timeNow = 0;
validLabel = 0;
TD.ts = TD.ts/TD.ts(end)*timeEnd;

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

% % Get the indices of the value which is more common (`0` here)
% zeroIdx = find(~TD.c); 
% remIdx = randperm(nnz(~TD.c), nnz(~TD.c) - nnz(TD.c));
% % Remove elements
% TD.x(zeroIdx(remIdx)) = [];
% TD.y(zeroIdx(remIdx)) = [];
% TD.p(zeroIdx(remIdx)) = [];
% TD.ts(zeroIdx(remIdx)) = [];
% TD.c(zeroIdx(remIdx)) = [];

countLabel2 = [0,1]; 
labelOccurencesHistorgam2 = hist(TD.c,countLabel2);
resultcountLabel2 = [countLabel2; labelOccurencesHistorgam2]


% fig=figure(453451);
% showTdIn3d(TD);
% darkBackground(fig,[0 0 0],[1 1 1]);

%figure(6786);bar(countNeuron(1,:))
% for labels = 1:numel(userInputCellArrayInterped(1,:))
%     plot(userInputCellArrayInterped(:,labels));hold on
% end

%%% 3D scatter plot animation
find_all_ground_truth = find(TD.c > 0);
figure(7878);
scatter3(TD.x(find_all_ground_truth,1),TD.y(find_all_ground_truth,1),TD.ts(find_all_ground_truth,1));

%% FEAST Algorithm, Unsupervised feature extraction
idx = 0;
nTD = numel(TD.x);

xs = 346;
ys = 260;

S = zeros(xs,ys); T = S; P = double(T);

tau = 1*1e4; % increase or decrease your exponential decay
displayFreq = 5e4; % For speed in units of time
nextTimeSample = TD.ts(1,1)+displayFreq;

thresholdArray_all = [];

R = 7;
D = 2*R + 1; % D = 21
%number of neurons
nNeuron = 9;
binc = 1:nNeuron;
%learning rate
eta = 0.001;
% Adaptive Positive threshold
thresholdRise = 0.001;
% Adaptive Negative threshold
thresholdFall = 0.002;

figure(4); clf;

sqNeuron = ceil(sqrt(nNeuron));
%weight, random numbersof 
w = rand(D*D,nNeuron);
%w = rand(xs*ys,nNeuron);
for iNeuron = 1:nNeuron
    w(:,iNeuron)       = w(:,iNeuron)./norm(w(:,iNeuron));
end

%Initialize low threshold
threshArray = zeros(1,nNeuron)+0.001;

countArray = zeros(1,nNeuron) + 10;

winnerNeuronArray = TD.x + nan;
% k = 0.5; K_next = 0.5; K_prev = 0.5;
T = T -inf;
T_F(:,:,nNeuron) = T;
T_F = T_F-inf;
P_F = T_F;
countNeuron = nan(2,nNeuron);count0 = 0;count1 = 0;
figure(432432);
pp = plot(winnerNeuronArray); grid on;

a = 1:nTD;
ind = randperm(numel(a));
index = a(ind);
missingCount = 0;


for idx = 1:nTD
    x = TD.x(idx)+1;
    y = TD.y(idx)+1;
    t = TD.ts(idx);
    p = TD.p(idx);
    c = TD.c(idx);
    T(x,y) = t;
    P(x,y) = p;
    
    if c == 0
        %         if TD.c(idx) == 0
        if (x-R>0) && (x+R<xs) && (y-R>0) && (y+R<ys)
            
            ROI = P(x-R:x+R,y-R:y+R).*exp(double((T(x-R:x+R,y-R:y+R)-t))/tau);
            
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
            
            winnerNeuronArray(idx) = winnerNeuron;
            
            %                 thresholdArray_all(idx,:) = threshArray';
            %                 if TD.c(idx) == 1
            %                     count0 = count0 + 1;
            %                     countNeuron(1,winnerNeuron) = count0;
            %                 else
            %                     count1 = count1 + 1;
            %                     countNeuron(2,winnerNeuron) = count1;
            %                 end
            
            T_F(x,y,winnerNeuron) = t;
            P_F(x,y,winnerNeuron) = p;
            
            if t > nextTimeSample
                idx
                threshArray(winnerNeuron);
                winnerNeuron
                set(pp,'YData',winnerNeuronArray(max(idx-1e7,1):idx))
                
                nextTimeSample = max(nextTimeSample + displayFreq,t);
                
                figure(4)
                for iNeuron = 1:nNeuron
                    subplot(sqNeuron,sqNeuron,iNeuron)
                    wShow = reshape(w(:,iNeuron),D,D);
                    wShow(R+1,R+1) = nan;
                    imagesc(wShow);colormap(hot);
                    view([90 90])
                    title([ num2str(threshArray(iNeuron),2)   '-'  num2str(countArray(iNeuron))])
                    set(gca,'visible','off')
                    set(findall(gca, 'type', 'text'), 'visible', 'on')
                end
                
                S_F = exp((T_F-t)/tau/3);
                figure(5)
                for iNeuron = 1:nNeuron
                    subplot(sqNeuron,sqNeuron,iNeuron)
                    imagesc(S_F(:,:,iNeuron)); colormap(hot);
                    view([90 90])
                    set(gca,'visible','off')
                    set(findall(gca, 'type', 'text'), 'visible', 'on')
                end
                eta = eta * 0.999;
                drawnow
            end
        end
        
    end
end

% fig3 = figure(56756);
% countNeuronArray = [countNeuron(1,:)' countNeuron(2,:)'];
% bar(countNeuronArray);
% legend("Circles", "Non-circles")
% darkBackground(fig3,[0 0 0],[1 1 1]);
% 
% fig4 = figure(567550);
% for thres = 1:numel(thresholdArray_all(1,:))
%     plot(thresholdArray_all(:,thres));hold on
%     darkBackground(fig4,[0 0 0],[1 1 1]);
% end

%% Inference
wFrozen = w;

% figure(432432);
% pp = plot(winnerNeuronArray); grid on;
T = T -inf;
T_F(:,:,nNeuron) = T;
T_F = T_F-inf;
P_F = zeros(size(T_F));
countNeuron = nan(2,nNeuron);count0 = 0;count1 = 0;
displayFreq = 5e4; % For speed in units of time
nextTimeSample = TD.ts(1,1)+displayFreq;

T_Fd = zeros(round(size(T_F)./20))-inf;
P_Fd = zeros(round(size(T_Fd))); 
T_FdSimple = T_Fd;
P_FdSimple = P_Fd;
beta = 0.5; oneMinusBeta = 1-beta;

for idx = 1:nTD
    x = TD.x(idx);
    y = TD.y(idx);
    t = TD.ts(idx);
    p = TD.p(idx);
    c = TD.c(idx);
    T(x,y) = t;
    P(x,y) = p;
    
    if c == 0
        if (x-R>0) && (x+R<xs) && (y-R>0) && (y+R<ys)
            
            ROI = P(x-R:x+R,y-R:y+R).*exp(double((T(x-R:x+R,y-R:y+R)-t))/tau);
            
            ROI_norm             = ROI/norm(ROI);
            ROI_ARRAY       = ROI_norm(:)*ones(1,nNeuron);
            dotProds        = sum(bsxfun(@times,wFrozen,ROI_ARRAY),1);
            [C,winnerNeuron ]       = max(dotProds);
            
            winnerNeuronArray(idx) = winnerNeuron;
            
            if TD.c(idx) == 1
                count0 = count0 + 1;
                countNeuron(1,winnerNeuron) = count0;
            else
                count1 = count1 + 1;
                countNeuron(2,winnerNeuron) = count1;
            end
            
            T_F(x,y,winnerNeuron) = t;
            P_F(x,y,winnerNeuron) = p;
            
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
        end
    end
end

fig3 = figure(56756);
countNeuronArray = [countNeuron(1,:)' countNeuron(2,:)'];
countNeuronArray(1,:) = 0
countNeuronArray2 = 100*bsxfun(@rdivide,countNeuronArray,sum(countNeuronArray,1))
bar(countNeuronArray2);
legend("Circles", "Non-circles");
xlabel("Neurons");
ylabel("%");
darkBackground(fig3,[0 0 0],[1 1 1]);

%%
% Neuron testing aka inference && create X and Y vectors
tic;
X_original = nan(nEvents,9*nNeuron);
% coordinate = zeros(nEvents, 3);
wFrozen = w;
downSampleFactor = 10;

xdMax = round(xs/downSampleFactor);
ydMax = round(ys/downSampleFactor);

Y = TD.x+NaN;
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
% D = 2*Radius + 1;
% nextTimeSample = TD.ts(1,1)+displayFreq;
toc;
%%
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
    
    if (x-R>0) && (x+R<xs) && (y-R>0) && (y+R<ys)
        
        ROI = P(x-R:x+R,y-R:y+R).*exp(double((T(x-R:x+R,y-R:y+R)-t))/tau);
        
        if xd>1 && yd>1 &&xd<xdMax && yd<ydMax  % figure out how to find xydMax
        ROI_norm             = ROI/norm(ROI);
        ROI_ARRAY       = ROI_norm(:)*ones(1,nNeuron);
        dotProds        = sum(bsxfun(@times,wFrozen,ROI_ARRAY),1);
        [C,winnerNeuron ]       = max(dotProds);
        
        Valididx = Valididx + 1;
        winnerNeuronArray(Valididx) = winnerNeuron;
        
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
        end
    end
end

X = single(X_original);
findNaN = find(isnan(X));
X = X(1:findNaN(1)-1,:);
figure(76767);imagesc(X)

toc;
%% Setup feature data for the classifier
if length(X0) < length(X1)
    X1 = X1(1:length(X0),:);
else
    X0 = X0(1:length(X1),:);
end
% figure(76768);imagesc(X0)
% figure(76769);imagesc(X1)
X = [X1;X0];
Y = nan(length(X),1);
Y(1:length(X1)/2)=1;
findnan = find(isnan(Y));
Y(findnan(1):end)=0;

