% Initialize a random individual/chromosome
%
% INPUT: 
% 'op' is the object describing the optimization problem 
%
% OUTPUT: 
% 'chrom' is the random chromosome [t+1 x n+4]
function [chrom] =  generateRandomChromosome(targetsRObstacles)
    
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

    switch algorithm
        case 'ga'
            % lengths is shared for each configuration of the robot, so it is generated only once
            lengths = zeros(1,op.n_nodes+4);
            for i=1:1:op.n_nodes
                lengths(i) = (op.length_domain(2)-op.length_domain(1))*rand + op.length_domain(1);
            end   
            
            n_targets = size(op.targets,1);
            chrom = zeros(n_targets+1,op.n_nodes+4);    
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
                            if(gas.obstacle_avoidance == true)
                                if targetsRObstacles
                                    op.obstacles_n_targets(size(op.obstacles,1) + i, :) = [0, 0, 0];
                                    angle = getRandomAngleAvoidingObstacles(end_effector, robot_orientation, lengths(j), op.length_domain, op.obstacles_n_targets, [-179 180], false);
                                    op.obstacles_n_targets(size(op.obstacles,1) + i, :) = [op.targets(i,1), op.targets(i,2), op.targets(i,4)];
                                else
                                    angle = getRandomAngleAvoidingObstacles(end_effector, robot_orientation, lengths(j), op.length_domain, op.obstacles, [-179 180], false);
                                end
                            else
                                angle = (180-(-179))*rand + (-179); % does not consider obstacle avoidance
                            end
                        else
                            if(gas.obstacle_avoidance == true)
                                if targetsRObstacles
                                    op.obstacles_n_targets(size(op.obstacles,1) + i,1) = 0;
                                    op.obstacles_n_targets(size(op.obstacles,1) + i,2) = 0;
                                    op.obstacles_n_targets(size(op.obstacles,1) + i,3) = 0;
                                    angle = getRandomAngleAvoidingObstacles(end_effector, robot_orientation, lengths(j), op.length_domain, op.obstacles_n_targets, [-abs(op.first_angle.angle) abs(op.first_angle.angle)], false);
                                    op.obstacles_n_targets(size(op.obstacles,1) + i, :) = [op.targets(i,1), op.targets(i,2), op.targets(i,4)];
                                else
                                    angle = getRandomAngleAvoidingObstacles(end_effector, robot_orientation, lengths(j), op.length_domain, op.obstacles, [-abs(op.first_angle.angle) abs(op.first_angle.angle)], false);
                                end
                            else
                                angle = op.first_angle.angle;  % does not consider obstacle avoidance
                            end
                        end
                    else                
                         if(gas.obstacle_avoidance==true)
                             if targetsRObstacles
                                op.obstacles_n_targets(size(op.obstacles,1) + i, :) = [0, 0, 0];
                                angle = getRandomAngleAvoidingObstacles(end_effector, robot_orientation, lengths(j), op.length_domain, op.obstacles_n_targets, op.angle_domain, false);
                                op.obstacles_n_targets(size(op.obstacles,1) + i, :) = [op.targets(i,1), op.targets(i,2), op.targets(i,4)];
                             else
                                angle = getRandomAngleAvoidingObstacles(end_effector, robot_orientation, lengths(j), op.length_domain, op.obstacles, op.angle_domain, false);
                             end
                         else
                             angle = (op.angle_domain(2)-op.angle_domain(1))*rand + op.angle_domain(1); % does not consider obstacle avoidance
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
                chrom(i,:) = robot;   
            end
            chrom(n_targets+1,:) = lengths;

        case 'bbbc'
            % lengths are shared for each configuration of the robot, so it is generated only once
            lengths = zeros(1,op.n_nodes+4);
            for i=1:1:op.n_nodes
                lengths(i) = (op.length_domain(2)-op.length_domain(1))*rand + op.length_domain(1);
            end   
            
            n_targets = size(op.targets,1);
            chrom = zeros(n_targets+1,op.n_nodes+4);    
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
                                op.obstacles_n_targets(size(op.obstacles,1) + i,:) = [0, 0, 0];
                                angle = getRandomAngleAvoidingObstacles(end_effector, robot_orientation, lengths(j), op.length_domain, op.obstacles_n_targets, [-179 180], false);
                                op.obstacles_n_targets(size(op.obstacles,1) + i,:) = [op.targets(i,1), op.targets(i,2), op.targets(i,4)];
                            else
                                angle = (180-(-179))*rand + (-179); % does not consider obstacle avoidance
                            end
                        else
                            if(bbbcs.obstacle_avoidance == true)
                                op.obstacles_n_targets(size(op.obstacles,1) + i,:) = [0, 0, 0];
                                angle = getRandomAngleAvoidingObstacles(end_effector, robot_orientation, lengths(j), op.length_domain, op.obstacles_n_targets, [-abs(op.first_angle.angle) abs(op.first_angle.angle)], false);
                                op.obstacles_n_targets(size(op.obstacles,1) + i,:) = [op.targets(i,1), op.targets(i,2), op.targets(i,4)];
                            else
                               angle = op.first_angle.angle;  % does not consider obstacle avoidance
                            end
                        end
                    else                
                         if(bbbcs.obstacle_avoidance==true)
                                op.obstacles_n_targets(size(op.obstacles,1) + i,:) = [0, 0, 0];
                                angle = getRandomAngleAvoidingObstacles(end_effector, robot_orientation, lengths(j), op.length_domain, op.obstacles_n_targets, op.angle_domain, false);
                                op.obstacles_n_targets(size(op.obstacles,1) + i,:) = [op.targets(i,1), op.targets(i,2), op.targets(i,4)];
                         else
                             angle = (op.angle_domain(2)-op.angle_domain(1))*rand + op.angle_domain(1); % does not consider obstacle avoidance
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
                chrom(i,:) = robot;   
            end
            chrom(n_targets+1,:) = lengths;
       
    end  
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