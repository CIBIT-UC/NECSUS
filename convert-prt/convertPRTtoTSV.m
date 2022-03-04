%% Create TSV from PRT

function convertPRTtoTSV(prtPath, prtFile, outFile, TR)
%% Input the prt file


if nargin < 4
    % Provide useful data
    TR = 1; %in seconds
end


outputPath = 'events';

%% Start
[ cond_names , intervalsPRT ,~,~,~, blockDur, blockNum, msecOnset ] = readProtocol( fullfile(prtPath,[prtFile(1:end-4) '.prt']) , TR );

Condition = {};
Onset = [];
Duration = [];
for cc = 1:length(cond_names)
    Condition = [Condition ; repmat({cond_names(cc)},blockNum(cc),1)];
    Onset = [Onset ; msecOnset.(cond_names{cc})(:,1).*TR-TR];
    Duration = [Duration; blockDur.(cond_names{cc})'*TR];
     
end
[Onset,idx] = sort(Onset);
Condition = Condition(idx);
Duration = Duration(idx);

T = table(Condition,Onset,Duration);

export_file = fullfile(outputPath, [outFile '.txt']);

writetable(T,export_file,'Delimiter','\t');
movefile(export_file,[export_file(1:end-4) '.tsv']);

disp('Done')