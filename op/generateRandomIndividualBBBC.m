% Initialize a random individual/chromosome
%
% INPUT: 
% 'op' is the object describing the optimization problem 
%
% OUTPUT: 
% 'indv' is the random individual [t+1 x n+4]
function [indv] =  generateRandomIndividualBBBC(cMass, gen, targetsRObstacles, robotMode)
    
    global op;  % optimization problem
    global bbbcs;
    n_targets = size(op.targets, 1);
    n_obstacles = size(op.obstacles, 1);
    n_nodes = op.n_nodes;

    % if targetsRObstacles == true
    %     n_targets = size(op.targets, 1);
    %     obstacles_n_targets = zeros(size(op.obstacles, 1) + n_targets-1, 3);
    %     obstacles_n_targets(1:size(op.obstacles, 1), :) = op.obstacles; 
    % 
    %     ownIndicePassed = false;
    %     for k = 1:n_targets
    %         if k == i
    %             ownIndicePassed = true;
    %             continue;
    %         end
    %         currObstc(1) = op.targets(k, 1);
    %         currObstc(2) = op.targets(k, 2);
    %         currObstc(3) = op.targets(k, 4);
    %         if ownIndicePassed
    %             obstacles_n_targets(size(op.obstacles, 1)+k-1, :) = currObstc;
    %         else
    %             obstacles_n_targets(size(op.obstacles, 1)+k, :) = currObstc;
    %         end
    %     end
    % end

    % lengths are shared for each configuration of the robot, so it is generated only once
    lengths = zeros(1, n_nodes + 4);
    
    for i = 1:n_nodes
        lengths(i) = cMass(n_targets + 1, i) + (op.length_domain(2) * (-1 + 2 * rand())) / gen;
        lengths(i) = max(min(lengths(i), op.length_domain(2)), op.length_domain(1));
    end
    
    indv = zeros(n_targets + 1, n_nodes + 4);
    
    if targetsRObstacles && strcmp(robotMode, "Vacuum Robot")
        tempObsNTargets = op.obstacles_n_targets;
    end
    
    for i = 1:n_targets
        end_effector = op.home_base(1:2);
        robot_orientation = [1, 0];
        robot = zeros(1, n_nodes + 4);
        
        for j = 1:n_nodes
            if j == 1 && op.first_angle.is_fixed
                angle = op.first_angle.angle;
            else
                if bbbcs.obstacle_avoidance
                    switch robotMode
                        case "Touch Robot"
                            if targetsRObstacles
                                op.obstacles_n_targets(n_obstacles + i, :) = [0, 0, 0];
                                angle = getRandomAngleAvoidingObstaclesWithCenterOfMass(end_effector, robot_orientation, lengths(j), op.length_domain, op.obstacles_n_targets, [-179, 180], false, gen, cMass, i, j);
                                op.obstacles_n_targets(n_obstacles + i, :) = [op.targets(i, 1), op.targets(i, 2), op.targets(i, 4)];
                            else
                                angle = getRandomAngleAvoidingObstaclesWithCenterOfMass(end_effector, robot_orientation, lengths(j), op.length_domain, op.obstacles, [-179, 180], false, gen, cMass, i, j);
                            end
                        case "Vacuum Robot"
                            if targetsRObstacles
                                tempObsNTargets(n_obstacles + i, :) = [0, 0, 0];
                                angle = getRandomAngleAvoidingObstaclesWithCenterOfMass(end_effector, robot_orientation, lengths(j), op.length_domain, tempObsNTargets, [-179, 180], false, gen, cMass, i, j);
                            else
                                angle = getRandomAngleAvoidingObstaclesWithCenterOfMass(end_effector, robot_orientation, lengths(j), op.length_domain, op.obstacles, [-179, 180], false, gen, cMass, i, j);
                            end
                        case "Pick & Collect Robot"
                            if targetsRObstacles
                                angle = getRandomAngleAvoidingObstaclesWithCenterOfMass(end_effector, robot_orientation, lengths(j), op.length_domain, op.carriable_o_n_t(i, :, :), [-179, 180], false, gen, cMass, i, j);
                            else
                                angle = getRandomAngleAvoidingObstaclesWithCenterOfMass(end_effector, robot_orientation, lengths(j), op.length_domain, op.obstacles, [-179, 180], false, gen, cMass, i, j);
                            end
                        case "Pick & Place Robot"
                            if targetsRObstacles
                                angle = getRandomAngleAvoidingObstaclesWithCenterOfMass(end_effector, robot_orientation, lengths(j), op.length_domain, op.carriable_o_n_t(i, :, :), [-179, 180], false, gen, cMass, i, j);
                            else
                                angle = getRandomAngleAvoidingObstaclesWithCenterOfMass(end_effector, robot_orientation, lengths(j), op.length_domain, op.obstacles, [-179, 180], false, gen, cMass, i, j);
                            end
                        case "Carry & Drop Robot"
                            if targetsRObstacles
                                angle = getRandomAngleAvoidingObstaclesWithCenterOfMass(end_effector, robot_orientation, lengths(j), op.length_domain, op.carriable_o_n_t(i, :, :), [-179, 180], false, gen, cMass, i, j);
                            else
                                angle = getRandomAngleAvoidingObstaclesWithCenterOfMass(end_effector, robot_orientation, lengths(j), op.length_domain, op.obstacles, [-179, 180], false, gen, cMass, i, j);
                            end
                    end
                else
                    angle = cMass(i, j) + (180 * (-1 + 2 * rand())) / gen;
                    angle = max(min(angle, 180), -179);
                end
            end
            robot(j) = angle;
            
            alpha = deg2rad(angle);
            new_end_effector = end_effector + robot_orientation * lengths(j);
            new_end_effector = [(new_end_effector(1) - end_effector(1)) * cos(alpha) - (new_end_effector(2) - end_effector(2)) * sin(alpha), ...
                                (new_end_effector(1) - end_effector(1)) * sin(alpha) + (new_end_effector(2) - end_effector(2)) * cos(alpha)] + end_effector;
            robot_orientation = (new_end_effector - end_effector) / norm(new_end_effector - end_effector);
            end_effector = new_end_effector;
        end
        indv(i, :) = robot;
    end
    indv(n_targets + 1, :) = lengths;
end

% A single individual is a matrix [t+1 x n+4]:

%  |                 |         |         |         |         |
%  |     (t x n)     | (t x 1) | (t x 1) | (t x 1) | (t x 1) |
%  |      angles     | segment | segment |  last   |  last   |
%  |                 |  node   |  node   |  joint  |  link   |
%  |                 |  index  |  angle  |  index  | length  |
%  |                 |         |         |         |         |
%   ----------------- --------- --------- --------- --------- 
%  |                 |         |         |         |         |
%  |     (1 x n)     |  (1x1)  |  (1x1)  |  (1x1)  |  (1x1)  |
%  |  link lengths   |  empty  |  empty  |  empty  |  empty  |
%  |                 |         |         |         |         |
%
%        robot                 extra genes 
%
% extra genes:
% - index of node on the target's orientation segment
% - angle to align to the orientation segment
% - index of last joint (the node before the end effector)
% - last link length