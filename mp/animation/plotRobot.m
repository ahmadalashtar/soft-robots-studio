function plotHandle = plotRobot(plotHandle, robotCartasian, color, f)
    arguments
        plotHandle
        robotCartasian
        color
        f = figure(1);
    end

    if isempty(plotHandle)
        plotHandle = plot(f, robotCartasian(:, 1), robotCartasian(:, 2), '-o', "Color", color, "LineWidth", 1.5);
        return;
    end

    plotHandle.set("XData", robotCartasian(:, 1), "YData", robotCartasian(:, 2), "Color", color);
end

