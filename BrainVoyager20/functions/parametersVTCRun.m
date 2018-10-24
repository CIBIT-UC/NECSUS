function [ vtcConfigs ] = parametersVTCRun( configs , functionalRuns , f , sliceTypePath )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

vtcConfigs = struct();

vtcPrefix = fullfile( configs.dataRootSubject,...
    'func',...
    functionalRuns{f},...
    'PROJECT',...
    'PROCESSING' );

vtcConfigs.iaName = configs.iaTransf;

vtcConfigs.faName = configs.faTransf;

vtcConfigs.mniName = configs.mniTransf;

runName = strrep (functionalRuns(f), '_', '-');

vtcConfigs.fmrName = fullfile( vtcPrefix, ...
    [ configs.filesSignature '_' runName{1} '_bold_' sliceTypePath '_3DMCTS_LTR_THPGLMF2c.fmr' ] );

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

vtcConfigs.vtcName = fullfile(  configs.dataRootSubject,'func',functionalRuns{f},...
    'PROJECT','ANALYSIS' , ...
    [ configs.filesSignature '_' runName{1} '_' sliceTypePath '_3DMCTS_LTR_THPGLMF2c_' stringvtc '.vtc' ] );

vtcConfigs.acpcTrfName = configs.acpcTransf;
vtcConfigs.talTrfName = configs.talTransf;
vtcConfigs.vmrName = fullfile(  configs.dataRootSubject,...
    configs.anatRunName, ...
    'PROJECT', ...
    [ configs.filesSignature '_T1w_1' stringIIHC stringvmr '.vmr' ] );

end

