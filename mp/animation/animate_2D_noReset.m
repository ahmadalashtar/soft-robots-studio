function [] = animate_2D_noReset(app, sp, path, dim, pace, f, skipIndex, reverseOrder)
    arguments
        app
        sp
        path
        dim = [200, 200]
        pace = 0.01
        f = figure(1);
        skipIndex = -1;
        reverseOrder = [];
    end

    % Draw first and last configuration.
    startColor = 'r';
    endColor = 'g';
    startCartasian = MP_solveForwardKinematics2D(path{1}, sp.home_base, false);
    endCartasian = MP_solveForwardKinematics2D(path{end}, sp.home_base, false);
    plotRobot([], startCartasian, startColor, f);
    plotRobot([], endCartasian, endColor, f);

    % Draw robot in each step.
    robotColor = 'b';
    traceColor = 'b';
    robotHandle = plotRobot([], [0, 0], robotColor, f);
    targetHandle = [];
    direction = [1,0];
    subtraction = [1,0];
    for i = 1:size(path, 2)
        robotCartasian = MP_solveForwardKinematics2D(path{i}, sp.home_base, false);
        plotRobot(robotHandle, robotCartasian, robotColor, f);
        plot(f, robotCartasian(end, 1), robotCartasian(end, 2), '.', "Color", traceColor);

        low = 1;
        high = size(robotCartasian, 1);
        last_valid_idx = 0;
    
        while low <= high
            mid = floor((low + high) / 2);
            if any(isnan(robotCartasian(mid, :)))
                high = mid - 1;
            else
                last_valid_idx = mid;
                low = mid + 1;
            end
        end
        
        if skipIndex > -1 && ~isempty(last_valid_idx)

            rad = app.MPTree.SelectedNodes.NodeData.targets(skipIndex,4);
            if last_valid_idx > 2
                subtraction = robotCartasian(last_valid_idx, :) - robotCartasian(last_valid_idx - 2, :);
            end
            if all(subtraction == 0)

            else
                direction = subtraction / norm(subtraction);
            end

            end_effector_x = robotCartasian(last_valid_idx, 1) + rad * direction(1);
            end_effector_y = robotCartasian(last_valid_idx, 2) + rad * direction(2);
            if ~isempty(targetHandle)
                delete(targetHandle);
            end
            targetHandle = draw_target(app, end_effector_x, end_effector_y, 0, f);
            
            if isfield(app.MPTree.SelectedNodes.NodeData, 'collCirc') && ishandle(app.MPTree.SelectedNodes.NodeData.collCirc)
                delete(app.MPTree.SelectedNodes.NodeData.collCirc);  % Remove previous radius
            end
            collCirc = rectangle('Parent', f, 'Position', [end_effector_x - rad, end_effector_y - rad, 2 * rad, 2 * rad], ...
                         'Curvature', [1, 1], ...
                         'EdgeColor', '#98a0ed', ...
                         'LineWidth', 1, 'Tag', "collCirc");

            app.MPTree.SelectedNodes.NodeData.collCirc = collCirc;
        end

        pause(pace);
    end
end

function plotRectangleCentered(x, y, width, color, f)
    arguments
        x
        y
        width
        color
        f = figure(1);
    end

    radius = width / 2;
    x = [x - radius, x + radius, x + radius, x - radius, x - radius];
    y = [y + radius, y + radius, y - radius, y - radius, y + radius];

    plot(f, x, y, "Color", color);
end