function [end_points] = retrieveOrientationSegmentEndPointsMP(draw_plot,var,app)
    
    global op;  % optimization problem
    op.end_points = [];
    var.NodeData.targets
    if draw_plot
        drawProblem2D([]); % draw the problem with no robot in it
    end

    end_points = zeros(size(var.NodeData.targets(1),1),2);

    for i=1:1:size(var.NodeData.targets,1)
         angle =fixAngle(180 + var.NodeData.targets(i,3));

        u = [cos(deg2rad(angle)),sin(deg2rad(angle))];

        segmentLength = calculateSegmentLengthMP(var.NodeData.targets(i,:),app.MPTree.SelectedNodes.NodeData.base,op.n_nodes*op.length_domain(2));
        
        p = var.NodeData.targets(i,1:2) + u*segmentLength;

        dO = []; 
        for j=1:1:size(app.MPTree.SelectedNodes.NodeData.obstacles)            
            [pointsOnObstacles , inter] = intersectionSegmentCircle_2D([var.NodeData.targets(i,1:2) ; p], app.MPTree.SelectedNodes.NodeData.obstacles(j,:), false);
            if inter==true
                dO = [dO; norm(pointsOnObstacles-var.NodeData.targets(i,1:2)),pointsOnObstacles];
            end            
        end
        
        if size(dO,1) > 0            
            [m,ind] = min(dO(:,1));
            p = dO(ind,2:3);
        end
        if draw_plot
            plot([p(1),var.NodeData.targets(i,1)],[p(2),var.NodeData.targets(i,2)],'--o','Color','b');
        end
        end_points(i,:) = p;
        
    end
end

function [length] = calculateSegmentLengthMP(target, home_base, max_length)
    
    t = target(1:2);    % x,y of the target
    h = home_base(1:2); % x,y of the robot's base
    
    angle = fixAngle(180 + target(3));  % target angle
       
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