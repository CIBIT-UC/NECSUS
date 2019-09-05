% Version 1.0 (adapted to NECSUS)
% - Overall restructure

%% Clear Command Window / Clear Workspace / Close / Add Paths.
clear , clc , close all;

addpath functions utils

%% Load config file.

load('Configs_NECSUS.mat')

%% Set configs.

% Participant's name.
subjectName='sub-NECSUS-UC004';
% Session's name.
sessionName='ses-01';
% Identify ID of participant in configs file.
subjectIndex=find(not(cellfun('isempty', strfind(datasetConfigs.subjects, subjectName))));
% Subject group
subjectGroup='A';

%% Series/run sequence
% 1 - anat; 2 - func;
subjectDataTypeOrder=[1,2,2,2,2,2,1,2,2];

% 1 - T1w; 2 - retinotopy; 3 - Glare; 4 - NoGlare;
switch subjectGroup
    case 'A' % A -
        subjectRunsOrder=[1,2,2,2,3,3,1,4,4];
    case 'B' % B -
        subjectRunsOrder=[1,2,2,2,4,4,1,3,3];
end

% Identify the participant in configs.
if isempty(subjectIndex)
    error('Invalid Subject Name')
end

%% Complete datasetConfigs variable.
datasetConfigs.subjectCode=subjectName;
datasetConfigs.sessionCode=sessionName;
datasetConfigs.subjectDataTypeOrder=subjectDataTypeOrder;
datasetConfigs.subjectRunsOrder=subjectRunsOrder;

datasetConfigs.rawData = 'C:\Users\bdireito\Data\NECSUS-Raw\SUBNECSUSUC004';

%% Set preprocessing presets.
% Automatic IIHC
performIIHC = 1;
% Automatic TAL Transformation
performATAL = 1;
% Automatic MNI Transformation
performAMNI = 0;
% Manual TAL Transformation
performMTAL = 0;
% Include motion parameters in SDM
motionParameters = 1;
% Spike Threshold
spikeThreshold = 0.25;
% Run to align motion correction
alignRun = '';
% Use BBR coregistration
performBBR = 1;


%% -- Create Folder Structure
[ success ] =  createDicomFolderStructure( datasetConfigs );

assert(success,'Folder creation aborted.');
clear dataPath dataTBV;


%% -- Initialize

configs=struct(); % Settings Structure

configs.dataRoot=fullfile(datasetConfigs.path, datasetConfigs.project_name);
addpath(configs.dataRoot);

% Initialize COM
configs.bvqx = actxserver('BrainVoyager.BrainVoyagerScriptAccess.1');

% Subject Name and Folder Name
configs.filesSignature = datasetConfigs.subjects{subjectIndex};
configs.subjectName = datasetConfigs.subjects{subjectIndex};

configs.dataRootSubject=fullfile(configs.dataRoot, configs.subjectName);
configs.dataRootSession=fullfile(configs.dataRootSubject, datasetConfigs.sessionCode);


configs.firstFunctRunIdx = [];
configs.firstFunctRunName = [];

configs.IIHC = performIIHC;
configs.ATAL = performATAL;
configs.AMNI = performAMNI;
configs.MTAL = performMTAL;
configs.alignRun = alignRun;
configs.BBR = performBBR;

configs.volToSkip=datasetConfigs.volsToSkip;

% Account for user error
if configs.ATAL && configs.MTAL
    configs.ATAL = false;
end
if configs.AMNI && ~configs.IIHC
    configs.IIHC = true;
end
if configs.AMNI && (configs.ATAL || configs.MTAL)
    configs.ATAL = false;
    configs.MTAL = false;
end

functFiles = [];
clear performIIHC performATAL performAMNI performMTAL

%% -- Anatomical Project Creation

% -----
% Check for multiple anatomical runs
% -----

configs.anatProjects = [];

% Check number of folder in anat folder of the subject/ses
anatProjects=dir(fullfile(configs.dataRootSession,'anat'));
% Remove '.', '..' from struct.
anatProjects(1:2)=[];

% Iterate through all runs in config.
for vmrProjectIdx=1:numel(anatProjects)
    
    % Create structure for anatomical projects id.
    configs.anatProjects(vmrProjectIdx).name=anatProjects(vmrProjectIdx).name;
    
    % Temporary folder path to project and data.
    projectPath=fullfile( configs.dataRootSession,...
        'anat', ...
        configs.anatProjects(vmrProjectIdx).name);
    projectDataPath=fullfile( configs.dataRootSession,...
        'anat', ...
        configs.anatProjects(vmrProjectIdx).name, ...
        'DATA');
    
    % Check for .IMA files and transform to DICOM if necessary.
    anatProjectFiles = dir( fullfile( projectDataPath, ...
        '*.IMA'));
    % If previously renamed do not perform operation.
    if ~isempty(anatProjectFiles)
        configs.bvqx.RenameDicomFilesInDirectory(projectDataPath);
    end
    
    % Anonimizing data.
    % First argument %path% and second the %name%
    configs.bvqx.AnonymizeDicomFilesInDirectory(projectDataPath, configs.subjectName);
    
    % Create VMR project and perform initial transformations - ACPC and TAL.
    kInputBool = false;
    while ~kInputBool
        
        % Create vmr project.
        configs.vmrProject = createVmrProject( configs,...
            projectPath,...
            vmrProjectIdx );
        
        % ACPC rotation and TAL transformation.
        if configs.ATAL
            disp('---> Check automatic TAL Transformation!')
            
            kInput = input('---> Continue (Y), Repeat (N) or Perform Manually (M)?', 's');
            switch lower(kInput)
                case 'y'
                    kInputBool = true;
                case 'm'
                    kInputBool = true;
                    disp('---> Press Enter when done.');
                    pause;
                    configs.ATAL = false;
                    configs.MTAL = true;
                otherwise
                    disp('---> Repeating...')
            end
        elseif configs.MTAL
            kInputBool = true;
            disp('---> Perform Manual Talairach Transformation.');
            disp('---> Press Enter when done.');
            pause;
        else % Native | IIHC | MNI transformations
            kInputBool = true;
        end
    end
    
end

%% Combine volumes - create average vmr file
% Create average vmr
fprintf('\n-- Combine 3D datasets using the BV interface. \n');

averageVmrProjectPath=fullfile(anatProjects(1).folder,...
    anatProjects(2).name,...
    'PROJECT',...
    [configs.filesSignature '_run-average_T1w_IIHC_NATIVE.vmr']);

if ~exist(averageVmrProjectPath,'file')
    % Ask to create average vmr or check for error.
    fprintf('[WARNING] Is the file %s created?\n', averageVmrProjectPath)
else
    % Perform TAL transformation.
    vmrProjectNormalization(configs,averageVmrProjectPath)
end


%% -- save average anat Project

configs.averageAnatProject=fullfile(anatProjects(1).folder,...
    anatProjects(2).name,...
    'PROJECT',...
    [configs.filesSignature '_run-average_T1w_IIHC_NATIVE.vmr']);


%% -- Functional Project Preparation

fprintf('\n-- Create functional projects. \n');
% -----
% Check for multiple functional runs
% -----

functionalRuns = dir(fullfile(configs.dataRootSession,'func'));
functionalRuns(1:2)=[]; % remove {'.','..'} entries

configs.functionalRuns=functionalRuns;

numFunctionalRuns=length( functionalRuns );

%% -- Functional Project Creation
sliceVector = cell(numFunctionalRuns);
for f = 1 : numFunctionalRuns
    % Rename DICOM
    functFiles = dir(fullfile(configs.dataRootSession, ...
        'func', ...
        configs.functionalRuns(f).name, ...
        'DATA', ...
        '*.IMA' ));
    
    if ~isempty(functFiles) % If previously renamed do nothing
        
        renameDirectoryDcm( fullfile(configs.dataRootSession, ...
            'func', ...
            configs.functionalRuns(f).name, ...
            'DATA', ...
            functFiles(1).name ) );
        
    end
    
    % Create .fmr project and link .prt
    [~ , sliceVector{f}] = createFmrProject(configs,fullfile('func',configs.functionalRuns(f).name));
    
end

save(fullfile(configs.dataRootSession,'sliceVector.mat'),'sliceVector');

disp ('Project Creation Finished Successfully.')

%% -- Preprocessing Functional Data


if ~exist('sliceVector','var')
    load(fullfile(configs.dataRootSession,'sliceVector.mat'));
end

% OR RUN THIS SECTION TWICE
% % % preprocessDataToDo=1;

% % % while preprocessDataToDo

    % -- Manually set align run ---
    if numel(configs.alignRun) ~= 1
        fprintf('No alignment run selected. Please select the first functional run. \n');
        AlignRunName = uigetdir(fullfile( configs.dataRootSession, ...
            'func'));
    end
    
    [~, configs.alignRun] = fileparts(AlignRunName);
    
    % --- Select the runs you wish to align ---
    % Align to.
    fprintf('Series to align to %s. \n', configs.alignRun)
    % Select runs to align.
    for r = 1:length(configs.functionalRuns)
        fprintf('Series idx: %i - %s \n',...
            r,...
            configs.functionalRuns(r).name);
    end
    inputStr = input(...
        '[Preprocessing and alignment] Please input the idxs to align to: ',...
        's');
    funcRunsToAlign=str2num(inputStr);

    % Identify align run and save variable.
    configs.firstFunctRunIdx = find(strcmp({configs.functionalRuns.name}, configs.alignRun));
    AlignRunsIdx = configs.firstFunctRunIdx;
    configs.firstFunctRunName = configs.functionalRuns(configs.firstFunctRunIdx).name;
    
    % Preprocess first run.
    [~ , sliceTypePath] = preprocessFirstFmrProject( configs, ...
        configs.firstFunctRunName, ...
        sliceVector{configs.firstFunctRunIdx} );
    save(fullfile(configs.dataRootSession,'sliceTypePath.mat'),'sliceTypePath');
        
    % Preprocess and align rest of the runs.
    for f = 1:numel(funcRunsToAlign)
        runIdx=funcRunsToAlign(f);
        if ~(AlignRunsIdx == runIdx)
            preprocessFmrProject( configs, configs.functionalRuns(runIdx).name , sliceVector{f} );
        end
    end
    
    disp ('Preprocessing Finished Successfully.')
    
    %%
    
    vtcRunsToCreate = [configs.firstFunctRunIdx funcRunsToAlign];
    
    % -- Coregistration and VTC file Preparation
    if ~exist('sliceTypePath','var')
        load(fullfile(configs.dataRootSession,'sliceTypePath.mat'));
    end
    
    % -- Coregistration and VTC file
    [ configs , vmrProject ] = parametersVTCCreation( configs , datasetConfigs , sliceTypePath );
    
    for f =  1:numel(vtcRunsToCreate)
        runIdx=vtcRunsToCreate(f);
        vtcConfigs = parametersVTCRun( configs , configs.functionalRuns(runIdx).name , f , sliceTypePath );
        % Create vtc
        createVtcProject( configs, vtcConfigs, vmrProject, configs.functionalRuns(runIdx).name )
        
    end
    
    disp('VTC files created successfully.')
    
% % %     % Select new set of runs - align run and preprocess.
% % %     temp=input('[Preprocessing and alignment] Another sequence? ', 's');
% % %     preprocessDataToDo=str2num(temp);
% % %     
% % %     
% % % end

%% -- SDM and GLM
if configs.ATAL || configs.MTAL
    stringvmr = 'TAL';
elseif configs.AMNI
    stringvmr = 'MNI';
else
    stringvmr = '';
end

vmrProject = configs.bvqx.OpenDocument( configs.averageAnatProject );

for f = 1 : numFunctionalRuns
    selected_run_name = functionalRuns(f).name;
    
    
    if configs.ATAL || configs.MTAL
        stringvtc = '_TAL';
    elseif configs.AMNI
        stringvtc = '_MNI';
    else
        stringvtc = '_NATIVE';
    end
    
    success = vmrProject.LinkVTC( fullfile(configs.dataRootSession,...
        'func',...
        functionalRuns(f).name,...
        'PROJECT',...
        'ANALYSIS',...
        [subjectName '_' selected_run_name '_' sliceTypePath '_3DMCTS_LTR_THPGLMF2c' stringvtc '.vtc']));
    
    SdmGlmFolder = fullfile(configs.dataRootSubject,...
        'func', functionalRuns{f} ,'PROJECT','ANALYSIS');
    
    n_vols = vmrProject.NrOfVolumes;
    
    vmrProject.ClearDesignMatrix;
    
    % Link stimulation protocol
    
    
    if exist(vmrProject.StimulationProtocolFile)
        prtFile = xff(vmrProject.StimulationProtocolFile);
    else
        fprintf('No .prt file found. Please select the corresponding prt file - %s . \n', functionalRuns{f});
        [prtFilePath, prtFolder] = uigetfile('*.prt',['Protocol for run' functionalRuns{f}],fullfile( configs.dataRoot));
        
        vmrProject.LinkStimulationProtocol(fullfile(prtFolder, prtFilePath)); % only filename, not pathname
        
        prtFile = xff (fullfile(prtFolder, prtFilePath));
    end
    
    
    configs.conditions = prtFile.ConditionNames;
    prtFile.ClearObject;
    
    for p = 1:length(configs.conditions)
        
        conditionName = configs.conditions{p};
        if conditionName (end) == ' '
            conditionName (end) = [];
        end
        
        %         if ~strcmpi(conditionName,'baseline') % Exclude rest condition
        
        vmrProject.AddPredictor(conditionName);
        
        vmrProject.SetPredictorValuesFromCondition(...
            conditionName,...
            conditionName,...
            1.0);
        
        vmrProject.ApplyHemodynamicResponseFunctionToPredictor(conditionName);
        %             vmrProject.ScalePredictorValues(conditionName,1.0,false);
        %         end
    end
    
    vmrProject.SDMContainsConstantPredictor = true;
    
    % Add motion parameters and spikes as confounds
    if motionParameters
        
        vmrProject.FirstConfoundPredictorOfSDM = p + 1;
        
        motionSDMpath = fullfile(configs.dataRootSubject, 'func', functionalRuns{f},'PROJECT','PROCESSING');
        motionSDMname = dir(fullfile(motionSDMpath,'*3DMC.sdm'));
        
        motionSDM = xff(fullfile(motionSDMpath,motionSDMname.name));
        
        % Detrend and z-normalize motion parameters
        detrendNormMotion = zscore(detrend(motionSDM.SDMMatrix));
        
        for i=1:6
            
            aux_detrendNormMotion = normalize_var(detrendNormMotion(:,i),-1,1); % Normalise between -1 and 1
            
            vmrProject.AddPredictor([motionSDM.PredictorNames{i} ' Detrended']);
            
            for j = 1:n_vols
                vmrProject.SetPredictorValues([motionSDM.PredictorNames{i} ' Detrended'],j,j,aux_detrendNormMotion(j));
            end
            
            %             vmrProject.ScalePredictorValues([motionSDM.PredictorNames{i} ' Detrended'],1.0,false);
            
        end
        
        [ spikeIndexes ] = spikeDetection( motionSDM , spikeThreshold );
        
        for i = 1:length(spikeIndexes)
            
            vmrProject.AddPredictor(['Spike ' num2str(spikeIndexes(i))]);
            
            for j = 1:n_vols
                if j == spikeIndexes(i)
                    value = 1;
                else
                    value = 0;
                end
                vmrProject.SetPredictorValues(['Spike ' num2str(spikeIndexes(i))],j,j,value);
            end
            
        end
        
        % -- Add Constant Predictor
        vmrProject.AddPredictor('Constant');
        vmrProject.SetPredictorValues('Constant', 1, vmrProject.NrOfVolumes, 1.0);
        
        % Save SDM
        sdmPathName = fullfile( SdmGlmFolder,[ configs.filesSignature '_3DMC_SPK.sdm' ] );
        vmrProject.SaveSingleStudyGLMDesignMatrix( sdmPathName );
        
        disp('SDM created (with motion parameters and spikes as confounds).');
        
    else
        vmrProject.FirstConfoundPredictorOfSDM = p + 1;
        
        % -- Add Constant Predictor
        vmrProject.AddPredictor('Constant');
        vmrProject.SetPredictorValues('Constant', 1, vmrProject.NrOfVolumes, 1.0);
        
        % Save SDM
        sdmPathName = fullfile( SdmGlmFolder,[ configs.filesSignature '.sdm' ] );
        vmrProject.SaveSingleStudyGLMDesignMatrix( sdmPathName );
        
        disp('SDM created.');
    end
    
    if ~exist(fullfile(datasetConfigs.AnalysisPath,'SDM-data',functionalRuns{f}),'dir')
        mkdir(fullfile(datasetConfigs.AnalysisPath,'SDM-data',functionalRuns{f}))
    end
    
    copyfile(sdmPathName, fullfile(datasetConfigs.AnalysisPath,'SDM-data',...
        functionalRuns{f} ) );
    
    vmrProject.CorrectForSerialCorrelations = true;
    vmrProject.ComputeSingleStudyGLM;
    
    if motionParameters
        stringM = '_3DMC_SPK';
    else
        stringM = '';
    end
    
    vmrProject.SaveGLM( fullfile( SdmGlmFolder,[ configs.filesSignature stringM stringvtc '.glm']) );
    
    disp('GLM created.');
    
end

disp('SDM and GLM creation successful.')

%% -- Close COM
configs.bvqx.delete;

disp('fMRI Data Processing Script Ended!')
