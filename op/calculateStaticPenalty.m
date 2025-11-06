%--------------STATIC PENALTY METHOD--------------
function [gScalar] = calculateStaticPenalty(chrom, r, targetsRObstacles, robotMode)          
    global op;  % optimization problem
    global gas; % genetic algorithm settings
    global bbbcs;
    global algorithm;

    gScalar = 0;

    n_nodes = size(chrom,2) - 4;
    n_targets = size(op.targets,1);
    min_angle = op.angle_domain(1);
    max_angle = op.angle_domain(2);
    min_length = op.length_domain(1);
    
    if targetsRObstacles && robotMode == "Vacuum Robot"
        tempObsNTargets = op.obstacles_n_targets;
    end

    for i = 1:1:n_targets
        final_angle = chrom(i,n_nodes+2);
        last_link_length = chrom(i,n_nodes+4);

        g = zeros(1,6);     % array of penalty terms for each constraint
        beta = 1;           % parameter of penalty method

        %--CONSTRAINT 1,2: final angle is between angle bounds
        g(1) = abs(min(0,final_angle - min_angle))^beta;

        g(2) = abs(min(0,max_angle - final_angle))^beta;    

        %--CONSTRAINT 3: final link length is > min link length, only if there is only 1 link on the target's orientation segment
        linksOnSegment = chrom(i,n_nodes+3) - (chrom(i,n_nodes+1)-1);
        if linksOnSegment <= 1
            g(3) = abs(min(0,last_link_length - min_length))^beta;
        else
            g(3) = 0;
        end

        %--CONSTRAINT 4: no collision with obstacles
        intersections = 0;  % counter for the intersections
        configurations = decodeIndividual(chrom); 
        conf = configurations(:,:,i);
        robot_points = solveForwardKinematics2D(conf,op.home_base,false);
        ee_index = chrom(i,n_nodes+3)+1;  
        % check intersections for every segment of each configuration of the robot
        for j=1:1:ee_index-1           
            p_start = robot_points(j,:);
            p_end = robot_points(j+1,:);
            link_length = norm(p_end-p_start);
            if targetsRObstacles && (robotMode == "Pick & Collect Robot" || robotMode == "Pick & Place Robot" || robotMode == "Carry & Drop Robot")
                rad = op.targets(i, 4);
                dire = (p_end - p_start)/link_length;
                p_end = p_end + dire * rad;
            end

            % if targetsRObstacles == true
            % 
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
            if targetsRObstacles
                switch robotMode
                    case "Touch Robot"
                        op.obstacles_n_targets(size(op.obstacles,1) + i,:) = [0, 0, 0];
                        nearby_obstacles = findNearbyObstacles(p_start,link_length,op.length_domain(1), op.obstacles_n_targets);  
                        n_nearby_obstacles = size(nearby_obstacles,2);
                        for z=1:1:n_nearby_obstacles
                            if intersectObstacle_2D([p_start; p_end],op.obstacles_n_targets(nearby_obstacles(z),:),false)
                                intersections = intersections + 1;
                            end
                        end
                        op.obstacles_n_targets(size(op.obstacles,1) + i,:) = [op.targets(i,1), op.targets(i,2), op.targets(i,4)];
                    case "Vacuum Robot"
                        tempObsNTargets(size(op.obstacles,1) + i,:) = [0, 0, 0];
                        nearby_obstacles = findNearbyObstacles(p_start,link_length,op.length_domain(1), tempObsNTargets);  
                        n_nearby_obstacles = size(nearby_obstacles,2);
                        for z=1:1:n_nearby_obstacles
                            if intersectObstacle_2D([p_start; p_end],tempObsNTargets(nearby_obstacles(z),:),false)
                                intersections = intersections + 1;
                            end
                        end
                    case "Pick & Collect Robot"
                        if ~isempty(op.carriable_o_n_t)
                            nearby_obstacles = findNearbyObstacles(p_start,link_length,op.length_domain(1) + op.targets(i,4), squeeze(op.carriable_o_n_t(i, :, :)));
                        else
                            nearby_obstacles = findNearbyObstacles(p_start,link_length,op.length_domain(1) + op.targets(i,4), op.obstacles);
                        end
                        
                        n_nearby_obstacles = size(nearby_obstacles,2);
                        for z=1:1:n_nearby_obstacles
                            if op.carriable_o_n_t(i,nearby_obstacles(z),3) == 0
                                continue;
                            end
                            if intersectObstacle_2D([p_start; p_end], op.carriable_o_n_t(i,nearby_obstacles(z),:),false)
                                intersections = intersections + 1;
                            end
                        end
                    case "Pick & Place Robot"
                        if ~isempty(op.carriable_o_n_t)
                            nearby_obstacles = findNearbyObstacles(p_start,link_length,op.length_domain(1) + op.targets(i,4), squeeze(op.carriable_o_n_t(i, :, :)));
                        else
                            nearby_obstacles = findNearbyObstacles(p_start,link_length,op.length_domain(1) + op.targets(i,4), op.obstacles);
                        end
                        n_nearby_obstacles = size(nearby_obstacles,2);
                        for z=1:1:n_nearby_obstacles
                            if op.carriable_o_n_t(i,nearby_obstacles(z),3) == 0
                                continue;
                            end
                            if intersectObstacle_2D([p_start; p_end], op.carriable_o_n_t(i,nearby_obstacles(z),:),false)
                                intersections = intersections + 1;
                            end
                        end
                    case "Carry & Drop Robot"
                        if ~isempty(op.carriable_o_n_t)
                            nearby_obstacles = findNearbyObstacles(p_start,link_length,op.length_domain(1) + op.targets(i,4), squeeze(op.carriable_o_n_t(i, :, :)));
                        else
                            nearby_obstacles = findNearbyObstacles(p_start,link_length,op.length_domain(1) + op.targets(i,4), op.obstacles);
                        end
                        n_nearby_obstacles = size(nearby_obstacles,2);
                        for z=1:1:n_nearby_obstacles
                            if op.carriable_o_n_t(i,nearby_obstacles(z),3) == 0
                                continue;
                            end
                            if intersectObstacle_2D([p_start; p_end], op.carriable_o_n_t(i,nearby_obstacles(z),:),false)
                                intersections = intersections + 1;
                            end
                        end
                end

            else
                nearby_obstacles = findNearbyObstacles(p_start,link_length,op.length_domain(1), op.obstacles);  
                n_nearby_obstacles = size(nearby_obstacles,2);
                for z=1:1:n_nearby_obstacles
                    if intersectObstacle_2D([p_start; p_end],op.obstacles(nearby_obstacles(z),:),false)
                        intersections = intersections + 1;
                    end
                end
            end
        end
        g(4) = intersections;

        %--CONSTRAINT 5: final angle is between angle bounds

        % this constraint is needed in beacause of the algorithm of distance point-segment,
        % since it can generate the closest point to be one of the edges of the segment, 
        % and in case that point is the target then the solution would be horrible
        
        link_count= chrom(i,n_nodes+1)-1;
        sum_of_angles = sum(chrom(i,2:link_count)) + final_angle;
        target_angle= op.targets(i,3) - op.home_base(3);
        angle_range= [target_angle-10 target_angle+10];
        if(sum_of_angles<min(angle_range) || sum_of_angles>max(angle_range))
            g(5)=1;
        end

        %--CONSTRAINT 6: all links are far from an obstacle directly infront of it

        % this constraint is needed because when an obstacle is right
        % infront of a link, and its not a sufficient distance far (minimum
        % length amount), it will collide before being able to grow the
        % minimum length.

        intersectionsN = 0;

        for j = 1:1:ee_index-1
            
            l_vector = robot_points(j+1,:) - robot_points(j,:);
            l_length = norm(l_vector);
            
            if j == ee_index-1
                continue;
            end

            angleA = atand(abs(robot_points(j,2)-robot_points(j+1,2))/abs(robot_points(j,1)-robot_points(j+1,1)));

            nearby_obstacles = findNearbyObstacles(robot_points(j,:), l_length, op.length_domain(1), op.obstacles);
            n_nearby_obstacles = size(nearby_obstacles, 2);

            for z = 1:1:n_nearby_obstacles
                o_pos = op.obstacles(nearby_obstacles(z), 1:2); 
                o_vector = o_pos - robot_points(j,:);
                o_distance = norm(o_vector);
                
                angleB = atand(abs(robot_points(j,2)-o_pos(2))/abs(robot_points(j,1)-o_pos(1)));

                angle2Apply = deg2rad(angleB + 90);

                x_offset = op.obstacles(nearby_obstacles(z), 3) * cos(angle2Apply);
                y_offset = op.obstacles(nearby_obstacles(z), 3) * sin(angle2Apply);

                o_corner1 = o_pos + [x_offset, y_offset];
                angleC = atand(abs(robot_points(j,2)-o_corner1(2))/abs(robot_points(j,1)-o_corner1(1)));

                angle2Apply = deg2rad(angleB - 90);

                x_offset = op.obstacles(nearby_obstacles(z), 3) * cos(angle2Apply);
                y_offset = op.obstacles(nearby_obstacles(z), 3) * sin(angle2Apply);

                o_corner2 = o_pos + [x_offset, y_offset];
                angleD = atand(abs(robot_points(j,2)-o_corner2(2))/abs(robot_points(j,1)-o_corner2(1)));

                if o_distance < min_length && ((angleA < angleC && angleA > angleB) || (angleA > angleC && angleA < angleB)) && ((0 < angleC && 0 > angleD) || (0 > angleC && 0 < angleD))
                    intersectionsN = intersectionsN + 1;
                end
            end
        end

        g(6) = intersectionsN;

        if(g(4) ~= 0)
            switch algorithm
                case 'ga'
                    gas.infeasible_subcount = gas.infeasible_subcount+intersections;
                case 'bbbc'
                    bbbcs.infeasible_subcount = bbbcs.infeasible_subcount+intersections;
            end
           % --- running variance by https://lingpipe-blog.com/2009/07/07/welford-s-algorithm-delete-online-mean-variance-deviation/
%            gas.infeasible_running_stats(2) = gas.infeasible_running_stats(2)+1;
%            nextM = gas.infeasible_running_stats(1) + (intersections - gas.infeasible_running_stats(1)) / gas.infeasible_running_stats(2);
%            gas.infeasible_running_stats(3) = gas.infeasible_running_stats(3) + (intersections - gas.infeasible_running_stats(1)) * (intersections - nextM);
%            gas.infeasible_running_stats(1) = nextM;

        end

        if(g(6) ~= 0)
            switch algorithm
                case 'ga'
                    gas.infeasible_subcount = gas.infeasible_subcount+intersectionsN;
                case 'bbbc'
                    bbbcs.infeasible_subcount = bbbcs.infeasible_subcount+intersectionsN;
            end
        end
        
        gScalar = gScalar + g*r';
    end
end
