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
% - Overall restructure NECSUS
%
% Author: Bruno Direito (2018)

%% Configs and presets
success = false;

% Get all the DICOM files available in the raw data folder from MR scanner.
D = dir( fullfile(datasetConfigs.rawData,'*.ima') ); % .IMA extension

% Check total number of required files in configs
if (length(D) < sum(datasetConfigs.volumes(datasetConfigs.subjectRunsOrder)) ...
        && length(D)>5)
    fprintf('[debug:createDicomFolderStructure] Fewer files than expected.\n');
elseif (length(D) < sum(datasetConfigs.volumes(datasetConfigs.subjectRunsOrder))...
        && length(D) < 5)
    D = dir(fullfile(datasetConfigs.rawData,'*.dcm')); % .dcm extension
end

files = {D.name};

%% identify number of runs in DICOM files

% initialize series variable
series = zeros(length(files),1);

for i=1:length(files)
    % Get series number by filename token
    % (fourth token corresponds to the series)
    toks=split(files{i}, '.');
    
    if numel(toks)<4
        toksRun=split(toks(1), '-');
        tokSeries=toksRun(2);
    else
        tokSeries=toks(4);
    end
    series(i,1) = str2double(tokSeries);
end

% unique (dicom) files series
seriesNumbers = unique(series);
% number of volumes per series
seriesVolumes = hist(series,length(1:seriesNumbers(end)));
% remove series numbers with zero elements
seriesVolumes = seriesVolumes(seriesVolumes~=0);
% get number of runs defined in the configs file
nRuns = datasetConfigs.nRuns;

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
if ~exist( projectFolder,'dir') == 7
    
    % %     while ~boolInput
    % %         x = input('[debug:createDicomFolderStructure] Project Folder already exists. Do you wish to overwrite (Y), stop (N) or proceed (P)?','s');
    % %         switch lower(x)
    % %             case 'y'
    % %                 rmdir(projectFolder,'s')
    % %                 mkdir(projectFolder)
    % %                 boolInput = true;
    % %             case 'n'
    % %                 return
    % %             case 'p'
    % %                 boolInput = true;
    % %             otherwise
    % %                 fprintf('[debug:createDicomFolderStructure] ERROR: Invalid input.')
    % %         end
    % %     end
    % % else
    
    mkdir(projectFolder)
end

% ---- Check and create Subject folder ----
% Participant's folder - project folder + subject code
partFolder = fullfile( projectFolder, char(datasetConfigs.subjectCode));

if ~exist(partFolder,'dir') == 7
    % %     while ~boolInput
    % %         x = input('[debug:createDicomFolderStructure] Participant''s folder already exists. Do you wish to overwrite (Y), stop (N) or proceed (P)?','s');
    % %         switch lower(x)
    % %             case 'y'
    % %                 rmdir(partFolder,'s')
    % %                 mkdir(partFolder)
    % %                 boolInput = true;
    % %             case 'n'
    % %                 return
    % %             case 'p'
    % %                 success = true;
    % %                 return
    % %             otherwise
    % %                 fprintf('[debug:createDicomFolderStructure] ERROR: Invalid input.')
    % %         end
    % %     end
    % % else
    mkdir(partFolder)
end

% ---- Check and create Session folder ----
% Session's folder - participant folder + session code
sessFolder = fullfile( partFolder, char(datasetConfigs.sessionCode));

if ~exist(sessFolder,'dir') == 7
    % %     while ~boolInput
    % %         x = input('[debug:createDicomFolderStructure] Session''s folder already exists. Do you wish to overwrite (Y), stop (N) or proceed (P)?','s');
    % %         switch lower(x)
    % %             case 'y'
    % %                 rmdir(sessFolder,'s')
    % %                 mkdir(sessFolder)
    % %                 boolInput = true;
    % %             case 'n'
    % %                 return
    % %             case 'p'
    % %                 success = true;
    % %                 return
    % %             otherwise
    % %                 fprinf('[debug:createDicomFolderStructure] ERROR: Invalid input.')
    % %         end
    % %     end
    % % else
    mkdir(sessFolder)
end
%%
% ---- Check and create a folder for each run ----
% Run folder - session folder + data type

% nRuns = number of runs
for r = 1:nRuns
    
    % ---- BIDS ----
    
    % ---
    % sub-<participant_label>[_ses-<session_label>][_acq-<label>][_rec-<label>][_run-<index>]_<modality_label>.nii[.gz]
    % ---
    
    % Get dataType (anat/func) and dataset description
    dataType=datasetConfigs.dataTypes{datasetConfigs.subjectDataTypeOrder(r)};
    acqDescr=datasetConfigs.task{datasetConfigs.subjectRunsOrder(r)};
    
    % Folder with project
    dataTypeRoot = fullfile (sessFolder, dataType);
    
    % check if it was previously created
    % Try to create dataType folder
    if ~(exist( dataTypeRoot,'dir') == 7)
        mkdir( dataTypeRoot );
    else
        fprintf( '[debug:createDicomFolderStructure] folder ** %s ** was previously created. \n', dataType )
    end
    
    % Select according to dataType
    switch dataType
        
        % If type of *anat*
        case 'anat'
            
            % Identify the name of the run, and create corresponding
            % folder/project
            
            % Get files idxs from run r.
            filesIdxs=find(series==seriesNumbers(r));
            
            % Read first file.
            dicomFileInfo=dicominfo( fullfile(datasetConfigs.rawData, files{filesIdxs(1)}) );
            
            % Set name of anat run according to number of project
            % previously created
            
            % --------------
            % sub-<participant_label>/[ses-<session_label>/]
            %   anat/
            %   sub-<participant_label>[_ses-<session_label>][_acq-<label>][_ce-<label>][_rec
            %   -<label>][_run-<index>][_mod-<label>]_<modality_label>.nii[.gz]
            
            % Check for anat runs previously created.
            t = dir(fullfile( sessFolder, dataType));
            numAnat = numel (t([t(:).isdir]))-2;
            
            % Number of anat project.
            anatProjIdx=numAnat+1;
            % Name of the anatomical project.
            anatProjName = [...
                datasetConfigs.subjectCode ...
                '_' ...
                datasetConfigs.sessionCode ...
                '_' ...
                'run-' num2str(anatProjIdx) ...
                '_' ...
                acqDescr...
                ];
            
            if ~(exist(fullfile(sessFolder,dataType,[acqDescr '_run-' num2str(anatProjIdx)]),'dir') == 7)
                % Create folder structure.
                mkdir(fullfile(sessFolder,dataType,[acqDescr '_run-' num2str(anatProjIdx)]));
                mkdir(fullfile(sessFolder,dataType,[acqDescr '_run-' num2str(anatProjIdx)],'PROJECT'));
                % Crete a copy of the raw files.
                anatProject = fullfile(sessFolder,dataType,[acqDescr '_run-' num2str(anatProjIdx)],'DATA');
                mkdir(anatProject);
                
                % Copy data files
                for f = filesIdxs'
                    [success]=copyfile(fullfile(datasetConfigs.rawData, files{f}),...
                        anatProject);
                end
            else
                fprintf('[createFolderStructure] !---> folder ** %s ** previously created. \n',...
                    anatProjName)
            end
            
            % If type of run = functional
        case 'func'
            
            % Check for func runs previously created of same type.
            funcProjIdx= numel(find(datasetConfigs.subjectRunsOrder(1:r)==datasetConfigs.subjectRunsOrder(r)));
            
            % Name of the anatomical project.
            funcProjName = [...
                datasetConfigs.subjectCode ...
                '_' ...
                datasetConfigs.sessionCode ...
                '_' ...
                'run-' num2str(funcProjIdx) ...
                '_' ...
                acqDescr...
                ];
                   
% %             if ~(exist(fullfile(sessFolder,dataType,[acqDescr '_ run-' num2str(funcProjIdx)]),'dir') == 7)
% %                 mkdir(fullfile(sessFolder,dataType,[acqDescr '_ run-' num2str(funcProjIdx)]));
% %             else
% %                 fprintf('[createFolderStructure] !---> folder ** %s ** previously created \n', dataType)
% %             end
            
            % ---
            % sub-<participant_label>[_ses-<session_label>]_task-<task_label>[_acq-<label>][_rec-<label>][_run-<index>]_bold.nii[.gz]
            % ---
            
            % Get files idxs from run
            filesIdxs = find(series == seriesNumbers(r));
            
            % Read first file
            dicomFileInfo = dicominfo( fullfile(datasetConfigs.rawData, files{filesIdxs(1)}) );
            
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
                    [ success ] = copyfile ( fullfile(datasetConfigs.rawData, files{f}) , dataFolder);
                end
                
                % Create the rest of the project data analysis folder structure.
                mkdir(fullfile(projectFolder,'PROCESSING'));
                mkdir(fullfile(projectFolder,'ANALYSIS'));
               
            else
                fprintf('[createFolderStructure] !---> folder ** %s ** previously created. \n',...
                    funcProjName)
            end
            
    end
    
end


success = true;
disp('[createFolderStructure] Folder structure creation completed.')

end

