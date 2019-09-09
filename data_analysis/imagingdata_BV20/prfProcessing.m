% pRF analysis - 
%% SOP 6.1, 6.2

[filepath,filename,ext] = fileparts(configs.averageAnatProject);

% Open a VMR project:
vmrProject = configs.bvqx.OpenDocument(fullfile(filepath, [filename '_aTAL' ext]));

%% Create VTC files
