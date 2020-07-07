
codeRunningStart = tic;
rng default % for reproducibility
SHOW_ANYTHING                     = 1;%-Simulation-Paramters-------------------------------------------------------------------------
RECORD_VIDEO                      = 0 && SHOW_ANYTHING;
CLEAN_UP_TD                       = 1;
SHOW_CLEANED_UP_TD_RESULTS_FIGURE = 0 && CLEAN_UP_TD && SHOW_ANYTHING;
SHOW_EVENT_SURFACES_ONLINE        = 0 && SHOW_ANYTHING;

FORCE_GENERATE_NEW_DATA             = 0;
FORCE_GENERATE_NEW_TIME_SURF_ARRAY  = 0;
FORCE_GENERATE_NEW_USER_INPUT_ARRAY = 0;

versionNum                    = 1.3;
%dataFolderName = '\ML\data\ATIS\dstgMoonShot\Data\dayLEO\';fileName ='20170322-23-49_INTELSAT_37834.mat'; prctHotPixelsToRemove        = 0;%good
%dataFolderName = '\otherProjects\Chetan\gait\data\'; fileName = 'gait_timedata_v3.mat';    prctHotPixelsToRemove        = 0;
%dataFolderName = '\ML\data\ATIS\dstgMoonShot\Data\dayLEO\atisDvsRec1\'; fileName   = 'canopus_streaks_1603_atis_tdCleaned.mat';prctHotPixelsToRemove        = [];%good
%dataFolderName = '\ML\data\ATIS\dstgMoonShot\Data\dayLEO\'; tdFileName = 'canopus_streaks_td_cleaned.mat';prctHotPixelsToRemove        = [];%good

%initialDataFolderName = '\ML\data\ATIS\dstgMoonShot\Data\userFiles\todoLili';  
%initialDataFolderName = '\ML\data\ATIS\dstgMoonShot\SpaceFest\';  % for star fields using BSI
%initialDataFolderName = 'E:\googleDrive\MATLAB\ML\data\ATIS\aritificialData';  % for ariticial dataset


 %initialTdFullPath = [getMyMatlabPath initialDataFolderName];     
initialTdFullPath = '/media/sami/USB DISK/mat/';

SELECT_NEW_FILES = 0 ||  (~exist('userInputCellArray','var') ) || (~exist('userInputCellArrayRadius','var') );
if SELECT_NEW_FILES
    [tdFileName, tdFullPath, selectedNewTdMatFileFlag] = uigetfile({  '*.mat','MAT-files (*.mat)'},'Please select a Video file',  initialTdFullPath);
    if selectedNewTdMatFileFlag==0
        return
    end
    newFullTdFileName = [ tdFullPath tdFileName]; % Get it via a prompt
    % Ask if you want to load a userInput file ----------
    initialUserInputFullFileName = [tdFullPath   tdFileName(1:end-4) '_userInput_v' num2str(versionNum) tdFileName(end-3:end)];
    choice = questdlg(['Do you want to select a user input file?' newline '(If you select yes and then cancel the program will shut down)'],tdFileName,'Yes','No','No');
    switch choice
        case 'Yes'
            [userInputFileName, userInputFullPath, filterIndex] = uigetfile({  '*.mat','MAT-files (*.mat)'},initialUserInputFullFileName,  tdFullPath);
            if filterIndex==0
                return
            else
                userInputFileSelected = 1;
            end
        case 'No'
            userInputFileSelected = 0;
    end
    
    if userInputFileSelected == 0
        userInputFullFileName = initialUserInputFullFileName;
        LOAD_USER_INPUT_CELL_ARRAY = 0;
    else
        userInputFullFileName = [userInputFullPath,userInputFileName];
        LOAD_USER_INPUT_CELL_ARRAY = 1;
        
    end
end
if FORCE_GENERATE_NEW_DATA || (SELECT_NEW_FILES && selectedNewTdMatFileFlag) || ~exist('nEventsLeftInTd','var') || ~exist('oldFullPathName','var') || ~isequal(newFullTdFileName,oldFullPathName)
    %oldFullPathName = newFullTdFileName;
    %myDataProcessingFolderName = '\ML\data\ATIS\dataAquisitionCode\myAtisLibrary\'; % for generateTimeSurfArrayFromTd
    %addpath(  [ getMyMatlabPath     myDataProcessingFolderName]);
    %addpath(  [ getMyMatlabPath  '\ML\data\ATIS\dataAquisitionCode\ATISLib\']); % for ReadAER
    %--------------------------------------------
    load(newFullTdFileName);
    if CLEAN_UP_TD
        prctHotPixelsToRemove = [];
        [TD,initialStartAndEndTimeIn_uSec,initialStartAndEndIndex]  = cleanUpTd(TD,[],prctHotPixelsToRemove,[],[],SHOW_CLEANED_UP_TD_RESULTS_FIGURE);
        try
            initialStartTimeIn_uSec = initialStartAndEndTimeIn_uSec(1);
            initialEndTimeIn_uSec   = initialStartAndEndTimeIn_uSec(2);
            initialStartIndex       = initialStartAndEndIndex(1);
            initialEndIndex         = initialStartAndEndIndex(2);
        end
        
    end
    [xMax,yMax]             = findxyMaxFromTd(TD);
    nEventsLeftInTd         = numel(TD.ts);
end
if FORCE_GENERATE_NEW_TIME_SURF_ARRAY || (SELECT_NEW_FILES && selectedNewTdMatFileFlag) || ~exist('timeSurfaceArray','var')
    UserInputGettingParameters                        = [];
    tauInSeconds                                      = 1; % in seconds%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    tauIn_uSecs                                       = tauInSeconds*1e6;
    UserInputGettingParameters.tau                    = tauIn_uSecs;
    
%     UserInputGettingParameters.fullTdFileName         = oldFullPathName;
    UserInputGettingParameters.userInputFullFileName  = userInputFullFileName;
    
    sampleIntervalInSeconds                           = 0.01;%.01;% in seconds%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    sampleIntervalIn_uSecs                            = sampleIntervalInSeconds*1e6;
    UserInputGettingParameters.surfaceSampleInterval  = sampleIntervalIn_uSecs;
    UserInputGettingParameters.viewArray              = [90, -90]; % flip x-y axis
    UserInputGettingParameters.versionNum             = versionNum; % default
    UserInputGettingParameters.SHOW_TIME_STAMP_PLOT   = 1;
    UserInputGettingParameters.SHOW_MEMORY_SURFACES_ONLINE = 0;
    UserInputGettingParameters.RECORD_VIDEO                = 0;
    UserInputGettingParameters.SHOW_TIME_STAMP_PLOT        = 0;
    UserInputGettingParameters.saveFileString              = 0;
    [timeSurfaceArray,surfaceSamplingTimeArray,surfaceSamplingIndexArray] = generateTimeSurfArrayFromTd(TD,UserInputGettingParameters);
end
FORCE_GENERATE_NEW_USER_INPUT_ARRAY = 1;
if FORCE_GENERATE_NEW_USER_INPUT_ARRAY || ~exist('userInputCellArray','var') && ~exist('userInputCellArrayRadius','var')
    if LOAD_USER_INPUT_CELL_ARRAY
        load(userInputFullFileName,'userInputCellArray','userInputCellArrayRadius','interpedUserInputCellArray','interpedUserInputCellRadiusArray','UserInputGettingParameters');%%%%%%%%%%%%%%%%%%%%%%%

         userData = load(userInputFullFileName);
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
        
        %%%
        if  isfield(userData,'userInputCellArrayRadius')
            userInputCellArrayRadius = userData.userInputCellArrayRadius;
        else
            userInputCellArrayRadius = {};
        end
        %%%
        
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
        iUser                             = numel(userInputCellArray);
        SHOW_USER_INPUT_CELL_ARRAY_ANIMATION = 0;
        if SHOW_USER_INPUT_CELL_ARRAY_ANIMATION && exist('interpedUserInputCellArray','var') && exist('userInputCellArray','var') && exist('interpedUserInputCellRadiusArray','var') && exist('userInputCellArrayRadius','var')
            nFramesInTimeSurfaceArray = size(timeSurfaceArray,3);
            numFramesToShow = 200;
            for iFrame = round(linspace(1,nFramesInTimeSurfaceArray,numFramesToShow))
                showUserInputCellArray(userInputCellArray,userInputCellArrayRadius,interpedUserInputCellArray,interpedUserInputCellRadiusArray,timeSurfaceArray,surfaceSamplingTimeArray,surfaceSamplingIndexArray,iFrame,UserInputGettingParameters)
            end
        end
    else
        iUser                         = 0;
        userInputCellArray            = {};
        userInputCellArrayRadius      = {};
        objectClassCellArray          = {};
        interpedUserInputCellArray    = {};   
        interpedUserInputCellRadiusArray  = {};
    end
    if ~isempty(userInputCellArray) && ~isempty(userInputCellArrayRadius)
        try
            [nFrame, nObj]             = size(userInputCellArray{1});
            objectClassArray    = ones(1,nObj);
            %objectClassArray(2) = -1;  %         objectClassArray(12) = 2;%archenar_leos_11_33_atis_td.mat DONE
            %objectClassArray(1) = -1;%archenar_leos_11_33_davis_td.mat   % two missing stars in all 10
            
            showUserInputDataIn3d(userInputCellArray,userInputCellArrayRadius,surfaceSamplingTimeArray, objectClassArray)
        catch
        end
    end
    showUserInputCellArray(userInputCellArray,userInputCellArrayRadius,interpedUserInputCellArray,interpedUserInputCellRadiusArray,timeSurfaceArray,surfaceSamplingTimeArray,surfaceSamplingIndexArray,[],UserInputGettingParameters)
    
    codeRunningTimeTaken = toc(codeRunningStart);
    finishedTakingUserInput = 0;
    while ~finishedTakingUserInput
        userTimeTakenStart = tic;
        
        [userInputArray, userInputRadiusArray, objectClassArray]=getUserInputFromFrameArray(timeSurfaceArray,surfaceSamplingTimeArray,surfaceSamplingIndexArray,UserInputGettingParameters,userInputCellArray);
        [userInputArray, userInputRadiusArray, objectClassArray]=sortObjectsInUserInputData(userInputArray,userInputRadiusArray,objectClassArray);
        iUser                             = iUser +1;
        userInputCellArray{iUser}         = userInputArray;
        objectClassCellArray{iUser}       = objectClassArray;
        interpedUserInputCellArray{iUser} = linearInterpolateUserInputData(userInputArray);
        userInputCellArrayRadius{iUser}         = userInputRadiusArray;
        interpedUserInputCellArray{iUser} = linearInterpolateUserInputCellArrayRadiusData(userInputRadiusArray);
        
        %%%%` 
        % Ask-----------------
        choice = questdlg('Do you want to Save the new user input data?','More User Input','Yes','No','No');
        switch choice
            case 'Yes'
                if exist(userInputFullFileName,'file')% keep copy of old file if it exists
                    
                    oldUserInputFullFileName = [userInputFullFileName(1:end-4) '_iUser_' num2str(iUser-1) '_OLD.mat'];
                    movefile(userInputFullFileName,oldUserInputFullFileName,'f');
                    
                end
                userTimeTakenArray(iUser) = toc(userTimeTakenStart);
                save(userInputFullFileName,'objectClassCellArray','userInputCellArray','userInputCellArrayRadius','userTimeTakenArray','codeRunningTimeTaken','UserInputGettingParameters','interpedUserInputCellArray','interpedUserInputCellRadiusArray')
            case 'No'  %keep going
        end
        % Ask-----------------
        choice = questdlg('Do you want to enter user input again?','More User Input','Yes','No','No');
        switch choice
            case 'No'
                break;%enterAnotherUserInputForThisFile = 1;
            case 'Yes'  %keep going
        end
    end
end









