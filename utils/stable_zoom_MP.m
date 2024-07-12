function stable_zoom_MP(app)
    if numel(app.UIAxes2.Children) > 0
        cla(app.UIAxes2);
        selectedNode = app.MPTree.SelectedNodes;
        % draw base
        ps = draw_base(app,selectedNode.NodeData.base(1), selectedNode.NodeData.base(2), selectedNode.NodeData.base(3),app.UIAxes2);
        data = struct("x",selectedNode.NodeData.base(1),"y",selectedNode.NodeData.base(2));
        ps.UserData =data;
        ps.ButtonDownFcn = @(src,event)mouseClickInMP(app,src);
        % [~] = draw_base(app,0, 0, 0,app.UIAxes2);
        % draw obstacles
        for i = 1:numel(selectedNode.NodeData.obstacles(:,1))
            draw_obstacle(app,selectedNode.NodeData.obstacles(i,1),selectedNode.NodeData.obstacles(i,2),selectedNode.NodeData.obstacles(i,3),app.UIAxes2);
    
        end
        % draw targets
        for i = 1:numel(selectedNode.NodeData.targets(:,1))
            ps = draw_target(app,selectedNode.NodeData.targets(i,1),selectedNode.NodeData.targets(i,2),selectedNode.NodeData.targets(i,3),app.UIAxes2,app.scalerMP);
            data = struct("x",selectedNode.NodeData.targets(i,1),"y",selectedNode.NodeData.targets(i,2));
            ps.UserData =data;
            ps.ButtonDownFcn = @(src,event)mouseClickInMP(app,src);
        end
        draw_segments_MP(app,app.UIAxes2,app.MPTree.SelectedNodes)
    end
end