function draw_segments(app,axes)
    try
        points = retrieveOrientationSegmentEndPoints(false);
        loadOP(app.op, points);

        % one target => points = [ x ; y]
        % two targets => points = [x y ; x y x y]
        if length(app.TargetsNode.Children)==1

            child = app.TargetsNode.Children(1);
            plot(axes,[points(1) child.NodeData.x],[points(2) child.NodeData.y], 'Color','blue','LineStyle','--')
            plot(axes, points(1),points(2),'ko','markerfacecolor','k')

        else
            for i = 1:length(points)
                point = points(i,:);
                child = app.TargetsNode.Children(i);
                plot(axes,[point(1) child.NodeData.x],[point(2) child.NodeData.y], 'Color','blue','LineStyle','--')
                plot(axes, point(1),point(2),'ko','markerfacecolor','k')
            end
        end

    catch ME
        % uialert(app.UIFigure,getReport(ME),'Error')
        uialert(app.UIFigure,ME.message,'Error')
    end
end