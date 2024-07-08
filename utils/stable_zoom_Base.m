function stable_zoom_Base(app)
    x = app.BaseNode.Children(1).NodeData.x;
    y = app.BaseNode.Children(1).NodeData.y;
    child = app.BaseNode.Children(1).NodeData.child;
    delete(child);

    angle = app.AngledegEditField.Value ;
    app.BaseNode.Children(1).NodeData.length = 1;
    app.BaseNode.Children(1).NodeData.angle = angle;
    app.BaseNode.Children(1).Text = "x: " + string(round(x,2)) + ", y: " + string(round(y,2)) + ", angle: " + string(round(angle,2));
    ps = draw_base(app,x,y,angle,app.UIAxes1);
    ps.UserData = app.BaseNode.Children(1);
    %ps.FaceAlpha = 0.1;
    app.BaseNode.Children(1).NodeData.child = ps;
    ps.ButtonDownFcn = @(src,event)ps_mouse_click(app,src);
end