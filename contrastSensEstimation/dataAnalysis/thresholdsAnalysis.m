%% create estimate for contrast (mean and SD)
%% Threshold estimate based on previous set of participants.

%% presets and constants
clear all, 
close all,
clc

% get previous files
thresholdFiles = dir('..\stimuli\Results\*.mat'); % var: results

%% Load files and compute mean/SD of contrast value
rAnalysis.T = [];
rAnalysis.NT = [];

for f = 1:numel (thresholdFiles)
    c_file = thresholdFiles(f);
    try
        load (fullfile( c_file.folder, c_file.name))
        rAnalysis.T(f) = results.threshold;
        rAnalysis.NT(f) = results.nearThreshold;
        rAnalysis.METHOD{f}= results.method;
    catch me
        disp(me)
        warning( ['Problem with file ', fullfile( c_file.folder, c_file.name)]);
    end
end

%% mean and SD
mean_thres = mean (rAnalysis.T);
sd_thres = std (rAnalysis.T);

[ max_thres, idx ] = max (rAnalysis.T);
[ min_thres, idx ] = min (rAnalysis.T);

fprintf('The mean is %.3f, maximum is %.3f and the minimum is %.3f \n', mean_thres, max_thres, min_thres)

%%



questR=rAnalysis.T(strcmp(rAnalysis.METHOD,'QUEST'));
csR=rAnalysis.T(strcmp(rAnalysis.METHOD,'ConstantStimuli'));

figure(1)
subplot(2,1,1);
hold on;
plot(questR, 'bo')
plot(rAnalysis.NT(strcmp(rAnalysis.METHOD,'QUEST')), 'b.', 'MarkerSize', 20)

legend({'QUEST T','QUEST NT'});

subplot(2,1,2);
hold on;
plot(csR(find(csR<7)), 'ro');
plot(rAnalysis.NT(strcmp(rAnalysis.METHOD,'ConstantStimuli')), 'r.', 'MarkerSize', 20)

legend({ 'Const Stim T','Const Stim NT'});



figure(2)
hold on;

boxplot([questR, csR(find(csR<7))],[zeros(size(questR)), ones(size(csR(find(csR<7))))]);




