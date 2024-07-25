clear, clc;

% polygon = [
%     0, 0;
%     0, -5;
%     5, -5;
%     0, 0;
%    ];
% 
% point = [1, -1];
% 
% 
% 
% mySquare = polyshape([0, 0, 5, 5], [0, -5, -5, 0]);
% mySquare = polyshape(polygon);
% 
% squareWidth = 1;
% squareHeight = 1;
% squareX = 0;
% squareY = 0;
% 
% myPoly = polyshape(polygon);
% 
% squarePoint = polyshape([squareX, squareX, squareX + squareWidth, squareX + squareWidth], ...
%     [squareY, squareY - squareHeight, squareY - squareHeight, squareY]);
% overlaps(mySquare, squarePoint)

%MP_insideArea2D(polygon, point)

myPoly = polyshape([ ...
    0, 0;
    1, 0;
    1, 1
    0, 1;
    ]);
shape = polyshape([ ...
    5, 6;
    7, 9;
    8, 9;
    ]);

myPoly2 = polyshape([ ...
    0, 0;
    0, 1;
    0, 2;
    1, 1;
    0, 1;
    0, 0
    ]);

plot(myPoly2)

A = [1, 2; 3, 4; 5, 6]
A(2:end, :) = 0


MP_Solution_2D

startNode.path = sp.start_conf;
startNode.g = 0;
startNode.h = 0;
startNode.f = 0;

sol = evert(startNode, 1, sp, 43);

numSubMatrices = size(sol.path, 2) / 2;

% Preallocate the 3D array to store the submatrices
formattedPathForAnimation = zeros(sp.j, 2, numSubMatrices);

% Extract the submatrices and store them in the 3D array
for i = 1:numSubMatrices
    formattedPathForAnimation(:, :, i) = sol.path(:, (i-1)*2 + 1 : i*2);
end

growthCount = 0;
retractCount = 0;
steerCount = 0;
for i=2:size(formattedPathForAnimation,3)
    [growthCount, retractCount, steerCount] = MP_actionCounter_2D(formattedPathForAnimation(:, :, i), formattedPathForAnimation(:, :, i-1), growthCount, retractCount, steerCount);
end

MP_softRobot_animation_2D(formattedPathForAnimation, [0,0], true, sp);

