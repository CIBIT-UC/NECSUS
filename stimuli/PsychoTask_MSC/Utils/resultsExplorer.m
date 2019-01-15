%% ---------------------- Explore Data --------------------------------- %%
% presets and constants
clear all, 
close all,
clc

% get previous files
results_files = dir(fullfile('C:\Users\Bruno\Documents\GitHub\NECSUS\stimuli\PsychoTask_MSC\Common', 'Results', '*_10_TestAnswers_noglare.mat'));

%% Load files and compute mean/SD of contrast value
matrix=[];

for f = 1:numel (results_files)
    r_file = results_files(f);
    try
        
        load (fullfile( r_file.folder, r_file.name))
        
        step=unique(sort(respMatrix(:,2)));
        
        matrix(f).step=step(2)-step(1);
        
        matrix(f).size=size(respMatrix);
        matrix(f).range=max(respMatrix(:,2))-min(respMatrix(:,2));
        matrix(f).max=max(respMatrix(:,2));
        matrix(f).min=min(respMatrix(:,2));
    catch
         warning( ['Problem with file ', fullfile( r_file.folder, r_file.name)]);
    end
end

%% explore

figure(1), hold on,
plot([matrix.max])
plot([matrix.min])
plot([matrix.range])
plot([matrix.step])

legend({'max per patient','min per patient','range per patient (max-min)', 'step (diff between consecutive contrasts)'})
xlabel('patient id')

% overview
fprintf("max varies between %f and %f. \n", min([matrix.max]), max([matrix.max]));
fprintf("min varies between %f and %f. \n", min([matrix.min]), max([matrix.min]));

fprintf("size of the step between consecutive contrasts %f and %f. \n", min([matrix.step]), max([matrix.step]));
fprintf("number of contrasts tested varies between %f and %f. \n", min([matrix.size]), max([matrix.size]));

%%

figure(2);plot([matrix(1:end-1).size])

legend({'matrix size (number of tests'})
xlabel('patient id')

%%

figure(3);plot([matrix.step])

legend({'step between concsecutive tests'})
xlabel('patient id')