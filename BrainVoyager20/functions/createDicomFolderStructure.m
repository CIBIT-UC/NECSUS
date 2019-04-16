function [ success ] = createDicomFolderStructure( dConfigs )
% createDicomFolderStructure creates a structured folder based on the DICOM
% files and config files
% input -
%   datasetConfigs presents the specifications of the experiment
% output -
%   success: True if folder is created correctly, False if folder was not
%   created
%
% Version 1.0
% - Overall restructure NECSUS
%
% Author: Bruno Direito (2018)

%% Configs and presets
success = false;

% Get all the DICOM files available in the raw data folder from MR scanner.
D = dir( fullfile(dConfigs.rawData,'*.ima') ); % .IMA extension

% Check total number of required files in configs
if (length(D) < sum(dConfigs.volumes(dConfigs.subjectRunsOrder)) ...
        && length(D)>5)
    fprintf('[debug:createDicomFolderStructure] Fewer files than expected.\n');
elseif (length(D) < sum(dConfigs.volumes(dConfigs.subjectRunsOrder))...
        && length(D) < 5)
    D = dir(fullfile(dConfigs.rawData,'*.dcm')); % .dcm extension
end

files = {D.name};

%% identify number of runs in DICOM files
series=checkAvailableRuns(files);

% Get number of runs defined in the configs file.
nRuns=dConfigs.nRuns;


%% Check for incomplete runs or extra runs
% Should allow for multiple anatomical scans, three pRF runs and four
% contrast task
if length(series.sNumbers)~=nRuns
    
    % Array with series numbers left.
    sLeftInArr=series.sNumbers;
    
    % Evaluate if number of runs greater than identified in configs.
    if length(sLeftInArr)>nRuns
        
        fprintf('[debug:createDicomFolderStructure] More series than runs identified in configs.\n');
        
        % Add to ignore if number of volumes different from configs.
        sToRemove = series.sNumbers(ismember(series.sVolumes, dConfigs.volumes)==0);
        
        
        % --- Check for multiple anat runs ---
        aRunsIdxs=checkMultipleAnat(dConfigs,series);
        
        % Remove anat runs from array with remaining runs.
        sLeftInArr(find(ismember(sLeftInArr,aRunsIdxs)))=[];
        
        % --- Check for func runs ---
        [fRunsIdxs,funcDefault] =checkMultipleFunc(dConfigs,series,sLeftInArr);
        
        
        % --- Remove series ---
        % If number of runs different from configs user must validate
        removeFinished = 0;
        boolInput=0;
        
        while ~(boolInput || removeFinished)
            inputStr = input(...
                ['[debug:createDicomFolderStructure] Please input the series to ignore( ', num2str( sLeftInArr' ) ' ):' ],...
                's');
            
            if ~ismember( str2double(inputStr),sLeftInArr )
                fprintf(['[debug:createDicomFolderStructure]'
                    ' ERROR: Incorrect series number.\n']);
            else
                % Series to remove from array.
                sToRemove = str2double(inputStr) ;
                fprintf(strcat('[debug:createDicomFolderStructure]',...
                    ' Ignoring files with series number %s.\n'),...
                    inputStr);
                sLeftInArr(sLeftInArr==sToRemove)=[];
                
                % Remaining series in array.
                fprintf(strcat('[debug:createDicomFolderStructure]',...
                    ' %s extra series remain (func.).\n'),...
                    num2str(length(sLeftInArr)-length(funcDefault)));
                
                % If number of functional runs equals the predefined.
                if sLeftInArr==length(funcDefault)
                    removeFinished = 1;
                    break,% confirm
                end
            end
            
            inputStr = input(strcat('[debug:createDicomFolderStructure]',...
                ' Continue to remove series (y/n): '),...
                's');
            if inputStr == 'n'
                boolInput = 1;
            end
        end
        
        % Evaluate if number of runs fewer than identified in configs.
    elseif length(series.sNumbers) < length(dConfigs.runs)
        fprinf('[debug:createDicomFolderStructure] Unsufficient data. Less series than runs identified in configs.\n')
        fprinf('[debug:createDicomFolderStructure] Proceed with caution.\n')
    end
end



%% Define folder creation for DICOM files per run

% ---- Check and create Project folder ----
% project folder path + foldername  to create
projectFolder = fullfile(dConfigs.path, dConfigs.project_name);

boolInput = false;

% if exist - do not create/overwrite/stop and re-check
if ~exist( projectFolder,'dir') == 7
    mkdir(projectFolder)
end

% ---- Check and create Subject folder ----
% Participant's folder - project folder + subject code
partFolder = fullfile( projectFolder, char(dConfigs.subjectCode));

if ~exist(partFolder,'dir') == 7
    mkdir(partFolder)
end

% ---- Check and create Session folder ----
% Session's folder - participant folder + session code
sessFolder = fullfile( partFolder, char(dConfigs.sessionCode));

if ~exist(sessFolder,'dir') == 7
    mkdir(sessFolder)
end
%%
% ---- Check and create a folder for each run ----
% Run folder - session folder + data type


% Create Anatomical folders / aRunsIdxs.
for a = 1:length(aRunsIdxs)
    
    dataType='anat';
    
    % {'T1w'  'retinotopia-8bar'  'glare'  'noglare'}
    acqDescr=dConfigs.task{1};
    
    % Get files idxs from run r.
    filesIdxs=find(series.runIdxPerFile==aRunsIdxs(a));
    
    % Read first file.
    dcmFileInfo=dicominfo(fullfile(dConfigs.rawData, files{filesIdxs(1)}));
    
    % Set name of anat run according to number of project
    % previously created
    
    % --------------
    % sub-<participant_label>/[ses-<session_label>/]
    %   anat/
    %   sub-<participant_label>[_ses-<session_label>][_acq-<label>][_ce-<label>][_rec
    %   -<label>][_run-<index>][_mod-<label>]_<modality_label>.nii[.gz]
    
    % Name of the anatomical project.
    anatProjName=[dConfigs.subjectCode '_' ...
        dConfigs.sessionCode '_' ...
        'run-' num2str(a) '_' ...
        acqDescr];
    
    folderPath_=fullfile(sessFolder,...
        dataType,...
        ['run-' num2str(a) '_' acqDescr]);
    
    if ~(exist(folderPath_,'dir') == 7)
        
        % Create folder structure.
        mkdir(folderPath_);
        mkdir(fullfile(folderPath_,'PROJECT'));
        
        % Create a copy of the raw files.
        anatProject = fullfile(folderPath_,'DATA');
        mkdir(anatProject);
        
        % Copy data files
        for f = filesIdxs'
            [success]=copyfile(fullfile(dConfigs.rawData, files{f}),...
                anatProject);
        end
    else
        fprintf('[createFolderStructure] !---> folder ** %s ** previously created. \n',...
            anatProjName)
    end
end


for r = 1:length(sLeftInArr)
    
    % Get dataType (anat/func) and dataset description.
    dataType='func';
    
    funcPreDef=find(dConfigs.subjectRunsOrder~=1);
    
    if length(sLeftInArr)~=length(funcPreDef)
        disp('WARNING! number of functional runs different from expected'); 
    end
    
    % ---- BIDS ----
    
    % ---
    % sub-<participant_label>[_ses-<session_label>][_acq-<label>][_rec-<label>][_run-<index>]_<modality_label>.nii[.gz]
    % ---
    acqDescr=dConfigs.task{dConfigs.subjectRunsOrder(funcPreDef(r))};
    fprintf('[createFolderStructure] Series num: %i, data type: %s \n',sLeftInArr(r),acqDescr)
    
    % Folder with functional data.
    dataTypeRoot=fullfile(sessFolder,dataType);
    
    % check if it was previously created
    % Try to create dataType folder
    if ~(exist( dataTypeRoot,'dir') == 7)
        mkdir( dataTypeRoot );
    else
        fprintf( '[debug:createDicomFolderStructure] folder ** %s ** was previously created. \n', dataType )
    end
    
    % Check for func runs previously created of same type.
    funcProjIdx=numel(find(dConfigs.subjectRunsOrder(funcPreDef(1:r))==dConfigs.subjectRunsOrder(funcPreDef(r))));
    
    % Name of the anatomical project.
    funcProjName = [...
        dConfigs.subjectCode ...
        '_' ...
        dConfigs.sessionCode ...
        '_' ...
        'run-' num2str(funcProjIdx) ...
        '_' ...
        acqDescr...
        ];
    
    % ---
    % sub-<participant_label>[_ses-<session_label>]_task-<task_label>[_acq-<label>][_rec-<label>][_run-<index>]_bold.nii[.gz]
    % ---
    
    % Get files idxs from run
    filesIdxs = find(series.runIdxPerFile==sLeftInArr(r));
    
    % Read first file
    dicomFileInfo = dicominfo( fullfile(dConfigs.rawData, files{filesIdxs(1)}) );
    
    % If type of run = func
    if ~(exist(fullfile(sessFolder,dataType,[acqDescr '_run-' num2str(funcProjIdx)]),'dir') == 7)
        
        % Create folder structure.
        mkdir(fullfile(sessFolder,dataType,[acqDescr '_run-' num2str(funcProjIdx)]));
        % Project results structure.
        projectFolder=fullfile(sessFolder,dataType,[acqDescr '_run-' num2str(funcProjIdx)],'PROJECT');
        mkdir(projectFolder);
        % Data copy folder.
        dataFolder=fullfile(sessFolder,dataType,[acqDescr '_run-' num2str(funcProjIdx)],'DATA');
        mkdir(dataFolder);
        
        % Copy data files
        for f = filesIdxs'
            [ success ] = copyfile ( fullfile(dConfigs.rawData, files{f}) , dataFolder);
        end
        
        % Create the rest of the project data analysis folder structure.
        mkdir(fullfile(projectFolder,'PROCESSING'));
        mkdir(fullfile(projectFolder,'ANALYSIS'));
        
    else
        fprintf('[createFolderStructure] !---> folder ** %s ** previously created. \n',...
            funcProjName)
    end
    
    % ------------------- TO REVIEW  -----------------------------------
    
end

success = true;
disp('[createFolderStructure] Folder structure creation completed.')

end

