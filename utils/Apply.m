function Apply(app)
    selectedNode = app.Tree.SelectedNodes;
    child = selectedNode.NodeData.child;
    delete(child);
    x = app.XcoordinateEditField.Value;
    y = app.YcoordinateEditField.Value;
    selectedNode.NodeData.x=x;
    selectedNode.NodeData.y=y;
    if selectedNode.Parent == app.TargetsNode
        % L = app.LengthEditField.Value;
        angle = app.AngledegEditField.Value ;
        scaleHold = app.scaler;
        selectedNode.NodeData.length = 2;
        selectedNode.NodeData.angle = angle;
        selectedNode.NodeData.currentScale = scaleHold;
        selectedNode.Text = "x: " + string(round(x,2)) + ", y: " + string(round(y,2)) + ", angle: " + string(round(angle,2))  + ", current scale: " + string(round(scaleHold,2));
        ps = draw_target(app,x,y,angle,app.UIAxes1, scaleHold);
        
    elseif selectedNode.Parent == app.ObstaclesNode
        radius = app.LengthEditField.Value;
        selectedNode.NodeData.radius = radius;
        selectedNode.Text = "x: " + string(round(x,2)) + ", y: " + string(round(y,2)) + ", radius: " + string(round(radius,2));
        ps = draw_obstacle(app,x,y,radius,app.UIAxes1);
    elseif selectedNode.Parent == app.BaseNode
        angle = app.AngledegEditField.Value ;
        selectedNode.NodeData.length = 1;
        selectedNode.NodeData.angle = angle;
        selectedNode.Text = "x: " + string(round(x,2)) + ", y: " + string(round(y,2)) + ", angle: " + string(round(angle,2));
        ps = draw_base(app,x,y,angle,app.UIAxes1);
    end
    
    ps.UserData = selectedNode;
    ps.FaceAlpha = 0.1;
    selectedNode.NodeData.child = ps;
    ps.ButtonDownFcn = @(src,event)ps_mouse_click(app,src);
    ps_mouse_click(app,ps);


end