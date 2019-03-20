%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------BRAINVOYAGER fMRI DATA ANALYSIS---------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  ______________________________________________________________________
% |                                                                      |%
% | Authors: Bruno Direito, Alexandre Sayal (2017)                       |%
% |                                                                      |%
% |            !!!!! Remember to install COM Functionality !!!!!         |%
% |            !!!!! Remember to install NeuroElf          !!!!!         |%
% |______________________________________________________________________|%
%
% Version 1.0 (adapted to NECSUS)
% - Overall restructure

%% Clear Command Window / Clear Workspace / Close / Add Paths.
clear , clc , close all;

addpath functions utils

%% Load config file.

load('Configs_NECSUS.mat')

%% Set configs.

% Participant's name.
subjectName = 'sub-NECSUS-UC01';
% Session's name.
sessionName = 'ses-01';
% Identify ID of participant in configs file.
subjectIndex = find(not(cellfun('isempty', strfind(datasetConfigs.subjects, subjectName))));

% 1 - anat; 2 - func;
subjectDataTypeOrder=[1,2,2,2,2,2,1,2,2];
% 1 - T1w; 2 - retinotopy; 3 - Glare; 4 - NoGlare;
subjectRunsOrder=[1,2,2,2,3,3,1,4,4];

% Identify the participant in configs.
if isempty(subjectIndex)
    error('Invalid Subject Name')
end

%% Complete datasetConfigs variable.
datasetConfigs.subjectCode=subjectName;
datasetConfigs.sessionCode=sessionName;
datasetConfigs.subjectDataTypeOrder=subjectDataTypeOrder;
datasetConfigs.subjectRunsOrder=subjectRunsOrder;

datasetConfigs.rawData = 'C:\Users\bdireito\Data\NECSUS-Raw\ALZIRAQUATORZE';

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
            'DATA' );
    
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
    
%     configs.anatRun = datasetConfigs.runs{configs.anatRun(run_idx)};
    
end

%% Combine volumes - create average vmr file
% Create average vmr
fprintf('\n-- Combine 3D datasets using the BV interface. \n');

averageVmrProjectPath=fullfile(anatProjects(1).folder,...
            anatProjects(1).name,...
            'PROJECT',...
            [configs.filesSignature '_run-average_T1w_IIHC.vmr']);
        
if ~exist(averageVmrProjectPath,'file')
    % Ask to create average vmr or check for error.
    fprinf('[WARNING] Is the file %s created?\n', averageVmrProjectPath)
else
    % Perform TAL transformation.
    vmrProjectNormalization(configs,averageVmrProjectPath)
end

%% -- Functional Project Preparation

fprintf('\n-- Create functional projects. \n');
% -----
% Check for multiple functional runs
% -----

functionalRuns = datasetConfigs.subfolders(find(strcmp (datasetConfigs.folders,'func')))';


% % functionalRuns = ( dir ( fullfile( configs.dataRootSubject, 'func' ) ) );
% % idx_f = [functionalRuns(:).isdir]; %# returns logical vector
% % functionalRuns = {functionalRuns(idx_f).name}';
% % functionalRuns(ismember(functionalRuns,{'.','..'})) = [];

numFunctionalRuns = length( functionalRuns );



%% -- Functional Project Creation
sliceVector = cell(numFunctionalRuns);

for f = 1 : numFunctionalRuns
    
    
    % Rename DICOM
    functFiles = dir( fullfile( configs.dataRoot, ...
        configs.subjectName, ...
        'func', ...
        functionalRuns{f}, ...
        'DATA', ...
        '*.IMA' ) );
    
    if ~isempty(functFiles) % If previously renamed do nothing
        
        renameDirectoryDcm( fullfile( configs.dataRoot, ...
            configs.subjectName, ...
            'func', ...
            functionalRuns{f}, ...
            'DATA', ...
            functFiles(1).name ) );
        
    end
    
    % Create .fmr project and link .prt
    [~ , sliceVector{f}] = createFmrProject( configs, fullfile('func', functionalRuns{f}) );
    
end

save(fullfile(configs.dataRoot,configs.subjectName,'sliceVector.mat'),'sliceVector');

disp ('Project Creation Finished Successfully.')

%% -- Preprocessing Functional Data

% -- Manually set align run
if ~exist('sliceVector','var')
    load(fullfile(configs.dataRoot,configs.subjectName,'sliceVector.mat'));
end

%%

% Identify alignment run - If none, please select.
if numel(configs.alignRun) ~= 1
    fprintf('No alignment run selected. Please select the first functional run. \n');
    AlignRunName = uigetdir(fullfile( configs.dataRoot, ...
        configs.subjectName, ...
        'func'));
end

[~, configs.alignRun] = fileparts(AlignRunName);

%%
configs.firstFunctRunIdx = find( strcmp(  functionalRuns , configs.alignRun )) ;
AlignRunsIdx = configs.firstFunctRunIdx;

configs.firstFunctRunName = functionalRuns{ configs.firstFunctRunIdx };

[~ , sliceTypePath] = preprocessFirstFmrProject( configs, ...
    functionalRuns{configs.firstFunctRunIdx} , ...
    sliceVector{configs.firstFunctRunIdx} );

save(fullfile(configs.dataRoot,configs.subjectName,'sliceTypePath.mat'),'sliceTypePath');


%% Rest of the runs
for f = 1 : numFunctionalRuns
    
    if ~(AlignRunsIdx == f)
        preprocessFmrProject( configs, functionalRuns{f} , sliceVector{f} );
    end
end

disp ('Preprocessing Finished Successfully.')

%% -- Coregistration and VTC file Preparation

if ~exist('sliceTypePath','var')
    load(fullfile(configs.dataRoot,configs.subjectName,'sliceTypePath.mat'));
end

%% -- Coregistration and VTC file

[ configs , vmrProject ] = parametersVTCCreation( configs , datasetConfigs , sliceTypePath );

%%

for f = 1 : numFunctionalRuns
    
    vtcConfigs = parametersVTCRun( configs , functionalRuns , f , sliceTypePath );
    
    % Create vtc
    createVtcProject( configs, vtcConfigs, vmrProject, functionalRuns{f} )
    
end

disp('VTC files created successfully.')

%% -- SDM and GLM
if configs.ATAL || configs.MTAL
    stringvmr = 'TAL';
elseif configs.AMNI
    stringvmr = 'MNI';
else
    stringvmr = '';
end

vmrFile = dir( fullfile( configs.dataRootSubject,datasetConfigs.runs{configs.anatRunIdx}, 'PROJECT', ['*' stringvmr '.vmr'] ) );

configs.vmrPathAndName = fullfile( vmrFile.folder, vmrFile.name );

vmrProject = configs.bvqx.OpenDocument( configs.vmrPathAndName );

for f = 1 : numFunctionalRuns
    selected_run_name = functionalRuns{f};
    selected_run_name = strrep(selected_run_name,'_','-');
    
    
    if configs.ATAL || configs.MTAL
        stringvtc = '_TAL';
    elseif configs.AMNI
        stringvtc = '_MNI';
    else
        stringvtc = '_NATIVE';
    end
    
    success = vmrProject.LinkVTC( fullfile(configs.dataRootSubject,...
        'func', functionalRuns{f} ,'PROJECT','ANALYSIS',...
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
