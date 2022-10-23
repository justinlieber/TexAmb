%% Gerick Lee 2022-10-23
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function contrastDataPsychPlot(data)

%% 
conData = data.conThreshData;
nSubjects = size(conData, 4);
nEyes = 2; 
nSF = length(data.sfList);
nFiles = size(conData, 3); % NB: not all subjects have nFiles files.
pfSlope = 2; % hard coded
chance = 0.5;

cMap = viridis(nFiles + 0); % "+ 1" gets rid of yellow, which is hard to see.
%%


for j = 1 : nSubjects
    for k = 1 : nEyes
        for jj = 1 : nSF
            aggData = []; % aggregate data for combined fit.
            
            for kk = 1 : nFiles
                if ~isempty(conData{jj, k, kk, j})
                    figHand = figure(1); set(gca, 'XScale', 'log', 'XTick', [0.001 0.003 0.01 0.03 0.1 0.3 1]); axis([0.001 1 0 1]); axis square
                    if kk == 1; clf; hold on; end
                    
                    fitData    = conData{jj, k, kk, j}.behSummary(:, [1 3 2]); 
                    aggData    = combineBehMats(fitData, aggData);
                    fitParams  = dataOut.conThreshSessPF{jj, k, kk, j};
                    
                    xVec = logspace(log10(min(fitData(:, 1))), log10(1), 100);
                    yVec = chance + ((1 - chance - abs(fitParams(3))) * wblcdf(xVec, fitParams(2), fitParams(1))); %* 0.99 + 0.005;
                    
                    plot(fitData(:, 1), fitData(:, 2) ./ fitData(:, 3), 'o', 'MarkerEdgeColor', [1 1 1], 'MarkerFaceColor', cMap(kk, :), 'MarkerSize', 7)
                    plot(fitParams(2), 0.1, 's', 'MarkerEdgeColor', [1 1 1], 'MarkerFaceColor', cMap(kk, :), 'MarkerSize', 7)
                    plot(xVec, yVec, '--', 'Color', cMap(kk, :))
                end
            end
            
            if ~isempty(aggData)
                fitParams  = dataOut.conThreshAggPF{jj, k, j};
                
%                 fitWblThreshLapse_fixedSlope(aggData, pfSlope, 0.5);
                
                xVec = logspace(log10(min(aggData(:, 1))), log10(1), 100);
                yVec = chance + ((1 - chance - abs(fitParams(3))) * wblcdf(xVec, fitParams(2), fitParams(1))); %* 0.99 + 0.005;
                
                plot(aggData(:, 1), aggData(:, 2) ./ aggData(:, 3), 'o', 'MarkerEdgeColor', [1 1 1], 'MarkerEdgeColor', [0 0 0], 'MarkerSize', 10)
                plot(fitParams(2), 0.1, 's', 'MarkerEdgeColor', [1 1 1], 'MarkerFaceColor', [0 0 0], 'MarkerSize', 10)
                plot(xVec, yVec, '-', 'Color', [0 0 0], 'LineWidth', 1)
                titleString = [data.subjectList{j}, ', ', data.eyeOrder{k}, 'E, ', num2str(data.sfList(jj), '%0.1f'), 'cpd'];
                title(titleString, 'FontWeight', 'normal')
            end
            %%
            xh = get(gca,'xlabel'); % handle to the label object
            p = get(xh,'position'); % get the current position property
            p(2) = 3*p(2);        % double the distance,
            % negative values put the label below the axis
            set(xh,'position',p)
            
            %     ylabel('d''', 'Fontsize', 8)
            xh = get(gca,'ylabel'); % handle to the label object
            p = get(xh,'position'); % get the current position property
            p(1) = 3*p(1);        % double the distance,
            % negative values put the label below the axis
            set(xh,'position',p)
            saveString =  ['Subject(', data.subjectList{j}, ')-Eye(', data.eyeOrder{k}, ')-SpatialFreq(', num2str(data.sfList(jj), '%0.1f'), ')'];
%             saveString = regexprep(saveString, ',', ')');
%             saveString = regexprep(saveString, ' ', '\_(');
            saveName = ['/v/analysis/gerick/TexAmbPlots/SimpleContrastTaskPsychFit-', saveString, '.eps'];%% save?
            
            
            hw = [15 15];
            set(0,'units','pixels');
            Pixels = get(0,'screensize');
            set(0,'units','inches');
            Inches = get(0,'screensize');
            Res = Pixels/Inches;
            
            set(figHand, 'position', [840   461   hw(1)*Res hw(2)*Res]);
            set(gcf, 'PaperUnits', 'inches')
            set(gcf, 'PaperPosition', [0 0 hw(1) hw(2)])
            % set(gca, 'TickDir', 'out', 'tickLength', [.02 .02])
            % set(gca, 'position', [.175 .25 .775 .7]);
            hold on;
            
            
            print(gcf, '-depsc', saveName); % this works!
            
%             pause
            
        end
    end
end


























