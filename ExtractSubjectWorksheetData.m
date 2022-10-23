function worksheetData = ExtractSubjectWorksheetData()

baseAnalysisFolder  = '/v/psycho/TexAmb/Analysis/';
csvFileName         = 'Amblyopia Subject Data - Experiment Status.csv';

thisCSVData         = readtable([baseAnalysisFolder csvFileName]);
fullSubjectList     = thisCSVData.Subject;

dropInd = find(contains(fullSubjectList,'Drop Out')); %~cellfun(@isempty,strfind(fullSubjectList,'Drop Out')));
useInd  = (1:dropInd-1);
useInd  = useInd(~cellfun(@isempty,fullSubjectList(useInd)));
useInd  = useInd(~cellfun(@(x)(strcmp(x,'KPS')),fullSubjectList(useInd))); % Special case, no medical confirmation of amblyopia

subjectList = fullSubjectList(useInd);
hasStarInd = cellfun(@(x)contains(x,'*'),subjectList);
subjectList(hasStarInd) = cellfun(@(x)(x(x~='*')),subjectList(hasStarInd),'UniformOutput',false);

% Right now, stars are controls
worksheetData                   = [];
worksheetData.subjectList       = subjectList;
worksheetData.controlSubjInd    = find(hasStarInd);
worksheetData.confirmedAmbInd   = thisCSVData.ResultsObtained(useInd);
worksheetData.logMarData        = thisCSVData.Logmar_L_R_(useInd);
worksheetData.pelRobData        = thisCSVData.PR_L_R_(useInd);
