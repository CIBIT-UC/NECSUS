function [methodStruct] = methodInitialization(methodName)

switch methodName
    case 'QUEST'
        methodStruct=initializationQuest();
    case 'ConstantStimuli'
        methodStruct=initializationConstStim();

end

