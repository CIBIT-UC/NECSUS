%% constrast sensitivity threshold converter to MRI setup
function [T_lum_estimated,T_invertGammaInput,T_Rb,NT_lum_estimated,NT_invertGammaInput,NT_Rb] = contrastConverter(T, NT, pathLCDGreydata, pathMRIGreydata, plotData)
% Get Threshold (50%) and Near Threshold (75%) estimated in the LCD monitor

if nargin<4
    plotData=0;
end

if nargin <1
    % example values
    T=20;
    NT=250;
    pathLCDGreydata='LCD_linear_Acromatic_grey_data.mat';
    pathMRIGreydata='rgblumGRAY10-Mar-2016';
    
end

% --- Use LCD gamma function to estimate 'true luminance'--- %
bitsRes=8;
maxBitsResol=(2^bitsRes-1);
% Load data from LCD - check variables
load(pathLCDGreydata)
% "RGB_lum"
% "FitParameters"
indexValues=RGB_lum(:,1)*maxBitsResol;
luminanceMeasurements=RGB_lum(:,2);

if plotData
    % % plot values
    figure(1); clf;
    plot(indexValues,luminanceMeasurements,'b+');
    hold on;
    xlabel('Pixel Values');
    ylabel('Luminance (cd/m2)');
end

% normalized range
normGammaData=luminanceMeasurements(2:end)./max(luminanceMeasurements);
normGammaInput=indexValues(2:end,1);

% --- estimate Gamma function ---
output=linspace(0,(2^bitsRes - 1),100)';

% Fit extended gamma power function.
fitType=2;  %extended power function
[extendedFit,extendedX]=FitGamma(normGammaInput,normGammaData,output,fitType);

% plot sampled luminance and curve fit results
figure(2);clf;
hold on;
plot(output,extendedFit,'g');
plot(normGammaInput,normGammaData,'+'); %sampled luminance

fprintf(1,'\nFound exponent %g, offset %g\n\n',extendedX(1),extendedX(2));

%% T and NT lum estimation
% T
T_lum_estimated_norm = ((50/255)^extendedX(1))+extendedX(2);
T_lum_estimated = T_lum_estimated_norm*max(luminanceMeasurements);
fprintf('Estimated luminance for T is %f. \n', T_lum_estimated);

%%
NT_lum_estimated = ((255/255)^extendedX(1))+extendedX(2);
NT_lum_estimated= NT_lum_estimated*max(luminanceMeasurements);
fprintf('Estimated luminance for NT is %f. \n', NT_lum_estimated);


%% --- Use MRscanner projector data to estimate similar luminance --- %
% invert true luminance to gamma function of the projector

bitsRes=8;
maxBitsResol=(2^bitsRes-1);
% Load data from MRI projector
load(pathMRIGreydata)

% "RGB_lum"
[T_invertGammaInput,T_Rb,~,~] = lumMatchRGBFinder(T_lum_estimated, bitsRes, pathMRIGreydata);
[NT_invertGammaInput,NT_Rb,~,~] = lumMatchRGBFinder(NT_lum_estimated, bitsRes, pathMRIGreydata);

end
