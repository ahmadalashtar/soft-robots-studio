% Calculate the fitness of a chromosome/individual
% Objective functions are: 
% (1) minimize the distance from the end effector to the target
% (2) minimize the displacement between the orientation of the end effector and the target desired orientation of reaching
% (3) minimize the number of links used to reach the target
% All these objective functions can be modeled into a single objective function. 
% The main idea is, istead of reaching the target, we simply want to reach the target's orientation segment; 
% then we would cut the remaining part of the chromosome (which will be unused, i.e. not everted from the robot).
% By minimizing the summation of all the distances between the used nodes of the robot and the target's orientation segment, 
% we are including all the three objective functions in a single one.
% It also makes sense to increase the importance of the distance from the as the number of used nodes increases 
% (i.e., we want to get closer to the segment).
% Therefore, the distances are wrapped together in a weighted sum, with
% weights that linearly increase with the index of the associated node 
% (we do not consider node 1 because the container of the robot does not move).
%
% To avoid robots that "zigzag" around the target's orientation segment, we "cut" the robot by using two search algorithms: 
% - hill climbing  (the first node that gets locally closer to the segment)
% - first link that intersects the target's orientation segment
% and we cut at the minimum between the nodes retreived by these two strategies.
%
% INPUT:
% 'chrom' is the chromosome [t+1 x n+4] to be evaluated (extra genes should be empty)
% 'draw_plot' is a boolean flag, true if you want to plot the segments from targets
%
% OUTPUT:
% 'chrom' is the evaluated chromosome [t+1 x n+4] with added information in the extra genes
% 'fitness' a scalar numeric value representing the fitness of the chromosome
function [chrom, fitness] = calculateFitness2D(chrom, draw_plot)

    global op;  % optimization problem
    global gas;  % genetic algorithm settings
    global bbbcs;
    global algorithm;     
    
    % the chromosome will be evaluated in this function
    % if it has been previoulsy evaluated, its extra genes would be different than 0
    % this would corrupt the chromosome during evaluation
    % therefore, reset the last extra genes to zero, and restart the evaluation
    chrom(:,op.n_nodes+1:op.n_nodes+gas.extra_genes) = 0; 
    
    fitness = [0 0 0 0 0];
    sumLinks = 0;
    sumLinksOnSegment = 0;
    totLength = 0;
    
    n_targets = size(op.targets,1);
    n_nodes = size(chrom,2) - gas.extra_genes;
    
    
    if draw_plot==true
        configurations = decodeIndividual(chrom); 
        drawProblem2D(configurations);
    end
    
    for i=1:1:n_targets
        t = op.targets(i,:);
        
        thisConf_totLength = 0;

        configurations = decodeIndividual(chrom);
        conf = configurations(:,:,i);
        dist_normalization = norm(t(1:2)-op.home_base(1:2));    % might be useful if we add different objectives to the fitness that have different degree of representation
        
        % safety check, this should never happen
        if chrom(i,n_nodes+1) ~= 0
            error("A corrupted chromosome entered evaluation!\n");
        end
        
        %----CALCULATE MIN DISTANCE FROM ROBOT TO TARGET'S ORIENTATION SEGMENT AND LAST ANGLE
        robot_points = solveForwardKinematics2D(conf,op.home_base,false);
        [dist_mat, ee_index] = calculateMinDistance_FromOrientationSegment(robot_points,[op.targets(i,1:2);op.end_points(i,:)]);
        chrom(i,n_nodes+1) = ee_index;  % this is the index of the closest node to the target's orientation segment
        sumLinks = sumLinks + chrom(i,n_nodes+1)-1;
        
        % draw distances from robot to segment (for DEBUG and PAPER FIGURES)
        areas_vect = zeros(1,size(dist_mat,1));
        if draw_plot==true
            for j = 1:1:ee_index
                n_proj = dist_mat(j,2:3);
                plot([robot_points(j,1),n_proj(1)],[robot_points(j,2),n_proj(2)],'--o','Color','k'); 
            end 
        end
        
        %----CALCULATE AREAS
        for j = 1:1:ee_index
            p1 = robot_points(j,1:2);   % first vertex of the triangle: the node of the robot
            p2 = dist_mat(j,2:3);       % second vertex of the triangle: the projection of the node on the orientation line
            p3 = t(1:2);                % third vertex of the triangle: the target
            areas_vect(j) = calculateTriangleArea(p1,p2,p3);
        end 
        
        dist_vect = (dist_mat(1:ee_index,1))';
        areas_vect = areas_vect(1:ee_index);
%         if(ee_index == 1)
%             error("Home base is too close to target!");
%         end
        
        weights = ones(ee_index,1);      % if we want to consider all nodes equally important        
        %weights = (1:1:ee_index)';      % if we want to consider nodes with importance that linearly increases with their proximity to the segment
        weights(ee_index) = 3;           % consider the last node more important
        
        strategy = 1; % 1 single point, 2 dist, 3 area
        
        switch algorithm
            case 'ga'
                switch strategy
                    case 1
                        fit = dist_vect(ee_index);
                    case 2
                        if gas.normalize_weightDistance == true
                            fit = (dist_vect*weights)/sum(weights);
                        else
                            fit = (dist_vect*weights);
                        end
                    case 3
                        if gas.normalize_weightDistance == true
                            fit = (areas_vect*weights)/sum(weights);
                        else
                            fit = (areas_vect*weights);
                        end
                end
            case 'bbbc'
                switch strategy
                    case 1
                        fit = dist_vect(ee_index);
                    case 2
                        if bbbcs.normalize_weightDistance == true
                            fit = (dist_vect*weights)/sum(weights);
                        else
                            fit = (dist_vect*weights);
                        end
                    case 3
                        if bbbcs.normalize_weightDistance == true
                            fit = (areas_vect*weights)/sum(weights);
                        else
                            fit = (areas_vect*weights);
                        end
                end

        end
        
        fitness(1) = fitness(1) + fit;

        final_angle = calculateLastAngle(robot_points, ee_index, op.targets(i,1:2));
        chrom(i,n_nodes+2) = final_angle;   % thixs is the angle to align the robot to the target's orientation segment
        
        
        %----CUT ROBOT
        configurations = decodeIndividual(chrom); 
        conf = configurations(:,:,i);
%         drawProblem2D(configurations);
        robot_points = solveForwardKinematics2D(conf,op.home_base,false);
        for j=ee_index:1:n_nodes
            l = chrom(n_targets+1,j);
            dist2target = norm(robot_points(j,:)-t(1:2));
            if(dist2target<l)
                %cut here
                lastNode_index = j;
                chrom(i,n_nodes+3) = lastNode_index;
                chrom(i,n_nodes+4) = dist2target; %cut length
                sumLinksOnSegment = sumLinksOnSegment + chrom(i,n_nodes+3) - chrom(i,n_nodes+1) + 1;
                break;
            end
        end
        
        %----calculate robot total length
        for j=1:1:chrom(i,n_nodes+3)-1
            thisConf_totLength = thisConf_totLength + chrom(n_targets+1,j);
        end
        thisConf_totLength = thisConf_totLength + chrom(i,n_nodes+4);
        totLength = max(thisConf_totLength,totLength);
    end
    
    fitness(1) = fitness(1) / n_targets;  % normalize the fitness among number of targets/configurations
    fitness(2) = sumLinks; % / n_targets;
    fitness(3) = fix(calculateOndulation(chrom) * 100);    % already normalized
    fitness(4) = sumLinksOnSegment; %/ n_targets;   
    fitness(5) = totLength;
    
    if draw_plot==true
        configurations = decodeIndividual(chrom); 
        drawProblem2D(configurations);
    end
end

% Calculate which node is closer to the target's orientation segmet (uses Voronoi distance defined in "Stroppa, F., Loconsole, C., & Frisoli, A. (2018). Convex polygon fitting in robot-based neurorehabilitation. Applied Soft Computing, 68, 609-625")
% Return a [? x 3] matrix where each row is:
% - distance from the node (at relative index) to the target's orientation segment
% - x coordinate of the robot's node Voronoi projecton on the segment orientation)
% - y coordinate of the robot's node Voronoi projecton on the segment orientation)
% Also, return the index of the last node before the cut
function [dist_mat, ee_index] = calculateMinDistance_FromOrientationSegment(robot_points,target_segment)
     
    dist_mat = zeros(size(robot_points,1),3);
    min_dist = 0;
    min_rowIndex = 2;
    
    % start from 2 so do not consider the first node (the robot's container cannot move!)
    for j = 1 : 1 : size(robot_points,1)            
        %----voronoi rotation-------------------------------------------
        p_1 = target_segment(1,:);
        p_2 = target_segment(2,:);
        p_t = robot_points(j,:);
        p_21 = p_2-p_1;
        p_t1 = p_t-p_1;
        p_11 = [0 0];
        angle = -atan2(p_21(2),p_21(1));
        r = [cos(angle) -sin(angle); sin(angle) cos(angle)];
        p_22 = (r*p_21')';
        p_t2 = (r*p_t1')'; 
        
%         figure;
%         hold on;
%         axis equal;
%         xlabel('x');
%         ylabel('y'); 
%         plot(p_t2(1), p_t2(2),'-x','Color','b');  
%         plot([p_11(1),p_22(1)],[p_11(2),p_22(2)],'-o','Color','r');   

        if p_t2(1)<=0 
            % before segment
            d = norm(p_t2 - p_11);  
            ee_proj = p_1;
            
            if(p_t2(2) <0)
                d = -d;
            end
        elseif p_t2(1)<p_22(1)
            % within the sement
            %d = abs(p_t2(2));
            d = (p_t2(2));
            ee_proj = [p_t2(1) 0];
            r = [cos(-angle) -sin(-angle); sin(-angle) cos(-angle)];
            ee_proj = (r*ee_proj')'+p_1;
            %ee_proj = (r\ee_proj')'+p_1;  
        else
            % after segment
            d = norm(p_t2 - p_22);           
            ee_proj = p_2;       
            
            if(p_t2(2) <0)
                d = -d;
            end
        end
        dist_mat(j,1) = d;
        dist_mat(j,2) = ee_proj(1);
        dist_mat(j,3) = ee_proj(2);
        
        %---------------------------------------------------------------            
    end
    
    % get the sign of each distance (if negative the node is "under" the  segment, if positive the node is "over" - based on voronoi rotation)
    signs = sign(dist_mat(:,1));
    dist_mat(:,1) = abs(dist_mat(:,1)); % go back to having distances all positive (euclidean distances are positive!)
    
    [m,ee_index] = min(dist_mat(:,1));
    if ee_index == 1    
        ee_index = 2;   % in case the closest point turns out to be the robot base, go one further; this configuration is going to be probably infeasible due to the last angle anyways
    end
    dist_mat = dist_mat(1:ee_index,:);  % cut all nodes after the minimum (it means the robot will not stop grow in that direction from now on)
end

% Calculate the angle between the robot (at the current end effector) and the target's orientation segment
% Uses voronoi rotation to make the angle calculation simpler
function [final_angle] = calculateLastAngle(robot_points, ee_index, target)
    
    if ee_index==1   
        % THIS WILL NEVER BE TRUE, calculateMinDistance_FromOrientationSegment WILL PREVENT IT
        ee_orient = [1 0];
    else
        point1 = (robot_points(ee_index,:));
        point2 = (robot_points(ee_index-1,:));
        ee_orient = (point1-point2)/norm(point1-point2);    % unit vector between two points
    end
    
%     des_orient = (target-point1)/norm(target-point1);    % unit vector between two points
%     dummyPoint = 100*des_orient + point1;
%     plot([point1(1),dummyPoint(1)],[point1(2),dummyPoint(2)],'-o','Color','r');
%     
%     dummyPoint2 = 100*ee_orient + point1;
%     plot([point1(1),dummyPoint2(1)],[point1(2),dummyPoint2(2)],'-o','Color','r');
    
    %----voronoi rotation-------------------------------------------
    r1 = point1;
    r2 = 100*ee_orient + point1;
    t2 = target;

    t2 = t2-r1;
    r2 = r2-r1;
    r1 = [0 0];
    angle = -atan2(r2(2),r2(1));
    r = [cos(angle) -sin(angle); sin(angle) cos(angle)];
    r2 = (r*r2')';
    t2 = (r*t2')';        
    final_angle = fixAngle(rad2deg(atan2(t2(2),t2(1))));
    %---------------------------------------------------------------
end

% Calculate the area of a triangle given its three vertices
function [area] = calculateTriangleArea(p1,p2,p3)
    area = abs((p1(1)*p2(2)+p2(1)*p3(2)+p3(1)*p1(2)-p1(2)*p2(1)-p2(2)*p3(1)-p3(2)*p1(1))/2.0);
end

function [ond] = calculateOndulation(chrom)
    global op;  % optimization problem
    global gas;  % genetic algorithm settings
    
    n_targets = size(op.targets,1);
    n_nodes = size(chrom,2) - gas.extra_genes;
    
    changes = zeros(n_targets,1);       % count changes in direction
    
    % count changes in direction for each configuration
    for i = 1:1:n_targets 
        lastNode = chrom(i, n_nodes + 1);               % get last node
        angleSigns = chrom(i,1:lastNode);               % get angles until cut
        angleSigns(lastNode) = chrom(i,n_nodes + 2);    % replace last angle
        angleSigns = sign(angleSigns);                  % get signs of angles
        angleSigns = angleSigns(angleSigns~=0);         % remove any zeros from angles (love this matlab function)
        for j = 2:1:size(angleSigns,2)
            if angleSigns(j) ~= angleSigns(j-1)
                changes(i) = changes(i) + 1;
            end
        end
        changes(i) = changes(i) / lastNode;             % normalize on the number of nodes
    end
    ond = mean(changes);
end