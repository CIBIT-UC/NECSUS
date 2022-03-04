function [ cond_names , intervalsPRT , intervals , baseCondIndex , colors , blockDurations , blockNumber, msecOnsets ] = readProtocol( prtFullPath , TR )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

Temp_prtFile = xff(prtFullPath);

type = Temp_prtFile.ResolutionOfTime;

intervals=[];

switch type
    case 'msec'
        prtFile = Temp_prtFile.ConvertToVol(TR*1000); %convert TR to msec
%         prtFile.SaveAs(fullfile(path , [name(1:end-4) '_vol.prt']));
    case 'Volumes'
        prtFile = Temp_prtFile;
end

cond_names = prtFile.ConditionNames;

baseCondIndex = 0;
colors = zeros(length(cond_names),3);
%blockDurations = zeros(length(cond_names),1);
blockNumber = zeros(length(cond_names),1);
v = 1;

for cond = 1:length(cond_names)
    
    cond_names{cond} = strtrim(cond_names{cond});
    
    if strcmpi(cond_names{cond},'baseline') || strcmpi(cond_names{cond},'Neutral') || strcmpi(cond_names{cond},'static')
        baseCondIndex = cond;
        intervals = ones(prtFile.Cond(baseCondIndex).OnOffsets(end),1);
    end
    colors(cond,:) = prtFile.Cond(cond).Color;

end

for cond = 1:length(cond_names)
    
    if cond ==1
         
        intervalsPRT.(cond_names{cond}) = prtFile.Cond(cond).OnOffsets;
        
        for int = 1:size(intervalsPRT.(cond_names{cond}),1)
            
            if int==1
                msecOnsets.(cond_names{cond})  = prtFile.Cond(cond).OnOffsets(:,1); 
                blockDurations.(cond_names{cond})(int) = intervalsPRT.(cond_names{cond})(int,2) - intervalsPRT.(cond_names{cond})(int,1) + 1;
            else

                % TO BE CONFIRMED
                msecOnsets.(cond_names{cond})(int)  = prtFile.Cond(cond).OnOffsets(int,1) - (1.3/2); 
                 % intervals(intervalsPRT.(cond_names{cond})(int,1) : intervalsPRT.(cond_names{cond})(int,2) ) = v;

                blockDurations.(cond_names{cond})(int) = intervalsPRT.(cond_names{cond})(int,2) - intervalsPRT.(cond_names{cond})(int,1) + 3.3/2;
            end

        end

        %blockDurations(cond) = intervalsPRT.(cond_names{cond})(end,2) - intervalsPRT.(cond_names{cond})(end,1) + 1;
        blockNumber(cond) = size(intervalsPRT.(cond_names{cond}),1);
        v = v + 1;
    else
        try
            intervalsPRT.(cond_names{cond}) = prtFile.Cond(cond).OnOffsets;
        catch %Invalid condition name for struct
            cond_names{cond} = ['C' cond_names{cond}];
            cond_names{cond} = strrep(cond_names{cond}, '.', '_');
            fprintf('Renaming Condition name to %s\n',cond_names{cond});
            intervalsPRT.(cond_names{cond}) = prtFile.Cond(cond).OnOffsets;
        end
        
        msecOnsets.(cond_names{cond})  = prtFile.Cond(cond).OnOffsets(:,1) ;

        for int = 1:size(intervalsPRT.(cond_names{cond}),1)

            % intervals(intervalsPRT.(cond_names{cond})(int,1) : intervalsPRT.(cond_names{cond})(int,2) ) = v;

            blockDurations.(cond_names{cond})(int) =0.7/2;

        end

        %blockDurations(cond) = intervalsPRT.(cond_names{cond})(end,2) - intervalsPRT.(cond_names{cond})(end,1) + 1;
        blockNumber(cond) = size(intervalsPRT.(cond_names{cond}),1);
        v = v + 1;
    end
    
end

end