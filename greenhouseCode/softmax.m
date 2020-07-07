function YtestOutputSoftmaxed = softmax(YtestOutput)
dim = 1;
s = ones(1, ndims(YtestOutput));
s(dim) = size(YtestOutput, dim);
maxz = max(YtestOutput, [], dim);
expz = exp(YtestOutput-repmat(maxz, s));
YtestOutputSoftmaxed = expz ./ repmat(sum(expz, dim), s);
end

