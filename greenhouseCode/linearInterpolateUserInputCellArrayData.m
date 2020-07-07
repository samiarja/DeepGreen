function interpedUserInputCellArray = linearInterpolateUserInputCellArrayData(userInputCellArray)
if isempty(userInputCellArray)
    interpedUserInputCellArray =userInputCellArray;
    return
end

nUser                      = numel(userInputCellArray);
interpedUserInputCellArray = {};
for iUser = 1:nUser
    interpedUserInputCellArray{iUser}         = linearInterpolateUserInputData(userInputCellArray{iUser});
end