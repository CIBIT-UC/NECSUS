function vmrProjectNormalization(configs,vmrProjectPath)

% Open .vmr project
vmrProject = configs.bvqx.OpenDocument(vmrProjectPath);

% Perform transformation according to the method selected.
% if automatic Talairach.
if configs.ATAL
    % Transform anatomy to AC-PC and Talairach space
    ok = vmrProject.AutoACPCAndTALTransformation();
    if ok; fprintf('[vmrProjectNormalization] ATAL Performed. \n'); end
end
% if automatic MNI.
if configs.AMNI
    % Transform anatomy to MNI space
    ok = vmrProject.NormalizeToMNISpace();
    if ok; fprintf('[vmrProjectNormalization] AMNI Performed. \n'); end
end

end