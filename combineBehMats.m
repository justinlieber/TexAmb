%% Gerick Lee 2020-04-16
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dataOut = combineBehMats(d1, d2)
%%
if isempty(d1)
    dataOut = d2;
    return
elseif isempty(d2)
    dataOut = d1;
    return
end
levels = unique([d1(:, 1); d2(:, 1)]);
dataOut = zeros(length(levels), 3);
dataOut(:, 1) = levels;

for j = 1 : length(levels)
    if ~isempty(d1(find(d1(:, 1) == levels(j)), 2 : 3))
        dataOut(j, 2 : 3) = d1(find(d1(:, 1) == levels(j)), 2 : 3);
    end
    if ~isempty(d2(find(d2(:, 1) == levels(j)), 2 : 3))
        dataOut(j, 2 : 3) = dataOut(j, 2 : 3) + d2(find(d2(:, 1) == levels(j)), 2 : 3);
    end
    
end