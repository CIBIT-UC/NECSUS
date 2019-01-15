function maxVal = GetMaxLuminance(pathToGrayData)

load(pathToGrayData)

maxVal = max(RGB_lum(:,2));

return

end