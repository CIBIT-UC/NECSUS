% main

prtPath='prts';

fn={'EVENTS_BOLD_RUN1_VOL.prt',...
    'EVENTS_BOLD_RUN2_VOL.prt',...
    'EVENTS_BOLD_GLARE_RUN1_VOL.prt',...
    'EVENTS_BOLD_GLARE_RUN2_VOL.prt'};

% sub-02_ses-01_task-glare_run-01_bold.json
out_fn={'noglare_run-01';...
    'noglare_run-02';...
    'glare_run-01';...
    'glare_run-02'};

TR=2;

%%
subs=51;

%% Contrast runs

for s = subs

    
    sub = num2str(s,'%02.f');

    for i=1:numel(fn)
        
        outFn=['sub-' sub '_ses-02_task-' out_fn{i} '_events'];
        
        fprintf('Creating file %s based on prt.\n',outFn);
        
        convertPRTtoTSV(prtPath, fn{i}, outFn, TR);
    
    end

end