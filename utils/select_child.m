function select_child(app,child)
    try
        app.lastSelected.Selected = "off";
    catch
    end
    children = app.TargetsNode.Children;
    for i = 1:length(children)
        if isfield(children(i).NodeData, 'collCirc') && ishandle(children(i).NodeData.collCirc)
            %delete(children(i).NodeData.collCirc);
        end
    end
    child.Selected = "on";
    app.lastSelected = child;
end