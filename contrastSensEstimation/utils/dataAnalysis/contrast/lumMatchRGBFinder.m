function [invertGammaInput, Rb, Gb, Bb] = lumMatchRGBFinder(lumRequired, bitsRes, pathToGreydata)
% example [invertGammaInput, Rb, Gb, Bb] = lumMatchRGBFinder(20, 8, 'Common\LCD_linear_Acromatic_grey_data.mat')

%%
if nargin<1
    pathToGreydata='Common\LCD_linear_Acromatic_grey_data.mat';
    lumRequired=20;
    bitsRes=8;
end

% --- load data ---
% LCD monitor RGB matrix on input
% returns RGB_lum (true output), FitParamters (gamma, offset)
load(pathToGreydata);

indexValues=RGB_lum(:,1) * (2^bitsRes - 1);
luminanceMeasurements=RGB_lum(:,2);

% plot values
figure(1); clf;
plot(indexValues,luminanceMeasurements,'b+');
hold on;
xlabel('Pixel Values');
ylabel('Luminance (cd/m2)');


%%
% normalized range
normGammaData = luminanceMeasurements(2:end)./max(luminanceMeasurements);
normGammaInput =  indexValues(2:end,1);

% --- estimate Gamma function ---
output = linspace(0,(2^bitsRes - 1),100)';

% Fit extended gamma power function.
fitType = 2;  %extended power function
[extendedFit,extendedX] = FitGamma(normGammaInput,normGammaData,output,fitType);

% plot sampled luminance and curve fit results
figure(2);clf;
hold on;
plot(output,extendedFit,'g');
plot(normGammaInput,normGammaData,'+'); %sampled luminance

fprintf(1,'\nFound exponent %g, offset %g\n\n',extendedX(1),extendedX(2));

%%
% Inverse function based on gamma data
maxInput = max(normGammaInput);
invertedInput = InvertGammaExtP(extendedX,maxInput,normGammaData);
figure(3); clf; hold on
plot(normGammaInput,invertedInput,'r+');
axis('square');
axis([0 maxInput 0 maxInput]);
plot([0 maxInput],[0 maxInput],'r');

% fprintf('Inverted input %.4f\n\n',invertedInput);

%%

% --- generate inverse gamma luminance function (based on curve fit above) ---
maxLum=max(luminanceMeasurements);
luminanceRamp=0:1/255:1;
pow=extendedX(1);
offset=extendedX(2);
invertedRamp=((maxLum-offset)*(luminanceRamp.^(1/pow)))+offset; %invert gamma w/o rounding
%normalize inverse gamma table
invertedRamp=invertedRamp./max(invertedRamp);
%plot inverse gamma function
figure(4); clf; hold on;
pels=[0:255];
plot(pels,invertedRamp,'r');
axis('square');
axis([0 255 0 1]);
xlabel('Pixel Values');
ylabel('Inverse Gamma Table');
strTitle{1}='Inverse Gamma Table Function';
strTitle{2}=['for Exponent = ',num2str(extendedX(1)),'; Offset = ',num2str(extendedX(2))];
title(strTitle);
hold off;

%% invert data
normLumRequired=lumRequired/maxLum;
invertGammaInput = InvertGammaExtP(extendedX,maxInput,normLumRequired);
invertGammaInput = invertGammaInput / (2^bitsRes - 1);
fprintf('Inverted input %.4f\n\n',invertGammaInput);

%% prepare output
% ~Gray - RGB equal
Rb = round(invertGammaInput*(2^bitsRes - 1));
Gb = round(invertGammaInput*(2^bitsRes - 1));
Bb = round(invertGammaInput*(2^bitsRes - 1));

end