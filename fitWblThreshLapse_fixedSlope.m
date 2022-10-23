%% Gerick Lee 2022-10-23
% For data in an n x 3 format, fit a Weibull function of a given input
% slope
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fitParams = fitWblThreshLapse_fixedSlope(data, slope, chance)
%%
guessVec = linspace(data(1, 1), data(end, 1), 8).';
guessVec(1, 2) = 0.01; % lapse rate
val = 100000; % number of iterations for fitting.
%%
thetaFcn = @(params, data, chanceVal) chanceVal + ((1 - chanceVal - abs(params(3))) * wblcdf(data(:, 1), params(1), params(2))); %* 0.99 + 0.005;
logLikFcn = @(Thresh, Slope, Lapse) -sum(data(:, 2).' * log(thetaFcn([Thresh, Slope, Lapse], data, chance)) + (data(:, 3) - data(:, 2)).' * log(1 - thetaFcn([Thresh, Slope, Lapse], data, chance)));
llFun = @(params) logLikFcn(params(1), slope, params(2));

lb = [min(data(data(:, 1) > 0, 1)), 0];
ub = [max(data(:, 1)), 0.15];

testParams = nan(length(guessVec), 2);
testErr = nan(length(guessVec), 1);
for k = 1 : length(guessVec)
    guessParams = [guessVec(k, 1), guessVec(1, 2)];
    testParams(k, :) = fmincon(llFun, guessParams, [], [], [], [], lb, ub, [], optimset('MaxFunEvals', val, 'MaxIter', val, 'Display', 'none'));
    testErr(k) = llFun(testParams(k, :));
end
[~, minInd] = min(testErr);
fitParams = testParams(minInd, :);
