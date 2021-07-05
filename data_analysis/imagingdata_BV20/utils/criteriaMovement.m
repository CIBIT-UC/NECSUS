%%
% NECSUS
% Exclusion Criteria for Head movements
% Joana Sampaio

%%

function [total] = criteriaMovement(configs,txtProjectNamePath, run)


filename = fullfile( configs.dataRootSession, 'func', txtProjectNamePath, 'PROJECT', 'PROCESSING', [ configs.filesSignature '_' txtProjectNamePath '_bold_SCCAI_3DMC.log']);
data = importfile(filename); %'sub-NECSUS-UC003_retinotopia-8bar_run-1_bold_SCCAI_3DMC.log'
name=fieldnames(data);
newName = 'id';
oldName = name{1};
[data.(newName)] = data.(oldName);
data = rmfield(data,oldName);
str = string(data.id); %string
str=str(4:end,1);

C=[];
for i=1:length(str)
    a = strsplit(str(i,1),' ','CollapseDelimiters',true);
    C=[C;a];
end

%Define Maximum values
%Rotation



max_dx=max(abs(str2double(C(:,7))));
max_dy=max(abs(str2double(C(:,10))));
max_dz=max(abs(str2double(C(:,13))));
%Translation
max_rx=max(abs(str2double(C(:,16))));
max_ry=max(abs(str2double(C(:,19))));
max_rz=max(abs(str2double(C(:,22))));


if ((max_dx)>3 || (max_dy)>3 || (max_dz)>3 || (max_rx)>3 || (max_ry)>3 || (max_rz)>3)
    message=['Exclude Run '  num2str(run)];
    total=[];
else
    message=['Run ' num2str(run) ' is clear!'];
    total=[run];
end


disp (message)

end
