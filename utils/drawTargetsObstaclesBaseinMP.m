function drawTargetsObstaclesBaseinMP(app, skipIndex, reverseOrder)
    if nargin < 2
        skipIndex = -1;
    end
    if nargin < 3
        reverseOrder = [];
    end

    selectedNode = app.MPTree.SelectedNodes;
    % draw base
    ps = draw_base(app,selectedNode.NodeData.base(1), selectedNode.NodeData.base(2), selectedNode.NodeData.base(3),app.UIAxes2);
    data = struct("x",selectedNode.NodeData.base(1),"y",selectedNode.NodeData.base(2));
    ps.UserData =data;
    ps.ButtonDownFcn = @(src,event)mouseClickInMP(app,src, false);
    % [~] = draw_base(app,0, 0, 0,app.UIAxes2);
    % draw obstacles
    for i = 1:numel(selectedNode.NodeData.obstacles(:,1))
        draw_obstacle(app,selectedNode.NodeData.obstacles(i,1),selectedNode.NodeData.obstacles(i,2),selectedNode.NodeData.obstacles(i,3),app.UIAxes2);

    end

    numTargets = numel(selectedNode.NodeData.targets(:,1));

    % draw targets
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
            ps = draw_target(app, selectedNode.NodeData.targets(i,1), selectedNode.NodeData.targets(i,2), selectedNode.NodeData.targets(i,3), app.UIAxes2);
            data = struct("x", selectedNode.NodeData.targets(i,1), "y", selectedNode.NodeData.targets(i,2));
            ps.DataTipTemplate.DataTipRows(end) = selectedNode.NodeData.TargetNames(i);
            labelWithAngle(ps, selectedNode.NodeData.targets(i,3));
            ps.Children.PickableParts = 'none';
            ps.UserData = data;
            ps.ButtonDownFcn = @(src, event)mouseClickInMP(app, src, false);
        end

    else
        for i = 1:numTargets
            ps = draw_target(app, selectedNode.NodeData.targets(i,1), selectedNode.NodeData.targets(i,2), selectedNode.NodeData.targets(i,3), app.UIAxes2);
            data = struct("x", selectedNode.NodeData.targets(i,1), "y", selectedNode.NodeData.targets(i,2));
            ps.DataTipTemplate.DataTipRows(end) = selectedNode.NodeData.TargetNames(i);
            labelWithAngle(ps, selectedNode.NodeData.targets(i,3));
            ps.Children.PickableParts = 'none';
            ps.UserData = data;
            ps.ButtonDownFcn = @(src, event)mouseClickInMP(app, src, false);
        end
    end
    
end