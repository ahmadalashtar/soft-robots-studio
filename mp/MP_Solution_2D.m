clear, clc, close;

sp.problemName = "wall";
sp.typeOfAlg = 'astar';
sp.typeOfHeuristic = 'continue';
switch sp.problemName
    case "wall"
        start.design = [50; 150; 150; 150; 150];
        start.matrix = [0 50; 0  150; 0 150; 0 150; 0 0];
        sp.steerBounds = [-50 50];
        sp.lengthMin = 5;
        sp.costArray = [1, 1, 1];
        sp.stepSize = [2.5 10];
        sp.obstacles = [
            400	-100 25
            400 -150 25
            400 -200 25
            ];

         sp.goals =[
            [0 50; -20  150; -20 150; -20 150; 10 150]
            ];


    case "wallWithEntrance"
        start.design = [50; 150; 150; 150; 150];
        start.matrix = [0 0 50; 10 0 150; 10 0 150; 0 0 150; 0 0 150];
        sp.steerBounds = [-30 30];
        sp.lengthMin = 5;
        sp.plane_z = 1000;
        sp.costArray = [1, 1, 1];
        sp.stepSize = [2.5 30];
        sp.obstacles = [
        -50	-300 sp.plane_z	25	650
        -50	-250 sp.plane_z	25	650
        -50	-200 sp.plane_z	25	650
        -50	-150 sp.plane_z	25	650
%         -50	-100 sp.plane_z	25	650
%         -50	-50	sp.plane_z	25	650
        -50	0	sp.plane_z	25	650
        -50	50	sp.plane_z	25	650
        -50	100	sp.plane_z	25	650
        -50	150	sp.plane_z	25	650
        -50	200	sp.plane_z	25	650
        -50	250	sp.plane_z	25	650
        -50	300	sp.plane_z	25	650
        ];
        sp.goals =[
            [0 0 50; 0 -25 150; 0 -20 150; 0 20 150; 0 0 150]
            ];
    case "hole"
        start.design = [50; 150; 175; 150; 200];
        start.matrix = [0 0 50; 0 0 150; 0 0 175; 0 0 150; 0 0 150];
        sp.steerBounds = [-40 30];
        sp.lengthMin = 5;
        sp.plane_z = 1000;
        sp.costArray = [1, 1, 1];
        sp.stepSize = [2.5 20];
        sp.obstacles = [
           0  100   450    25   100
         -50  100   450    25   100
          50  100   450    25   100
          50 100   sp.plane_z    25   430
         -50 100   sp.plane_z    25   430
          0  100   sp.plane_z    25   430
        -125 100   sp.plane_z    50   650
         125 100   sp.plane_z    50   650
        ]; 
        sp.goals =[
            [0 0 50; 0 0 150; 0 0 175; -30 0 150; -40 0 200]
            ];
    case 'GrabbingTest'
        start.design =[50; 100; 150; 150; 150];
        start.matrix = [0 0 0; 0 0 0; 0 0 0; 0 0 0; 0 0 0];
        sp.steerBounds = [-40 40];
        sp.lengthMin = 5;
        sp.plane_z = 1000;
        sp.costArray = [1, 1, 1];
        sp.stepSize = [2.5 30];
        sp.obstacles = [
           0  -200   sp.plane_z    25   450
           0  200   sp.plane_z    25   450
        ]; 
        sp.goals =[
            [0 0 50; 0 0 100; 5 0 150; 20 0 150; 35 0 140]
            [0 0 50; 0 0 100; -5 0 150; -20 0 150; -35 0 140]
        ];
        
end




sp.design = start.design;
sp.baseRotate = false;
sp.start_conf = start.matrix;
sp.j = size(sp.start_conf, 1);
sp.goal_conf = sp.goals(1:sp.j, 1:2);
sp.home_base = [0,0];
sp.isSimulataneously = false;


tic
[solution, expandedNodes] =MP_searchAlgorithm_2D(sp);
time = toc;
if isempty(solution)
    return;
end
expandedNodes;
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
growthCount;
retractCount;
steerCount;
% formattedPathForAnimation = MP_smoothMatrix(formattedPathForAnimation);
newPath = MP_smoothMatrix_2D(formattedPathForAnimation);
% ms = 10;
% pathMS = MP_sampleMs(newPath, ms);

% required = 300;
% pathRequired = MP_stretchMat(newPath, required, sp.stepSize);
% filename = 'path.txt';
% MP_writeOnFile(pathRequired, filename);
% for i = 1: 340000
%     disp(pathMS(:,:,i));
% end
% MP_softRobot_animation_2D(newPath, [0,0,0], true, sp);
MP_softRobot_animation_2D(formattedPathForAnimation, [0,0], true, sp);

