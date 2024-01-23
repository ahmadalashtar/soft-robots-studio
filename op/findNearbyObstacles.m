% Identify the obstacles close to a node of the robot, and return an array of their indices with respect to the matrix op.obstacles
%
% INPUT:
% 'node' is a [1x2] containing the coordinates x-y of the node in the space
% 'link_length' is the maximum size of the next link (robot can evert up to this length), used as radius to detect the obstacles close to the node
% 'min_length' is the lower bound of the link lengths
% 'obstacles' is a [ox3] containing information for each obstacle (x, y, and radius), it is a copy of op.obstacles
%
% OUTPUT:
% 'nearby_obstacle_indices' is a [1xo] containing the indices with respect to the matrix op.obstacles
function [nearby_obstacle_indices] = findNearbyObstacles(node, link_length, min_length, obstacles)
    n_obstacles = size(obstacles,1);
    nearby_obstacle_indices = zeros(1,n_obstacles);
    n_nearby_obstacles = 0;
    for i=1:1:n_obstacles
        d = norm(node-obstacles(i,1:2)) - (obstacles(i,3) + min_length);        % ok so with this formula, 'd' is supposed to be the distance between the minimum length of the link (lower bound) 
                                                                                % and the circumference of the obstacle. 
                                                                                
                                                                                
        
        %d = norm(node-obstacles(i,1:2)) - (obstacles(i,3));    % so this would have been just the distance between the node and the circumference
        
        if d<link_length
            % if the maximum link length is bigger than the distance node-obstacle, then the obstacle is considered to be close
            n_nearby_obstacles = n_nearby_obstacles + 1;
            nearby_obstacle_indices(n_nearby_obstacles) = i;
        end
    end
    nearby_obstacle_indices(n_nearby_obstacles+1:end) = []; % remove unused elements of the result matrix (mmm maybe this is computationally inefficient..?)
end