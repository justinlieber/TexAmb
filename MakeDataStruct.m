function dataStruct = MakeDataStruct(fileData, levelList)

thisFilename    = fileData.fullPath;

tInd        = strfind(thisFilename,'T');
takenInd    = strfind(thisFilename,'Taken');
dateString  = thisFilename(takenInd+5:tInd(find(tInd>takenInd,1,'first'))-1);
thisDate    = datetime(dateString,'InputFormat','yyyymmdd');

dataStruct = [];

saveColInd      = [find(strcmp(fileData.outputStruct.behDimNames,'behStimLevel')) find(strcmp(fileData.outputStruct.behDimNames,'behCorrect'))];

dataStruct.trialList    = fileData.outputStruct.behavior(:,saveColInd);
dataStruct.trialList(:,1) = levelList(dataStruct.trialList(:,1));
dataStruct.behSummary   = fileData.behSummaryMat;
dataStruct.filename     = [thisFilename '.mat'];
dataStruct.date         = thisDate;