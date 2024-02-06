% This function creates an animation for the soft robot motion planner, given the motion commands to be executed (which are retreived with A*)
%
% INPUT:
% 'commands' nx3xs contains an array of configurations of a soft robot in polar coordinates, for each of the 'n' joint: rotation on x, rotation on y, length of the link, for a total of 's' configurations
% 'home_base' 1x3 contains the coordinates x,y,z of the container. robot will grow in z direction
%
% DISCLAIMER:
% It must me updated to draw obstacles when we will add any in the future
function MP_softRobot_animation_2D(commands, home_base, drawPath, obstacles, axes,secondsToPause)
    % --- Example of commands, remove this piece of code for real usage ----
%     commands = zeros(3,3,10);
%     for i=1:1:10
%         commands(:,:,i) = [ 
%                             0 0 200;
%                             0 0 350;
%                             0 0 200;
%                             ];
%     end
%     for i=2:1:10
%         commands(2,1,i) = (i-1)*2;
%         commands(3,1,i) = (i-1)*3;
%     end
    % ---------------------------------------------------
    
    steps = size(commands,3);       % number of steps of motion
    n_joints = size(commands,1);    % number of joints of the robot
    
    end_effectors = zeros(steps,2); % end effector array that will contain the coordinates of the end effector for each step of motion
    
    n_obstacles = size(obstacles,1);

    disp(drawPath)
    for k=1:1:steps
        pause(secondsToPause)
        cla(axes)
        hold(axes,"on");
        axis(axes,"equal")
        xlabel(axes,'x');
        ylabel(axes,'y');
        % xlim(axes,[-600 600]);
        % ylim(axes,[-400 400]);
        plot(axes,home_base(1),home_base(2),'--gs','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor','b'); %draw home
        startConf = MP_solveForwardKinematics2D(commands(:,:,1),home_base,false);
        endConf = MP_solveForwardKinematics2D(commands(: , : , end),home_base,false);
        robot_CC = MP_solveForwardKinematics2D(commands(:,:,k),home_base,false); %solve the forward kinematics for a given robot configuration
        
        % collect the end effector coordinates for each step of motion to draw the path of the robot 
        end_effectors(k,:) = robot_CC(n_joints+1,:); 
        
        %draw the start configuration
        grayRobotColor = '#569c69';
        for i=2:1:n_joints+1
            plot(axes,[startConf(i-1,1),startConf(i,1)],[startConf(i-1,2),startConf(i,2)],'-o','Color',grayRobotColor, 'LineWidth', 1.5);
        end

        for i=2:1:n_joints+1
            plot(axes,[endConf(i-1,1),endConf(i,1)],[endConf(i-1,2),endConf(i,2)],'-o','Color','b', 'LineWidth', 1.5);
        end
        % draws the soft robot
        for i=2:1:n_joints+1
            plot(axes,[robot_CC(i-1,1),robot_CC(i,1)],[robot_CC(i-1,2),robot_CC(i,2)],'-o','Color','r', 'LineWidth', 1.5);
        end
        
        % draws the path from the end effector array
        if drawPath == true
            for j=1:3:k
                    plot(axes,end_effectors(j,1),end_effectors(j,2),'.','Color','b');
            end
        end


        for i = 1:1:n_obstacles
            theta = linspace(0, 2*pi,100);
                X = obstacles(i, 3) * cos(theta) + obstacles(i, 1);
                Y = obstacles(i, 3) * sin(theta) + obstacles(i, 2);
                plot(axes,X, Y, 'k');

        end


        


        pause(0); %change this to make the animation faster/slower
    end
    
end

