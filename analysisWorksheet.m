

%% We'll use this worksheet to develop all the analysis code. 
% Eventually we'll write a function that calls all the code/functions we 
% set up here. 

%% Key folders 

baseDataFolder      = '/v/psycho/TexAmb/Results/';
baseAnalysisFolder  = '/v/analysis/justin/TexAmb/';

eyeCodeList         = {'L','R'};


%% Can we write a bash script or something that signs in and downloads the latest CSV file?



%% Extract subject list and other data from the Google Sheet

worksheetData = ExtractSubjectWorksheetData();

%% Extract Contrast Threshold Data

% Reload all the data
contrastDataStruct = UpdateContrastDataStruct([], worksheetData.subjectList);

% Update an existing structure
%contrastDataStruct = UpdateContrastDataStruct(contrastDataStruct, worksheetData.subjectList);

writeFolder = '/v/psycho/TexAmb/Analysis/';
fullFilePath = [writeFolder 'contrastDataStruct.mat'];

try
    save([writeFolder 'contrastDataStruct'],'contrastDataStruct')
    fileattrib(fullFilePath,'+w','a');
    fileattrib(fullFilePath,'+x','a');
catch 
    load(fullFilePath)
end

%% Contrast data fits
contrastDataStruct_fit = contrastDataPsychFit(contrastDataStruct); % yo

%% Contrast data plots
contrastDataPsychPlot(contrastDataStruct_fit)

%% Standard Texture Data

% Reload all the data
textureDataStruct = UpdateTextureDataStruct([], worksheetData.subjectList);

% Update an existing structure
%textureDataStruct = UpdateTextureDataStruct(textureDataStruct, worksheetData.subjectList);

%%
writeFolder = '/v/psycho/TexAmb/Analysis/';
fullFilePath = [writeFolder 'textureDataStruct.mat'];
save([writeFolder 'textureDataStruct'],'textureDataStruct')
fileattrib(fullFilePath,'+w','a');
fileattrib(fullFilePath,'+x','a');

%% Low-pass filtered texture data

% We're going to need extensive control data for these experiments, so that
% we have a good map from texture sensitivity to low-pass filter edge.

%% Extracting McKee Data


% Reload all the data
mcKeeDataStruct = UpdateMcKeeDataStruct([], worksheetData);

% Update an existing structure
% mcKeeDataStruct = UpdateMcKeeDataStruct(mcKeeDataStruct, worksheetData);

%%
writeFolder = '/v/psycho/TexAmb/Analysis/';
fullFilePath = [writeFolder 'mcKeeDataStruct.mat'];
save([writeFolder 'mcKeeDataStruct'],'mcKeeDataStruct')
fileattrib(fullFilePath,'+w','a');
fileattrib(fullFilePath,'+x','a');

%% McKee: Low-dimensional factor space analysis from the paper

%% Scratch