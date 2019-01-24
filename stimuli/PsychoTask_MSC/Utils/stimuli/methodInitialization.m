function [methodStruct] = methodInitialization(methodName)

switch methodName
    case 'QUEST'
        methodStruct=initializationQuest();
    case 'QUESTFSS'
        methodStruct=initializationQuestfss();
    case 'ConstantStimuli'
        methodStruct=initializationConstStim();
        
end

