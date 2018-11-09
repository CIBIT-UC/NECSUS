function [ success ] = createDicomFolderStructure( datasetConfigs )
% createDicomFolderStructure creates a structured folder based on the DICOM
% files and config files
% input -
%   datasetConfigs presents the specifications of the experiment
% output -
%   success: True if folder is created correctly, False if folder was not
%   created
%
% Version 1.0
% - Overall restructure
%
% Author: Bruno Direito (2018)

%% Configs and presets
success = false;

% Get all the DICOM files available in the raw data folder from MR scanner
D = dir( fullfile(datasetConfigs.rawData,'*.ima') ); % .IMA extension

% Check total number of required files in configs
if (length(D) < sum(datasetConfigs.volumes)) && (length(D) > 5)
    fprintf('[debug:createDicomFolderStructure] Fewer files than expected.\n');
elseif (length(D) < sum(datasetConfigs.volumes)) && (length(D) < 5)
    D = dir(fullfile(datasetConfigs.rawData,'*.dcm')); % .dcm extension
end

files = extractfield(D,'name')';

% TODO / REVIEW: check if files OK before creating folders etc.
%   example:  firstDCMfile = dicominfo(fullfile(D(1).folder,D(1).name));
%             firstDCMfile.PatientID


%% identify number of runs in DICOM files
% initialize series variable
series = zeros(length(files),1);
for i=1:length(files)
    % Get series number by filename token
    % (fourth token corresponds to the series)
    temp = split(files{i}, '.');
    series(i,1) = str2double(temp(4));
end

% unique (dicom) files series
seriesNumbers = unique(series);
% number of volumes per series
seriesVolumes = hist(series,length(1:seriesNumbers(end)));
% remove series numbers with zero elements
seriesVolumes = seriesVolumes(seriesVolumes~=0);

% get number of runs defined in the configs file
nRuns = length(datasetConfigs.runs);

% TODO / REVIEW: Double check number of runs and their size before continuing
% example_ read infor of DICOM file from each run and ask user
%       then proceed

%% Check for incomplete runs or extra runs
% Should allow for multiple anatomical scans, three pRF runs and four
% contrast task

if length( seriesNumbers ) ~= nRuns
    
    seriesNumbersLeftInArr = seriesNumbers;
    
    % Evaluate if number of runs greater than identified in configs.
    if length( seriesNumbersLeftInArr ) > nRuns
        
        fprintf('[debug:createDicomFolderStructure] More series than runs identified in configs.\n');
        
        % Add to ignore if number of volumes different from configs.
        ignoreS = seriesNumbers( ismember(seriesVolumes, datasetConfigs.volumes ) == 0);
        
        % Check for multiple anat runs
        if sum( seriesVolumes ==  unique( datasetConfigs.volumes ( ismember (datasetConfigs.folders, 'anat' ) ) ) )> 1           
            % Set number anat runs
            numAnatRuns = seriesNumbers( ismember (datasetConfigs.folders, 'anat' ) );              
            % Remove anat runs from array of runs left.
            seriesNumbersLeftInArr( ismember (datasetConfigs.folders, 'anat' ) ) = [];
            % Debug message
            fprintf(['[debug:createDicomFolderStructure] More than one run of anat. data detected: '...
                num2str(seriesNumbers( ismember (datasetConfigs.folders, 'anat' ) )' ) '.\n'])            
        end
        
        numFuncRuns = numel( datasetConfigs.volumes ( ismember (datasetConfigs.folders, 'func' ) ) );
        if numel(seriesNumbersLeftInArr) >  numel( datasetConfigs.volumes ( ismember (datasetConfigs.folders, 'func' ) ) ) 
            fprintf(['[debug:createDicomFolderStructure] ' num2str(length(seriesNumbers) - nRuns) ' extra series remain (func.).\n']);
        end
        
        % Remove series
        % If number of runs different from configs user must validate
        removeFinished = 0;
        boolInput=0;
        
        while ~(boolInput || removeFinished)
            inputStr = input(...
                ['[debug:createDicomFolderStructure] Please input the series to ignore( ', num2str( seriesNumbersLeftInArr' ) ' ):' ],...
                's');
            
            if ~ismember( str2double(inputStr),seriesNumbersLeftInArr ) 
                fprintf('[debug:createDicomFolderStructure] ERROR: Incorrect series number.\n');
            else
                ignoreS = str2double(inputStr) ; % only one at a time
                fprintf('[debug:createDicomFolderStructure] Ignoring files with series number %s.\n', num2str(ignoreS'));
                seriesNumbersLeftInArr(seriesNumbersLeftInArr == ignoreS) = [];
                fprintf('[debug:createDicomFolderStructure] %s extra series remain (func.).\n',  num2str(length(seriesNumbersLeftInArr) - numFuncRuns));
                if length(ignoreS) == (length (seriesNumbers) - nRuns)
                    removeFinished = 1;
                    break,% confirm
                end
            end
            
            inputStr = input('[debug:createDicomFolderStructure] Continue to remove series (y/n): ','s');
            if inputStr == 'n'
                boolInput = 1;
            end
        end
      
    % Evaluate if number of runs fewer than identified in configs.
    elseif length( seriesNumbers) < length(datasetConfigs.runs)
        fprinf('[debug:createDicomFolderStructure] Unsufficient data. Less series than runs identified in configs.\n')
        fprinf('[debug:createDicomFolderStructure] Proceed with caution.\n')
    end
end


%% CREATE NEW SCRIPT TO CREATE FOLDER STRUCTURE
%% Define folder creation for DICOM files per run

% ---- Check and create Project folder ----
% project folder path + foldername  to create
projectFolder = fullfile(datasetConfigs.path, datasetConfigs.project_name);

boolInput = false;

% if exist - do not create/overwrite/stop and re-check
if exist( projectFolder,'dir') == 7
    
    while ~boolInput
        x = input('[debug:createDicomFolderStructure] Project Folder already exists. Do you wish to overwrite (Y), stop (N) or proceed (P)?','s');
        switch lower(x)
            case 'y'
                rmdir(projectFolder,'s')
                mkdir(projectFolder)
                boolInput = true;
            case 'n'
                return
            case 'p'
                boolInput = true;
            otherwise
                fprintf('[debug:createDicomFolderStructure] ERROR: Invalid input.')
        end
    end
else
    mkdir(projectFolder)
end

% ---- Check and create Subject folder ----
% Participant's folder - project folder + subject code
partFolder = fullfile( projectFolder, char(datasetConfigs.subjectCode));

if exist(partFolder,'dir') == 7
    while ~boolInput
        x = input('[debug:createDicomFolderStructure] Participant''s folder already exists. Do you wish to overwrite (Y), stop (N) or proceed (P)?','s');
        switch lower(x)
            case 'y'
                rmdir(partFolder,'s')
                mkdir(partFolder)
                boolInput = true;
            case 'n'
                return
            case 'p'
                success = true;
                return
            otherwise
                fprintf('[debug:createDicomFolderStructure] ERROR: Invalid input.')
        end
    end
else
    mkdir(partFolder)
end

% ---- Check and create Session folder ----
% Session's folder - participant folder + session code
sessFolder = fullfile( partFolder, char(datasetConfigs.sessionCode));

if exist(sessFolder,'dir') == 7
    while ~boolInput
        x = input('[debug:createDicomFolderStructure] Session''s folder already exists. Do you wish to overwrite (Y), stop (N) or proceed (P)?','s');
        switch lower(x)
            case 'y'
                rmdir(sessFolder,'s')
                mkdir(sessFolder)
                boolInput = true;
            case 'n'
                return
            case 'p'
                success = true;
                return
            otherwise
                fprinf('[debug:createDicomFolderStructure] ERROR: Invalid input.')
        end
    end
else
    mkdir(sessFolder)
end

% ---- Check and create a folder for each run ----
% Run folder - session folder + data type

% nRuns = number of runs
for r = 1:nRuns
    
    % ---- BIDS ---- 
    
    % ---
    % sub-<participant_label>[_ses-<session_label>][_acq-<label>][_rec-<label>][_run-<index>]_<modality_label>.nii[.gz]
    % ---
    
    % Get dataType (anat/func) and dataset description
    [dataType, acqDescr] = fileparts( char( datasetConfigs.runs{r} ) );
    
    % Folder with project
    dataTypeRoot = fullfile (sessFolder, dataType);
    
    % check if it was previously created
    % Try to create dataType folder
    if ~(exist( dataTypeRoot,'dir') == 7)
        mkdir( dataTypeRoot );
    else
        fprintf( '[debug:createDicomFolderStructure] WARNING folder ** %s ** was previously created. \n', dataType )
    end

    % Select according to dataType
    switch dataType
        
        % If type of *anat*
        case 'anat'
            
            % Identify the name of the run, and create corresponding
            % folder/project
            
            % Get files idxs from run r
            filesIdxs = find(series == seriesNumbers(r));
            
            % Read first file
            dicomFileInfo = dicominfo( fullfile(datasetConfigs.rawData, files{filesIdxs(1)}) );
            

            % Set name of anat run according to number of project
            % previously created
            
            % --------------
            % sub-<participant_label>/[ses-<session_label>/]
            %   anat/
            %   sub-<participant_label>[_ses-<session_label>][_acq-<label>][_ce-<label>][_rec
            %   -<label>][_run-<index>][_mod-<label>]_<modality_label>.nii[.gz]

            
            % check for anat runs previously created           
            t = dir(fullfile( sessFolder, dataType));
            numAnat = numel (t([t(:).isdir]))-2;
 
            % Number of anat project
            anatProjIdx = numAnat + 1;
            anatProjName = [dicomFileInfo.ProtocolName '_run' num2str(anat_run_id)];
            
            
            if ~(exist(fullfile(partFolder,temp_root, temp_run_complete_name),'dir') == 7)
                
                % Create data structure
                mkdir(temp_root, temp_run_complete_name);
                mkdir(fullfile(temp_root, temp_run_complete_name),'PROJECT');
                data_folder = fullfile(temp_root, temp_run_complete_name,'DATA');
                mkdir(data_folder)
                
                % Copy data files
                for f = filesIdxs'
                    [ success ] = copyfile ( fullfile(datasetConfigs.raw_dicom_path, files{f}) , data_folder);
                end
                
            else
                fprintf('[createFolderStructure] !---> folder ** %s ** previously created. \n', temp_run_complete_name)
            end
            
            % If type of run = functional
        case 'func'
            
            if ~(exist(fullfile( partFolder,dataType ),'dir') == 7)
                mkdir(partFolder,dataType );
            else
                fprintf('[createFolderStructure] !---> folder ** %s ** previously created \n', dataType)
            end
            
            % ---
            % sub-<participant_label>[_ses-<session_label>]_task-<task_label>[_acq-<label>][_rec-<label>][_run-<index>]_bold.nii[.gz]
            % ---
            
            % Get files idxs from run
            filesIdxs = find(series == seriesNumbers(r));
            
            % Read first file
            dicomFileInfo = dicominfo( fullfile(datasetConfigs.raw_dicom_path, files{filesIdxs(1)}) );
            temp_run_complete_name = fullfile(dicomFileInfo.ProtocolName);
            temp_root = fullfile(partFolder,dataType);
            
            
            % If type of run = func
            if ~(exist(fullfile(partFolder,temp_root, temp_run_complete_name),'dir') == 7)
                
                % Create data structure
                mkdir(temp_root, temp_run_complete_name);
                project_folder = fullfile(temp_root, temp_run_complete_name,'PROJECT');
                mkdir(project_folder);
                data_folder = fullfile(temp_root, temp_run_complete_name,'DATA');
                mkdir(data_folder);
                
                % Copy data files
                for f = filesIdxs'
                    [ success ] = copyfile ( fullfile(datasetConfigs.raw_dicom_path, files{f}) , data_folder);
                end
                
                % create project structure
                mkdir(fullfile(project_folder,'PROCESSING'));
                mkdir(fullfile(project_folder,'ANALYSIS'));
                mkdir(fullfile(project_folder,'TBVTARGET'));
                
            else
                fprintf('[createFolderStructure] !---> folder ** %s ** previously created. \n', temp_run_complete_name)
            end
            
    end
    
end


success = true;
disp('[createFolderStructure] Folder structure creation completed.')

end

