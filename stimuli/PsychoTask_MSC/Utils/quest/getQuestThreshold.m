function [T,NT] = getThresholdQuest(respMatrix,nameFile)

respSort=sortrows(respMatrix(:,2:3)); % contrast values and answers

NumberCorrectanswer=[];
contrast=[];
answer=[];

for i=1:length(respSort(:,1))
    
    if i==1
        A=respSort(i,1); % Contrast Value
        inf=i; % subscript
        contrast(end+1)=A; % contrast
        
        if respSort(inf,2)==1
            answer(end+1)=1;
        else
            answer(end+1)=0;
        end
    end
    
    if i<= length(respSort(:,1)) && respSort(i,1)~=A
        sup = i-1; % indice superior
        NumberCorrectanswer(end+1)=sum(respSort(inf:sup,2));    % contabiliza o número de erros de fixaçao por contrast
        inf=i;
        A=respSort(i,1);
        contrast(end+1)=A; %contrast
        
        if respSort(inf,2)==1
            answer(end+1)=1;
        else
            answer(end+1)=0;
        end
    end
    
    if i == length(respSort(:,1))
        sup = i;
        NumberCorrectanswer(end+1)=sum(respSort(inf:sup,2));
        
    end
end

repetPerCondition=histc(respMatrix(:,2), unique(respMatrix(:,2)));
PercentageCorrectanswers=(NumberCorrectanswer'*100)./repetPerCondition; % percentage of "yes" answers
TableAnswers=[contrast' PercentageCorrectanswers]; % contrast values and percentage of "yes";

% -------------------------------------------------------------------------
%                       FITTING PSICHOMETRIC FUNCTION
%--------------------------------------------------------------------------

% number of trials per condition
trials_condition=repetPerCondition;
guessing = 0; % guessing rate
lapsing = 0; % lapsing rate

% weibull function
[b,K] = binom_weib(NumberCorrectanswer',trials_condition,contrast');
% fitted curve
numxfit = 999; % Number of points to be generated minus 1
xfit = [min(contrast'):(max(contrast')-min(contrast'))/numxfit:max(contrast')]';
pfit = binomval_lims( b, xfit, 'weibull', guessing, lapsing, K );

% required threshold level
niter = 2000; % Number of bootstrap iterations
[T] = threshold_slope( pfit, xfit, 0.5);
[NT] = threshold_slope( pfit, xfit, 0.75);


% plot data point and fitted curve
MCS=figure
plot(contrast',PercentageCorrectanswers,'r.');
hold on, plot( xfit, pfit*100, 'b' );
xlabel('contrast [%]');
ylabel('Perceived [%]');
NameFile = fullfile(pwd,'Thresholds',nameFile);
saveas(MCS,[NameFile '.fig'])


end

