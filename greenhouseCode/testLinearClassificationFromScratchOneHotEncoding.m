% In this example we have 

inputChannels = 1;
regularizationFactor = 1e-10;
%no more than billion data points
nData = 1000;
X = rand(nData,144);
Y = nan(nData,1);

nEventAfterSkip = size(X,1);
trainTestSplitRatio = 0.5;

Y(1:250,1) = 1;
Y(251:500,1) = 2;
Y(501:750,1) = 3;
Y(751:nData,1) = 4;

YoneHotEncoded = bsxfun(@eq, Y(:), 1:max(Y)); % apply one hot encoding

shuffledIndex = randperm(nEventAfterSkip);
X = X(shuffledIndex,:);
Y = Y(shuffledIndex,:);
YoneHotEncoded = YoneHotEncoded(shuffledIndex,:);


% for ii = 1:nData
%     if Xtrain(ii,1) >Xtrain(ii,2)
% %         Ytrain(ii,2)   = 1;
%         Ytrain(ii,1)   = 0;
%     else
% %         Ytrain(ii,2)   = 0;
%         Ytrain(ii,1)   = 1;
%     end
% end

% frozenWeight = rand(16,255);
% Ytrain = eye(1000,1);
% for i = 1:numel(Xtrain(:,1:end))
%     Xtrain(:,i) = rand(1000,1);
% end

linearInputToOutputMapping = (X'*Y)'/(X'*X + regularizationFactor*eye(inputChannels,inputChannels)) %Wo = (X'*Y)'/(X'*X+1e-6*eye(size_xall(2),size_xall(2)));

YoutputPrediction = X * linearInputToOutputMapping';
