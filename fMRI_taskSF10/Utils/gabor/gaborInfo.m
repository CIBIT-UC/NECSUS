function [ gabor ]=gaborInfo(sfrq)
% gaborInfo sets gabor info into a structure
%   gabor = gaborInfo(sfrq) creates a structure with gabor info.
%
%

gabor=struct();

gabor.gaborDimDegree=12; %750; % Dimension of the region where will draw the Gabor in pixels

gabor.phase=0; % spatial phase
gabor.angle=0; %the optional orientation angle in degrees (0-360)
gabor.aspectratio=1.0; % Defines the aspect ratio of the hull of the gabor
gabor.spatFreq=sfrq; % Desired Spatial Frequency in cpd.

% % % Presentation Time for the Gabor in seconds and frames
% % gabor.presTimeSecs = 0.5; %500msec

end
