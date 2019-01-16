function [fCross] = designFixationCross( windowRect )
%DESINGFIXATIONCROSS Summary of this function goes here
%   Detailed explanation goes here


    % Get the centre coordinate of the window
    [fCross.xCenter, fCross.yCenter]=RectCenter(windowRect);
    
    % set of size of the arms of our fixation cross
    fCross.fixCrossDimPix=20;
    % set the line width for our fixation cross
    fCross.lineWidthPix=4;
        
    % set the coordinates for fixation cross in the center of the screen
    fCross.xCrossCoords=[-fixCrossDimPix fixCrossDimPix 0 0];
    fCross.yCrossCoords=[0 0 -fixCrossDimPix fixCrossDimPix];
    fCross.CrossCoords=[xCrossCoords; yCrossCoords];
     

end

