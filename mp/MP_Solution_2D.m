function result = MP_Solution_2D()

global sp;

sp.j = size(sp.start_conf, 1);
sp.goal_conf = sp.goals(1:sp.j, 1:2);
sp.isSimulataneously = false;


[solution, ~] =MP_searchAlgorithm_2D(sp);
if isempty(solution)
    result = [];
    return;
end
solution.g;

% Calculate the number of submatrices you will create
numSubMatrices = size(solution.path, 2) / 2;

% Preallocate the 3D array to store the submatrices
formattedPathForAnimation = zeros(sp.j, 2, numSubMatrices);




% Extract the submatrices and store them in the 3D array
for i = 1:numSubMatrices
    formattedPathForAnimation(:, :, i) = solution.path(:, (i-1)*2 + 1 : i*2);
end

growthCount = 0;
retractCount = 0;
steerCount = 0;
for i=2:size(formattedPathForAnimation,3)
    [growthCount, retractCount, steerCount] = MP_actionCounter_2D(formattedPathForAnimation(:, :, i), formattedPathForAnimation(:, :, i-1), growthCount, retractCount, steerCount);
end

result  = formattedPathForAnimation;


end