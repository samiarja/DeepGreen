function B = onehotcode (A,varargin)
%%% Usage:
% B = onehotcode (A)
% B = onehotcode (A,dim)  % default dim is 2
% -----------------------------------------------------
% Example1:
% A = [
%     0 0 1 2 3 4
%     0 1 1 1 1 1
%     0 0 0 4 4 4]
% B = onehotcode (A)
% B = [
%     1 0 1 0 0 1
%     1 1 1 0 0 0
%     1 0 0 1 1 1];
% -----------------------------------------------------
% Example2:
% A = [
%     0 0 1 2 3 4
%     0 0 0 2 2 2
%     0 0 0 0 0 0];
% B = onehotcode (A,2)
% B = [
%     0 0 0 0 0 1
%     0 0 0 1 1 1
%     0 0 0 0 0 0];
% -----------------------------------------------------
% Example3:
% A = nan(2,2,2)
% A(:,:,1) = [
%     3     0
%     2     2]
% A(:,:,2) = [
%     4     0
%     1     2]
% B = onehotcode (A,3)
% B(:,:,1) =[
%      0     0
%      1     1]
% B(:,:,2) =[
%      1     0
%      0     1]
dimUsedForOneHotCoding  = 1; % default
if nargin>1
    dimUsedForOneHotCoding = varargin{1};
end

sizeOfA = size(A);
nDim    = numel(sizeOfA);
nRow    = sizeOfA(1);
nCol    = sizeOfA(2);
B       = zeros(sizeOfA);

% isInfA  = isinf(A);
% signOfA = sign(A);
% maxValueOfA = realmax(class(A));
% A(isInfA) = 0;

if nDim==2
    if dimUsedForOneHotCoding == 1
        for iCol = 1:nCol
            thisBitOfA           = A(:,iCol);
            thisBitOfB           = thisBitOfA*0;
            [maxOfThisBitOfA] = max(thisBitOfA);
            if maxOfThisBitOfA == 0 && all(thisBitOfA == 0)
                B(:,iCol)          = thisBitOfB;
            else
                thisBitOfB(thisBitOfA  == maxOfThisBitOfA) = 1;
                B(:,iCol)           = thisBitOfB;
            end
        end
    elseif dimUsedForOneHotCoding == 2
        for iRow = 1:nRow
            thisBitOfA           = A(iRow,:);
            thisBitOfB           = thisBitOfA*0;
            [maxOfThisBitOfA] = max(thisBitOfA);
            if maxOfThisBitOfA == 0 && all(thisBitOfA == 0)
                B(iRow,:)           = thisBitOfB;
            else
                thisBitOfB(thisBitOfA  == maxOfThisBitOfA) = 1;
                B(iRow,:)           = thisBitOfB;
            end
        end
    else
        error('wtf')
    end
elseif nDim==3
    nSheets    = sizeOfA(3);
    if dimUsedForOneHotCoding == 1
        for iSheet = 1:nSheets
            for iCol = 1:nCol
                thisBitOfA           = A(:,iCol,iSheet);
                thisBitOfB           = thisBitOfA*0;
                [maxOfThisBitOfA]    = max(thisBitOfA);
                if maxOfThisBitOfA == 0 && all(thisBitOfA == 0)
                    B(:,iCol,iSheet)         = thisBitOfB;
                else
                    thisBitOfB(thisBitOfA  == maxOfThisBitOfA) = 1;
                    B(:,iCol,iSheet)   = thisBitOfB;
                end
            end
        end
    elseif dimUsedForOneHotCoding == 2
        for iSheet = 1:nSheets
            for iRow = 1:nRow
                thisBitOfA           = A(iRow,:,iSheet);
                thisBitOfB           = thisBitOfA*0;
                [maxOfThisBitOfA] = max(thisBitOfA);
                if maxOfThisBitOfA == 0 && all(thisBitOfA == 0)
                    B(iRow,:,iSheet)         = thisBitOfB;
                else
                    thisBitOfB(thisBitOfA  == maxOfThisBitOfA) = 1;
                    B(iRow,:,iSheet)           = thisBitOfB;
                end
            end
        end
    elseif dimUsedForOneHotCoding == 3
        for iRow = 1:nRow
            for iCol = 1:nCol
                thisBitOfA             = A(iRow,iCol,:);
                thisBitOfB             = thisBitOfA*0;
                [maxOfThisBitOfA]      = max(thisBitOfA);
                if maxOfThisBitOfA == 0 && all(thisBitOfA == 0)
                    B(iRow,iCol,:)         = thisBitOfB;
                else
                    thisBitOfB(thisBitOfA  == maxOfThisBitOfA) = 1;
                    B(iRow,iCol,:)         = thisBitOfB;
                end
            end
        end
    end
else
    error('wtf')
end