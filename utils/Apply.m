function Apply(app)
    selectedNode = app.Tree.SelectedNodes;
    child = selectedNode.NodeData.child;

    %These operations are common for all of the possible Apply-able UI parts(obstacle, target base),
    %so they're made at the top.

    x = app.XcoordinateEditField.Value;
    y = app.YcoordinateEditField.Value;

    selectedNode.NodeData.x = x;
    selectedNode.NodeData.y = y;

    %Switch-cases for all the possible node types.
    switch selectedNode.Parent
        case app.TargetsNode

            t = child.DataTipTemplate.DataTipRows(end);
            angle = app.AngledegEditField.Value(1);
            scaleHold = app.scalerOP;

            selectedNode.NodeData.length = 2;
            selectedNode.NodeData.angle = angle;
            selectedNode.NodeData.currentScale = scaleHold;
            selectedNode.Text = formatText(x, y, angle, scaleHold);

            ps = draw_target(app, x, y, angle, app.UIAxes1, scaleHold);
            ps.DataTipTemplate.DataTipRows(end) = t;
            
        case app.ObstaclesNode
            radius = app.LengthEditField.Value;

            selectedNode.NodeData.radius = radius;
            selectedNode.Text = formatText(x, y, radius);

            ps = draw_obstacle(app, x, y, radius, app.UIAxes1);
            
        case app.BaseNode
            angle = app.AngledegEditField.Value(1);
            
            selectedNode.NodeData.length = 1;
            selectedNode.NodeData.angle = angle;
            selectedNode.Text = formatText(x, y, angle);

            ps = draw_base(app, x, y, angle, app.UIAxes1);

    end
    
    %Common operations after getting the node drawn back on the Axes

    delete(child);

    ps.UserData = selectedNode;
    selectedNode.NodeData.child = ps;
    ps.ButtonDownFcn = @(src, event)ps_mouse_click(app, src);
    ps_mouse_click(app, ps);

end

function text = formatText(x, y, variable)
    %Formatting the text based on the number of input arguments
    text = "x: " + string(round(x, 2)) + ", y: " + string(round(y, 2));
    if nargin > 2
        text = text + ", angle: " + string(round(variable{1}, 2));
        if nargin > 3
            text = text + ", current scale: " + string(round(variable{2}, 2));
        end
    end
end