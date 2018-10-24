function [ success ] = createDICOM_folder_struct( datasetConfigs )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
clc,
success = false;

% Get all the DICOM files available in the raw data folder from MR scanner
D = dir(fullfile(datasetConfigs.raw_dicom_path,'*.ima'));

% Check total number of required files in configs
if (length(D) < sum(datasetConfigs.volumes_per_run)) && (length(D) > 5)
    fprintf('[createFolderStructure] Fewer files than expected...');
elseif (length(D) < sum(datasetConfigs.volumes_per_run)) && (length(D) < 5)
    D = dir(fullfile(datasetConfigs.raw_dicom_path,'*.dcm'));
end

files = extractfield(D,'name')';

% TODO: check if files OK before creating folders etc.
%   example:  firstDCMfile = dicominfo(fullfile(D(1).folder,D(1).name));
%             firstDCMfile.PatientID

for i=1:length(files)
    
    % Get series number by filename token
    temp = split(files{i}, '.');
    series(i,1) = str2double(temp(4));
    
end

seriesNumbers = unique(series);
seriesVolumes = hist(series,length(1:seriesNumbers(end)));
seriesVolumes = seriesVolumes(seriesVolumes~=0);

n_runs = length(datasetConfigs.runs);

% TODO / REVIEW: Double check number of runs and their size before continuing!!!!
% example_ read infor of DICOM file from each run and ask user
%       then proceed

% Check for incomplete runs or extra runs
if length( seriesNumbers ) > n_runs
    
    ignoreS = seriesNumbers( ismember(seriesVolumes, datasetConfigs.volumes_per_run ) == 0);
    
    if sum( seriesVolumes == datasetConfigs.volumes_per_run(1) )> 1 % More than one anatomical
        
        % Define anat runs
        anat_runs = seriesNumbers(seriesVolumes == datasetConfigs.volumes_per_run(1));
        
        % Selected anat run to use in the data processing
        fprintf(['[createFolderStructure] More than one run of anatomical data detected: '...
            num2str(seriesNumbers(seriesVolumes == datasetConfigs.volumes_per_run(1))')])
        
        %         kInput = input('---> Select the anatomical run to use - ', 's');
        %
        %         anat_run_to_use = str2double (kInput);
        
    end
    
    % TODO: should not limit experiences with localizer etc.
    
    
    if length(seriesNumbers) > n_runs
        ignoreS = [];
        boolInput = false;
        disp(['[createFolderStructure] ' num2str(length(seriesNumbers) - n_runs) ' extra series remain.']);
        while ~boolInput
            disp(['[createFolderStructure] Current series: ' mat2str(seriesNumbers') '.'])
            x = input('Please input the ones to ignore [<series numbers>]: ','s');
            
            if length(str2num(x)) > length(seriesNumbers) - n_runs
                disp(['!---> ERROR: Too many series to delete. Choose only ' length(seriesNumbers) - n_runs ]);
            elseif ~ismember(str2num(x),seriesNumbers)
                disp('!---> ERROR: Incorrect series number.');
            else
                ignoreS = [ str2num(x) ignoreS ];
                seriesNumbers = seriesNumbers( min(seriesNumbers~=str2num(x), [], 2) )
                if (length(seriesNumbers) - n_runs) == 0
                    
                    boolInput = true;
                end
            end
        end
        disp(['[createFolderStructure] Ignoring files with series number of ' num2str(ignoreS)]);
        %files(ismember(series,ignoreS)) = [];
        seriesNumbers(ismember(seriesNumbers,ignoreS)) = [];
    end
    
elseif length(seriesNumbers) < length(datasetConfigs.runs)
    disp('[createFolderStructure] !---> ERROR: Unsufficient data.')
    boolInput = false;
    while ~boolInput
        x = input('[createFolderStructure] Do you wish to proceed anyway (Y/N)?','s');
        switch lower(x)
            case 'y'
                n_runs = length(seriesNumbers);
                boolInput = true;
            otherwise
                return
        end
    end
end

%% Define folder creation for DICOM files per run

% ---- Check and create Project folder ----
% project folder
projectFolder = fullfile(datasetConfigs.root_dir,datasetConfigs.project_name);

boolInput = false;
if exist(projectFolder,'dir') == 7
    
    while ~boolInput
        x = input('[createFolderStructure] Project Folder already exists. Do you wish to overwrite (Y), stop (N) or proceed (P)?','s');
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
                disp('[createFolderStructure] !---> ERROR: Invalid input.')
        end
    end
else
    mkdir(projectFolder)
end

% ---- Check and create Subject folder ----
% Subject folder
subjectFolder = fullfile(projectFolder, char(datasetConfigs.subject_code));

if exist(subjectFolder,'dir') == 7
    while ~boolInput
        x = input('[createFolderStructure] Subject Folder already exists. Do you wish to overwrite (Y), stop (N) or proceed (P)?','s');
        switch lower(x)
            case 'y'
                rmdir(subjectFolder,'s')
                mkdir(subjectFolder)
                boolInput = true;
            case 'n'
                return
            case 'p'
                success = true;
                return
            otherwise
                disp('[createFolderStructure] !---> ERROR: Invalid input.')
        end
    end
else
    mkdir(subjectFolder)
end

% TODO - ADD SESSION FOLDER

% Iteration runs
for r = 1:n_runs
    
    % Create folder structure
    temp_run_name = char(datasetConfigs.runs{r});
    
    % check data type - anat or func
    [run_type, run_name] = fileparts(temp_run_name);
    
    switch run_type
        
        % If type of run = anat
        case 'anat'
            
            % Set name of anat run according to number of files
            if ~(exist(fullfile( subjectFolder,run_type ),'dir') == 7)
                mkdir(subjectFolder,run_type);
            else
                fprintf('[createFolderStructure] !---> folder ** %s ** previously created \n', run_type)
            end
            
            % ---
            % sub-<participant_label>[_ses-<session_label>][_acq-<label>][_rec-<label>][_run-<index>]_<modality_label>.nii[.gz]
            % ---
            
            % Get files idxs from run
            files_from_run = find(series == seriesNumbers(r));
            
            % Read first file
            temp_info = dicominfo( fullfile(datasetConfigs.raw_dicom_path, files{files_from_run(1)}) );
            temp_root = fullfile(subjectFolder, run_type);
            
            % If type of run = anat
            % Set name of anat run according to number of files
            
            previous_anat_runs = dir(fullfile( subjectFolder,run_type ));
            previous_anat_runs = previous_anat_runs([previous_anat_runs(:).isdir]);
            num_previous_anat_runs = numel(previous_anat_runs) - 2; % ., ..
            
            % Number of anat till now in the dataset
            anat_run_id = num_previous_anat_runs + 1;
            temp_run_complete_name = [temp_info.ProtocolName '_run' num2str(anat_run_id)];
            
            
            if ~(exist(fullfile(subjectFolder,temp_root, temp_run_complete_name),'dir') == 7)
                
                % Create data structure
                mkdir(temp_root, temp_run_complete_name);
                mkdir(fullfile(temp_root, temp_run_complete_name),'PROJECT');
                data_folder = fullfile(temp_root, temp_run_complete_name,'DATA');
                mkdir(data_folder)
                
                % Copy data files
                for f = files_from_run'
                    [ success ] = copyfile ( fullfile(datasetConfigs.raw_dicom_path, files{f}) , data_folder);
                end
                
            else
                fprintf('[createFolderStructure] !---> folder ** %s ** previously created. \n', temp_run_complete_name)
            end
            
        % If type of run = functional
        case 'func'
            
            if ~(exist(fullfile( subjectFolder,run_type ),'dir') == 7)
                mkdir(subjectFolder,run_type );
            else
                fprintf('[createFolderStructure] !---> folder ** %s ** previously created \n', run_type)
            end
            
            % ---
            % sub-<participant_label>[_ses-<session_label>]_task-<task_label>[_acq-<label>][_rec-<label>][_run-<index>]_bold.nii[.gz]
            % ---
            
            % Get files idxs from run
            files_from_run = find(series == seriesNumbers(r));
            
            % Read first file
            temp_info = dicominfo( fullfile(datasetConfigs.raw_dicom_path, files{files_from_run(1)}) );
            temp_run_complete_name = fullfile(temp_info.ProtocolName);
            temp_root = fullfile(subjectFolder,run_type);
            
            
            % If type of run = func
            if ~(exist(fullfile(subjectFolder,temp_root, temp_run_complete_name),'dir') == 7)
                
                % Create data structure
                mkdir(temp_root, temp_run_complete_name);
                project_folder = fullfile(temp_root, temp_run_complete_name,'PROJECT');
                mkdir(project_folder);
                data_folder = fullfile(temp_root, temp_run_complete_name,'DATA');
                mkdir(data_folder);
                
                % Copy data files
                for f = files_from_run'
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

