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
    lengths = zeros(1,op.n_nodes+4);
    
    n_targets = size(op.targets,1);
    for i=1:1:op.n_nodes
        lengths(i) = cMass(n_targets+1,i) + (op.length_domain(2)*(-1 + (1--1)*rand()))/gen;
        lengths(i) = max(min(lengths(i), op.length_domain(2)), op.length_domain(1));
    end   
    
    if targetsRObstacles && robotMode == "Vacuum Robot"
        tempObsNTargets = op.obstacles_n_targets;
    end

    indv = zeros(n_targets+1,op.n_nodes+4);    
    for i=1:1:n_targets        
        
        end_effector = op.home_base(1:2);
        robot_orientation = [1 0];
        robot = zeros(1,op.n_nodes+4); 
        
        for j=1:1:op.n_nodes   
            % generate angles for each node
            % each angle is generated in a range that avoids collision with obstacles
            if j==1
                % first link might be fixed to the base
                if op.first_angle.is_fixed == false
                    if(bbbcs.obstacle_avoidance == true)
                        switch robotMode
                            case "Touch Robot"
                                % How Touch Robot works:
                                % The current target is removed from the obstacle pool by setting
                                % everything about it to 0, including radius. After that
                                % calculate accordingly and add the target's values back to the 
                                % obstacle pool from the targets pool.
                                if targetsRObstacles
                                    op.obstacles_n_targets(size(op.obstacles,1) + i, :) = [0, 0, 0];
                                    angle = getRandomAngleAvoidingObstaclesWithCenterOfMass(end_effector, robot_orientation, lengths(j), op.length_domain, op.obstacles_n_targets, [-179 180], false, gen, cMass, i, j);
                                    op.obstacles_n_targets(size(op.obstacles,1) + i, :) = [op.targets(i,1), op.targets(i,2), op.targets(i,4)];
                                else
                                    angle = getRandomAngleAvoidingObstaclesWithCenterOfMass(end_effector, robot_orientation, lengths(j), op.length_domain, op.obstacles, [-179 180], false, gen, cMass, i, j);
                                end
                            case "Vacuum Robot"
                                % How Vacuum Robot works:
                                % The current target is removed from the obstacle pool by setting
                                % everything about it to 0, including radius. After that
                                % calculate accordingly. Target is not added back because
                                % it was vacuumed in.
                                % This mode is preferably for dust and
                                % flexible things that can be sucked in.
                                if targetsRObstacles
                                    tempObsNTargets(size(op.obstacles,1) + i, :) = [0, 0, 0];
                                    angle = getRandomAngleAvoidingObstaclesWithCenterOfMass(end_effector, robot_orientation, lengths(j), op.length_domain, tempObsNTargets, [-179 180], false, gen, cMass, i, j);
                                else
                                    angle = getRandomAngleAvoidingObstaclesWithCenterOfMass(end_effector, robot_orientation, lengths(j), op.length_domain, op.obstacles, [-179 180], false, gen, cMass, i, j);
                                end
                            case "Carry Robot"
                                % How Carry Robot works:
                                % The Radius of the current target is added to every other obstacle.
                                % Basically increasing their radius.
                                % This is because the target being carried back can collide with the
                                % previous obstacles on the path.
                                % After, the current target is removed from the obstacle pool by setting
                                % everything about it to 0, including radius. After that
                                % calculate accordingly. Target is not added back because
                                % it was carried back.
                                if targetsRObstacles
                                    angle = getRandomAngleAvoidingObstaclesWithCenterOfMass(end_effector, robot_orientation, lengths(j), op.length_domain, op.carriable_o_n_t(i,:,:), [-179 180], false, gen, cMass, i, j);
                                else
                                    angle = getRandomAngleAvoidingObstaclesWithCenterOfMass(end_effector, robot_orientation, lengths(j), op.length_domain, op.obstacles, [-179 180], false, gen, cMass, i, j);
                                end
                        end

                    else
                        % does not consider obstacle avoidance
                        angle = cMass(i,j) + (180*(-1 + (1--1)*rand()))/gen;
                        angle = max(min(angle, 180), -179);
                    end
                else
                    if(bbbcs.obstacle_avoidance == true)
                        switch robotMode
                            case "Touch Robot"
                                if targetsRObstacles
                                    op.obstacles_n_targets(size(op.obstacles,1) + i, :) = [0, 0, 0];
                                    angle = getRandomAngleAvoidingObstaclesWithCenterOfMass(end_effector, robot_orientation, lengths(j), op.length_domain, op.obstacles_n_targets, [-abs(op.first_angle.angle) abs(op.first_angle.angle)], false, gen, cMass, i, j);
                                    op.obstacles_n_targets(size(op.obstacles,1) + i, :) = [op.targets(i,1), op.targets(i,2), op.targets(i,4)];
                                else
                                    angle = getRandomAngleAvoidingObstaclesWithCenterOfMass(end_effector, robot_orientation, lengths(j), op.length_domain, op.obstacles, [-abs(op.first_angle.angle) abs(op.first_angle.angle)], false, gen, cMass, i, j);
                                end
                            case "Vacuum Robot"
                                if targetsRObstacles
                                    tempObsNTargets(size(op.obstacles,1) + i, :) = [0, 0, 0];
                                    angle = getRandomAngleAvoidingObstaclesWithCenterOfMass(end_effector, robot_orientation, lengths(j), op.length_domain, tempObsNTargets, [-abs(op.first_angle.angle) abs(op.first_angle.angle)], false, gen, cMass, i, j);
                                else
                                    angle = getRandomAngleAvoidingObstaclesWithCenterOfMass(end_effector, robot_orientation, lengths(j), op.length_domain, op.obstacles, [-abs(op.first_angle.angle) abs(op.first_angle.angle)], false, gen, cMass, i, j);
                                end
                            case "Carry Robot"
                                if targetsRObstacles
                                    tempObsNTargets(size(op.obstacles,1) + i, :) = [0,0,0];
                                    angle = getRandomAngleAvoidingObstaclesWithCenterOfMass(end_effector, robot_orientation, lengths(j), op.length_domain, op.carriable_o_n_t(i,:,:), [-abs(op.first_angle.angle) abs(op.first_angle.angle)], false, gen, cMass, i, j);
                                else
                                    angle = getRandomAngleAvoidingObstaclesWithCenterOfMass(end_effector, robot_orientation, lengths(j), op.length_domain, op.obstacles, [-abs(op.first_angle.angle) abs(op.first_angle.angle)], false, gen, cMass, i, j);
                                end
                        end

                    else
                       angle = op.first_angle.angle;  % does not consider obstacle avoidance
                    end
                end
            else                
                 if(bbbcs.obstacle_avoidance==true)
                     switch robotMode
                         case "Touch Robot"
                             if targetsRObstacles
                                op.obstacles_n_targets(size(op.obstacles,1) + i, :) = [0, 0, 0];
                                angle = getRandomAngleAvoidingObstaclesWithCenterOfMass(end_effector, robot_orientation, lengths(j), op.length_domain, op.obstacles_n_targets, op.angle_domain, false, gen, cMass, i, j);
                                op.obstacles_n_targets(size(op.obstacles,1) + i, :) = [op.targets(i,1), op.targets(i,2), op.targets(i,4)];
                             else
                                angle = getRandomAngleAvoidingObstaclesWithCenterOfMass(end_effector, robot_orientation, lengths(j), op.length_domain, op.obstacles, op.angle_domain, false, gen, cMass, i, j);
                             end
                         case "Vacuum Robot"
                             if targetsRObstacles
                                tempObsNTargets(size(op.obstacles,1) + i, :) = [0, 0, 0];
                                angle = getRandomAngleAvoidingObstaclesWithCenterOfMass(end_effector, robot_orientation, lengths(j), op.length_domain, tempObsNTargets, op.angle_domain, false, gen, cMass, i, j);
                             else
                                angle = getRandomAngleAvoidingObstaclesWithCenterOfMass(end_effector, robot_orientation, lengths(j), op.length_domain, op.obstacles, op.angle_domain, false, gen, cMass, i, j);
                             end
                         case "Carry Robot"
                             if targetsRObstacles
                                tempObsNTargets(size(op.obstacles,1) + i, :) = [0,0,0];
                                angle = getRandomAngleAvoidingObstaclesWithCenterOfMass(end_effector, robot_orientation, lengths(j), op.length_domain, op.carriable_o_n_t(i,:,:), op.angle_domain, false, gen, cMass, i, j);
                             else
                                angle = getRandomAngleAvoidingObstaclesWithCenterOfMass(end_effector, robot_orientation, lengths(j), op.length_domain, op.obstacles, op.angle_domain, false, gen, cMass, i, j);
                             end
                     end
                 else
                     angle = cMass(i,j) + (op.angle_domain(2)*(-1 + (1--1)*rand()))/gen;
                     angle = max(min(angle, op.angle_domain(2)), op.angle_domain(1));
                 end
            end
            robot(j) = angle;
            
            %------------Forward Kinematics--------------
            alpha = deg2rad(angle);
            new_end_effector = end_effector+robot_orientation*lengths(j);
            new_end_effector = [(new_end_effector(1)-end_effector(1))*cos(alpha) - (new_end_effector(2)-end_effector(2))*sin(alpha) , (new_end_effector(1)-end_effector(1))*sin(alpha) + (new_end_effector(2)-end_effector(2))*cos(alpha)]+end_effector;   
            robot_orientation = (new_end_effector-end_effector)/norm(new_end_effector-end_effector);
            end_effector = new_end_effector;
            %--------------------------------------------
        end
        indv(i,:) = robot;   
    end
    indv(n_targets+1,:) = lengths;

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