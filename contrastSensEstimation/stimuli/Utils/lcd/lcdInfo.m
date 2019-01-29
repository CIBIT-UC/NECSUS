function [ lcd ] = lcdInfo(VIEWINGDISTANCE)
% lcdInfo sets lcd info into a structure
%   lcd = lcdInfo() creates a structure with lcd info.
%
% 

lcd=struct();

lcd.screenHeight=25.9; % Screen height (cm) nb. 34.7.
lcd.screenWidth=54.6; % Screen width (cm).
lcd.viewingDistance=VIEWINGDISTANCE; %150; % Viewing Distance (cm).

lcd.bitres=8; % Bits.


end

