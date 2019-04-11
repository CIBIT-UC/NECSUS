function [anatRunsIdxs] = checkMultipleAnat(dConfigs, s)

% Anat projects id.
anatID=find(strcmp(dConfigs.dataTypes,'anat')); % 1 anat, 2 func

% Number of anat runs.
totAnatRuns=sum(s.sVolumes==unique(dConfigs.volumes(anatID)));

% Check if more than one anat project.
if totAnatRuns>1
    % Set number anat runs
    anatRunsIdxs=s.sNumbers(s.sVolumes==unique(dConfigs.volumes(anatID)));

    % Debug message.
    fprintf(['[debug:createDicomFolderStructure] More than one run of anat. data detected: '...
        num2str(anatRunsIdxs') '.\n'])
end

end