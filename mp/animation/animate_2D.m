function [] = animate_2D(sp, path, dim, pace, f)
    arguments
        sp
        path
        dim = [200, 200]
        pace = 0.01
        f = figure(1);
    end

    clf;
    hold on;
    axis equal;
    grid on;
    xlabel('x');
    ylabel('y');
    zlabel('z');
    xlim([-dim(1), dim(1)]);
    ylim([-dim(2), dim(2)]);

    % Draw obstacles.
    obstacleColor = 'k';
    for i = 1:size(sp.obstacles, 1)
        obstacle = sp.obstacles(i, :);
        fplot(f, @(t) obstacle(3) * cos(t) + obstacle(1), @(t) obstacle(3) * sin(t) + obstacle(2), "Color", obstacleColor);
    end

    % Draw the home base.
    baseColor = 'k';
    plotRectangleCentered(sp.home_base(1), sp.home_base(2), 5, baseColor, f);

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
    for i = 1:size(path, 2)
        robotCartasian = MP_solveForwardKinematics2D(path{i}, sp.home_base, false);
        plotRobot(robotHandle, robotCartasian, robotColor, f);
        plot(f, robotCartasian(end, 1), robotCartasian(end, 2), '.', "Color", traceColor);
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