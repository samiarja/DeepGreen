clear
% load neuron weight
load("recordings/wFrozen.mat");

n = 0;
eta = 0.01;
epoch = 0;
wFrozen = w;
nNeuron = 16;
D = 15;
R = 7;
figure(4)
for iNeuron = 1:nNeuron
    subplot(16,1,iNeuron)
    %subplot(1,nNeuron,iNeuron)
    %wShow = reshape(w(:,iNeuron),xs,ys);
    wShow = reshape(w(:,iNeuron),D,D);
    wShow(R+1,R+1) = nan;
    imagesc(wShow);colormap(hot);
    view([90 90])
    %                     title(append(num2str(threshArray(iNeuron),2),'-',num2str(countArray(iNeuron))))
%     title([ num2str(threshArray(iNeuron),2)   '-'  num2str(countArray(iNeuron))])
    set(gca,'visible','off')
    set(findall(gca, 'type', 'text'), 'visible', 'on')
    
    %                 colorbar
end
%%
inputChannels = 1;
regularizationFactor = 1e-10;
ylabel = [1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0];
% classweight = (ylabel*wFrozen')'/(wFrozen'.*wFrozen' + regularizationFactor*eye(inputChannels,inputChannels));
% Initialize weight as zero
classweight = zeros(1,numel(wFrozen(:,1)));
y_hatvec = ones(1,numel(ylabel));
error = ones(1,numel(ylabel));
threshold = 0;
indexvec = numel(ylabel);
J = [];

tic;
% figure(1);
while epoch < 1000
    for i = 1:indexvec
        % Sum of the dot product
        dotProduct = dot(wFrozen(:,i),classweight);
        % Threshold the result
        if dotProduct > 0
            y_hat = 1;
        else
            y_hat = 0;
        end
        y_hatvec(i) = y_hat;
        % Weight update
        for j = 1:indexvec
            classweight(j) = classweight(j) + eta*(ylabel(j) - y_hatvec(j))*wFrozen(i,j);
        end
    end
    % Compute error, binary cross entropy
    for err = 1:indexvec
        error(err) = (ylabel(err)-y_hatvec(err))^2;
        J = [J,0.5*sum(error)];
        
    end
    epoch = epoch + 1;
%     plot(J);
end
toc;
finalResults = [ylabel',y_hatvec']