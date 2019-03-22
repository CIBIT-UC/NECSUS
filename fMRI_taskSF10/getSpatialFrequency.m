function [SF] = getSpatialFrequency(screenHeight,screenYpixels,viewingDistance,desiredSF)

%This function calculates the Spatial Frequency desired (cycles Per Pixel)

    % pixel size  
    PixelSize = screenHeight/screenYpixels;
    
    % This is the projetion of one degree on the screen (cm)
    oneDegreeOnScreen = tan(pi/180)* viewingDistance ;
    
    % Number of pixels per degree
    pixelsInDegree = oneDegreeOnScreen/PixelSize;
    
    % How many pixels will each period/cycle occupy?
    pixelsPerPeriod = pixelsInDegree/desiredSF;  

%     % How many periods/cycles are there in a pixel?
    SF= 1/pixelsPerPeriod;


end

