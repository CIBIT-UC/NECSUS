function [fRunsIdxs,funcID] = checkMultipleFunc(dConfigs, s, sLeftInArr)

% Func projects id.
funcDTID=find(strcmp(dConfigs.dataTypes,'func')); % 1 anat, 2 func
funcID=dConfigs.subjectRunsOrder(dConfigs.subjectDataTypeOrder==funcDTID);

% Number of func runs.
totFuncRuns=sum(ismember(s.sVolumes,unique(dConfigs.volumes(unique(funcID)))));

fRunsIdxs=s.sNumbers(ismember(s.sVolumes,unique(dConfigs.volumes(unique(funcID)))));

% Check if any of the remaingin projects is not functional.
if numel(sLeftInArr)> totFuncRuns
    fprintf(['[debug:createDicomFolderStructure] '
        num2str(length(s.sNumbers) - nRuns) 
        ' extra series remain (func.).\n']);
end


end