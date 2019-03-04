% Randomize patients and order of tasks
clear all

% Presets.
% Different groups in the study (lenses type, controls, etc.).
nGroups=3;
numElemtnsPerGroup=[11,12,10];
groupDescriptions={'Controls','Monofocal lenses','Bifocal lenses'};


%% Randomize

% Create struct.
groups=struct();

% Create each group.
for i=1:nGroups
    % Number of patients per group (i.e. nGroups = numel(nPatPerGroup))
    groups(i).nElements=numElemtnsPerGroup(i);
    % description of each group
    groups(i).description=groupDescriptions{i};
end

% Total number of participants in the study.
totNumPats=sum([groups.nElements]);

% block randomization
% If the block size is four, we can make six possible sequences;
% these are AABB, ABAB, ABBA, BAAB, BABA, BBAA, and we randomize them.

% A - with glare first and without glare second
% B - without glare first and with glare second
blockRandSize=4;
blockTemplt={'A','B','A','B'};

% Randomize patients.
for g=1:nGroups
    % sequence for
    groups(g).blockSeq=[];
   
    nBlocks=floor(groups(g).nElements/blockRandSize);
    blockRem=nBlocks;
    
    % while block remaining do random
    while blockRem>0
        b=1:nBlocks;
        idxs=randperm(blockRandSize);
        groups(g).blockSeq=[groups(g).blockSeq {blockTemplt{idxs}}];
        blockRem = blockRem-1;
    end
    remainder=rem(groups(g).nElements,blockRandSize);
    
    if remainder
        groups(g).blockSeq=[groups(g).blockSeq {blockTemplt{randperm(remainder)}}];
    end
    
end % number of groups

%%

save patntRandzd groups