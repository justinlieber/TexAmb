%% Gerick Lee 2022-10-23
% 5 SF x 2 eyes x 4 files x 10 subjects?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dataOut = contrastDataPsychFit(data)
%%
conData = data.conThreshData;
nSubjects = size(conData, 4);
nEyes = 2; 
nSF = length(data.sfList);
nFiles = size(conData, 3); % NB: not all subjects have nFiles files.
pfSlope = 2; % hard coded

dataOut = data;
%%
dataOut.conThreshSessPF = cell(size(conData)); % slope thresh lapse!
dataOut.conThreshAggPF  = cell(size(conData, 1), size(conData, 2), size(conData, 4)); % slope thresh lapse!

for j = 1 : nSubjects
    for k = 1 : nEyes
        for jj = 1 : nSF
            aggData = []; % aggregate data for combined fit.
            
            for kk = 1 : nFiles
                if ~isempty(conData{jj, k, kk, j})
                    fitData    = conData{jj, k, kk, j}.behSummary(:, [1 3 2]); 
                    aggData    = combineBehMats(fitData, aggData);
                    fitParams  = fitWblThreshLapse_fixedSlope(fitData, pfSlope, 0.5);
                    dataOut.conThreshSessPF{jj, k, kk, j} = [pfSlope, fitParams];
                    
                    % add intercept contrast lol nvm it doesn't matter
                    
                end
            end
            if ~isempty(aggData)
                fitParams  = fitWblThreshLapse_fixedSlope(aggData, pfSlope, 0.5);
%                 dataOut.behSummaryAgg{jj, k, j} = aggData;
                dataOut.conThreshAggPF{jj, k, j} = [pfSlope, fitParams];
            end
            
        end
    end
end























