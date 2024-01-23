function [] = drawWorkspace(nNodes)
    op.home_base = [0 0 0];

    op.n_nodes = 4;
    op.angle_domain = [-30, 30];

    conf = zeros(nNodes,2);
    for i=1:1:nNodes
        conf(i,2) = 5;
    end

    figure;
    hold on;
    axis equal;
    xlabel('x');
    ylabel('y'); 

    for i=2:1:nNodes
        dfs(conf,i,op,nNodes);
    end
end

function [] = dfs(conf,i,op, nNodes)
    if i==nNodes+1
        return
    end
    for j=op.angle_domain(1) : 30 : op.angle_domain(2)
        conf(i,1) = j;
        dfs(conf,i+1,op,nNodes)
        drawRobot(conf, op);
    end
end


function [] = drawRobot(conf, op)
    
    
    %draw home (as blue little square)
    plot(op.home_base(1),op.home_base(2),'--gs','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor','b');
    
    %draw robot configurations (as red segments)
    if isempty(conf) == false
        xy = solveForwardKinematics2D(conf,op.home_base,false); % solve forward kinematics to draw the robot configuration
        
        %plot(xy(size(xy,1),1),xy(size(xy,1),2),'o','Color','r');
        
        for j = 1 : 1 : size(xy,1)-1
            plot([xy(j,1),xy(j+1,1)],[xy(j,2),xy(j+1,2)],'-o','Color','r'); % print each node of the robot configuration
        end  
    end
    get(figure)
end