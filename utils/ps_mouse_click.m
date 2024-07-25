function ps_mouse_click(app, src)
    if src.Selected == "off"
        app.Tree.SelectedNodes = src.UserData;
        node_click(app);

    else
        disable_properties(app);
        if ishandle(app.figS)
            figCloser(0, 0, app);
        end
        src.Selected = "off";

        % Delete collCirc if it exists
        if isfield(src.UserData.NodeData, 'collCirc') && ishandle(src.UserData.NodeData.collCirc)
            delete(src.UserData.NodeData.collCirc);
        end

        delete(src.Children);
    end
    if app.Eraser.State == "on"
        if app.Tree.SelectedNodes.Parent == app.ObstaclesNode || app.Tree.SelectedNodes.Parent == app.TargetsNode
            if numel(app.OPTree.Children) > 1
                result = confirmAction(app, 'Editing', "Loss in Optimizer's Output Will Occur");
                if result == "OK"
                    delete(app.OPTree.Children);
                else
                    return;
                end
            end
            deleteSelected(app);
            app.lastSelected = app.BaseNode.Children(end).NodeData.child;
            % Change cursor to arrow
            PointerOnCall(app, 0);
        end
    end
end