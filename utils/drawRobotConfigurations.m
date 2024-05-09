function drawRobotConfigurations(app,configs)
    % from main script drawProblem2D
    n_targets = size(app.op.targets,1);
    if isempty(configs) == false
        for i=1:1:n_targets
            conf = configs(:,:,i);
            xy = solveForwardKinematics2D(conf,app.op.home_base,false); % solve forward kinematics to draw the robot configuration
            for j = 1 : 1 : size(xy,1)-1
                plot(app.UIAxes1,[xy(j,1),xy(j+1,1)],[xy(j,2),xy(j+1,2)],'-o','Color','r'); % print each node of the robot configuration
            end  
        end
    end

end