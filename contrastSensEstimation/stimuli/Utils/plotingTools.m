%% re-arrange data to plot data

% Stimulus level, x
% Number of successes, r
% Number of trials, m
x=[];
r=[];
m=[];

[a,~,c]=unique(respMatrix(:,2));
for i = 1:numel(a)
    x=[x; a(i)];
    r=[r; sum(respMatrix(c==i,3))];
    m=[m; numel(respMatrix(c==i,3))];
end
  
% x=respMatrix(:,2);
% r=respMatrix(:,3);
% m=ones(size(respMatrix(:,3)));

figure; plot( x, r ./ m, 'k.');

%% gaussian cumulative distribution
degpol = 1; % Degree of the polynomial
b = binomfit_lims( r, m, x, degpol, 'probit' );
numxfit = 999; % Number of points to be generated minus 1
xfit = [min( x ):(max(x)-min(x))/numxfit:max( x )]';
% Plot the fitted curve
pfit = binomval_lims( b, xfit, 'probit' );
hold on, plot( xfit, pfit, 'k' );

%% weibull function
[ b, K ] = binom_weib( r, m, x );
guessing = 0; % guessing rate
lapsing = 0; % lapsing rate
% Plot the fitted curve
pfit = binomval_lims( b, xfit, 'weibull', guessing, lapsing, K );
hold on, plot( xfit, pfit, 'r' );

%% inverse weibull
[ b, K ] = binom_revweib( r, m, x );
% Plot the fitted curve
pfit = binomval_lims( b, xfit, 'revweibull', guessing, lapsing, K );
hold on, plot( xfit, pfit, 'g' );

%% local linear fitting
bwd_min = min( diff( x ) );
bwd_max = max( x ) - min( x );
bwd = bandwidth_cross_validation( r, m, x, [ bwd_min, bwd_max ] );

bwd = bwd(3); % Choose the third estimate, which is based on cross-validated deviance
pfit = locglmfit( xfit, r, m, x, bwd );
figure; plot( x, r ./ m, 'k.'); axis([0.05 1.35 -0.02 1]); axis square;
hold on, plot( xfit, pfit, 'k' );