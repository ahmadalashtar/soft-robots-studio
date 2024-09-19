%--------------STATIC PENALTY METHOD--------------
function [gScalar] = calculateStaticPenalty(chrom, r)          
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
            l_length = norm(p_end-p_start);                
            nearby_obstacles = findNearbyObstacles(p_start,l_length,op.length_domain(1), op.obstacles);  
            n_nearby_obstacles = size(nearby_obstacles,2);
            for z=1:1:n_nearby_obstacles
                if intersectObstacle_2D([p_start; p_end],op.obstacles(nearby_obstacles(z),:),false)
                    intersections = intersections + 1;
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
            l_angle = atan2(l_vector(2), l_vector(1));
            
            if j < ee_index-1
                n_vector = robot_points(j+2,:) - robot_points(j+1,:);
                n_angle = atan2(n_vector(2), n_vector(1));
            else
                n_angle = l_angle;
            end

            min_angleN = min(l_angle, n_angle);
            max_angleN = max(l_angle, n_angle);

            nearby_obstacles = findNearbyObstacles(robot_points(j,:), l_length, op.length_domain(1), op.obstacles);
            n_nearby_obstacles = size(nearby_obstacles, 2);

            for z = 1:1:n_nearby_obstacles
                o_pos = op.obstacles(nearby_obstacles(z), 1:2); 
                o_vector = o_pos - robot_points(j,:);
                o_distance = norm(o_vector);
                o_angle = atan2(o_vector(2), o_vector(1));

                if min_angleN < 0
                    min_angleN = min_angleN + 2*pi;
                    max_angleN = max_angleN + 2*pi;
                    o_angle = mod(o_angle + 2*pi, 2*pi);
                end

                if o_angle >= min_angleN && o_angle <= max_angleN && o_distance < min_length
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
