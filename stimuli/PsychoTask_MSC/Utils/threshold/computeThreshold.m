function [ results ] = computeThreshold(answers)

% --- ORGANIZE DATA ---

% --- Create vars ---
numCorrectAns=[]; % Number of correct answers.

% Sort contrast values according to the contrast
answersSortd=sortrows(answers(:,2:3));

% Find unique contrasts.
uniqueAnswers=unique(answersSortd(:,1));
uniqueAnswersCount=[];

% Iterate each contrast tested.
for uAnsIdx=1:length(uniqueAnswers)
    % Find idxs for each uniqeu contrast.
    [idxsUn]=find(answersSortd(:,1)==uniqueAnswers(uAnsIdx));
    uniqueAnswersCount(uAnsIdx)=numel(idxsUn);
    % Check for number of positives.
    [SeenIdxsUn]=find(answersSortd(idxsUn,2)==1);
    % Number of correct answer for unique contrast Idx.
    numCorrectAns(uAnsIdx)=numel(SeenIdxsUn);
    ratioCorrectAnswers(uAnsIdx)=( numel(SeenIdxsUn)/numel(idxsUn) );
end

% percentage of "yes" answers per unique contrast.
percentageCorrectAnswers=(ratioCorrectAnswers*100); 
% Contrast values and percentage of "yes".
tableAnswers=[uniqueAnswers percentageCorrectAnswers']; 

% --- FITTING PSICHOMETRIC FUNCTION ---

% Number of trials per unique contrast.
% var: uniqueAnswersCount

% Guessing rate.
guessing = 0;
% Lapsing rate.
lapsing = 0; 

% Weibull function.
[b,K] = binom_weib(numCorrectAns',uniqueAnswersCount',uniqueAnswers);

% Fitted curve.
numxfit = 999; % Number of points to be generated minus 1
xfit = [min(uniqueAnswers'):(max(uniqueAnswers')-min(uniqueAnswers'))/numxfit:max(uniqueAnswers')]';
pfit = binomval_lims( b, xfit, 'weibull', guessing, lapsing, K );

% Required treshold level.
numIterations=2000; % Number of bootstrap iterations
results.threshold=threshold_slope( pfit, xfit, 0.5);
results.nearThreshold=threshold_slope( pfit, xfit, 0.75);

% --- plot data point and fitted curve ---
figure(1)
plot(uniqueAnswers',percentageCorrectAnswers,'r.');
hold on, plot( xfit, pfit*100, 'b' );
xlabel('contrast [%]');
ylabel('Perceived [%]');


% % % % % % % NameFile = fullfile(pwd,'Treshoulds',nameFile);
% % % % % % % saveas(MCS,[NameFile '.fig'])






end

