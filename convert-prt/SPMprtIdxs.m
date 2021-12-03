%% Clear and close
clc

clear all 
close all

%% Load data from fastrak

fid = fopen('events/sub-03_ses-01_task-er_run-01_events.tsv');
data = textscan(fid, "%s %s %s");
success = fclose(fid);

%%

% Unique - conditions avaliablep
labels=unique(data{1}(3:end));

for e=1:numel(labels)

    % Rows corresponding to condition e.
    condIdxs=find(endsWith(data{1}, labels{e}));
    
    fprintf('%s, ',labels{e} );
    
    for i=1:numel(condIdxs)
        fprintf('%s, ',data{2}{condIdxs(i)});
       
    end
    fprintf('\n');  
end


    