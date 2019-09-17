% pRF analysis - 
%% SOP 4.

[filepath,filename,ext] = fileparts(configs.averageAnatProject);

% Open a VMR project:
vmrProject = configs.bvqx.OpenDocument(fullfile(filepath, [filename '_aTAL' ext]));

%% Create VTC files
