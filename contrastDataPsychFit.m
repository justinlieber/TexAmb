%% Gerick Lee 2022-10-23
% 5 SF x 2 eyes x 4 files x 10 subjects?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dataOut = contrastDataPsychFit(data)
%%
conData      = data.conThreshData;
nSubjects    = size(conData, 4);
nEyes        = 2; 
nSF          = length(data.sfList);
nFiles       = size(conData, 3); % NB: not all subjects have nFiles files.
pChance      = 0.5; % 2AFC task, so chance = 50%
conSensSlope = 2; % hard coded for contrast sensitivity

dataOut = data;

%%
dataOut.conThreshSessPF = cell(size(conData)); % thresh slope lapse!
dataOut.conThreshAggPF  = cell(size(conData, 1), size(conData, 2), size(conData, 4)); % thresh slope lapse!

warning('\n\nI think we can switch the output here from cell arrays to double arrays\n\n');
for subjInd = 1:nSubjects
    for eyeInd = 1 : nEyes
        for sfInd = 1 : nSF
            aggData = []; % aggregate data for combined fit.
            for fInd = 1 : nFiles
                if ~isempty(conData{sfInd, eyeInd, fInd, subjInd})
                    fitData    = conData{sfInd, eyeInd, fInd, subjInd}.behSummary(:, [1 3 2]); 
                    aggData    = combineBehMats(fitData, aggData);
                    fitParams  = fitWblThreshLapse(fitData, pChance, conSensSlope);
                    fitParams  = [fitParams(1) conSensSlope fitParams(2)];
                    dataOut.conThreshSessPF{sfInd, eyeInd, fInd, subjInd} = fitParams;                    
                end
            end
            if ~isempty(aggData)
                fitParams   = fitWblThreshLapse(aggData, pChance, conSensSlope);
                fitParams   = [fitParams(1) conSensSlope fitParams(2)];
                dataOut.conThreshAggPF{sfInd, eyeInd, subjInd} = fitParams;
%                 dataOut.behSummaryAgg{sfInd, eyeInd, subjInd} = aggData;
            end
        end
        [subjInd eyeInd]
    end
end























