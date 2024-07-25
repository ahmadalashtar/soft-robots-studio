% This function solves the forward kinematics of the soft robot given link lengths and angles
%
% This function solves the forward kinematics of a 2D manipulator given a set of angles and link lengths for each link
%
% INPUT:
% 'robot_config_AL' is a robot configuration represented as pairs of angles and linklengths
% 'draw_plot' is a boolean flag, true if you want to plot the segments from targets
%
% OUTPUT:
% 'robot_config_P' is a robot configuration represented as coordinates of each node in the plane
function [robot_config_P] = MP_solveForwardKinematics2D(robot_config_AL, home_base, draw_plot, rotation_angle)    

    n_nodes = size(robot_config_AL,1); % number of nodes (links of the robot - 1)
    
    %%%%%%%%%%editted home base
    unitVector_start = [cos(deg2rad(home_base(3))),sin(deg2rad(home_base(3)))];
    node = home_base(1:2);          % 'node' will be the current node, starts from the robot's base
    unitVector = unitVector_start;  % unit vector used to define the orientation of the current link
    
    robot_config_P = zeros(n_nodes+1,2);   % ouptut vector (initialized with zeros)
    robot_config_P(1,:) = node;            % first node of the robot (whihc is the robot's base)
    
    % draw plot
    if draw_plot==true
        figure;
        hold on;
        axis equal;
        xlabel('x');
        ylabel('y');
    end
    
    % solve forward kinematics for the single robot
    for j = 1:1:n_nodes
        % for each node of the robot
        alpha = deg2rad(robot_config_AL(j,1)); % first element of the array is an angle (in degrees)
        linkLength = robot_config_AL(j,2);     % second element of the array length (in metric units)
        
        % translation + rotation ('ee' would be the end effector of the robot, grows at each node)
        ee = node+unitVector*linkLength; % translation   
       
%         R = [cos(alpha), -sin(alpha); sin(alpha), cos(alpha)];
%         ee = (R*(ee-node)' + node')';
        
        ee = [(ee(1)-node(1))*cos(alpha) - (ee(2)-node(2))*sin(alpha) , (ee(1)-node(1))*sin(alpha) + (ee(2)-node(2))*cos(alpha)]+node;  % apply rotation      
 
        
        % recalculation of the unit vector
        mod = sqrt((ee(1)-node(1))^2 + (ee(2)-node(2))^2);        
        unitVector(1) = (ee(1) - node(1)) / mod;
        unitVector(2) = (ee(2) - node(2)) / mod;       

        %draw robot
        if draw_plot==true
            plot([node(1),ee(1)],[node(2),ee(2)],'-o','Color','r');
        end
        
        node = ee;              % current node is the end effector
        robot_config_P(j+1,:) = node;  % add node to set of nodes
    end
end