
function plotGlare(glare, wScreen, white, black)

% [minSmoothPointSize, maxSmoothPointSize, minAliasedPointSize, maxAliasedPointSize] = Screen(%DrawDots , windowPtr, xy [,size] [,color] [,center] [,dot_type][, lenient]);


glare.y = randsample(glare.s,size(glare.xymatrix,2), glare.numBlinkingDots)

Screen('DrawDots', wScreen, glare.xymatrix(:,glare.y), glare.glareDotWidthPixs, black);
Screen('Flip', wScreen, 1);

pause(glare.blinkOffTime)

% Screen('DrawDots', w, xymatrix, s, colvect, center, 1); 
Screen('DrawDots', wScreen,  glare.xymatrix, glare.glareDotWidthPixs, white);  
Screen('Flip', wScreen, [], 1);

end



