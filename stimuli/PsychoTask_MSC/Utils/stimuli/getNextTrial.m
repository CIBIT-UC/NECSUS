function [methodStruct] =  getNextTrial(methodStruct)

switch methodStruct.name
    case 'QUEST'
        methodStruct=getNextQuestTrial(methodStruct);
    case 'ConstantStimuli'
        methodStruct=getNextConstStimTrial(methodStruct);
end



end