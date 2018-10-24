function [  ] = createVtcProject( configs, vtcConfigs, vmrProject, functRunName )
%CREATEVTCPROJECT Summary of this function goes here
%   Detailed explanation goes here
%
% EXAMPLE
%

%vars
%Data type: high-precision data (float format)= 2 / integer format = 1
dataType = 2;

resolution = 3; %default
interpolation = 1; %value 0 will select nearest neighbor interpolation, value 1 trilinear interpolation and value 2 will select sinc interpolation
bbithresh = 100;

if configs.ATAL || configs.MTAL
    
    success = vmrProject.CreateVTCInTALSpace( vtcConfigs.fmrName,...
        vtcConfigs.iaName,...
        vtcConfigs.faName,...
        vtcConfigs.acpcTrfName,...
        vtcConfigs.talTrfName,...
        vtcConfigs.vtcName,...
        dataType,...
        resolution,...
        interpolation,...
        bbithresh);
    
    configs.bvqx.OpenDocument( vtcConfigs.vmrName );

elseif configs.AMNI
    
        success = vmrProject.CreateVTCInMNISpace( vtcConfigs.fmrName,...
        vtcConfigs.iaName,...
        vtcConfigs.faName,...
        vtcConfigs.mniName,...
        vtcConfigs.vtcName,...
        dataType,...
        resolution,...
        interpolation,...
        bbithresh);
    
    configs.bvqx.OpenDocument( vtcConfigs.vmrName );
    
else
    
    success = vmrProject.CreateVTCInVMRSpace( vtcConfigs.fmrName,...
        vtcConfigs.iaName,...
        vtcConfigs.faName,...
        vtcConfigs.vtcName,...
        dataType,...
        resolution,...
        interpolation,...
        bbithresh);

    configs.bvqx.OpenDocument( vtcConfigs.vmrName );

end

if ~exist(fullfile(configs.dataRoot,'ANALYSIS','VTC-data',functRunName ),'dir')
    mkdir(fullfile(configs.dataRoot,...
        'ANALYSIS',...
        'VTC-data',...
        functRunName ))
end

copyfile(vtcConfigs.vtcName, fullfile(configs.dataRoot,...
    'ANALYSIS',...
    'VTC-data',...
    functRunName ) );

if success 
    disp ( ['[createVtcProject] VTC created: '  vtcConfigs.vtcName ] )
end

end