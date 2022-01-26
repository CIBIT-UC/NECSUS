function glare = setBlink(glare)

glare.y = randsample(glare.s,size(glare.xymatrix,2), glare.numBlinkingDots);


end