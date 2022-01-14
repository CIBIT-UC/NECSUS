function [ lcd ] = lcdInfo(VIEWINGDISTANCE, pathToGreyData)
% lcdInfo sets lcd info into a structure
%   lcd = lcdInfo() creates a structure with lcd info.
%
% 

lcd=struct();

lcd.pathToGreyData=pathToGreyData;

% Debug office.
lcd.screenHeight=25.9; % Screen height (cm) 
lcd.screenWidth=54.6; % Screen width (cm).
lcd.viewingDistance=VIEWINGDISTANCE; %150; % Viewing Distance (cm).

% % % At home.
% % lcd.screenHeight=29.6; % Screen height (cm) 
% % lcd.screenWidth=52.7; % Screen width (cm).
% % lcd.viewingDistance=VIEWINGDISTANCE; %150; % Viewing Distance (cm).

lcd.bitres=8; % Bits.


end

