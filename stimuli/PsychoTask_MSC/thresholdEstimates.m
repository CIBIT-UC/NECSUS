

%% create estimate for contrast (mean and SD)
%% Threshold estimate based on previous set of participants.

%% presets and constants
clear all, 
close all,
clc

% get previous files
threshold_files = dir(fullfile(pwd, 'Treshoulds', '*_10_TestAnswers_noglare.mat'));

%% Load files and compute mean/SD of contrast value
results.T = [];
results.NT = [];

for f = 1:numel (threshold_files)
    c_file = threshold_files(f);
    try
        load (fullfile( c_file.folder, c_file.name))
        results.T(f) = Treshould.T;
        results.NT(f) = Treshould.NT;
    catch
         warning( ['Problem with file ', fullfile( c_file.folder, c_file.name)]);
    end
end

%% mean and SD
mean_thres = mean (results.T);
sd_thres = std (results.T);

[ max_thres, idx ] = max (results.T)
[ min_thres, idx ] = min (results.T)


