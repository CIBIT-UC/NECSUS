function [smp_RH, smp_LH, poi_RH, poi_LH, srf_RH, srf_LH] = LoadSubjectData(pathFilesParticipant)
?
SMP_POSITION_HEMISPHERE = 4;
POI_POSITION_HEMISPHERE = 4;
SRF_POSITION_HEMISPHERE = 6;
?
Logger = log4m.getLogger('log_ageing_receptive_fields.txt');
?
filesParticipant = dir(pathFilesParticipant);
?
has_files = zeros(1, 6);
?
for i = 1: length(filesParticipant)
    filename = filesParticipant(i).name;
?
    if (length(filename) < 3)
        continue;
    end
?
?
    filenameSplited = split(filename, '_');
    pathFile =  strcat(filesParticipant(i).folder, '/', filesParticipant(i).name);
?
    extension = filename((length(filename)-3):length(filename));
?
    if strcmp(extension, '.smp')
        hemisphere = filenameSplited{SMP_POSITION_HEMISPHERE}(1);
        if (strcmp(hemisphere, 'R'))
?
            has_files(1) = has_files(1) + 1;
            Logger.info(mfilename, sprintf('Reading Right Hemisphere file %s', pathFile))
?
            smp_RH = BVQXfile(pathFile);
?
        elseif  (strcmp(hemisphere, 'L'))
?
            has_files(2) = has_files(2) + 1;
            Logger.info(mfilename, sprintf('Reading Left Hemisphere file %s', pathFile))
?
            smp_LH = BVQXfile(pathFile);
            
        end
?
    elseif strcmp(extension, '.poi')
?
        hemisphere = filenameSplited{POI_POSITION_HEMISPHERE}(1);
        if (strcmp(hemisphere, 'R'))
?
            has_files(3) = has_files(3) + 1;
            Logger.info(mfilename, sprintf('Reading Right Hemisphere file %s', pathFile))
?
            poi_RH = BVQXfile(pathFile);
        elseif (strcmp(hemisphere, 'L'))
?
            has_files(4) = has_files(4) + 1;
            Logger.info(mfilename, sprintf('Reading Left Hemisphere file %s', pathFile))
?
            poi_LH = BVQXfile(pathFile);
        end
?
    elseif strcmp(extension, '.srf')
        hemisphere = filenameSplited{SRF_POSITION_HEMISPHERE}(1);
        if (strcmp(hemisphere, 'R'))
?
            has_files(5) = has_files(5) + 1;
            Logger.info(mfilename, sprintf('Reading Right Hemisphere file %s', pathFile))
?
            srf_RH = BVQXfile(pathFile);
        elseif (strcmp(hemisphere, 'L'))
?
            has_files(6) = has_files(6) + 1;
            Logger.info(mfilename, sprintf('Reading Left Hemisphere file %s', pathFile))
?
            srf_LH = BVQXfile(pathFile);
        end
    end
end
?
assert(sum(has_files>0) == 6 & sum(has_files) == 6)
end