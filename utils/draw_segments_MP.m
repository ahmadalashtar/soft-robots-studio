function draw_segments_MP(app,axes,var)
    try
        points = retrieveOrientationSegmentEndPointsMP(false,var,app);
        loadOP(app.op, points);

        % one target => points = [ x ; y]
        % two targets => points = [x y ; x y x y]
        iter = size(var.NodeData.targets);
        for i = 1:iter(1)
            point = points(i,:);
            plot(axes,[point(1) var.NodeData.targets(i,1)],[point(2) var.NodeData.targets(i,2)], 'Color','blue','LineStyle','--')
            plot(axes, point(1),point(2),'ko','markerfacecolor','k')
        end


    catch ME
        % uialert(app.UIFigure,getReport(ME),'Error')
        uialert(app.UIFigure,ME.message,'Error')
    end
end