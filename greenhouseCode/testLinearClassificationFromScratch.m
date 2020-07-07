% In this example we have  
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

% frozenWeight = rand(16,255);
% Ytrain = eye(1000,1);
% for i = 1:numel(Xtrain(:,1:end))
%     Xtrain(:,i) = rand(1000,1);
% end

linearInputToOutputMapping = (Xtrain'*Ytrain)'/(Xtrain'*Xtrain + regularizationFactor*eye(inputChannels,inputChannels)) %Wo = (X'*Y)'/(X'*X+1e-6*eye(size_xall(2),size_xall(2)));

YoutputPrediction = Xtrain * linearInputToOutputMapping';