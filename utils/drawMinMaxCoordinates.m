function  [x1,y1,x2,y2, x3,y3,x4,y4 ] = drawMinMaxCoordinates(app)
                
    yLimUp = app.UIAxes1.YLim(end);
    yLimDown = app.UIAxes1.YLim(1);
    yLength = yLimUp - yLimDown;

    xLimRight = app.UIAxes1.XLim(end);
    xLimLeft = app.UIAxes1.XLim(1);
    xLength = xLimRight - xLimLeft;

    yTenPercent = yLength/10;
    xTenPercent = xLength/10;
    
    
    min = app.MinlengthEditField.Value;
    max = app.MaxlengthEditField.Value;

    % Define the coordinates of the line
    x1 = [xLimLeft+xTenPercent/2, xLimLeft+xTenPercent/2+max];
    y1 = [yLimUp-yTenPercent/2, yLimUp-yTenPercent/2];
    x2 = [xLimLeft+xTenPercent/2, xLimLeft+xTenPercent/2+min];
    y2 = [yLimUp-7*yTenPercent/10, yLimUp-7*yTenPercent/10];
    x3 = [xLimLeft, xLimLeft+xTenPercent/2];
    y3=[yLimUp-yTenPercent/2, yLimUp-yTenPercent/2];
    x4=[xLimLeft, xLimLeft+xTenPercent/2];
    y4=[yLimUp-7*yTenPercent/10, yLimUp-7*yTenPercent/10];
end
