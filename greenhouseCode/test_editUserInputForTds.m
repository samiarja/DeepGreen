% dont use! unique file names needed rng default % for reproducibility 
SHOW_ANYTHING                     = 1;%-Simulation-Paramters-------------------------------------------------------------------------
RECORD_VIDEO                      = 0 && SHOW_ANYTHING;
CLEAN_UP_TD                       = 1;
SHOW_CLEANED_UP_TD_RESULTS_FIGURE = 0 && CLEAN_UP_TD && SHOW_ANYTHING;
SHOW_EVENT_SURFACES_ONLINE        = 0 && SHOW_ANYTHING;
versionNum                        = 1;
FORCE_GENERATE_NEW_DATA             = 0;
FORCE_GENERATE_NEW_TIME_SURF_ARRAY  = 0;
FORCE_GENERATE_NEW_USER_INPUT_ARRAY = 0;

%dataFolderName = '\ML\data\ATIS\dstgMoonShot\Data\dayLEO\';fileName ='20170322-23-49_INTELSAT_37834.mat'; prctHotPixelsToRemove        = 0;%good
%dataFolderName = '\otherProjects\Chetan\gait\data\'; fileName = 'gait_timedata_v3.mat';    prctHotPixelsToRemove        = 0;
%dataFolderName = '\ML\data\ATIS\dstgMoonShot\Data\dayLEO\atisDvsRec1\'; fileName   = 'canopus_streaks_1603_atis_tdCleaned.mat';prctHotPixelsToRemove        = [];%good
%dataFolderName = '\ML\data\ATIS\dstgMoonShot\Data\dayLEO\'; tdFileName   = 'canopus_streaks_td_cleaned.mat';prctHotPixelsToRemove        = [];%good

initialDataFolderName = 'E:/mat';
initialTdFullPath = 'E:/mat';

% initialTdFullPath = [myMatlabPath initialDataFolderName];
TOO_MANY_OBJECT_SLOWING_RUN = 0;
SELECT_NEW_FILES = 0 ||  (~exist('userInputCellArray','var') ) || (~exist('userInputCellArrayRadius','var') );
if SELECT_NEW_FILES
    [tdFileName, tdFullPath, selectedNewTdMatFileFlag] = uigetfile({  '*.mat','MAT-files (*.mat)'},'Please select a Video file to view (big brother)',  initialTdFullPath);
    if selectedNewTdMatFileFlag==0
        return
    end
    newFullTdFileName = [ tdFullPath tdFileName]; % Get it via a prompt
    % Ask if you want to load a userInput file ----------
    initialUserInputFullFileName = [tdFullPath   tdFileName(1:end-4) '_userInput_v' num2str(versionNum) tdFileName(end-3:end)];
    
    userInputSelectionChoice = questdlg(['Do you want to select a user input file (little sister)?' newline  'For:' newline tdFileName newline  newline 'In:' newline newline tdFullPath  newline newline  '(If you select yes and then cancel the program will shut down)'],'User Input File','Yes','No','Cancel','No');
    switch userInputSelectionChoice
        case 'Yes'
            autoUserInputSelectionChoice = questdlg('AUTO select user input file (little sister)?',initialUserInputFullFileName,'Yes','No','Cancel','No');
            switch autoUserInputSelectionChoice
                case 'Yes'
                    userInputFullFileName = initialUserInputFullFileName;
                    userInputFileSelected = 1;
                case 'No'
                    [userInputFileName, userInputFullPath, filterIndex] = uigetfile({  '*.mat','MAT-files (*.mat)'},initialUserInputFullFileName,  tdFullPath);
                    if filterIndex==0
                        return
                    else
                        userInputFileSelected = 1;
                        userInputFullFileName = [userInputFullPath,userInputFileName];
                    end
                case 'Cancel'
                    return
            end
        case 'No'
            userInputFileSelected = 0;
            %return
        case 'Cancel'
            return
    end
    if userInputFileSelected == 0
        userInputFullFileName = initialUserInputFullFileName;
        LOAD_USER_INPUT_CELL_ARRAY = 0;
        %return
    else
        LOAD_USER_INPUT_CELL_ARRAY = 1;
        if exist(userInputFullFileName,'file')
            userData = load(userInputFullFileName);
        else
            iUserChoice = questdlg(['Cant find the user file (little sister).'  newline ' Try again... Quiting...'   newline   newline ' and click No on the second question to pick the little sister by hand'] ,'No little sister','OK','OK');    
            return
        end
        if  isfield(userData,'UserInputGettingParameters')
            UserInputGettingParameters = userData.UserInputGettingParameters;
        else
            UserInputGettingParameters = nan;
        end
       
        if  isfield(userData,'userInputCellArray')
            userInputCellArray = userData.userInputCellArray;
        else
            userInputCellArray = {};
        end
        if  isfield(userData,'userInputCellArrayRadius')
            userInputCellArrayRadius = userData.userInputCellArrayRadius;
        else
            userInputCellArrayRadius = {};
        end
        if  isfield(userData,'interpedUserInputCellArray')
            interpedUserInputCellArray = userData.interpedUserInputCellArray;
        else
            try
                interpedUserInputCellArray = {};
                for iUser = 1:numel(userInputCellArray)
                    interpedUserInputCellArray{iUser} = linearInterpolateUserInputData(userInputCellArray{iUser});
                end
            catch
                interpedUserInputCellArray = {};
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if  isfield(userData,'interpedUserInputCellRadiusArray')
            interpedUserInputCellRadiusArray = userData.interpedUserInputRadiusArray;
        else
            try
                interpedUserInputCellRadiusArray = {};
                for iUser = 1:numel(userInputCellArrayRadius)
                    interpedUserInputCellRadiusArray{iUser} = linearInterpolateUserInputData(userInputCellArrayRadius{iUser});
                end
            catch
                interpedUserInputCellRadiusArray = {};
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if  isfield(userData,'objectClassCellArray')
            objectClassCellArray = userData.objectClassCellArray;
        else
            if isfield(userData,'objectClassArray')
                objectClassCellArray = {userData.objectClassArray};
            else
                objectClassCellArray = {};
            end
        end
        if  isfield(userData,'userTimeTakenArray')
            userTimeTakenArray = userData.userTimeTakenArray;
        else
            userTimeTakenArray = [];
        end
    end
    if ~LOAD_USER_INPUT_CELL_ARRAY
        iUser                         = 0;
        userInputCellArray            = {};
        userInputCellArrayRadius      = {};
        objectClassCellArray          = {};
        interpedUserInputCellArray    = {};
        interpedUserInputCellRadiusArray  = {};
    end
end
if FORCE_GENERATE_NEW_DATA || (SELECT_NEW_FILES && selectedNewTdMatFileFlag) || ~exist('nEventsLeftInTd','var') || ~exist('oldFullPathName','var') || ~isequal(newFullTdFileName,oldFullPathName)
    oldFullPathName = newFullTdFileName;
%     myDataProcessingFolderName = '\ML\data\ATIS\dataAquisitionCode\myAtisLibrary\'; % for generateTimeSurfArrayFromTd
%     addpath(  [ getMyMatlabPath     myDataProcessingFolderName]);
%     addpath(  [ getMyMatlabPath  '\ML\data\ATIS\dataAquisitionCode\ATISLib\']); % for ReadAER
    %--------------------------------------------
    load(newFullTdFileName);    
    if CLEAN_UP_TD
        givenStartTimeIn_uSec = 0;
        givenEndTimeIn_uSec = inf;
        prctHotPixelsToRemove             = [];  SHOW_CLEANED_UP_TD_RESULTS_FIGURE = 0 && SHOW_ANYTHING;
        [TD,CleanUpTdResults,CleanUpTdParameters] = cleanUpTd(TD,[givenStartTimeIn_uSec givenEndTimeIn_uSec],prctHotPixelsToRemove,[],[],SHOW_CLEANED_UP_TD_RESULTS_FIGURE);
        TD.ts = TD.ts - TD.ts(1);
    end   
    [xMax,yMax]             = findxyMaxFromTd(TD);
    nEventsLeftInTd         = numel(TD.ts);
end
if FORCE_GENERATE_NEW_TIME_SURF_ARRAY || (SELECT_NEW_FILES && selectedNewTdMatFileFlag) || ~exist('timeSurfaceArray','var')
    UserInputGettingParameters                        = [];
    tauInSeconds                                      = .1; %0.05 in seconds
    tauIn_uSecs                                       = tauInSeconds*1e6;
    UserInputGettingParameters.tau                    = tauIn_uSecs;
    
    UserInputGettingParameters.fullTdFileName         = oldFullPathName;
    UserInputGettingParameters.userInputFullFileName  = userInputFullFileName;
    
    sampleIntervalInSeconds                                = .1;% in seconds
    sampleIntervalIn_uSecs                                 = sampleIntervalInSeconds*1e6;
    UserInputGettingParameters.surfaceSampleInterval       = sampleIntervalIn_uSecs;
    UserInputGettingParameters.viewArray                   = [90, -90]; % flip x-y axis
    UserInputGettingParameters.versionNum                  = versionNum; % default
    UserInputGettingParameters.SHOW_TIME_STAMP_PLOT        = 1;
    UserInputGettingParameters.SHOW_MEMORY_SURFACES_ONLINE = 0;
    UserInputGettingParameters.RECORD_VIDEO                = 0;
    UserInputGettingParameters.SHOW_TIME_STAMP_PLOT        = 0;
    UserInputGettingParameters.saveFileString              = 0;
    [timeSurfaceArray,surfaceSamplingTimeArray,surfaceSamplingIndexArray] = generateTimeSurfArrayFromTd(TD, UserInputGettingParameters);
end

SHOW_COMBINED_TIME_SURF_VIDEO = 0;
if SHOW_COMBINED_TIME_SURF_VIDEO
    f11_eventSurfaceFigureNum = 53454311;
    figure(f11_eventSurfaceFigureNum); clf;%f10_xyLabelFigureNum      = 53454310;
    nFramesInTimeSurfaceArray = size(timeSurfaceArray,3);
    %numFramesToShow = nFramesInTimeSurfaceArray/10;
    numFramesToShow = 100;
    for iFrame = round(linspace(1,nFramesInTimeSurfaceArray,numFramesToShow))
        showUserInputCellArray(userInputCellArray,userInputCellArrayRadius,interpedUserInputCellArray,interpedUserInputCellRadiusArray,timeSurfaceArray,surfaceSamplingTimeArray,surfaceSamplingIndexArray,iFrame,UserInputGettingParameters)
        drawnow
        % pause(.1)
    end
end
if ~TOO_MANY_OBJECT_SLOWING_RUN
    if ~isempty(userInputCellArray) && ~isempty(userInputCellArrayRadius)
        [nFrame, nObj]      = size(userInputCellArray{1});
        if isempty(objectClassCellArray)
            objectClassCellArray = {nan(1,nObj)};    % assume the objects are non regular stars %objectClassCellArray = {-ones(1,nObj)};    % assume the objects are non regular stars
        end
        %objectClassArray(1) = -1;   %archenar_leos_11_33_davis_td.mat   % two missing stars in all 10
        showUserInputDataIn3d(userInputCellArray,userInputCellArrayRadius,surfaceSamplingTimeArray, objectClassCellArray)
    end
    showUserInputCellArray(userInputCellArray,userInputCellArrayRadius,interpedUserInputCellArray,interpedUserInputCellRadiusArray,timeSurfaceArray,surfaceSamplingTimeArray,surfaceSamplingIndexArray,[],UserInputGettingParameters)
end
SHOW_AND_EDIT_SINGLE_USER_TIME_SURF_VIDEO = 1;
if SHOW_AND_EDIT_SINGLE_USER_TIME_SURF_VIDEO
    nUser               = numel(userInputCellArray);
    try
        newObjectClassCellArray = objectClassCellArray;
    catch
        newObjectClassCellArray = {};
    end
    objectClassCellArray
    iUser = 1;
    while 1%for iUser = 1:nUser        
        try
            objectClassArray                 = objectClassCellArray{iUser}; 
        catch
            objectClassArray     = {};
        end
        try
            userInputArray                   = userInputCellArray{iUser};
            userInputSingleCell              = userInputCellArray(iUser);
        catch
            userInputArray       = [];
            userInputSingleCell  = {};
            iUser                = 0;
        end
        %%%
        try
            userInputRadiusArray                   = userInputCellArrayRadius{iUser};
            userInputSingleCellRadius              = userInputCellArrayRadius(iUser);
        catch
            userInputRadiusArray       = [];
            userInputSingleCellRadius  = {};
            iUser                = 0;
        end
        %%%
        try
            interpedUserInputSingleCell      = interpedUserInputCellArray(iUser);
        catch
            interpedUserInputSingleCell = {linearInterpolateUserInputData(userInputArray)};
        end
        %%%
        try
            interpedUserInputSingleCellRadius      = interpedUserInputCellRadiusArray(iUser);
        catch
            interpedUserInputSingleCellRadius = {linearInterpolateUserInputCellArrayRadiusData(userInputRadiusArray)};
        end
        %%%%
        objectClassArray
        iFrame                           = []; % defaults to the last frame
        try
            showUserInputCellArray(userInputSingleCell,userInputSingleCellRadius,interpedUserInputSingleCell,interpedUserInputSingleCellRadius,timeSurfaceArray,surfaceSamplingTimeArray,surfaceSamplingIndexArray,iFrame,UserInputGettingParameters)
        end
        drawnow
        if isempty(userInputCellArray)
            [userInputArray  ,userInputRadiusArray,newObjectClassArray]    = editUserInputArray(timeSurfaceArray,surfaceSamplingTimeArray,surfaceSamplingIndexArray,userInputArray,userInputRadiusArray,UserInputGettingParameters,objectClassArray);
            [userInputArray  ,userInputRadiusArray,newObjectClassArray ]   = sortObjectsInUserInputData(userInputArray,userInputRadiusArray,newObjectClassArray);
            iUser                                     = 1;
            newObjectClassCellArray{iUser}            = newObjectClassArray;
            userInputCellArray{iUser}                 = userInputArray;
            userInputCellArrayRadius{iUser}                 = userInputRadiusArray;
            try
                interpedUserInputCellArray{iUser}         = linearInterpolateUserInputData( userInputArray);
            end
            try
                interpedUserInputCellRadiusArray{iUser}         = linearInterpolateUserInputCellArrayRadiusData( userInputRadiusArray);
            end
        else
            txt = [];
            for iU = 1:nUser
                if iU == iUser
                    userMarker = '===>';
                else
                    userMarker = '         ';
                end
                txt = [txt userMarker 'user = ' num2str(iU) '      Obj = ' num2str(size(userInputCellArray{iU},2)) newline]; %#ok<AGROW>
            end
            txt = ['QUIT' newline txt 'QUIT'];
            iUserChoice = questdlg([txt  newline newline 'Want to Edit?'  newline  newline],'Select to edit?','Yes EDIT','+ User','- User','+ User');
            switch iUserChoice
                case 'Yes EDIT'
                    [userInputArray  ,userInputRadiusArray,newObjectClassArray]    = editUserInputArray(timeSurfaceArray,surfaceSamplingTimeArray,surfaceSamplingIndexArray,userInputArray,userInputRadiusArray,UserInputGettingParameters,objectClassArray);
                    [userInputArray  ,userInputRadiusArray,newObjectClassArray ]   = sortObjectsInUserInputData(userInputArray,userInputRadiusArray,newObjectClassArray);
                    newObjectClassCellArray{iUser}            = newObjectClassArray;
                    userInputCellArray{iUser}                 = userInputArray;
                    userInputCellArrayRadius{iUser}                 = userInputRadiusArray;
                    %interpedUserInputCellArray{iUser}         = linearInterpolateUserInputData( userInputArray);
                    %%%%
                case '+ User'
                    iUser = iUser + 1;
                    % move to the next user
                case '- User'
                    iUser = iUser - 1;
            end
            if iUser > nUser || iUser<1
                iUserQuitChoice = questdlg(['Do you want to Quit?'] ,'Select to edit?','Quit','No','No');
                iUser = min(max(iUser,1),nUser);
                switch iUserQuitChoice
                    case 'Quit'
                        break
                    case 'No'
                        %                     case  'Show Black Lines'
                        %                         testShowBlackLinesScript_v1
                        %                         return
                end
            end
        end
    end
    fillObjectClassChoice = questdlg('Copy star classes for everyone?' ,'fill','Yes MostObjects','Yes last user','No','No');
    switch fillObjectClassChoice
        case 'Yes MostObjects'
            nObjectsInObjectClassCellArray = -1;
            for iUserFind = 1:nUser
                try
                    nObjectInThis = sum(~isnan(newObjectClassCellArray{iUserFind}));
                catch
                    nObjectInThis = 0;
                end
                if nObjectInThis > nObjectsInObjectClassCellArray
                    nObjectsInObjectClassCellArray = nObjectInThis;
                    iUserWithMostObjects = iUserFind;
                end
            end
            if iUserWithMostObjects>0
                bestObjectClassArray = newObjectClassCellArray{iUserWithMostObjects};
                for iUserCopy = 1:nUser
                    newObjectClassCellArray{iUserCopy} = bestObjectClassArray;
                end
            end
            objectClassCellArray = newObjectClassCellArray;
        case 'Yes last user'
            bestObjectClassArray = newObjectClassCellArray{max(iUser-1,1)};
            for iUserCopy = 1:nUser
                newObjectClassCellArray{iUserCopy} = bestObjectClassArray;
            end            
            objectClassCellArray = newObjectClassCellArray;
        case 'No'
    end
    % Ask-----------------
    saveUserInputChoice = questdlg('Do you want to SAVE the new user input data?','More User Input','Yes','No','No');
    switch saveUserInputChoice
        case 'Yes'
            if exist(userInputFullFileName,'file')% keep copy of old file if it exists
                oldUserInputFullFileName = [userInputFullFileName(1:end-4) '_nUser_' num2str(nUser) '_OLD_' round(num2str(rand*100000))  '.mat'];
                movefile(userInputFullFileName,oldUserInputFullFileName,'f');
            end
            save(userInputFullFileName ,'userInputCellArray','userInputCellArrayRadius','UserInputGettingParameters','objectClassCellArray','userTimeTakenArray')     
        case 'No'  %keep going
    end
end

if ~TOO_MANY_OBJECT_SLOWING_RUN
    
    
    combinedObsAndMeanFigureNumber = 42423;
    figure(combinedObsAndMeanFigureNumber); clf; %combined mean and obs
    try
        if ~isempty(userInputCellArray)
            [nFrame, nObj]      = size(userInputCellArray{1});
            if isempty(objectClassCellArray)
                objectClassCellArray = {nan(1,nObj)};    % assume the objects are non regular stars %objectClassCellArray = {-ones(1,nObj)};    % assume the objects are non regular stars
            end
            %objectClassArray(2) = -1;  %         objectClassArray(12) = 2;%archenar_leos_11_33_atis_td.mat DONE
            %objectClassArray(1) = -1;   %archenar_leos_11_33_davis_td.mat   % two missing stars in all 10
            showUserInputDataIn3d(userInputCellArray,userInputCellArrayRadius,surfaceSamplingTimeArray, objectClassCellArray,{},combinedObsAndMeanFigureNumber)
        end
        nUser                       = numel(userInputCellArray);
        [nFrame, nObj]             = size(userInputCellArray{1});
        %objectClassArray = -ones(1,nObj);
        %meanIntepredUserInputArray = calculateMeanInterpedUserInputFromUserInputCellArray(userInputCellArray, objectClassCellArray{1});
        meanIntepredUserInputArray = calculateNanMeanInterpedUserInputFromUserInputCellArray(userInputCellArray, objectClassCellArray{1});
        %showUserInputCellArray(userInputSingleCell,{nanMeanIntepredUserInput},timeSurfaceArray,surfaceSamplingTimeArray,surfaceSamplingIndexArray,iFrame,UserInputGettingParameters,[],2)
        xMeanIntepredUserInput = real(meanIntepredUserInputArray);
        yMeanIntepredUserInput = imag(meanIntepredUserInputArray);
        yMeanIntepredUserInput(yMeanIntepredUserInput == 0) = nan;
        
         
        
        surfaceSamplingTimeArray1 = zeros(size(meanIntepredUserInputArray))+surfaceSamplingTimeArray';
         plot3(xMeanIntepredUserInput,yMeanIntepredUserInput,surfaceSamplingTimeArray1,'.k','MarkerSize',3)
        plot3(xMeanIntepredUserInput,yMeanIntepredUserInput,surfaceSamplingTimeArray1,'-','color',[1 1 1]/2)
        %           xMeanIntepredUserInputS = smooth(real(meanIntepredUserInputArray),5,'moving');
        %         yMeanIntepredUserInputS = smooth(imag(meanIntepredUserInputArray),5,'moving');
        %         plot3(xMeanIntepredUserInputS,yMeanIntepredUserInputS,surfaceSamplingTimeArray1,'.b','MarkerSize',3)
        grid on;
        xlabel('x')
        ylabel('y')
        zlabel('time')
    catch
    end
    
    
end

% point = [1,2,3];
% normal = [1,2,2];
% t=(0:10:360)';
% circle0=[cosd(t) sind(t) zeros(length(t),1)];
% r=vrrotvec2mat(vrrotvec([0 0 1],normal));
% circle=circle0*r'+repmat(point,length(circle0),1);
% patch(circle(:,1),circle(:,2),circle(:,3),.5);
% axis square; grid on;
% %add line
% line=[point;point+normr(normal)]
% hold on;plot3(line(:,1),line(:,2),line(:,3),'LineWidth',5)

