% Apply mutation operator on a pair of parents
%
% INPUT: 
% 'chrom' is the chromosome of the individual to be mutated
%
% OUTPUT: 
% 'chrom' is the mutated chromosome [t+1 x n+4]
function [chrom] = mutation(chrom, targetsRObstacles, robotMode)
    
    global op;  % optimization problem
    global gas; % genetic algorithm settings

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
    
    if rand() <= gas.mutation_probability
        % do mutation
        switch gas.mutation_method
            case 'random'
                chrom = randomMutation(targetsRObstacles, robotMode);
            case 'modifiedRandomMutation'
                chrom = modifiedRandomMutation(chrom, targetsRObstacles, robotMode);
            case 'polynomial'
                chrom = polynomialMutation(chrom, robotMode);
            otherwise
                error('Unexpected Mutation Method.');
        end
    end

end

%--------------RANDOM MUTATION--------------

function [chrom] = randomMutation(targetsRObstacles, robotMode)
    chrom = generateRandomChromosome(targetsRObstacles, robotMode);
end

%--------------MODIFIED RANDOM MUTATION--------------

function [chrom] = modifiedRandomMutation(chrom, targetsRObstacles, robotMode)
    global op;  % optimization problem
    global gas; % genetic algorithm settings
    targets= size(chrom,1)-1;
    ll_index = targets+1;
    bounds_angle= op.angle_domain;
    bounds_length= op.length_domain;
    a=0.5;
    angle=0;
    
    max_perturbation= (bounds_length(2) - bounds_length(1))/2;
    for j=1:1:op.n_nodes
        
        chrom(ll_index,j) = chrom(ll_index,j) + (rand-a)*max_perturbation;
        chrom(ll_index,j) = max(min(bounds_length(2),chrom(ll_index,j)),bounds_length(1));
        

        
    end

    max_perturbation= (bounds_angle(2)-bounds_angle(1))/2;
    
    if targetsRObstacles && robotMode == "Vacuum Robot"
        tempObsNTargets = op.obstacles_n_targets;
    end

    for i=1: 1:targets
        end_effector = op.home_base(1:2);
        robot_orientation = [1 0];

        for j=1: 1: op.n_nodes
            if j==1
                if op.first_angle.is_fixed==false
                    angle_bound= [chrom(i,j)-(max_perturbation/2) chrom(i,j)+(max_perturbation/2)] ;

                    switch robotMode
                        case "Touch Robot"
                            % How Touch Robot works:
                            % The current target is removed from the obstacle pool by setting
                            % everything about it to 0, including radius. After that
                            % calculate accordingly and add the target's values back to the 
                            % obstacle pool from the targets pool.
                            if targetsRObstacles
                                op.obstacles_n_targets(size(op.obstacles,1) + i,:) = [0, 0, 0];
                                angle=getRandomAngleAvoidingObstacles(end_effector, robot_orientation, chrom(ll_index,j), bounds_length, op.obstacles_n_targets, angle_bound, false);
                                op.obstacles_n_targets(size(op.obstacles,1) + i,:) = [op.targets(i,1), op.targets(i,2), op.targets(i,4)];
                            else
                                angle=getRandomAngleAvoidingObstacles(end_effector, robot_orientation, chrom(ll_index,j), bounds_length, op.obstacles, angle_bound, false);
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
                                tempObsNTargets(size(op.obstacles,1) + i,:) = [0, 0, 0];
                                angle=getRandomAngleAvoidingObstacles(end_effector, robot_orientation, chrom(ll_index,j), bounds_length, tempObsNTargets, angle_bound, false);
                            else
                                angle=getRandomAngleAvoidingObstacles(end_effector, robot_orientation, chrom(ll_index,j), bounds_length, op.obstacles, angle_bound, false);
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
                                angle=getRandomAngleAvoidingObstacles(end_effector, robot_orientation, chrom(ll_index,j), bounds_length, op.carriable_o_n_t, angle_bound, false);
                            else
                                angle=getRandomAngleAvoidingObstacles(end_effector, robot_orientation, chrom(ll_index,j), bounds_length, op.obstacles, angle_bound, false);
                            end
                    end

                    angle=max(min(bounds_angle(2),angle),bounds_angle(1));
                    chrom(i,j)=angle;
%                    chrom(i,j)=op.first_angle.angle;% don't mutate
                else
                    chrom(i,j)=op.first_angle.angle;
                end
            else
                if(gas.obstacle_avoidance== false)
                    chrom(i,j)= chrom(i,j) + (rand-a)*max_perturbation;
                    chrom(i,j) = max(min(bounds_angle(2),chrom(i,j)),bounds_angle(1));
                else
                    angle_bound= [chrom(i,j)-(max_perturbation/2) chrom(i,j)+(max_perturbation/2)] ;
                    switch robotMode
                        case "Touch Robot"
                            if targetsRObstacles
                                op.obstacles_n_targets(size(op.obstacles,1) + i,:) = [0, 0, 0];
                                angle=getRandomAngleAvoidingObstacles(end_effector, robot_orientation, chrom(ll_index,j), bounds_length, op.obstacles_n_targets, angle_bound, false);
                                op.obstacles_n_targets(size(op.obstacles,1) + i,:) = [op.targets(i,1), op.targets(i,2), op.targets(i,4)];
                            else
                                angle=getRandomAngleAvoidingObstacles(end_effector, robot_orientation, chrom(ll_index,j), bounds_length, op.obstacles, angle_bound, false);
                            end
                        case "Vacuum Robot"
                            if targetsRObstacles
                                tempObsNTargets(size(op.obstacles,1) + i,:) = [0, 0, 0];
                                angle=getRandomAngleAvoidingObstacles(end_effector, robot_orientation, chrom(ll_index,j), bounds_length, tempObsNTargets, angle_bound, false);
                            else
                                angle=getRandomAngleAvoidingObstacles(end_effector, robot_orientation, chrom(ll_index,j), bounds_length, op.obstacles, angle_bound, false);
                            end
                        case "Carry Robot"
                            if targetsRObstacles
                                angle=getRandomAngleAvoidingObstacles(end_effector, robot_orientation, chrom(ll_index,j), bounds_length, op.carriable_o_n_t, angle_bound, false);
                            else
                                angle=getRandomAngleAvoidingObstacles(end_effector, robot_orientation, chrom(ll_index,j), bounds_length, op.obstacles, angle_bound, false);
                            end
                    end
                    angle=max(min(bounds_angle(2),angle),bounds_angle(1));
                    chrom(i,j)=angle;
                end
            end
            %------------Forward Kinematics--------------
            alpha = deg2rad(angle);
            new_end_effector = end_effector+robot_orientation*(chrom(ll_index,j));
            new_end_effector = [(new_end_effector(1)-end_effector(1))*cos(alpha) - (new_end_effector(2)-end_effector(2))*sin(alpha) , (new_end_effector(1)-end_effector(1))*sin(alpha) + (new_end_effector(2)-end_effector(2))*cos(alpha)]+end_effector;   
            robot_orientation = (new_end_effector-end_effector)/norm(new_end_effector-end_effector);
            end_effector = new_end_effector;
            %--------------------------------------------
        end
    end
    

end

%--------------POLYNOMIAL MUTATION--------------

function [chrom] = polynomialMutation(chrom)
    global op;  % optimization problem
    global gas; % genetic algorithm settings
    error('This Mutation Method is not implemented yet.');
end
