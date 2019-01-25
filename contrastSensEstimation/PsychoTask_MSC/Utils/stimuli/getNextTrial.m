function [methodStruct] =  getNextTrial(methodStruct, trialIdx)

% If first trial return methodStruct.init else - getnexttrial
if trialIdx==1
    methodStruct.contrastTrial=methodStruct.init;
else
    switch methodStruct.name
        case 'QUEST'
            methodStruct=getNextQuestTrial(methodStruct);
        case 'QUESTFSS'
            methodStruct=getNextQuestfssTrial(methodStruct);
        case 'ConstantStimuli'
            methodStruct=getNextConstStimTrial(methodStruct);
    end
end

end