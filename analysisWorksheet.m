

%% We'll use this worksheet to develop all the analysis code. 
% Eventually we'll write a function that calls all the code/functions we 
% set up here. 

%% Key folders 

baseDataFolder      = '/v/psycho/TexAmb/Results/';
baseAnalysisFolder  = '/v/analysis/justin/TexAmb/';

eyeCodeList         = {'L','R'};


%% Can we write a bash script or something that signs in and downloads the latest CSV file?



%% Extract subject list and other data from the Google Sheet

csvFileName = 'Amblyopia Subject Data - Experiment Status.csv';
thisCSVData = readtable([baseAnalysisFolder csvFileName]);

fullSubjectList = thisCSVData.Subject;

dropInd = find(~cellfun(@isempty,strfind(fullSubjectList,'Drop Out')));
useInd  = (1:dropInd-1);
useInd  = useInd(~cellfun(@isempty,fullSubjectList(useInd)));
useInd  = useInd(~cellfun(@(x)(strcmp(x,'KPS')),fullSubjectList(useInd))); % Special case, no medical confirmation of amblyopia

subjectList = fullSubjectList(useInd);
hasStarInd = cellfun(@(x)~isempty(strfind(x,'*')),subjectList);
subjectList(hasStarInd) = cellfun(@(x)(x(x~='*')),subjectList(hasStarInd),'UniformOutput',false);

% Right now, stars are controls
controlInd = find(hasStarInd);
confAmbInd = thisCSVData.ResultsObtained(useInd);

logMARData  = thisCSVData.Logmar_L_R_(useInd);
prData      = thisCSVData.PR_L_R_(useInd);

[subjectList logMARData prData]


nSubj = length(subjectList);


%% Extract Contrast Threshold Data

calibFolder = [baseDataFolder 'ContrastCalibration/'];
contrastFolder = [baseDataFolder 'SimpleContrastTask/'];

% there should just be one of these, right? 
sfValList   = [0.35 1.41 2.83 5.66 11.31];
nSF         = length(sfValList);

nEye        = 2; %lol

getContrastDataStruct               = {};
getContrastDataStruct.sfList        = sfValList;
getContrastDataStruct.eyeOrder      = eyeCodeList;
getContrastDataStruct.subjectList   = subjectList;
getContrastDataStruct.indexNames    = {'spatial frequency','eye (L/R)','file index','subject'};
getContrastDataStruct.calibContrast = [];
getContrastDataStruct.conThreshData = {};
for subjInd = 1:nSubj
    subjCode = subjectList{subjInd};
    for eyeInd = 1:nEye
        for sfInd = 1:nSF
            sfVal = sfValList(sfInd);
            
            % Calibration contrast data
            fList = dir([calibFolder sprintf('*Subject(%s)-Eye(%s)-SpatialFreq(%0.2f)*.mat',subjCode,eyeCodeList{eyeInd},sfVal)]);
            for fInd = 1:length(fList)
                fileData = load([calibFolder fList(fInd).name]);
                getContrastDataStruct.calibContrast(sfInd,eyeInd,fInd,subjInd) = ...
                    fileData.finalContrast;
            end
            
            % Main task contrast data
            fList = dir([contrastFolder sprintf('*Subject(%s)-Eye(%s)-SpatialFreq(%0.2f)*-Taken*T*.mat',subjCode,eyeCodeList{eyeInd},sfVal)]);
            for fInd = 1:length(fList)
                thisFilename = [contrastFolder fList(fInd).name];
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
                
                getContrastDataStruct.conThreshData{sfInd,eyeInd,fInd,subjInd} = thisDataStruct;
            end
            [subjInd eyeInd sfVal]
        end
    end
end


getContrastDataStruct.conThreshDate = NaT(size(getContrastDataStruct.conThreshData));
ctMask = ~cellfun(@isempty,getContrastDataStruct.conThreshData);
getContrastDataStruct.conThreshDate(ctMask) = cellfun(@(x)(x.date),getContrastDataStruct.conThreshData(ctMask));


contrastDataStruct = getContrastDataStruct;

%%
writeFolder = '/v/psycho/TexAmb/Analysis/';
fullFilePath = [writeFolder 'contrastDataStruct.mat'];
save([writeFolder 'contrastDataStruct'],'contrastDataStruct')
fileattrib(fullFilePath,'+w','a');
fileattrib(fullFilePath,'+x','a');


%% Contrast data fits

%% Contrast data plots

%% Standard Texture Data


%% Low-pass filtered texture data

% We're going to need extensive control data for these experiments, so that
% we have a good map from texture sensitivity to low-pass filter edge.

%% McKee Data
%
%

%% McKee: Contrast

%% McKee: Acuity 

%% McKee: Vernier

%% McKee: Extacting Snellen and Pelli acuity

%% McKee: Low-dimensional factor space analysis from the paper

%% Scratch