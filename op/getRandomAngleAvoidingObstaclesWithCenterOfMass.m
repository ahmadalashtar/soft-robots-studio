% Generate an angle in degree within a range
% Subtract the ranges of angles that would generate a robot colliding with an obstacle
%
% INPUT:
% 'end_effector' is a [1x2] with the coordinates of the current node (considered to be the end effector before next growth)
% 'robot_orientation' is a [1x2] unit vector with the orientation of the robot at the current node 
% 'link_length' is the length of the link we are about to create
% 'length_domain' is the bounds on the link length
% 'obstacles' is [ox3] with the pose of the obstacle(s), matrix: [x , y , radius]
% 'angle_domain' is the bounds on the angle to be generated
% 'draw_plot' is a boolean flag, true if you want to plot the range from that end effector
%
% OUTPUT:
% 'angle' is the angle in degree generated with collision avoidance
function [angle] = getRandomAngleAvoidingObstaclesWithCenterOfMass(end_effector, robot_orientation, link_length, length_domain, obstacles, angle_domain, draw_plot, gen, cMass, targetRow, targetCol)
    angleBound = obstacleAvoidance_getAngle(end_effector, robot_orientation, link_length, length_domain, obstacles, angle_domain, draw_plot);
    if size(angleBound,1)>1
        randAngles = zeros(size(angleBound,1),1);
        for i=1:1:size(angleBound,1)
            randAngles(i) = cMass(targetRow, targetCol) + (angleBound(i,2)*(-1 + (1--1)*rand()))/gen;
            randAngles(i) = max(min(randAngles(i), angleBound(i,2)), angleBound(i,1));
        end
        randIndex = nearest((size(angleBound,1)-1)*rand + 1);
        angle = randAngles(randIndex);
    else
        angle = cMass(targetRow, targetCol) + (angleBound(1,2)*(-1 + (1--1)*rand()))/gen; 
        angle = max(min(angle, angleBound(1,2)), angleBound(1,1));
    end
end