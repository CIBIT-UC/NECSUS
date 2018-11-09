% Load data from MRI setup
load('rgblumGRAY10-Mar-2016.mat')

% Fit data to gamma function
[gray_fitparam,gray_gof] = fit(RGB_lum(2:end,1),RGB_lum(2:end,2),'power2');
%val(x)=a*x^b+c;
grayc = (gray_fitparam.a*((0:1/255:1).^(gray_fitparam.b)))+gray_fitparam.c;

figure;
% subplot(3,1,1); hold on;
plot(RGB_lum(:,1),RGB_lum(:,2),'r.');
hold on;
plot(0:1/255:1,grayc,'k');
title('Luminance Response');


%%
% O gammavalue calculado aqui tb (params1(1)):
clear measTest

% see help for FitGamma in Psychophysics Toolbox
measTest(:,1)=RGB_lum(:,1)*255;
%measTest(:,2)=RGB_lum(:,canhao); %canhao=2:size(RGB_lum,2)
measTest(:,2)= RGB_lum(1:end,2); 

%%%%  put your data into 'meas'
meas = measTest;
maxIndex = 255;  %  +1 = total num of indices
indexNormal = [0:0.001:1]';
maxLum = meas(size(meas,1),2)
[out1 params1  message1] = FitGamma(meas(:,1)/maxIndex,  meas(:,2)/maxLum, indexNormal, 1);


%%
figure;
% subplot(3,1,1); hold on;
plot(out1(:,1),'r.');

title('Luminance Response');
