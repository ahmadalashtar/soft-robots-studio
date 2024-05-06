function result = insideAxes(app)
    currentPoint = app.UIAxes.CurrentPoint;
    x = currentPoint(1,1);
    y = currentPoint(1,2);
    
    % Get the current axis limits
    currentXLimits = app.UIAxes.XLim;
    currentYLimits = app.UIAxes.YLim;
    
    % Check if cursor coordinates are inside the axes limits
    result = x >= currentXLimits(1) && x <= currentXLimits(2) && ...
                  y >= currentYLimits(1) && y <= currentYLimits(2);
    
   
end