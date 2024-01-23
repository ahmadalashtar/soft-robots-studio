% Draw the problem and the configurations of the robot (solution)
%
% INPUT:
% 'robot_configs' is [nodes x 2 x targets], an array of robot configurations
%                 one configuration for target
%                 each configuration is composed of a matrix [nodes x 2] containing pairs angle - link length for each node
% 'op' is the object describing the optimization problem 
function [] = MP_drawProblem2D(robot_configs)
    global op;  % optimization problem
    
    figure;
    hold on;
    axis equal;
    xlabel('x');
    ylabel('y'); 
        
    n_targets = size(op.targets,1); 
    
    %draw obstacles (as black circles)
    n_obstacles = size(op.obstacles,1);
    for i=1:1:n_obstacles
        th = 0:pi/50:2*pi;
        xunit = op.obstacles(i,3) * cos(th) + op.obstacles(i,1);
        yunit = op.obstacles(i,3) * sin(th) + op.obstacles(i,2);
        plot(xunit, yunit,'Color','k');
    end
    
    %draw home (as blue little square)
    plot(op.home_base(1),op.home_base(2),'--gs','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor','b');
    
    %draw robot configurations (as red segments)
    if isempty(robot_configs) == false
        for i=1:1:n_targets
            conf = robot_configs(:,:,i);
            xy = MP_solveForwardKinematics2D(conf,op.home_base,false); % solve forward kinematics to draw the robot configuration
            for j = 1 : 1 : size(xy,1)-1
                plot([xy(j,1),xy(j+1,1)],[xy(j,2),xy(j+1,2)],'-o','Color','r'); % print each node of the robot configuration
            end  
            text(xy(size(xy,1),1)+5, xy(size(xy,1),2)+5,num2str(i))
        end
    end
    
    %draw targets (as blue diamonds)
    for i=1:1:n_targets
        plot(op.targets(i,1), op.targets(i,2),'-x','Color','b','LineWidth',8);    
        text(op.targets(i,1)+5, op.targets(i,2)+5,num2str(i))
        if size(op.end_points,1) ~= 0 
            plot([op.end_points(i,1),op.targets(i,1)],[op.end_points(i,2),op.targets(i,2)],'--o','Color','b');
            
        end
    end
    
    %draw min max
    %Proximity scan for optimal y-axis
    y_obstacleMax = 0;
    if n_obstacles > 0
        y_obstacleMax=max(op.obstacles(:,2))+max(op.obstacles(:,3));
    end
    y_targetMax= max(op.targets(:,2));
    y_outsideBounds=max(y_obstacleMax,y_targetMax);
    y_axis= y_outsideBounds+10;
    x_axis= 5;
    text(x_axis, y_axis+15, "Max:");
    plot([x_axis,op.length_domain(2)+x_axis],[y_axis+10,y_axis+10],'-o','Color','r');
    text(x_axis, y_axis+5, "Min:");
    plot([x_axis,op.length_domain(1)+x_axis],[y_axis,y_axis],'-o','Color','r');
    plot([x_axis,op.length_domain(1)+x_axis],[y_axis+20,y_axis+20],'-o','Color','w');
    
end