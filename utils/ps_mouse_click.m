function ps_mouse_click(app,src)
    if src.Selected == "off"
        app.Tree.SelectedNodes = src.UserData;
        node_click(app);
        if ishandle(app.fig) ~= 1 && app.genHold == -10 && src.UserData.NodeData.openedFirst
            app.fig = uifigure;
            app.fig.Name = "Angle Changer";
            app.fig.Position(3:4) = [360 120];

            grid = uigridlayout(app.fig);
            grid.RowHeight = {'1x', '1x', '1x', 'fit'};
            grid.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', 'fit'};

            sld = uislider(grid, "slider");
            sld.ValueChangingFcn = @(src,event) angleChanger(src, event, app);
            sld.Layout.Row = [1 2];
            sld.Layout.Column = [1 5];
            sld.Limits = [-360 360];
            sld.MajorTicks = [-360 -270 -180 -90 0 90 180 270 360];
            sld.MajorTickLabels = sld.MajorTicks + "°";
            sld.MinorTicks = [-315 -225 -135 -45 45 135 225 315];
            sld.Value =  app.AngledegEditField.Value(1);

            butt = uibutton(grid, "Text", "Done");
            butt.Layout.Row = 3;
            butt.Layout.Column = 3;
            butt.ButtonPushedFcn = @(src, event) figCloser(src, event, app.fig, sld);
        elseif ~src.UserData.NodeData.openedFirst
            src.UserData.NodeData.openedFirst = true;
        end
        
    else
        disable_properties(app);
        src.Selected = "off";
    end
    if app.Eraser.State == "on"

        if app.Tree.SelectedNodes.Parent == app.ObstaclesNode || app.Tree.SelectedNodes.Parent == app.TargetsNode
            if numel(app.OPTree.Children)>1
                result = confirmAction(app,'Editing',"Loss in Optimizer's Output Will Occur");
                if result  == "OK"
                    delete(app.OPTree.Children);
                else
                    return;
                end

            end
            deleteSelected(app);
            app.lastSelected = app.BaseNode.Children(end).NodeData.child;
            % change cursor to arrow
             PointerOn(app,0);

        end
    end



end