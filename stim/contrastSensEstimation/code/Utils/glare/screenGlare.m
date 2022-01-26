
function screenGlare(glare, wScreen, color, blink)

% [minSmoothPointSize, maxSmoothPointSize, minAliasedPointSize, maxAliasedPointSize] = Screen(%DrawDots , windowPtr, xy [,size] [,color] [,center] [,dot_type][, lenient]);

if blink
    Screen('DrawDots', wScreen, glare.xymatrix(:,glare.y), glare.glareDotWidthPixs, color);
else
    Screen('DrawDots', wScreen,  glare.xymatrix, glare.glareDotWidthPixs, color);  
end



% 
% glare.y = randsample(glare.s,size(glare.xymatrix,2), glare.numBlinkingDots)
% 
% Screen('DrawDots', wScreen, glare.xymatrix(:,glare.y), glare.glareDotWidthPixs, backgrCol);
% Screen('Flip', wScreen, 1);
% 
% pause(glare.blinkOffTime)
% 
% % Screen('DrawDots', w, xymatrix, s, colvect, center, 1); 
% Screen('DrawDots', wScreen,  glare.xymatrix, glare.glareDotWidthPixs, white);  
% Screen('Flip', wScreen, [], 1);

end



