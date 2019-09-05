function [ vtcConfigs ] = parametersVTCRun( configs , functionalRunName , f , sliceTypePath )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

vtcConfigs = struct();

vtcPrefix = fullfile( configs.dataRootSession,...
    'func',...
    functionalRunName,...
    'PROJECT',...
    'PROCESSING' );

vtcConfigs.iaName = configs.iaTransf;

vtcConfigs.faName = configs.faTransf;

vtcConfigs.mniName = configs.mniTransf;


vtcConfigs.fmrName = fullfile( vtcPrefix, ...
    [ configs.filesSignature '_' functionalRunName '_bold_' sliceTypePath '_3DMCTS_SD3DSS2.00mm_LTR_THPGLMF2c.fmr' ] );

if configs.ATAL
    stringvtc = 'TAL';
    stringvmr = '_aTAL';
elseif configs.MTAL
    stringvtc = 'TAL';
    stringvmr = '_TAL';
elseif configs.AMNI
    stringvtc = 'MNI';
    stringvmr = '_MNI';
else
    stringvtc = 'NATIVE';
    stringvmr = '';
end

if configs.IIHC
    stringIIHC = '_IIHC';
else
    stringIIHC = '';
end

vtcConfigs.vtcName = fullfile(configs.dataRootSession,...
    'func',...
    functionalRunName,...
    'PROJECT','ANALYSIS' ,...
    [ configs.filesSignature '_' functionalRunName '_' sliceTypePath '_3DMCTS_SD3DSS2.00mm_LTR_THPGLMF2c_' stringvtc '.vtc' ] );

vtcConfigs.acpcTrfName = configs.acpcTransf;
vtcConfigs.talTrfName = configs.talTransf;
vtcConfigs.vmrName = configs.averageAnatProject;

end

