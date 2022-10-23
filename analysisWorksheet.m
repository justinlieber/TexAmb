

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

% Reload all the data
contrastDataStruct = UpdateContrastDataStruct([], subjectList);

% Update an existing structure
%contrastDataStruct = UpdateContrastDataStruct(contrastDataStruct, subjectList);

writeFolder = '/v/psycho/TexAmb/Analysis/';
fullFilePath = [writeFolder 'contrastDataStruct.mat'];
save([writeFolder 'contrastDataStruct'],'contrastDataStruct')
fileattrib(fullFilePath,'+w','a');
fileattrib(fullFilePath,'+x','a');

%% Contrast data fits

%% Contrast data plots

%% Standard Texture Data

% Reload all the data
textureDataStruct = UpdateTextureDataStruct([], subjectList);

% Update an existing structure
%textureDataStruct = UpdateTextureDataStruct(textureDataStruct, subjectList);

%%
writeFolder = '/v/psycho/TexAmb/Analysis/';
fullFilePath = [writeFolder 'textureDataStruct.mat'];
save([writeFolder 'textureDataStruct'],'textureDataStruct')
fileattrib(fullFilePath,'+w','a');
fileattrib(fullFilePath,'+x','a');

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