

function [methodStruct] =  updateEstimate(methodStruct, answer)

switch methodStruct.name
    case 'QUEST'
        methodStruct=updateQuestEstimate( methodStruct, answer );
    case 'QUESTFSS'
        methodStruct=updateQuestfssEstimate( methodStruct, answer );
        
    case 'ConstantStimuli'
        % do nothing - no update required.
end

end
