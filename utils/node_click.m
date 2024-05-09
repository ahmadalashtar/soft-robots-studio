function node_click(app)
            
            selectedNodes = app.Tree.SelectedNodes;
            if app.Eraser.State == "on"
                % when erasing, if you click on a node, it selects a child
                select_child(app,selectedNodes.NodeData.child);

            elseif selectedNodes.Parent == app.ObstaclesNode || selectedNodes.Parent == app.TargetsNode || selectedNodes.Parent == app.BaseNode
                select_child(app,selectedNodes.NodeData.child);
    
                app.TabGroup.SelectedTab = app.PropertiesTab;
                % msgbox(string(selectedNodes.NodeData.x))
                if selectedNodes.Parent == app.TargetsNode || selectedNodes.Parent == app.BaseNode
                    app.XcoordinateEditField.Value = selectedNodes.NodeData.x;
                    app.YcoordinateEditField.Value = selectedNodes.NodeData.y;
                    app.LengthEditField.Value = 1;
                    app.AngledegEditField.Value = selectedNodes.NodeData.angle;
                    app.LengthEditFieldLabel.Text = "length";
                    app.LengthEditField.Enable="off";
                    app.LengthEditFieldLabel.Enable="off";
                    enable_properties(app,"target")
                elseif selectedNodes.Parent == app.ObstaclesNode
                    app.XcoordinateEditField.Value = selectedNodes.NodeData.x;
                    app.YcoordinateEditField.Value = selectedNodes.NodeData.y;
                    app.LengthEditField.Value = selectedNodes.NodeData.radius;
                    app.LengthEditFieldLabel.Text = "radius";
                    app.AngledegEditField.Enable ="off";
                    app.AngledegEditFieldLabel.Enable ="off";
                    enable_properties(app,"obstacle")
                end
            else 
                %  deselect 
            end
        end