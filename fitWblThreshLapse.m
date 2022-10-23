%% Gerick Lee 2022-10-23
% For data in an n x 3 format, fit a Weibull function of a given input
% slope
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fitParams = fitWblThreshLapse(data, chance, fixedSlope)


thetaFcn    = @(params, data, chanceVal)  chanceVal + ((1 - chanceVal - abs(params(3))) * wblcdf(data(:, 1), params(1), params(2))); %* 0.99 + 0.005;
logLikFcn   = @(Thresh, Slope, Lapse)     -sum(data(:, 2).' * log(thetaFcn([Thresh, Slope, Lapse], data, chance)) + (data(:, 3) - data(:, 2)).' * log(1 - thetaFcn([Thresh, Slope, Lapse], data, chance)));

minData         = data(1, 1);
maxData         = data(end,1);
logDelta        = log2(maxData/minData);
guessVec        = 2.^linspace(log2(data(1, 1))+logDelta*0.05, log2(data(end, 1))-logDelta*0.05, 8)';
val             = 100000; % number of iterations for fitting.

if ~exist('fixedSlope') || isempty(fixedSlope) || fixedSlope==false
    fixedSlope      = NaN;
    llFun           = @(params)           logLikFcn(params(1), params(2), params(3));
    guessVec(:,2)   = 2; % slope guess;
    lapseInd        = 3;
else
    llFun           = @(params)           logLikFcn(params(1), fixedSlope, params(2));
    lapseInd        = 2;
end

guessVec(:, lapseInd)  = 0.01; % lapse rate

%%

lb          = [min(data(data(:, 1) > 0, 1)), 0];
ub          = [max(data(:, 1)), 0.15];

testParams  = nan(length(guessVec), lapseInd);
testErr     = nan(length(guessVec), 1);

for gInd = 1 : length(guessVec)
    guessParams         = guessVec(gInd, :);
    testParams(gInd, :) = fmincon(llFun, guessParams, [], [], [], [], lb, ub, [], optimset('MaxFunEvals', val, 'MaxIter', val, 'Display', 'none'));
    testErr(gInd)       = llFun(testParams(gInd, :));
end

[~, minInd] = min(testErr);
fitParams   = testParams(minInd, :);

