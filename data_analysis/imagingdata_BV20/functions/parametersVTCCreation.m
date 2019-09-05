function [ configs , vmrProject ] = parametersVTCCreation( configs , datasetConfigs, sliceTypePath )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


vmrFileName = configs.averageAnatProject;

[vmrfolder, vmrprefix] = fileparts(vmrFileName);

vmrProject = configs.bvqx.OpenDocument(vmrFileName);

iafaComplete = false;

while ~iafaComplete
    
        % --- Automatically create IA and FA transformation matrices
        vtcPrefix = fullfile( configs.dataRootSession,...
            'func',...
            configs.alignRun,...
            'PROJECT',...
            'PROCESSING' );
        
        fmrFile = fullfile( vtcPrefix, ...
            [ configs.filesSignature ...
            '_' configs.alignRun ...
            '_bold_' sliceTypePath ...
            '_3DMCTS_SD3DSS2.00mm_LTR_THPGLMF2c.fmr']);
        
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
            [ configs.filesSignature '_' configs.alignRun '_bold_' sliceTypePath '_3DMCTS_SD3DSS2.00mm_LTR_THPGLMF2c-TO-' vmrprefix '_IA.trf' ] );
        
        configs.faTransf = fullfile( vtcPrefix, ...
            [ configs.filesSignature '_' configs.alignRun '_bold_' sliceTypePath '_3DMCTS_SD3DSS2.00mm_LTR_THPGLMF2c-TO-' vmrprefix stringFA '.trf' ] );
        
        configs.acpcTransf = fullfile(vmrfolder, ...
            [ vmrprefix stringTAL '.trf' ] );
        
        configs.talTransf = fullfile( vmrfolder, ...
            [ vmrprefix stringTAL '.tal' ] );
        
        configs.mniTransf = fullfile(vmrfolder, ...
            [ vmrprefix '_TO_MNI_a12.trf' ] );
        
        % --- Check if IA and FA files exist
        if (exist(configs.iaTransf,'file') + exist(configs.faTransf,'file')) == 4
            iafaComplete = true;
        else
            disp('---> !!! IA or FA not found. Repeating...')
        end
    end
    


end

