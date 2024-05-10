function dragDropInMotion(app,~)

    currentPoint = app.UIAxes.CurrentPoint;
    delta = currentPoint - app.dragDropStart;

    % Update the axes limits based on the mouse movement
    xlim(app.UIAxes, xlim(app.UIAxes) - delta(1));
    ylim(app.UIAxes, ylim(app.UIAxes) - delta(3));
    
    % draw min max
    drawMinMax(app);
    
end