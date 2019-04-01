function [linInput] = luminanceToRgb(lumRequired, bitsRes, pathToGreyData)

if nargin<3  
    % MR scanner
    pathToGreyData=fullfile(pwd,'Utils','luminance','rgblumGRAY10-Mar-2016.mat.mat');
    
    % LCD lab 95
    % pathToGreyData=fullfile(pwd,'Utils','luminance','NecsusNolightGray-rgblum11-Dec-2018.mat');
end

if nargin<2
    bitsRes=8;
end

if nargin<1
    lumRequired=20;
end

% --- load data ---
% LCD monitor RGB matrix on input
% returns RGB_lum (true output), FitParamters (gamma, offset)
load(pathToGreyData);

maxLum=max(RGB_lum(:,2));

% Assuming linear CLUT.
linInput=lumRequired/maxLum;

end