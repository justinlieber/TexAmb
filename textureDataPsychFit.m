
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dataOut = textureDataPsychFit(data)


nSubjects    = size(data.subjectList, 1);
nEyes        = 2; 
nTex         = length(data.texFamList);
nFilt        = length(data.lpFilterEdgeList);

pChance      = 0.5; % 2AFC task, so chance = 50%

dataOut = data;

calibData = data.texCalibData;
dataOut.texCalibThreshSessPF = cell(size(calibData)); % slope thresh lapse!
dataOut.texCalibThreshAggPF  = cell(size(calibData, 1), size(calibData, 2), size(calibData, 4)); % thresh slope lapse!

basicData = data.texBasicData;
dataOut.texBasicThreshSessPF = cell(size(basicData)); % slope thresh lapse!
dataOut.texBasicThreshAggPF  = cell(size(basicData, 1), size(basicData, 2), size(basicData, 4)); % thresh slope lapse!

lpData = data.texLowPassData;
dataOut.texLpThreshSessPF = cell(size(lpData)); % slope thresh lapse!
dataOut.texLpThreshAggPF  = cell(size(lpData, 1), size(lpData, 2), size(lpData, 3), size(basicData, 5)); % thresh slope lapse!


for subjInd = 1:nSubjects
    for eyeInd = 1 : nEyes
        for texInd = 1 : nTex
            
            {subjInd data.subjectList{subjInd} data.eyeOrder{eyeInd} data.texFamList(texInd)}
            
            calibAggData = []; % aggregate data for combined fit.
            nFiles  = size(calibData,3);
            for fInd = 1 : nFiles
                if ~isempty(calibData{texInd, eyeInd, fInd, subjInd})
                    fitData         = calibData{texInd, eyeInd, fInd, subjInd}.behSummary(:, [1 3 2]); 
                    calibAggData    = combineBehMats(fitData, calibAggData);
                    fitParams       = fitWblThreshLapse(fitData, pChance);
                    dataOut.texCalibThreshSessPF{texInd, eyeInd, fInd, subjInd} = fitParams; 
                end
            end
            if ~isempty(calibAggData)
                fitParams  = fitWblThreshLapse(calibAggData, pChance);
                dataOut.texCalibThreshAggPF{texInd, eyeInd, subjInd} = fitParams;
%                 dataOut.behSummaryAgg{sfInd, eyeInd, subjInd} = aggData;
            end
            
            basicAggData = []; % aggregate data for combined fit.
            nFiles  = size(basicData,3);
            for fInd = 1 : nFiles
                if ~isempty(basicData{texInd, eyeInd, fInd, subjInd})
                    fitData         = basicData{texInd, eyeInd, fInd, subjInd}.behSummary(:, [1 3 2]); 
                    basicAggData    = combineBehMats(fitData, basicAggData);
                    fitParams       = fitWblThreshLapse(fitData, pChance);
                    dataOut.texBasicThreshSessPF{texInd, eyeInd, fInd, subjInd} = fitParams; 
                end
            end
            if ~isempty(basicAggData)
                fitParams  = fitWblThreshLapse(basicAggData, pChance);
                dataOut.texBasicThreshAggPF{texInd, eyeInd, subjInd} = fitParams;
%                 dataOut.behSummaryAgg{sfInd, eyeInd, subjInd} = aggData;
            end
            
            for filtInd = 1:nFilt
                lpAggData = []; % aggregate data for combined fit.
                nFiles  = size(lpData,4);
                for fInd = 1 : nFiles
                    if ~isempty(lpData{texInd, eyeInd, filtInd, fInd, subjInd})
                        fitData         = lpData{texInd, eyeInd, filtInd, fInd, subjInd}.behSummary(:, [1 3 2]); 
                        lpAggData       = combineBehMats(fitData, lpAggData);
                        fitParams       = fitWblThreshLapse(fitData, pChance);
                        dataOut.texLpThreshSessPF{texInd, eyeInd, filtInd, fInd, subjInd} = fitParams; 
                    end
                end
                if ~isempty(lpAggData)
                    fitParams  = fitWblThreshLapse(lpAggData, pChance);
                    dataOut.texLpThreshAggPF{texInd, eyeInd, filtInd, subjInd} = fitParams;
%                    dataOut.behSummaryAgg{sfInd, eyeInd, subjInd} = aggData;
                end
            end
        end
    end
end















