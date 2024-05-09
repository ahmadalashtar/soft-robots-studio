function turn_children_hittest(app,value)
    children = app.UIAxes1.Children;
    for i = 1:length(children)
        children(i).HitTest = value;
    end
end