% randomize patients and order of tasks

nGroups=3; % different groups in the study (lenses type/Controls)

nPatPerGroup=[11,12,10]; % number of patients per group (nGroups = numel(nPatPerGroup))
groupDescrp={'group1','group2','group3'}; % description of each group

totNumPats=sum(nPatPerGroup);

% block randomization 
% If the block size is four, we can make six possible sequences; 
% these are AABB, ABAB, ABBA, BAAB, BABA, BBAA, and we randomize them.
blockRandSize=4;
blockTemplt={'A','B','A','B'};


% randomize patients
for g=1:nGroups
    blockSeq{g}=[];
    nPats=nPatPerGroup(g);
        
    nBlocks=floor(nPats/blockRandSize);
    blockRem=nBlocks;
    
    % while block remaining do random
    while blockRem>0
        b=1:nBlocks;
        idxs=randperm(blockRandSize);
        blockSeq{g}=[blockSeq{g} {blockTemplt{idxs}}];
        blockRem = blockRem-1;
    end 
    remainder=rem(nPats,blockRandSize);
    
    if remainder
         blockSeq{g}= [blockSeq{g} {blockTemplt{randperm(remainder)}}];
    end
        
end % number of groups

%%

save patntRandzd blockSeq groupDescrp nPatPerGroup