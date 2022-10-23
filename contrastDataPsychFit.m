%% Gerick Lee 2022-10-23
% 5 SF x 2 eyes x 4 files x 10 subjects?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dataOut = contrastDataPsychFit(data)
%%
conData     = data.conThreshData;
nSubjects   = size(conData, 4);
nEyes       = 2; 
nSF         = length(data.sfList);
nFiles      = size(conData, 3); % NB: not all subjects have nFiles files.
pfSlope     = 2; % hard coded

dataOut = data;

%%
dataOut.conThreshSessPF = cell(size(conData)); % slope thresh lapse!
dataOut.conThreshAggPF  = cell(size(conData, 1), size(conData, 2), size(conData, 4)); % slope thresh lapse!

for subjInd = 1:nSubjects
    for eyeInd = 1 : nEyes
        for sfInd = 1 : nSF
            aggData = []; % aggregate data for combined fit.
            for fInd = 1 : nFiles
                if ~isempty(conData{sfInd, eyeInd, fInd, subjInd})
                    fitData    = conData{sfInd, eyeInd, fInd, subjInd}.behSummary(:, [1 3 2]); 
                    aggData    = combineBehMats(fitData, aggData);
                    %tic
                    fitParams  = fitWblThreshLapse_fixedSlope(fitData, pfSlope, 0.5);
                    %toc
                    dataOut.conThreshSessPF{sfInd, eyeInd, fInd, subjInd} = [pfSlope, fitParams];                    
                end
            end
            if ~isempty(aggData)
                fitParams  = fitWblThreshLapse_fixedSlope(aggData, pfSlope, 0.5);
                dataOut.conThreshAggPF{sfInd, eyeInd, subjInd} = [pfSlope, fitParams];
%                 dataOut.behSummaryAgg{jj, k, j} = aggData;

            end
        end
        [subjInd eyeInd]
    end
end























