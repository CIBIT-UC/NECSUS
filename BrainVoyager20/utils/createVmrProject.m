function [ vmrProject ] = createVmrProject( configs, projectPath, vmrIdx )
%CREATEVMR Summary of this function goes here
%   Detailed explanation goes here

disp('Creating VMR Project...');

% -----------------------
% get first file from anatomical image
% -----------------------

% Set folder containing anat. data
pathfiles=fullfile(projectPath, 'DATA');
files=dir(fullfile(pathfiles,'*.dcm'));

% files previously transformed to .dcm
firstFileName=fullfile(projectPath,'DATA',files(1).name);
[~,~,ext]=fileparts(firstFileName);

switch ext
    case '.dcm', filetype = 'DICOM';
    case '.IMA', filetype = 'SIEMENS';
    case '.I', filetype = 'GE_I';
    case '.MR', filetype = 'GE_MR';
    case '.REC', filetype = 'PHILIPS_REC';
    case '.hdr', filetype = 'ANALYZE';
end

if (strcmp(ext,'.dcm')==1) && (exist('dicominfo.m')>0)
    dcminfo=dicominfo( firstFileName );
    bytesperpixel = ( dcminfo.BitsAllocated/8 );
    xres = dcminfo.Columns;
    yres = dcminfo.Rows;
else
    prompt = { 'Size of x-axis:','Size of y-axis:', 'Number of bytes per pixel:' };
    dlgtitle = 'Parameters for VMR project';
    nrlines = 1;
    def = { '256','256', '2' };
    answer = inputdlg( prompt,dlgtitle,nrlines,def );
    xres = answer{ 1 };
    yres = answer{ 2 };
    bytesperpixel = answer{ 3 };
end

rawFileSelection=fullfile(pathfiles,[ '*' ext ]);
files=dir(rawFileSelection);
sizeAr=size(files);
nrSlices=sizeAr(1);

swap=0;

vmrProject = configs.bvqx.CreateProjectVMR(...
    filetype,...
    firstFileName,...
    nrSlices,...
    swap,...
    xres,...
    yres,...
    bytesperpixel);

vmrProject.SaveAs( fullfile ...
    (projectPath,...
    'PROJECT',...
    [configs.filesSignature '_run_' num2str(vmrIdx) '_T1w.vmr']));

%% TRANSFORMATIONS
% Perform inhomogeneity correction and transform VMR to AC-PC and Talairach space

% if configs.ATAL || configs.IIHC || configs.AMNI
%     disp('---> Check Brightness and Contrast, then press Enter.')
%     pause;
% end

if configs.IIHC
    ok = vmrProject.CorrectIntensityInhomogeneities();
    if ok; fprintf('[createVmrProject] IIHC Performed. \n'); end
end

if configs.ATAL
    % Transform anatomy to AC-PC and Talairach space
    ok = vmrProject.AutoACPCAndTALTransformation();
    if ok; fprintf('[createVmrProject] ATAL Performed. \n'); end
end

if configs.AMNI
    % Transform anatomy to MNI space
    ok = vmrProject.NormalizeToMNISpace();
    if ok; fprintf('[createVmrProject] AMNI Performed. \n'); end
end

disp('VMR Project created.')

end
