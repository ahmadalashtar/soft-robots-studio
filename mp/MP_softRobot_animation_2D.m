% This function creates an animation for the soft robot motion planner, given the motion commands to be executed (which are retreived with A*)
%
% INPUT:
% 'commands' nx3xs contains an array of configurations of a soft robot in polar coordinates, for each of the 'n' joint: rotation on x, rotation on y, length of the link, for a total of 's' configurations
% 'home_base' 1x3 contains the coordinates x,y,z of the container. robot will grow in z direction
%
% DISCLAIMER:
% It must me updated to draw obstacles when we will add any in the future
function [] = MP_softRobot_animation_2D(commands, home_base, drawPath, sp)

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
    
    f = figure;
    n_obstacles = size(sp.obstacles,1);

    
    for k=1:1:steps
        clf;
        hold on;
        axis equal;
        grid on;
        xlabel('x');
        ylabel('y');
%         zlabel('z');
        xlim([-600 600]);
        ylim([-400 400]);
%         zlim([-100 1000]);
        plot(home_base(1),home_base(2),'--gs','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor','b'); %draw home
        startConf = MP_solveForwardKinematics2D(commands(:,:,1),home_base,false);
        endConf = MP_solveForwardKinematics2D(commands(: , : , end),home_base,false);
        robot_CC = MP_solveForwardKinematics2D(commands(:,:,k),home_base,false); %solve the forward kinematics for a given robot configuration
        
        % collect the end effector coordinates for each step of motion to draw the path of the robot 
        end_effectors(k,:) = robot_CC(n_joints+1,:); 
        
        %draw the start configuration
        grayRobotColor = '#569c69';
        for i=2:1:n_joints+1
            plot([startConf(i-1,1),startConf(i,1)],[startConf(i-1,2),startConf(i,2)],'-o','Color',grayRobotColor, 'LineWidth', 1.5);
        end

        %draw the end configuration
%         endConf = commands(: , : , end);
        for i=2:1:n_joints+1
            plot([endConf(i-1,1),endConf(i,1)],[endConf(i-1,2),endConf(i,2)],'-o','Color','b', 'LineWidth', 1.5);
        end
        % draws the soft robot
        for i=2:1:n_joints+1
            plot([robot_CC(i-1,1),robot_CC(i,1)],[robot_CC(i-1,2),robot_CC(i,2)],'-o','Color','r', 'LineWidth', 1.5);
        end
        
        % draws the path from the end effector array
        if drawPath == true
            hexCode = '#FFA500';
            for j=1:3:k
%                 if j == 1
%                     plot3(end_effectors(j,1),end_effectors(j,2),end_effectors(j,3),'.','Color','r','MarkerSize', 20);
%                 else
                    plot(end_effectors(j,1),end_effectors(j,2),'.','Color','b');
%                 end
            end
        end

%         for i=1:1:n_obstacles
%             [X,Y,Z] = cylinder(sp.obstacles(i,4));
%             X = X + sp.obstacles(i,1);
%             Y = Y + sp.obstacles(i,2);
%             Z = Z*-sp.obstacles(i,5) + sp.obstacles(i,3);
%             plot3(X,Y,Z,'Color','k');
%             th = 0:pi/50:2*pi;
%             xunit = sp.obstacles(i,4) * cos(th) + sp.obstacles(i,1);
%             yunit = sp.obstacles(i,4) * sin(th) + sp.obstacles(i,2);
%             zunit = 0*th + sp.obstacles(i,3);
%             plot3(xunit, yunit, zunit,'Color','k');
%             plot3(xunit, yunit, (zunit-sp.obstacles(i,5)),'Color','k');
%         end
        for i = 1:1:n_obstacles
            theta = linspace(0, 2*pi,100);
                X = sp.obstacles(i, 3) * cos(theta) + sp.obstacles(i, 1);
                Y = sp.obstacles(i, 3) * sin(theta) + sp.obstacles(i, 2);
                plot(X, Y, 'k');
%             [X, Y] = rectangle('Position',[sp.obstacles(i, 1) - sp.obstacles(i, 3), sp.obstacles(i, 2) -sp.obstacles(i, 3) , 2 * sp.obstacles(i, 3), 2 * sp.obstacles(i, 3)], 'Curvature', [1 ,1], 'EdgeColor', 'k');%cylinder(sp.obstacles(i, 4), 10);
%             X = X + sp.obstacles(i, 1);
%             Y = Y + sp.obstacles(i, 2);
% %             Z = Z * -sp.obstacles(i, 5) + sp.obstacles(i, 3);
% 
%             surf(X, Y, 'FaceColor', 'w', 'EdgeColor', 'none');
%             grayColor = '#778079';
%             plot3(X,Y,Z,'Color',grayColor);
%             th = 0:pi / 50:2 * pi;
%             xunit = sp.obstacles(i, 3) * cos(th) + sp.obstacles(i, 1);
%             yunit = sp.obstacles(i, 3) * sin(th) + sp.obstacles(i, 2);
% %             zunit = 0 * th + sp.obstacles(i, 3);
% 
%             plot(xunit, yunit,'Color',grayColor);
%             plot(xunit, yunit,'Color',grayColor);
        end


        f.CurrentAxes.ZDir = 'Reverse';
        cameratoolbar('SetCoordSys','x');
        view(0,90);

%          filepath = "C:\Users\OMEN\C_C++_MATLAB_Projects\VScode__\Files\Figures\" + sp.problemName;
% % %         fullFilePath = fullfile(filepath, [num2str(k), '.fig']);
% % %         savefig(gcf, fullFilePath)
%          fullFilePathPng = fullfile(filepath, [num2str(k), '.png']);
%          saveas(gcf, fullFilePathPng);
        pause(0); %change this to make the animation faster/slower
    end
    
end

