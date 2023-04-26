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

trial_type = {};
onset = [];
duration = [];
for cc = 1:length(cond_names)
    trial_type = [trial_type ; repmat({cond_names(cc)},blockNum(cc),1)];
    onset = [onset ; msecOnset.(cond_names{cc})(:,1).*TR-TR];
    duration = [duration; blockDur.(cond_names{cc})'*TR];
end

[onset,idx] = sort(onset);
trial_type = trial_type(idx);
duration = duration(idx);

T = table(onset,duration,trial_type);

export_file = fullfile(outputPath, [outFile '.txt']);

writetable(T,export_file,'Delimiter','\t');
movefile(export_file,[export_file(1:end-4) '.tsv']);

disp('Done')