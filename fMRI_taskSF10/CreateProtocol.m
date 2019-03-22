function [StimuliPrt] = CreateProtocol(chaos,nrepeats,tr,tr_factor,protocolName,conditionsV,Participant)
% ------------------------------------------------------------------------%
%                Funtion to create the protocol                           % 
%-------------------------------------------------------------------------%

% Build a variable with specific values of the treshold and near treshold
% for each participant (determined in psychophysical task)
%conditionsV = getConditions(NT_SF,GT_SF,GNT_SF);

StimuliPrt.parameters.blocks_mutliplier=1; % each event is processed as a block 
StimuliPrt.parameters.events_multiplier=nrepeats; % number of repetitions of each event
StimuliPrt.parameters.conditions_range=length(conditionsV); % number of conditions
StimuliPrt.parameters.tr=tr; % repetition time
StimuliPrt.parameters.trial_duration=0.700;


% create a space for the complete protocol
StimuliPrt.events=cell(nrepeats*length(conditionsV),5);

% Repeat the conditionsV (16 trials of each contrast value) 
% the protocol is complete after 64 trials 
condition = [];
for i=1:nrepeats
    condition = [condition;conditionsV];
end

for j=1:length(chaos)
    StimuliPrt.events{j,1}=condition{chaos(j),1}; % string with identification of conditions
    StimuliPrt.events{j,2}=condition{chaos(j),2}; %  contrast value 
    StimuliPrt.events{j,4}=condition{chaos(j),3}; % spatial frequency value 
    StimuliPrt.events{j,5}=condition{chaos(j),4}; % ID of each trial (1-4)
%     if debug(4)~=0
%          StimuliPrt.events{j,3}=1
%     else
        StimuliPrt.events{j,3}=tr*tr_factor(j)-StimuliPrt.parameters.trial_duration+tr; %fixation duration
%     end
end

% start and end times of each stimulation and fixation trial for
% BrainVoyager 
% end_time: the total time duration of the experiment

[end_time,bv]=timecourseGenerate(StimuliPrt);

% Add final timecourse values to 'stimuliPrt'
StimuliPrt.timecourse.total_time = end_time;
StimuliPrt.timecourse.total_volumes = StimuliPrt.timecourse.total_time/StimuliPrt.parameters.tr;
StimuliPrt.timecourse.bv = bv;
StimuliPrt.timecourse.prtgen.chaos = chaos;
StimuliPrt.timecourse.prtgen.tr_factor = tr_factor;

%----------------CREATE PROTOCOL FILES FOR BRAINVOYAGER-------------------%

mkdir(['Output/',num2str(Participant.Information.ID),'/'],protocolName);

for k=1:length(bv.start(1,:))
    
    fname=['Output/',num2str(Participant.Information.ID),'/',protocolName,'/ev',num2str(k),'.txt'];
    fid = fopen(fname, 'w');
    
    for kk=1:length(bv.start(:,k))
        
        fprintf(fid, '%g %g\n', bv.start(kk,k), bv.end(kk,k));
        
    end
    
    fclose(fid);
end

fid = fopen(['Output/',num2str(Participant.Information.ID),'/',protocolName,'/fix.txt'], 'w');

for ksi=1:length(bv.fixation.start(:,1))
    
    if ksi == length(bv.fixation.start(:,1))
        fprintf(fid, '%g %g\n', bv.fixation.start(ksi,1), bv.fixation.end(ksi,1)+1);
    else
        fprintf(fid, '%g %g\n', bv.fixation.start(ksi,1), bv.fixation.end(ksi,1));
    end
    
end
        
fclose(fid);


return

