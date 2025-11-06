% getLengthWithMaterialLoss - Returns the length of the link after
% steering, including material loss
%
% Parameters:
%   angle_x         - rotation angle around x-axis in degrees
%   angle_y         - rotation angle around y-axis in degrees
%   link_length     - full length of the link
%   radius          - radius of the robot body
%
% Returns:
%   length          - length after material loss
function length = getLengthWithMaterialLoss(angle_x, angle_y, link_length, radius)
    length = getBendLength(abs(angle_y), getBendLength(abs(angle_x), link_length, radius, false), radius, false);

end

% getBendLength - Rotates a rectangle clockwise and computes the distance
% between the original bottom-left vertex and the rotated bottom-right vertex.
%
% Parameters:
%   angle - rotation angle in degrees (clockwise)
%   w     - width of rectangle
%   h     - height of rectangle
%   draw  - boolean flag, draws a plot when true (for deubg)
%
% Returns:
%   bendLength - Euclidean distance between the original bottom-left and
%                rotated bottom-right vertex
function bendLength = getBendLength(angle, w, h, draw)
    % Original rectangle vertices (top-left origin)
    origVerts = [...
        0,  0;    % Top-left
        w,  0;    % Top-right
        w, -h;    % Bottom-right
        0, -h;    % Bottom-left
        0,  0];   % Close shape

    % Convert angle to radians and create clockwise rotation matrix
    theta = deg2rad(angle);
    R = [cos(theta)  sin(theta);
        -sin(theta)  cos(theta)];  % Clockwise rotation

    % Apply rotation
    rotVerts = (R * origVerts')';

    % Compute bend length: from original bottom-left to rotated bottom-right
    origBL = [0, -h];
    rotBR  = rotVerts(3, :); % Third vertex after rotation
    bendLength = sqrt((rotBR(1) - origBL(1))^2 + (rotBR(2) - origBL(2))^2);

    % Plot
    if draw == true
        figure;
        hold on; axis equal; grid on;
        plot(origVerts(:,1), origVerts(:,2), 'r-', 'LineWidth', 2);
        plot(rotVerts(:,1), rotVerts(:,2), 'b-', 'LineWidth', 2);
        plot(origBL(1), origBL(2), 'ro', 'MarkerFaceColor', 'r');
        plot(rotBR(1), rotBR(2), 'bo', 'MarkerFaceColor', 'b');
    
        % Add dotted line between the two vertices
        plot([origBL(1) rotBR(1)], [origBL(2) rotBR(2)], 'k--', 'LineWidth', 1.5);
    
        legend('Original rectangle', 'Rotated rectangle', ...
               'Original bottom-left', 'Rotated bottom-right', ...
               'Distance', 'Location', 'best');
        xlabel('X'); ylabel('Y');
        title(sprintf('Rotation by %.1f° (Clockwise)', angle));
        hold off;
    end
end
