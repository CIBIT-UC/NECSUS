%% Configuration
clear, clc;

% Settings Structure
configs = struct();

% Initialize COM
configs.bvqx = actxserver('BrainVoyager.BrainVoyagerScriptAccess.1');

%%
load('../Configs_VP_AdaptationCheck_Final.mat')

%% Iterate on subjects

for s = 1:length(datasetConfigs.subjects)
    
    fprintf('==> Subject %i \n',s);
    
    configs.subjectName = datasetConfigs.subjects{s};
    configs.dataRootSubject = fullfile(datasetConfigs.path, configs.subjectName);
    
    vmrFile = dir( fullfile( configs.dataRootSubject,...
        'anatomical','PROJECT', '*TAL.vmr' ) );

    configs.vmrPathAndName = fullfile( configs.dataRootSubject,...
        'anatomical', 'PROJECT', vmrFile.name );
    
    vmrTalProject = configs.bvqx.OpenDocument( configs.vmrPathAndName );
    
    vmrTalProject.ZTransformStudies = 0;
    vmrTalProject.PSCTransformStudies = 1;
    vmrTalProject.CorrectForSerialCorrelations = 1;
    
    multirunFolder = fullfile(configs.dataRootSubject,'MultiRun');
    
    vmrTalProject.LoadMultiStudyGLMDefinitionFile(fullfile(multirunFolder, 'FFX_Ptrans_RunB1234_Smooth6mm.mdm'));
    
    vmrTalProject.ComputeMultiStudyGLM;
    vmrTalProject.SaveGLM(fullfile(multirunFolder, 'runB1234_VTC_N-4_FFX_PT_AR-2_ITHR-100_Smooth6mm.glm'));
    
    vmrTalProject.ShowGLM;
    
    vmrTalProject.Close;
    
end

%% Close COM
configs.bvqx.delete;
