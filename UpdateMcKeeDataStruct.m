function mcKeeDataStruct = UpdateMcKeeDataStruct(mcKeeDataStruct, worksheetData)


baseDataFolder      = '/v/psycho/TexAmb/Results/';
acuityFolder        = [baseDataFolder 'McKeeAcuity/'];
contrastFolder      = [baseDataFolder 'McKeeContrastStep/'];
vernierFolder       = [baseDataFolder 'McKeeVernier/'];

eyeCodeList     = {'L','R'};
nEye            = 2; 
nExp            = 3;

subjectList     = worksheetData.subjectList;

if ~exist('textureDataStruct') || isempty(mcKeeDataStruct)
    mcKeeDataStruct               = {};
    mcKeeDataStruct.expOrder      = {'Acuity','Contrast step', 'Vernier'};
    mcKeeDataStruct.eyeOrder      = eyeCodeList;
    mcKeeDataStruct.subjectList   = subjectList;
    %mcKeeDataStruct.basicIndexNames    = {'texture family','eye (L/R)','file index','subject'};
    
    nSubj       = length(mcKeeDataStruct.subjectList);
    
    mcKeeDataStruct.expData     = cell(nExp,nEye,1,nSubj);
    mcKeeDataStruct.viewDist    = NaN(nExp,nEye,1,nSubj);
    mcKeeDataStruct.expFilename = cell(nExp,nEye,1,nSubj);
    mcKeeDataStruct.logMarValString = {'logMAR line score','Equivalent c/deg threshold'};
    mcKeeDataStruct.pelRobValString = {'Pelli/Robson line score','Equivalent contrast threshold'};
else
end

for subjInd = 1:length(subjectList)
    if ~any(strcmp(mcKeeDataStruct.subjectList,subjectList(subjInd)))
        mcKeeDataStruct.subjectList = cat(1,mcKeeDataStruct.subjectList,subjectList(subjInd));
    end
    
    structSubjInd = find(contains(mcKeeDataStruct.subjectList,subjectList{subjInd}));
    
    % logMAR/Snellen extraction
    logMarString = worksheetData.logMarData{subjInd};
    wasClose = contains(logMarString,'(AT 1.5M)');
    
    if wasClose
        startInd = strfind(logMarString,')')+2;
    else
        startInd = 1;
    end
    slashInd        = strfind(logMarString,'/');
    thisLogMarVal   = [str2double(logMarString(startInd:slashInd-1)) str2double(logMarString(slashInd+1:end))];
    if wasClose % special case for subject @ 1.5M
        thisLogMarVal = thisLogMarVal + 0.3;
    end
    mcKeeDataStruct.logMarVal(:,structSubjInd,1) = thisLogMarVal;
    
    % Pelli/Robson exctraction
    pelRobString = worksheetData.pelRobData{subjInd};
    startInd = 1;

    slashInd        = strfind(pelRobString,'/');
    thisPelRobVal   = [str2double(pelRobString(startInd:slashInd-1)) str2double(pelRobString(slashInd+1:end))];
    mcKeeDataStruct.pelRobVal(:,structSubjInd,1) = thisPelRobVal;
end
nSubj       = length(mcKeeDataStruct.subjectList);

mcKeeDataStruct.logMarVal(:,:,2) = 30.*2.^-(mcKeeDataStruct.logMarVal(:,:,1)/0.3);
mcKeeDataStruct.pelRobVal(:,:,2) = 10.^-(mcKeeDataStruct.pelRobVal(:,:,1));


if size(mcKeeDataStruct.expFilename,4) < nSubj
    mcKeeDataStruct.expFilename    = cat(4,mcKeeDataStruct.expFilename,cell(nExp,nEye,size(mcKeeDataStruct.expFilename,3),nSubj-size(mcKeeDataStruct.expFilename,4)));
end


expFolderList       = {acuityFolder,contrastFolder,vernierFolder};
expFileHeaderNames  = {'McKeeAcuity','McKeeContrastStep','McKeeVernier'};
expStaircaseField   = {'spatialFrequencyList','contrastList','deltaShiftList'};

for subjInd = 1:length(mcKeeDataStruct.subjectList)
    subjCode    = mcKeeDataStruct.subjectList{subjInd};
    for eyeInd = 1:nEye
        
        for expInd = 1:nExp
            fList = dir([expFolderList{expInd} sprintf('%s-Subject(%s)-Eye(%s)-ViewDist(*)-Taken*T*.mat',expFileHeaderNames{expInd}, subjCode,eyeCodeList{eyeInd})]);
            for fListInd = 1:length(fList)
                thisFilename = [expFolderList{expInd} fList(fListInd).name];

                if ~any(strcmp(mcKeeDataStruct.expFilename(expInd,eyeInd,:,subjInd),thisFilename))
                    fLength = sum(~cellfun(@isempty,mcKeeDataStruct.expFilename(expInd,eyeInd,:,subjInd)));
                    fInd = fLength + 1;

                    vdInd           = strfind(thisFilename,'ViewDist');
                    parenInd        = strfind(thisFilename,')');
                    thisViewDist    = str2double(thisFilename(vdInd+9:parenInd(find(parenInd>vdInd,1,'first'))-1));

                    fileData = load(thisFilename);

                    %levelList    = getfield(fileData.groupProperties, expStaircaseField{expInd});
                    levelList    = fileData.groupProperties.(expStaircaseField{expInd});
                    thisDataStruct = MakeDataStruct(fileData, levelList);

                    mcKeeDataStruct.expData{expInd,eyeInd,fInd,subjInd} = thisDataStruct;
                    mcKeeDataStruct.expFilename{expInd,eyeInd,fInd,subjInd} = thisFilename;
                    mcKeeDataStruct.viewDist(expInd,eyeInd,fInd,subjInd) = thisViewDist;
                end
            end
        end
        [subjInd eyeInd]
    end
end


mcKeeDataStruct.expDate = NaT(size(mcKeeDataStruct.expData));
expMask = ~cellfun(@isempty,mcKeeDataStruct.expData);
mcKeeDataStruct.expDate(expMask) = cellfun(@(x)(x.date),mcKeeDataStruct.expData(expMask));

