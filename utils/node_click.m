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
                    app.LengthEditFieldLabel.Text = "Length";
                    app.LengthEditField.Enable="off";
                    app.LengthEditFieldLabel.Enable="off";
                    if app.genHold == -10
                        enable_properties(app,"target")
                    end
                    if selectedNodes.Parent == app.TargetsNode
                        if ishandle(app.figS) && (app.figS.Name ~= "Angle Changer: " + (string(app.Tree.SelectedNodes.NodeData.child.DataTipTemplate.DataTipRows(end).Label)))
                            figCloser(0, 0, app);
                        end
                        if isempty(selectedNodes.NodeData.child.Children)
                            labelWithAngle(selectedNodes.NodeData.child, selectedNodes.NodeData.angle);
                        end
                    else
                        if ishandle(app.figS) && (app.figS.Name ~= "Angle Changer: Base")
                            figCloser(0, 0, app);
                        end
                    end
                    
                elseif selectedNodes.Parent == app.ObstaclesNode
                    if ishandle(app.figS)
                        figCloser(0, 0, app);
                    end
                    app.XcoordinateEditField.Value = selectedNodes.NodeData.x;
                    app.YcoordinateEditField.Value = selectedNodes.NodeData.y;
                    app.LengthEditField.Value = selectedNodes.NodeData.radius;
                    app.LengthEditFieldLabel.Text = "Radius";
                    app.AngledegEditField.Value = 0;
                    app.AngledegEditField.Enable = "off";
                    app.AngledegEditFieldLabel.Enable = "off";
                    app.Rotator.Enable = "off";
                    if app.genHold == -10
                        enable_properties(app,"obstacle")
                    end
                end
            else 
                %  deselect 
            end
        end