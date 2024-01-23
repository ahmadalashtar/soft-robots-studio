% Return a set of coordinates identifying the endpoints of the target's orientation segments 
%
% INPUT:
% 'draw_plot' is a boolean flag, true if you want to plot the segments from targets
%
% OUTPUT:
% 'end_points' is an array tx2 containing the coordinates [x,y] of the end points for each segment
function [end_points] = retrieveOrientationSegmentEndPoints(draw_plot)
    
    global op;  % optimization problem
    op.end_points = [];
    
    if draw_plot
        drawProblem2D([]); % draw the problem with no robot in it
    end
    
    end_points = zeros(size(op.targets,1),2);

    % get a segment for each target
    for i=1:1:size(op.targets,1)
         angle =fixAngle(180 + op.targets(i,3));

        u = [cos(deg2rad(angle)),sin(deg2rad(angle))];  % unit vector for segment direction
        
        % calculate length of segment (max cap is set by the maximum size of the overall robot)
        segmentLength = calculateSegmentLength(op.targets(i,:),op.home_base,op.n_nodes*op.length_domain(2));
        
        p = op.targets(i,1:2) + u*segmentLength;
        
        % if an obstacle is in the way, cut the segment
        dO = []; 
        for j=1:1:size(op.obstacles,1)            
            [pointsOnObstacles , inter] = intersectionSegmentCircle_2D([op.targets(i,1:2) ; p], op.obstacles(j,:), false);
            if inter==true
                dO = [dO; norm(pointsOnObstacles-op.targets(i,1:2)),pointsOnObstacles];
            end            
        end
        
        if size(dO,1) > 0            
            [m,ind] = min(dO(:,1));
            p = dO(ind,2:3);
        end
        if draw_plot
            plot([p(1),op.targets(i,1)],[p(2),op.targets(i,2)],'--o','Color','b');
        end
        end_points(i,:) = p;
        
    end
end

% This function returns the length of a target's orientation segment, 
% which calculated by intersecting the target's orientation straight line
% with an orthogonal line from the robot's base. 
%
% INPUT:
% 'target' is a [tx3] containing the pose of the target: [x , y , angle in deg (positive counterclockwise from x-axis)]
% 'home_base' is a [1x3] containing the pose of the robot's base: [x , y , angle in deg (positive counterclockwise from x-axis)]
% 'max_length' is the maximum length the segment is allowed to be
%
% OUTPUT:
% 'length' is the calculated length of the segment
function [length] = calculateSegmentLength(target, home_base, max_length)
    
    t = target(1:2);    % x,y of the target
    h = home_base(1:2); % x,y of the robot's base
    
    angle = fixAngle(180 + target(3));  % target angle
       
    % translation and rotation of the target's orientation line to be coinciding with the vertical axes of the reference frame
    % the distance base-line will simply be the y coordinate of the transformed robot's base, and the x coordinate will be the length of the segment
    h=h-t;  % translation of the robot's based having the target as origin of the frame
    angle = deg2rad(-angle);    % rotation angle in radiants
    rot = [cos(angle) -sin(angle); sin(angle) cos(angle)];  % rotation matrix 
    h = (rot*h')'; % rotation of the robot's base
    
    h(1) = round(h(1),3); 
        
    if h(1)>0.0
        length = h(1);  % set the lenght
    else
        length = max_length;    % if the length is negative, use max cap
    end
end