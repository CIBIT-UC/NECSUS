%% create estimate for contrast (mean and SD)
%% Threshold estimate based on previous set of participants.

%% presets and constants
clear all, 
close all,
clc

% get previous files
thresholdFiles = dir('C:\DataBackup\Desktop\NECSUS\source_code\neuromodulacao\PsychoTask_MSC\Treshoulds\*10_TestAnswers_noglare.mat'); % var: results

%% Load files and compute mean/SD of contrast value
rAnalysis.T = [];
rAnalysis.NT = [];

for f = 1:numel (thresholdFiles)
    c_file = thresholdFiles(f);
    try
        load (fullfile( c_file.folder, c_file.name))
        rAnalysis.T(f) = Treshould.T;
        rAnalysis.NT(f) = Treshould.NT;
        
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

figure(1)
hold on;
plot(rAnalysis.T, 'bo')
plot(rAnalysis.NT, 'b.', 'MarkerSize', 20)

%%

for i =1:numel(rAnalysis.T)
   
    ratSum(i)=rAnalysis.NT(i)/rAnalysis.T(i);
    thrSub(i)=rAnalysis.NT(i)-rAnalysis.T(i);
    
end

fprintf('Mean of the ratio between NT and T is %.3f.\n',nanmean(ratSum))
fprintf('Standard deviation of the ratio between NT and T is %.3f.\n',nanstd(ratSum))
fprintf('max of the ratio between NT and T is %.3f.\n',nanmax(ratSum))
fprintf('min of the ratio between NT and T is %.3f.\n',nanmin(ratSum))

figure (1)
boxplot(ratSum)
xticklabels( {'NT/T ratio'})
%%

figure (2)
boxplot([rAnalysis.T, rAnalysis.NT],[zeros(1,95), ones(1,95)])
xticklabels( {'T', 'NT'})


figure (3)
boxplot(thrSub)