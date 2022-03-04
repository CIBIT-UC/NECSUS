% main

prtPath='prts';

fn={'EVENTS_BOLD_RUN1_msec.prt'};

% sub-02_ses-01_task-glare_run-01_bold.json
out_fn={'noglare_run-01_temp'};

TR=2;

%%
sub='02';

%% Contrast runs

for i=1:numel(fn)
    
    
   % outFn=['sub-' sub '_ses-01_task-' out_fn{i} '_events'];
    
    prtFile = xff(fullfile(fn{i}));
    
    prtFile.ConvertToMS(TR*1000);
    
    for j=1:5
        prtFile.Cond(j).OnOffsets= prtFile.Cond(j).OnOffsets* 1000
    end
    
    prtFile.SaveAs('prt_msec.prt')


end