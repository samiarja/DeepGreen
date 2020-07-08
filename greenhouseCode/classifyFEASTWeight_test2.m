tic;
Valididx = 0;
nNeuron = 16;
countNeuron = nan(2,nNeuron);
sqNeuron = ceil(sqrt(nNeuron));
Radius = 5;
D = 2*Radius + 1; % D = 15
count0 = 0;count1 = 0;
wFrozen = w;
S = zeros(xs,ys); T = S; P = double(T);
T = T -inf;
T_F(:,:,nNeuron) = T;
T_F = T_F-inf;
P_F = T_F;

for idx = 1:nTD
    
    x = TD.x(idx);
    y = TD.y(idx);
    p = TD.p(idx);
    t =  TD.ts(idx);
    T(x,y) = t;
    P(x,y) = p;
    
    if (x-Radius>0) && (x+Radius<xs) && (y-Radius>0) && (y+Radius<ys)
        
        ROI = P(x-Radius:x+Radius,y-Radius:y+Radius).*exp(double((T(x-Radius:x+Radius,y-Radius:y+Radius)-t))/tau);
        % normalizing ROI
        ROI_norm             = ROI/norm(ROI);
        ROI_ARRAY       = ROI_norm(:)*ones(1,nNeuron);
        % element wise binary operation
        dotProds        = sum(bsxfun(@times,wFrozen,ROI_ARRAY),1);
        [C,winnerNeuron ]       = max(dotProds);
        
        Valididx = Valididx + 1;
        winnerNeuronArray(idx) = winnerNeuron;

%         T_F(x,y,winnerNeuron) = t;
%         P_F(x,y,winnerNeuron) = p;
        
%         figure(4);
%         S_D = exp(double(T_F-t)/tau);
%         imagesc(S_D(:,:,winnerNeuron));view([90 90]);
        
%         for iNeuron = 1:nNeuron
%             subplot(sqNeuron,sqNeuron,iNeuron)
%             S_D = exp(double(T_F-t)/tau);
%             imagesc(S_D(:,:,iNeuron));colormap(hot);
%             view([90 90]);
%             set(gca,'visible','off');
%             set(findall(gca, 'type', 'text'), 'visible', 'on');
%         end
        
        if TD.c(idx) == 1
%             figure(4);
%             S_D = exp(double(T_F-t)/tau);
%             imagesc(S_D(:,:,winnerNeuron));view([90 90]);
            count0 = count0 + 1;
            countNeuron(1,winnerNeuron) = count0;
            
        else- Everything else
%             figure(5);
%             S_D = exp(double(T_F-t)/tau);
%             imagesc(S_D(:,:,winnerNeuron));view([90 90]);
            count1 = count1 + 1;
            countNeuron(2,winnerNeuron) = count1;
        end
        

    end
end
toc;
test = [countNeuron(1,:)' countNeuron(2,:)']
figure(56756);bar(test);
figure(56757);bar(countNeuron(2,:));
%%
corrArray = nan(1,nNeuron);

for idx = 1:numel(corrArray)
    results = countNeuron(2,idx)/countNeuron(2,idx)+countNeuron(1,idx);
    corrArray(:,idx) = results;
end
figure(56758);bar(corrArray);
%%
fig=figure(6786);
% subplot(1,3,1)
% bar(normalize(corrArray,2,'range')*100,'r')
% xlabel("Neuron Index");
% ylabel("% of Winner Neuron");
% title("Ratio between class 1 and class 0");

subplot(1,2,1)
bar(normalize(countNeuron(1,:),2,'range')*100,'r')
xlabel("Neuron Index");
ylabel("% of Winner Neuron");
title("Winner Neuron for Label 1");

subplot(1,2,2)
bar(normalize(countNeuron(2,:),2,'range')*100,'r')
xlabel("Neuron Index");
ylabel("% of Winner Neuron");
title("Winner Neuron for Label 0");

set(gcf, 'Position',  [100, 100, 1500, 600])
darkBackground(fig,[0 0 0],[1 1 1]);

%% Inference
wFrozen = w;

% figure(432432);
% pp = plot(winnerNeuronArray); grid on;
T = T -inf;
T_F(:,:,nNeuron) = T;
T_F = T_F-inf;
P_F = zeros(size(T_F));

T_Fd = zeros(round(size(T_F)./20))-inf;
P_Fd = zeros(round(size(T_Fd))); 
T_FdSimple = T_Fd;
P_FdSimple = P_Fd;
beta = 0.5; oneMinusBeta = 1-beta;
displayFreq = 1e4;
% a = 1:nevents;
% ind = randperm(numel(a));
% index = a(ind);

% for epoch = 1:10

% nextTimeSample = TD.ts(1,1)+displayFreq;

for idx = 1:nEvents
    x = TD.x(idx)+1;
    y = TD.y(idx)+1;
    xd = round(x/10);
    yd = round(y/10);
    %         if x > 10
    %             xd = round(x/10);
    %         end
    %         if y > 10
    %             yd = round(y/10);
    %         end
    t = TD.ts(idx);
    p = TD.p(idx)*2-1;
    T(x,y) = t;
    P(x,y) = p;
    
    if (x-R>0) && (x+R<xs) && (y-R>0) && (y+R<ys)
        
        ROI = P(x-R:x+R,y-R:y+R).*exp(double((T(x-R:x+R,y-R:y+R)-t))/tau);
        
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
        
        if t > nextTimeSample
            idx
            winnerNeuron
            
            %                 set(pp,'YData',winnerNeuronArray(max(idx-1e7,1):idx))
            nextTimeSample = max(nextTimeSample + displayFreq,t);
            
            S_F = exp((T_F-t)/tau/3);
            %Feature map after FEAST
            figure(8)
            for iNeuron = 1:nNeuron
                subplot(sqNeuron,sqNeuron,iNeuron)
                imagesc(S_F(:,:,iNeuron)); colormap(hot);
                view([90 90]);
                set(gca,'visible','off');
                set(findall(gca, 'type', 'text'), 'visible', 'on');
                
            end
            %                 %spatial downsampling from 640x480 = 32x24
%             DS_F = imresize(S_F,1/10);
%             figure(6)
%             for iNeuron = 1:nNeuron
%                 subplot(sqNeuron,sqNeuron,iNeuron)
%                 imagesc(DS_F(:,:,iNeuron)); colormap(hot);
%             end
            %                 %summation across column (1x24)
            %                 figure(7)
            %                 for iNeuron = 1:nNeuron
            %                     DS_F_count_column = sum(DS_F(:,:,iNeuron));
            %                     subplot(sqNeuron,sqNeuron,iNeuron)
            %                     plot(DS_F_count_column);
            %                 end
            %                 %summation across row (32x1)
            %                 figure(8)
            %                 for iNeuron = 1:nNeuron
            %                     DS_F_count_row = sum(DS_F(:,:,iNeuron)')';
            %                     subplot(sqNeuron,sqNeuron,iNeuron)
            %                     plot(DS_F_count_row);
            %                 end
            %                 %flatten layer 32x24 = 768
            %                 figure(9)
            %                 for iNeuron = 1:nNeuron
            %                     F_DS_F = DS_F(:,:,iNeuron);
            %                     F_DS_F = F_DS_F(:);
            %                     subplot(sqNeuron,sqNeuron,iNeuron)
            %                     imagesc(F_DS_F(:,1)); colormap(hot);
            %                 end
            
            %                 downsample straight after winning neuron
%             figure(7);
%             S_FdSimple = exp((T_FdSimple-t)/tau/3);
%             for iNeuron = 1:nNeuron
%                 subplot(sqNeuron,sqNeuron,iNeuron)
%                 imagesc(S_FdSimple(:,:,iNeuron)); colormap(hot);
%             end
%             
            %                 figure(11)
            
            %                 figure(6)
            %                 for iNeuron = 1:nNeuron
            %                     plot(w(:,winnerNeuron));
            %                     grid on
            %                 end
            
            %                 drawnow
        end
    end
end

% end


