function drawMinMax(app)
    % try to remove previous minMax
    try
        removePreviousMinMax(app);
    catch

    end

    %  Get the coordinates of the points for drawing lines
    [x1,y1,x2,y2,x3,y3,x4,y4 ] = drawMinMaxCoordinates(app);
    darkOrange = "#bf6c00";
    % Plot the line
    
    app.minMax(1) = plot(app.UIAxes1,x1, y1, '-o',"UserData","Min Max", color=darkOrange); % Use '-o' to connect the points with a line and add markers
    app.minMax(2) = plot(app.UIAxes1,x2, y2, '-o',"UserData","Min Max", color=darkOrange); % Use '-o' to connect the points with a line and add markers
    app.minMax(3) = text(app.UIAxes1,mean(x3), mean(y3), 'Max', 'HorizontalAlignment', 'center', "UserData","Min Max");
    app.minMax(4) = text(app.UIAxes1,mean(x4), mean(y4), 'Min', 'HorizontalAlignment', 'center', "UserData","Min Max");

    
end