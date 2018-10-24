function [ configs , vmrProject ] = parametersVTCCreation( configs , datasetConfigs, sliceTypePath )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if configs.IIHC
    vmrFileName = fullfile ...
        ( configs.dataRootSubject,...
        datasetConfigs.runs{configs.anatRunIdx}, ...
        'PROJECT',...
        [configs.filesSignature '_T1w_1_IIHC.vmr']);
    if ~exist(vmrFileName, 'file') == 2 % In case the file does not exist
        disp(['[parametersVTCCreation] ' configs.filesSignature '_IIHC.vmr' ' does not exist.']);
        vmrFileName = fullfile ...
            ( configs.dataRootSubject,...
            'anat',...
            datasetConfigs.runs{configs.anatRunIdx}, ...
            'PROJECT',...
            [configs.filesSignature '_T1w_1.vmr']);
    end
else
    vmrFileName = fullfile ...
        ( configs.dataRootSubject,...
        datasetConfigs.runs{configs.anatRunIdx}, ...
        'PROJECT',...
        [configs.filesSignature '_T1w_1.vmr']);
end

[~, vmrprefix] = fileparts(vmrFileName);

vmrProject = configs.bvqx.OpenDocument(vmrFileName);

iafaComplete = false;

while ~iafaComplete
    
        % --- Automatically create IA and FA transformation matrices
        vtcPrefix = fullfile( configs.dataRootSubject,...
            'func',...
            configs.alignRun,...
            'PROJECT',...
            'PROCESSING' );
        
        
        fmrFile = fullfile( vtcPrefix, ...
            [ configs.filesSignature '_' strrep(configs.alignRun,'_','-') '_bold_' sliceTypePath '_3DMCTS_LTR_THPGLMF2c.fmr']);
        
        if configs.BBR
            ok = vmrProject.CoregisterFMRToVMRUsingBBR(fmrFile);
        else
            ok = vmrProject.CoregisterFMRToVMR(fmrFile,0); % original FMR volume should be used (value: 0) or whether the volume in an attached AMR should be used as input (value: 1, recommended).
        end
        if ok
            disp('[parametersVTCCreation] Coregistration successful.')
        end
        
        % --- Build files prefixes
        if configs.IIHC; stringIIHC = '_IIHC'; else; stringIIHC = ''; end
        
        if configs.ATAL
            stringTAL = '_aACPC';
        elseif configs.MTAL
            stringTAL = '_ACPC';
        else
            stringTAL = '';
        end
        
        if configs.BBR; stringFA = '_BBR_FA'; else; stringFA = '_FA'; end
        
        configs.iaTransf = fullfile( vtcPrefix, ...
            [ configs.filesSignature '_' strrep(configs.alignRun,'_','-') '_bold_' sliceTypePath '_3DMCTS_LTR_THPGLMF2c-TO-' vmrprefix stringIIHC '_IA.trf' ] );
        
        configs.faTransf = fullfile( vtcPrefix, ...
            [ configs.filesSignature '_' strrep(configs.alignRun,'_','-') '_bold_' sliceTypePath '_3DMCTS_LTR_THPGLMF2c-TO-' vmrprefix stringIIHC stringFA '.trf' ] );
        
        configs.acpcTransf = fullfile( configs.dataRootSubject, datasetConfigs.runs{configs.anatRunIdx}, 'PROJECT', ...
            [ vmrprefix stringIIHC stringTAL '.trf' ] );
        
        configs.talTransf = fullfile( configs.dataRootSubject, datasetConfigs.runs{configs.anatRunIdx}, 'PROJECT', ...
            [ vmrprefix stringIIHC stringTAL '.tal' ] );
        
        configs.mniTransf = fullfile( configs.dataRootSubject, datasetConfigs.runs{configs.anatRunIdx}, 'PROJECT', ...
            [ vmrprefix '_IIHC_TO_MNI_a12.trf' ] );
        
        % --- Check if IA and FA files exist
        if (exist(configs.iaTransf,'file') + exist(configs.faTransf,'file')) == 4
            iafaComplete = true;
        else
            disp('---> !!! IA or FA not found. Repeating...')
        end
    end
    


end

