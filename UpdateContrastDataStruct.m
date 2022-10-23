function contrastDataStruct = UpdateContrastDataStruct(contrastDataStruct, subjectList)

baseDataFolder      = '/v/psycho/TexAmb/Results/';
calibFolder         = [baseDataFolder 'ContrastCalibration/'];
contrastFolder      = [baseDataFolder 'SimpleContrastTask/'];
baseAnalysisFolder  = '/v/paycho/TexAmb/Analysis/';

% there should just be one of these, right? 
sfValList   = [0.35 1.41 2.83 5.66 11.31];
eyeCodeList         = {'L','R'};

nSF         = length(sfValList);
nEye        = 2; %lol


if ~exist('contrastDataStruct') || isempty(contrastDataStruct)
    contrastDataStruct               = {};
    contrastDataStruct.sfList        = sfValList;
    contrastDataStruct.eyeOrder      = eyeCodeList;
    contrastDataStruct.subjectList   = subjectList;
    nSubj                            = length(contrastDataStruct.subjectList);
    contrastDataStruct.indexNames    = {'spatial frequency','eye (L/R)','file index','subject'};
    contrastDataStruct.calibContrast = zeros(nSF,nEye,1,nSubj);
    contrastDataStruct.calibFilename = cell(nSF,nEye,1,nSubj);
    contrastDataStruct.conThreshData = cell(nSF,nEye,1,nSubj);
    contrastDataStruct.conThreshFilename = cell(nSF,nEye,1,nSubj);
else
    for subjInd = 1:length(subjectList)
        if ~any(strcmp(contrastDataStruct.subjectList,subjectList(subjInd)))
            contrastDataStruct.subjectList = cat(1,contrastDataStruct.subjectList,subjectList(subjInd));
        end
    end
    
    nSubj                            = length(contrastDataStruct.subjectList);
    contrastDataStruct.calibFilename        = cat(4,contrastDataStruct.calibFilename,cell(nSF,nEye,size(contrastDataStruct.calibFilename,3),nSubj-size(contrastDataStruct.calibFilename,4)));
    contrastDataStruct.conThreshFilename    = cat(4,contrastDataStruct.conThreshFilename,cell(nSF,nEye,size(contrastDataStruct.conThreshFilename,3),nSubj-size(contrastDataStruct.conThreshFilename,4)));
end
    


for subjInd = 1:length(contrastDataStruct.subjectList)
    subjCode    = contrastDataStruct.subjectList{subjInd};
    for eyeInd = 1:nEye
        for sfInd = 1:nSF
            sfVal = sfValList(sfInd);
            
            % Calibration contrast data
            fList = dir([calibFolder sprintf('*Subject(%s)-Eye(%s)-SpatialFreq(%0.2f)*.mat',subjCode,eyeCodeList{eyeInd},sfVal)]);
            for fListInd = 1:length(fList)
                thisFilename = [calibFolder fList(fListInd).name];                
                if ~any(strcmp(contrastDataStruct.calibFilename(sfInd,eyeInd,:,subjInd),thisFilename))
                    fLength = sum(~cellfun(@isempty,contrastDataStruct.calibFilename(sfInd,eyeInd,:,subjInd)));
                    fInd = fLength + 1;
                
                    fileData = load(thisFilename);
                    contrastDataStruct.calibContrast(sfInd,eyeInd,fInd,subjInd) = ...
                        fileData.finalContrast;
                    contrastDataStruct.calibFilename{sfInd,eyeInd,fInd,subjInd} = thisFilename;
                end
            end
            
            % Main task contrast data
            fList = dir([contrastFolder sprintf('*Subject(%s)-Eye(%s)-SpatialFreq(%0.2f)*-Taken*T*.mat',subjCode,eyeCodeList{eyeInd},sfVal)]);
            for fListInd = 1:length(fList)
                thisFilename = [contrastFolder fList(fListInd).name];
                
                if (size(contrastDataStruct.conThreshFilename,1) < nSF || size(contrastDataStruct.conThreshFilename,2) < nEye) || ...
                        ~any(strcmp(contrastDataStruct.conThreshFilename(sfInd,eyeInd,:,subjInd),thisFilename))
                    fLength = sum(~cellfun(@isempty,contrastDataStruct.conThreshFilename(sfInd,eyeInd,:,subjInd)));
                    fInd = fLength + 1;
                
                    fileData = load(thisFilename);

                    tInd        = strfind(thisFilename,'T');
                    takenInd    = strfind(thisFilename,'Taken');
                    dateString  = thisFilename(takenInd+5:tInd(find(tInd>takenInd,1,'first'))-1);
                    thisDate    = datetime(dateString,'InputFormat','yyyymmdd');

                    thisDataStruct = [];

                    saveColInd      = [find(strcmp(fileData.outputStruct.behDimNames,'behStimLevel')) find(strcmp(fileData.outputStruct.behDimNames,'behCorrect'))];
                    contrastList    = fileData.groupProperties.contrastList;

                    thisDataStruct.trialList    = fileData.outputStruct.behavior(:,saveColInd);
                    thisDataStruct.trialList(:,1) = contrastList(thisDataStruct.trialList(:,1));
                    thisDataStruct.behSummary   = fileData.behSummaryMat;
                    thisDataStruct.filename     = thisFilename;
                    thisDataStruct.date         = thisDate;

                    contrastDataStruct.conThreshData{sfInd,eyeInd,fInd,subjInd} = thisDataStruct;
                    contrastDataStruct.conThreshFilename{sfInd,eyeInd,fInd,subjInd} = thisFilename;
                
                end
            end
            [subjInd eyeInd sfVal]
        end
    end
end


contrastDataStruct.conThreshDate = NaT(size(contrastDataStruct.conThreshData));
ctMask = ~cellfun(@isempty,contrastDataStruct.conThreshData);
contrastDataStruct.conThreshDate(ctMask) = cellfun(@(x)(x.date),contrastDataStruct.conThreshData(ctMask));
