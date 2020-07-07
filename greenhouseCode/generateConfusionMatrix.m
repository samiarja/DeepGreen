function   [confusionMatrix, varargout ] = generateConfusionMatrix(YgroundTruth,Youtput)
%%%%%%%% Expample inputs (mutuallly exclusive)
%%%%%%%%             male     right-handed 
% YgroundTruth     = [  1          0
%                       1          0
%                       1          0
%                       1          0
%                       1          0
%                       
%                       0          1
%                       0          1
%                       0          1
%                       0          1
%                       0          1
%                       0          1
%                       0          1];
% 
% %%%%%%%%           male     right-handed
% Youtput          = [  1          0
%                       1          0
%                       1          0
%                       0          1
%                       0          1
% 
%                       0          1
%                       0          1
%                       0          1
%                       0          1
%                       0          1
%                       0          1
%                       1          0];
%                           
% %%%%%%%               predicted/classified as 
% %%%%%%%               male       right-handed
% confusionMatrix =  [  3               2          % actually male
%                       1               6   ]      % actually right handed
% 
% confusionMatrixPercent = 100*confusionMatrix/12;
% 
% correctlyLabeledPositives = [3, 6]
% actualPositives           = [5  7]
% 
% sensitivity(1) = 0.60    % 3/5         % sensitivity Male                % what percentage of actual males were correctly labeled as males 
% sensitivity(2) = 0.86    % 6/7         % sensitivity Right-Handed        %   
% 
% correctlyLabeledNegatives = [6 ,3]
% actualNegatives           = [7 ,5]
% specificity(1) = 0.86    % 6/7         % specificity female              % what pecentage of actual females were correctly labeled as female  
% specificity(2) = 0.60    % 3/5         % specificity Right-handed        % 

[numObservation,  numClass]= size(YgroundTruth );

confusionMatrix = zeros(numClass, numClass);

for iObs = 1:numObservation    
    if sum(YgroundTruth(iObs,:))~=1
        iObs
        YgroundTruth(iObs,:)
        error('Each observation should have exactly a single 1 in it and any other output should be zero')
    else
        for iClass = 1:numClass
            if YgroundTruth(iObs,iClass) == 1
                confusionMatrix(iClass,:)  = confusionMatrix(iClass,:) + Youtput(iObs,:);
            end
        end
    end
end

correctlyLabeledPositives = sum(and(YgroundTruth,Youtput),1); % TP
correctlyLabeledNegatives = sum(and(~YgroundTruth,~Youtput),1); % TN

actualPositives = sum(YgroundTruth,1); % 
actualNegatives = sum(~YgroundTruth,1); % 

sensitivity = correctlyLabeledPositives ./ actualPositives; % TP/TP+FN
specificity = correctlyLabeledNegatives ./ actualNegatives; % TN/TN+FP

informedness = sensitivity + specificity - 1;

%confusionMatrixPercent = 100*confusionMatrix/sum(confusionMatrix(:));
confusionMatrixPerClassPercent = nan+ confusionMatrix;
for iClass = 1:numClass
    confusionMatrixPerClassPercent(iClass,:) = 100*confusionMatrix(iClass,:)/sum(confusionMatrix(iClass,:),2);
end

% [c,cm,ind,per] = confusion(YgroundTruth',Youtput')
% plotconfusion(YgroundTruth',Youtput')


if nargout ==2 
    varargout{1} = confusionMatrixPerClassPercent;
elseif nargout ==3     
    varargout{1} = confusionMatrixPerClassPercent;
    varargout{2} = [sensitivity ; specificity; informedness];
end


