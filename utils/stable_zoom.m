function stable_zoom(app)
    targetAmount = size(app.TargetsNode.Children);
    
    for i=1:targetAmount(1)
        
        x = app.TargetsNode.Children(i).NodeData.x;
        y = app.TargetsNode.Children(i).NodeData.y;
        child = app.TargetsNode.Children(i).NodeData.child;
        t = child.DataTipTemplate.DataTipRows(end);
        delete(child);
        % L = app.LengthEditField.Value;
        angle = app.TargetsNode.Children(i).NodeData.angle;
        radius = app.TargetsNode.Children(i).NodeData.radius;
        app.TargetsNode.Children(i).NodeData.length = 2;
        app.TargetsNode.Children(i).NodeData.angle = angle;
        app.TargetsNode.Children(i).NodeData.currentScale = app.scalerOP;
        app.TargetsNode.Children(i).Text = "X: " + string(round(x,2)) + ", Y: " + string(round(y,2)) + ", Angle: " + string(round(angle,2))  + ", Radius: " + string(radius);
        ps = draw_target(app,x,y,angle,app.UIAxes1);
        ps.UserData = app.TargetsNode.Children(i);
        %ps.FaceAlpha = 0.1;
        app.TargetsNode.Children(i).NodeData.child = ps;
        ps.ButtonDownFcn = @(src,event)ps_mouse_click(app,src);
        ps.DataTipTemplate.DataTipRows(end)= t;
        app.lastSelected = app.TargetsNode.Children(i).NodeData.child;
    end
end