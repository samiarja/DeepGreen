%% FEAST Algorithm, Unsupervised feature extraction
idx = 0;
nevents = numel(events(:,1));

% if DAVIS
% xs = 240;
% ys = 180;

%if Prophesee
xs = 346;
ys = 260;

%if DAVIS
S = int64(zeros(xs,ys)); T = S; P = double(T);%-inf;
% 
%if Prophesee
% S = zeros(xs,ys); T = S; P = double(T);

tau = 1*1e4; % increase or decrease your exponential decay
displayFreq = 1e4; % For speed in units of time
nextTimeSample = events(1,4)+displayFreq;
% events(:,4) = events(:,4) - events(1,4);
thresholdArray_all = [];
weightArray_all = [];
capturedevent = [];

R = 7;
D = 2*R + 1; % D = 15
%number of neurons
nNeuron = 16;
binc = 1:nNeuron;
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

winnerNeuronArray = events(:,1) + nan;
% k = 0.5; K_next = 0.5; K_prev = 0.5;
T = T -inf;
T_F(:,:,nNeuron) = T;
T_F = T_F-inf;
P_F = T_F;

figure(432432);
pp = plot(winnerNeuronArray); grid on;

a = 1:nevents;
ind = randperm(numel(a));
index = a(ind);
missingCount = 0;
% for epoch = 1:1
% nextTimeSample = events.ts(1,1)+displayFreq;

for idx = 1:index
    x = events(idx,1)+1;
    y = events(idx,2)+1;
    t = events(idx,4);
    p = events(idx,3);
    T(x,y) = t;
    P(x,y) = p;
    
    %     if p>0
    
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
            for iNeuron = 1:nNeuron
                subplot(sqNeuron,sqNeuron,iNeuron)
                imagesc(S_F(:,:,iNeuron)); colormap(hot);
                view([90 90])
                set(gca,'visible','off')
                set(findall(gca, 'type', 'text'), 'visible', 'on')
            end
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
    
    %     end
end
% end
countsOccurences = histogram(winnerNeuronArray',binc);
result = [binc; countsOccurences];
figure(56799);
bar(result(2,:))