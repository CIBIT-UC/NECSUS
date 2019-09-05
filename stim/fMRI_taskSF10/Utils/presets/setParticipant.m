function p=setParticipant(ID, NT, GT, GNT)

%-------------------------------------------------------------------------%
% This function creates a struct with information about the participant   %
% Participant.Information:contains the demographic data of the participant%
% Participants.Psychophysic: contains the contrast values obtained in     %
% psychophysical task                                                     %
%-------------------------------------------------------------------------%

p.ID=ID;

p.psychophysic.NT=NT;
p.psychophysic.GT=GT;
p.psychophysic.GNT=GNT;

end

