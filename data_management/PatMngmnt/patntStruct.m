% Load current idxs for each group-
load idxs.mat;

% Check group and id of the patient.
subjects=struct();

% Create new study subject
subject.name='';
subject.group='';
subject.id='%idx_from_group%';

% update id and save idxs file