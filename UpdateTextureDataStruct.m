function textureDataStruct = UpdateTextureDataStruct(textureDataStruct, subjectList)

%%
baseDataFolder          = '/v/psycho/TexAmb/Results/';
calibTextureFolder      = [baseDataFolder 'SimpleTextureTask/day0/'];
basicTextureFolder      = [baseDataFolder 'SimpleTextureTask/'];
lowPassTextureFolder    = [baseDataFolder 'FilterTextureTask/'];

% there should just be one of these, right? 
texFamList   = [18 30 99 336];
lpFilterEdgeList = [2.83 4.76 8.00 13.45];
eyeCodeList         = {'L','R'};

nTex        = length(texFamList);
nEye        = 2; 

if ~exist('textureDataStruct') || isempty(textureDataStruct)
    textureDataStruct               = {};
    textureDataStruct.texFamList    = texFamList;
    textureDataStruct.lpFilterEdgeList  = lpFilterEdgeList;
    textureDataStruct.eyeOrder      = eyeCodeList;
    textureDataStruct.subjectList   = subjectList;
    textureDataStruct.basicIndexNames    = {'texture family','eye (L/R)','file index','subject'};
    
    
    nSubj       = length(textureDataStruct.subjectList);
    nFilt       = length(textureDataStruct.lpFilterEdgeList);
    
    textureDataStruct.texCalibData = cell(nTex,nEye,1,nSubj);
    textureDataStruct.texCalibFilename = cell(nTex,nEye,1,nSubj);

    textureDataStruct.texBasicData = cell(nTex,nEye,1,nSubj);
    textureDataStruct.texBasicFilename = cell(nTex,nEye,1,nSubj);

    textureDataStruct.lowPassIndexNames    = {'texture family','eye (L/R)','low pass filter edge frequency (c/deg)', 'file index','subject'};
    textureDataStruct.texLowPassData = cell(nTex,nEye,nFilt,1,nSubj);
    textureDataStruct.texLowPassFilename = cell(nTex,nEye,nFilt,1,nSubj);
else
    nSubj       = length(textureDataStruct.subjectList);
    nFilt       = length(textureDataStruct.lpFilterEdgeList);

    for subjInd = 1:length(subjectList)
        if ~any(strcmp(textureDataStruct.subjectList,subjectList(subjInd)))
            textureDataStruct.subjectList = cat(1,textureDataStruct.subjectList,subjectList(subjInd));
        end
    end
    
    nSubj                            = length(textureDataStruct.subjectList);
    textureDataStruct.texBasicFilename    = cat(4,textureDataStruct.texBasicFilename,cell(nTex,nEye,size(textureDataStruct.texBasicFilename,3),nSubj-size(textureDataStruct.texBasicFilename,4)));
end


for subjInd = 1:length(textureDataStruct.subjectList)
    subjCode    = textureDataStruct.subjectList{subjInd};
    for eyeInd = 1:nEye
        for texInd = 1:nTex
            
            texFam = texFamList(texInd);
            
            % day0 Texture calibration data
            fList = dir([calibTextureFolder sprintf('*Subject(%s)-Eye(%s)-TexFam(%i)-Filter(FullPass)-*-Taken*T*.mat',subjCode,eyeCodeList{eyeInd},texFam)]);
            for fListInd = 1:length(fList)
                thisFilename = [calibTextureFolder fList(fListInd).name];
                
                if ~any(strcmp(textureDataStruct.texCalibFilename(texInd,eyeInd,:,subjInd),thisFilename))
                    fLength = sum(~cellfun(@isempty,textureDataStruct.texCalibFilename(texInd,eyeInd,:,subjInd)));
                    fInd = fLength + 1;
                
                    fileData = load(thisFilename);
                    
                    levelList    = fileData.stimuliGroup.cohList;
                    thisDataStruct = MakeDataStruct(fileData, levelList);

                    textureDataStruct.texCalibData{texInd,eyeInd,fInd,subjInd} = thisDataStruct;
                    textureDataStruct.texCalibFilename{texInd,eyeInd,fInd,subjInd} = thisFilename;
                end
            end
            
            
            % Main texture task data
            fList = dir([basicTextureFolder sprintf('*Subject(%s)-Eye(%s)-TexFam(%i)-Filter(FullPass)-*-Taken*T*.mat',subjCode,eyeCodeList{eyeInd},texFam)]);
            for fListInd = 1:length(fList)
                thisFilename = [basicTextureFolder fList(fListInd).name];
                
                if ~any(strcmp(textureDataStruct.texBasicFilename(texInd,eyeInd,:,subjInd),thisFilename))
                    fLength = sum(~cellfun(@isempty,textureDataStruct.texBasicFilename(texInd,eyeInd,:,subjInd)));
                    fInd = fLength + 1;
                
                    fileData = load(thisFilename);
                    
                    levelList    = fileData.stimuliGroup.cohList;
                    thisDataStruct = MakeDataStruct(fileData, levelList);

                    textureDataStruct.texBasicData{texInd,eyeInd,fInd,subjInd} = thisDataStruct;
                    textureDataStruct.texBasicFilename{texInd,eyeInd,fInd,subjInd} = thisFilename;
                end
            end
            
            % Low pass texture task data
            for filtInd = 1:nFilt
                filtVal = textureDataStruct.lpFilterEdgeList(filtInd);
                fList = dir([lowPassTextureFolder sprintf('*Subject(%s)-Eye(%s)-TexFam(%i)-Filter(LowPass-%0.2f)-*-Taken*T*.mat',subjCode,eyeCodeList{eyeInd},texFam,filtVal)]);
                for fListInd = 1:length(fList)
                    thisFilename = [lowPassTextureFolder fList(fListInd).name];

                    if ~any(strcmp(textureDataStruct.texLowPassFilename(texInd,eyeInd,filtInd,:,subjInd),thisFilename))
                        fLength = sum(~cellfun(@isempty,textureDataStruct.texLowPassFilename(texInd,eyeInd,filtInd,:,subjInd)));
                        fInd = fLength + 1;

                        fileData = load(thisFilename);

                        levelList    = fileData.stimuliGroup.cohList;
                        thisDataStruct = MakeDataStruct(fileData, levelList);

                        textureDataStruct.texLowPassData{texInd,eyeInd,filtInd,fInd,subjInd} = thisDataStruct;
                        textureDataStruct.texLowPassFilename{texInd,eyeInd,filtInd,fInd,subjInd} = thisFilename;
                    end
                end
            end
            [subjInd eyeInd texFam]
        end
    end
end

textureDataStruct.texBasicDate = NaT(size(textureDataStruct.texBasicData));
tbMask = ~cellfun(@isempty,textureDataStruct.texBasicData);
textureDataStruct.texBasicDate(tbMask) = cellfun(@(x)(x.date),textureDataStruct.texBasicData(tbMask));

textureDataStruct.texLowPassDate = NaT(size(textureDataStruct.texLowPassData));
tbMask = ~cellfun(@isempty,textureDataStruct.texLowPassData);
textureDataStruct.texLowPassDate(tbMask) = cellfun(@(x)(x.date),textureDataStruct.texLowPassData(tbMask));
