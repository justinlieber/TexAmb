

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
    save(fullFilePath,'contrastDataStruct')
    fileattrib(fullFilePath,'+w','a');
    fileattrib(fullFilePath,'+x','a');
catch 
    load(fullFilePath)
end

%% Contrast data fits
warning('\n\nWe can change these functions to update an existing fit function\n\n');
warning('\n\nPutting the fits into the data struct variables makes updating tricky. Might need to separate them.\n\n');

contrastDataStruct_fit = contrastDataPsychFit(contrastDataStruct); 

%%
fullFilePath = [writeFolder 'contrastDataStruct_fit.mat'];
try
    save(fullFilePath, 'contrastDataStruct_fit')
    fileattrib(fullFilePath,'+w','a');
    fileattrib(fullFilePath,'+x','a');
catch 
    load(fullFilePath)
end


%% Contrast data plots
contrastDataPsychPlot(contrastDataStruct_fit)

%% Standard Texture Data

% Reload all the data
textureDataStruct = UpdateTextureDataStruct([], worksheetData.subjectList);

% Update an existing structure
%textureDataStruct = UpdateTextureDataStruct(textureDataStruct, worksheetData.subjectList);

%%
fullFilePath = [writeFolder 'textureDataStruct.mat'];
try
    save(fullFilePath, 'textureDataStruct')
    fileattrib(fullFilePath,'+w','a');
    fileattrib(fullFilePath,'+x','a');
catch 
    load(fullFilePath)
end

%% Get texture psychophysical functions


textureDataStruct_fit = textureDataPsychFit(textureDataStruct); 

%%

fullFilePath = [writeFolder 'textureDataStruct_fit.mat'];
try
    save(fullFilePath, 'textureDataStruct_fit')
    fileattrib(fullFilePath,'+w','a');
    fileattrib(fullFilePath,'+x','a');
catch 
    load(fullFilePath)
end

%% Analysis of low-pass filtered texture data

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