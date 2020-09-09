X = [circle; line; star];
X(:,2) = 1:numel(X);

Y = nan(length(X),1);
Y(1:length(circle)+1,1) = 1;Y(length(circle):length(circle)*2+1,1) = 2;Y(length(circle)*2:length(circle)*3,1) = 3;


nEventAfterSkip = round(size(X,1));
trainTestSplitRatio = 0.5;
shuffledIndex = randperm(nEventAfterSkip);

X = X(shuffledIndex,:);
Y = Y(shuffledIndex,:);