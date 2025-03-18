function draw_segments_MP(app,axes,var, skipIndex, reverseOrder)
    if nargin < 4
        skipIndex = -1;
    end
    if nargin < 5
        reverseOrder = [];
    end
    try
        points = retrieveOrientationSegmentEndPointsMP(false,var,app);
        loadOP(app.op, points);

        % one target => points = [ x ; y]
        % two targets => points = [x y ; x y x y]
        iter = size(var.NodeData.targets);
        numTargets = iter(1);

        if ~isempty(reverseOrder)
            if reverseOrder
                startIdx = 1;
                endIdx = skipIndex;
            else
                startIdx = skipIndex + 1;
                endIdx = numTargets;
            end

            for i = startIdx:endIdx
                if reverseOrder && i == skipIndex
                    continue;
                end
                point = points(i, :);
                plot(axes, [point(1) var.NodeData.targets(i, 1)], [point(2) var.NodeData.targets(i, 2)], 'Color', 'blue', 'LineStyle', '--');
                plot(axes, point(1), point(2), 'ko', 'markerfacecolor', 'k');
            end
        else
            for i = 1:numTargets
                point = points(i, :);
                plot(axes, [point(1) var.NodeData.targets(i, 1)], [point(2) var.NodeData.targets(i, 2)], 'Color', 'blue', 'LineStyle', '--');
                plot(axes, point(1), point(2), 'ko', 'markerfacecolor', 'k');
            end
        end


    catch ME
        % uialert(app.UIFigure,getReport(ME),'Error')
        uialert(app.UIFigure,ME.message,'Error')
    end
end