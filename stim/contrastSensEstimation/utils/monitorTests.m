%% LCD display tests

pathBase='C:\Users\Bruno\Desktop\LuminanciaLCD-PR650-dez2018\LCDnexus';

% gray values no light no leds
pathToGraydata= fullfile(pathBase, 'NecsusNolightGray-rgblum11-Dec-2018.mat');
[gammaPar, gammaPar2]=characterizeMonitor(pathToGraydata, 'noLightNoLEDs');
% maxVal = GetMaxLuminance(pathToGraydata);
% fprintf('Maximum lumnance from setup is %f. \n', maxVal);

% gray values no light WITH leds
pathToGraydata= fullfile(pathBase, 'necsusLedON-GRAY-LCD_monitor_RGB_Lum11-Dec-2018.mat');
[gammaPar, gammaPar2]=characterizeMonitor(pathToGraydata, 'noLightWithLEDs');
% maxVal = GetMaxLuminance(pathToGraydata);
% fprintf('Maximum lumnance from setup is %f. \n', maxVal);

% gray values With light WITH leds
pathToGraydata= fullfile(pathBase, 'necsusLightsONLedsON-GRAY-LCD_monitor_RGB_Lum11-Dec-2018.mat');
[gammaPar, gammaPar2]=characterizeMonitor(pathToGraydata, 'withLightWithLEDs');
% maxVal = GetMaxLuminance(pathToGraydata);
% fprintf('Maximum lumnance from setup is %f. \n', maxVal);


%% MR setup


pathBase='C:\Users\Bruno\Documents\GitHub\NECSUS\stimuli\contrast';

% gray values no light no leds
pathToGraydata= fullfile(pathBase, 'rgblumGRAY10-Mar-2016.mat');
[gammaPar, gammaPar2]=characterizeMonitor(pathToGraydata, 'MRScannerNoLightNoLEDs');
% maxVal = GetMaxLuminance(pathToGraydata);
% fprintf('Maximum lumnance from setup is %f. \n', maxVal);

%%

