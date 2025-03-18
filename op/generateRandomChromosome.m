% Initialize a random individual/chromosome
%
% INPUT: 
% 'op' is the object describing the optimization problem 
%
% OUTPUT: 
% 'chrom' is the random chromosome [t+1 x n+4]
function [chrom] =  generateRandomChromosome(targetsRObstacles, robotMode)
    
    global op;  % optimization problem
    global gas;
    global bbbcs;
    global algorithm;

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

    n_targets = size(op.targets, 1);
    n_obstacles = size(op.obstacles, 1);
    n_nodes = op.n_nodes;

    lengths = zeros(1, n_nodes + 4);
    for i = 1:n_nodes
        lengths(i) = (op.length_domain(2) - op.length_domain(1)) * rand + op.length_domain(1);
    end

    chrom = zeros(n_targets + 1, n_nodes + 4);

    if targetsRObstacles && robotMode == "Vacuum Robot"
        tempObsNTargets = op.obstacles_n_targets;
    end

    switch algorithm
        case 'ga'
            obstacle_avoidance = gas.obstacle_avoidance;
        case 'bbbc'
            obstacle_avoidance = bbbcs.obstacle_avoidance;
        otherwise
            error('Unknown algorithm');
    end

    for i = 1:n_targets
        end_effector = op.home_base(1:2);
        if targetsRObstacles && (robotMode == "Pick & Collect Robot" || robotMode == "Pick & Place Robot" || robotMode == "Carry & Drop Robot")
            end_effector = end_effector + (op.targets(i,4) * op.home_base(3));
        end
        robot_orientation = [1, 0];
        robot = zeros(1, n_nodes + 4);

        for j = 1:n_nodes
            if j == 1 && op.first_angle.is_fixed
                angle = op.first_angle.angle;
            else
                if obstacle_avoidance
                    if targetsRObstacles
                        switch robotMode
                            case "Touch Robot"
                                op.obstacles_n_targets(n_obstacles + i, :) = [0, 0, 0];
                                angle = getRandomAngleAvoidingObstacles(end_effector, robot_orientation, lengths(j), op.length_domain, op.obstacles_n_targets, op.angle_domain, false);
                                op.obstacles_n_targets(n_obstacles + i, :) = [op.targets(i, 1), op.targets(i, 2), op.targets(i, 4)];
                            case "Vacuum Robot"
                                tempObsNTargets(n_obstacles + i, :) = [0, 0, 0];
                                angle = getRandomAngleAvoidingObstacles(end_effector, robot_orientation, lengths(j), op.length_domain, tempObsNTargets, op.angle_domain, false);
                            case "Pick & Collect Robot"
                                if ~isempty(op.carriable_o_n_t)
                                    angle = getRandomAngleAvoidingObstacles(end_effector, robot_orientation, lengths(j) + op.targets(i,4), op.length_domain, squeeze(op.carriable_o_n_t(i, :, :)), op.angle_domain, false);
                                else
                                    angle = getRandomAngleAvoidingObstacles(end_effector, robot_orientation, lengths(j) + op.targets(i,4), op.length_domain, [], op.angle_domain, false);
                                end
                            case "Pick & Place Robot"
                                if ~isempty(op.carriable_o_n_t(i, :, :))
                                    angle = getRandomAngleAvoidingObstacles(end_effector, robot_orientation, lengths(j) + op.targets(i,4), op.length_domain, squeeze(op.carriable_o_n_t(i, :, :)), op.angle_domain, false);
                                else
                                    angle = getRandomAngleAvoidingObstacles(end_effector, robot_orientation, lengths(j) + op.targets(i,4), op.length_domain, [], op.angle_domain, false);
                                end
                            case "Carry & Drop Robot"
                                if ~isempty(op.carriable_o_n_t(i, :, :))
                                    angle = getRandomAngleAvoidingObstacles(end_effector, robot_orientation, lengths(j) + op.targets(i,4), op.length_domain, squeeze(op.carriable_o_n_t(i, :, :)), op.angle_domain, false);
                                else
                                    angle = getRandomAngleAvoidingObstacles(end_effector, robot_orientation, lengths(j) + op.targets(i,4), op.length_domain, [], op.angle_domain, false);
                                end
                        end
                    else
                        angle = getRandomAngleAvoidingObstacles(end_effector, robot_orientation, lengths(j), op.length_domain, op.obstacles, op.angle_domain, false);
                    end
                else
                    angle = (op.angle_domain(2) - op.angle_domain(1)) * rand + op.angle_domain(1);
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

        chrom(i, :) = robot;
    end

    chrom(n_targets + 1, :) = lengths;
end

% A single chromosome is a matrix [t+1 x n+4]:

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
%        robot            extra genes of the
%    configurations           chromosome
%
% extra genes:
% - index of node on the target's orientation segment
% - angle to align to the orientation segment
% - index of last joint (the node before the end effector)
% - last link length