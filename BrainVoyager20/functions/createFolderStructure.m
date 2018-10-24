function [ success ] = createFolderStructure( datasetConfigs , dataPath , dataTBV , subjectIndex , shiftROI)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

success = false;

D = dir(fullfile(dataPath,'*.ima'));
if (length(D) < sum(datasetConfigs.volumes)) && (length(D) > 5)
    disp('[createFolderStructure] Fewer files than expected...');
elseif (length(D) < sum(datasetConfigs.volumes)) && (length(D) < 5)
    D = dir(fullfile(dataPath,'*.dcm'));
end

files = extractfield(D,'name')';

for i=1:length(files)
    
    % Check if files belong to participant by comparing the first name
    if i == 1
        firstDCMfile = dicominfo(fullfile(D(1).folder,D(1).name));
        
        if ~strcmpi(datasetConfigs.subjects{subjectIndex},[firstDCMfile.PatientName.GivenName firstDCMfile.PatientName.FamilyName])
            disp('[createFolderStructure] Check if files correspond to subject!')
            fprintf('Name on DCM files: %s %s\n',firstDCMfile.PatientName.GivenName,firstDCMfile.PatientName.FamilyName);
            fprintf('Name provided: %s\n',datasetConfigs.subjects{subjectIndex});
            
            x = input('[createFolderStructure] Do you wish to proceed anyway (Y/N)?','s');
            switch lower(x)
            case 'y'
                disp('[createFolderStructure] Proceeding...');
            otherwise
                return
            end
        end
    end
    
    % Proceed
    auxname = files{i};
    aux =  auxname - '0';
    aux2 = find( aux >= 0 & aux < 10, 1 );
    series(i,1) = str2double(auxname(aux2:aux2+3));
     
end

seriesNumbers = unique(series);
seriesVolumes = hist(series,length(1:seriesNumbers(end)));
seriesVolumes = seriesVolumes(seriesVolumes~=0);

n_runs = length(datasetConfigs.runs);

% Check for incomplete runs or extra runs
if length(seriesNumbers) > n_runs
    
    ignoreS = seriesNumbers(ismember(seriesVolumes,datasetConfigs.volumes) == 0);
    
    if sum(seriesVolumes == datasetConfigs.volumes(1)) > 1 % More than one anatomical
        
        boolInput = false;
        disp(['[createFolderStructure] More than one run of anatomical data detected: ' num2str(seriesNumbers(seriesVolumes == datasetConfigs.volumes(1))')])
        while ~boolInput
            x = input('Please input the ones to ignore [<series numbers>]: ','s');
            
            if ~ismember(str2double(x),seriesNumbers(seriesVolumes == datasetConfigs.volumes(1)))
                disp('!---> ERROR: Incorrect series number.');
            else
                ignoreS = [ str2double(x) ignoreS ];
                boolInput = true;
            end
        end
        
    end
    
    if sum(seriesVolumes == datasetConfigs.volumes(2)) > 1 % More than one localiser
        
        boolInput = false;
        disp(['[createFolderStructure] More than one localiser run data detected: ' num2str(seriesNumbers(seriesVolumes == datasetConfigs.volumes(2))')])
        while ~boolInput
            x = input('Please input the ones to ignore [<series numbers>]: ','s');
            
            if ~ismember(str2double(x),seriesNumbers(seriesVolumes == datasetConfigs.volumes(2)))
                disp('!---> ERROR: Incorrect series number.');
            else
                ignoreS = [ str2double(x) ignoreS ];
                boolInput = true;
            end
        end
        
    end
    
    %     if isempty(ignoreS)
    %         disp('[createFolderStructure] Ignoring extra files.');
    %     else
    disp(['[createFolderStructure] Ignoring files with series number of ' num2str(ignoreS')]);
    files(ismember(series,ignoreS)) = [];
    seriesNumbers(ismember(seriesNumbers,ignoreS)) = [];
    %     end
    
    if length(seriesNumbers) > n_runs
        ignoreS = [];
        boolInput = false;
        disp(['[createFolderStructure] ' num2str(length(seriesNumbers) - n_runs) ' extra series remain.']);
        while ~boolInput
            disp(['[createFolderStructure] Current series: ' mat2str(seriesNumbers) '.'])
            x = input('Please input the ones to ignore [<series numbers>]: ','s');
            
            if length(str2double(x)) > length(seriesNumbers) - n_runs
                disp(['!---> ERROR: Too many series to delete. Choose only ' length(seriesNumbers) - n_runs ]);
            elseif ~ismember(str2double(x),seriesNumbers)
                disp('!---> ERROR: Incorrect series number.');
            else
                ignoreS = [ str2double(x) ignoreS ];
                boolInput = true;
            end
        end
        disp(['[createFolderStructure] Ignoring files with series number of ' num2str(ignoreS')]);
        files(ismember(series,ignoreS)) = [];
        seriesNumbers(ismember(seriesNumbers,ignoreS)) = [];
    end
    
elseif length(seriesNumbers) < length(datasetConfigs.runs)
    disp('[createFolderStructure] !---> ERROR: Unsufficient data.')
    boolInput = false;
    while ~boolInput
        x = input('[createFolderStructure] Do you wish to proceed anyway (Y/N)?','s');
        switch lower(x)
            case 'y'
                n_runs = length(seriesNumbers);
                boolInput = true;
            otherwise
                return
        end
    end
end

% Subject folder
subjectFolder = fullfile(datasetConfigs.path,datasetConfigs.subjects{subjectIndex});

boolInput = false;

if exist(subjectFolder,'dir') == 7
    while ~boolInput
        x = input('[createFolderStructure] Subject Folder already exists. Do you wish to overwrite (Y), stop (N) or proceed (P)?','s');
        switch lower(x)
            case 'y'
                rmdir(subjectFolder,'s')
                mkdir(subjectFolder)
                boolInput = true;
            case 'n'
                return
            case 'p'
                success = true;
                return
            otherwise
                disp('[createFolderStructure] !---> ERROR: Invalid input.')
        end
    end
else
    mkdir(subjectFolder)
end

% Iteration runs
for r = 1:n_runs
    
    % Create folder structure
    switch datasetConfigs.runs{r}
        case 'anatomical'
            mkdir(subjectFolder,datasetConfigs.runs{r});
            mkdir(fullfile(subjectFolder,datasetConfigs.runs{r}),'PROJECT');
            auxfolder = fullfile(subjectFolder,datasetConfigs.runs{r},'DATA');
        otherwise
            mkdir(subjectFolder,['run-' datasetConfigs.runs{r} '-data']);
            mkdir(fullfile(subjectFolder,['run-' datasetConfigs.runs{r} '-data']),'PROJECT');
            auxfolder = fullfile(subjectFolder,['run-' datasetConfigs.runs{r} '-data'],'DATA');
            mkdir(fullfile(subjectFolder,['run-' datasetConfigs.runs{r} '-data'],'PROJECT'),'PROCESSING');
            mkdir(fullfile(subjectFolder,['run-' datasetConfigs.runs{r} '-data'],'PROJECT'),'ANALYSIS');
            mkdir(fullfile(subjectFolder,['run-' datasetConfigs.runs{r} '-data'],'PROJECT'),'TBVTARGET');
            
            % Copy Protocol
            if ~isempty(dir(fullfile(dataTBV,[datasetConfigs.prtPrefix{r-1} '*.prt']))) % .prt in the same folder as .tbv

                auxDir = dir(fullfile(dataTBV,[datasetConfigs.prtPrefix{r-1} '*.prt']));
                
                if length(auxDir) > 1
                    boolInput = false;
                    disp(['[createFolderStructure] More than one ' datasetConfigs.runs{r} ' run prt file detected: '])
                    disp(extractfield(auxDir,'name')');
                    
                    while ~boolInput
                        x = input(sprintf('Please input the number (1:%i) of the PRT to keep: ',length(auxDir)),'s');
                        
                        if isnan(str2double(x)) || str2double(x) > length(auxDir)
                            fprintf('!---> ERROR: Please insert a number between 1 and %i/n.',length(auxDir));
                        else
                            keepDir = auxDir(str2double(x));
                            boolInput = true;
                        end
                    end
                else
                    keepDir = auxDir;
                end
                
                copyfile(fullfile(keepDir.folder,keepDir.name),fullfile(subjectFolder,['run-' datasetConfigs.runs{r} '-data'],'PROJECT','ANALYSIS'));                
                
            elseif ~isempty(dir(fullfile(dataTBV,'TargetFolder',[datasetConfigs.prtPrefix{r-1} '*.prt']))) % .prt inside TargetFolder
                
                auxDir = dir(fullfile(dataTBV,'TargetFolder',[datasetConfigs.prtPrefix{r-1} '*.prt']));
                
                if length(auxDir) > 1
                    boolInput = false;
                    disp(['[createFolderStructure] More than one ' datasetConfigs.runs{r} ' run prt file detected: '])
                    disp(extractfield(auxDir,'name')');
                    
                    while ~boolInput
                        x = input(sprintf('Please input the number (1:%i) of the PRT to keep: ',length(auxDir)),'s');
                        
                        if isnan(str2double(x)) || str2double(x) > length(auxDir)
                            fprintf('!---> ERROR: Please insert a number between 1 and %i/n.',length(auxDir));
                        else
                            keepDir = auxDir(str2double(x));
                            boolInput = true;
                        end
                    end
                else
                    keepDir = auxDir;
                end
                
                copyfile(fullfile(keepDir.folder,keepDir.name),fullfile(subjectFolder,['run-' datasetConfigs.runs{r} '-data'],'PROJECT','ANALYSIS'));
                
            else
                disp('[createFolderStructure] No .prt file found in TBV folder.')
            end
            
    end
    
    % Copy data files
    fprintf('Copying %s files...\n',datasetConfigs.runs{r});
    copyfile(fullfile(dataPath,[ auxname(1:aux2-1) num2str(seriesNumbers(r),'%.4i') '*']) , auxfolder );
    
end

% Copy TBV files
try
    copyfile(fullfile(dataTBV,'*.tbv'),fullfile(subjectFolder,'TBV'));
catch
    disp('[createFolderStructure] No .tbv files found to copy.')
end

% Copy and Shift ROI files
try
    copyfile(fullfile(dataTBV,'NF*.roi'),fullfile(subjectFolder,'TBV'));
    
    if shiftROI
        roiname = dir(fullfile(dataTBV,'NF*.roi'));
        
        for i=1:length(roiname)
            shifterROI(fullfile(subjectFolder,'TBV'),roiname(i).name);
        end
    end
    
catch
    disp('[createFolderStructure] No .roi files found to copy.')
end

success = true;
disp('[createFolderStructure] Folder structure creation completed.')

end

