% QuestInitialization  Initializes the PTB QUEST method
%   C = QuestInitialization() creates a structure with defualt values.
%
%   See also PTB, QUEST.
function [questStruct] = initializationQuest()

questStruct=struct(); %init struct

% Estimation based on previous data / initial guess
questStruct.estMean=6.2980;
questStruct.estStd=4.3992;

% Stopping criteria
questStruct.nTrials=50;

% QUEST parameters
questStruct.CsfScale=0:.3:60;
questStruct.deltInt=.15;
questStruct.init=6;
questStruct.direction=0;
questStruct.last=questStruct.init;


% Watson AB, Pelli DG (1983) Quest: A Bayesian adaptive psychometric method. Percept Psychophys 33:113–120.
questStruct.pThreshold=0.82;
questStruct.beta=3.5;
questStruct.delta=0.05;
questStruct.gamma=0.5;

questStruct.grain=0.05;
questStruct.dim=250;

questStruct.plotIt=1;

end