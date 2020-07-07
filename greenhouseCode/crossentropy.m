function cost = crossentropy(YtestGroundTruth,YtestOutput_softmax)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
m = length(YtestGroundTruth);
cost=-(1/m)*((YtestGroundTruth(:,1)'*log(YtestOutput_softmax(:,1)))+(1-YtestGroundTruth(:,1))'*log(1-YtestOutput_softmax(:,1)));
end

