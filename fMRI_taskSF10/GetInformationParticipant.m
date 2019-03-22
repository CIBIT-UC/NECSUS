function Participant = GetInformationParticipant

%-------------------------------------------------------------------------%
% This function creates a struct with information about the participant   %
% Participant.Information:contains the demographic data of the participant%
% Participants.Psychophysic: contains the contrast values obtained in     %
% psychophysical task                                                     %
%-------------------------------------------------------------------------%


ID=input('ID:','s'); % initials of the participant's name _ visit

% between ' '

Name='teste';
Gender='M';
DoB='05/01/1955'; % date of birth of the participant
NT_SF='2.8288';
GT_SF='3.0811';
GNT_SF='3.7883';

Participant.Information.ID=ID;
Participant.Information.Name=Name;
Participant.Information.Gender=Gender;
Participant.Information.DoB=DoB;


Participant.Psychophysic.NT_SF=NT_SF;
Participant.Psychophysic.GT_SF=GT_SF;
Participant.Psychophysic.GNT_SF=GNT_SF;
Participant.Psychophysic.GNT_SF=GNT_SF;

end

