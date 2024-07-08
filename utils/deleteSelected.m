function deleteSelected(app)
    selectedNodes = app.Tree.SelectedNodes;
    if selectedNodes.Parent == app.ObstaclesNode
        delete(selectedNodes.NodeData.child);
        delete(selectedNodes);
        deselect(app)
        
    elseif selectedNodes.Parent == app.TargetsNode

        delete(selectedNodes.NodeData.child);
        delete(selectedNodes);

        for i=1:height(app.TargetsNode.Children)
            app.TargetsNode.Children(i).NodeData.child.DataTipTemplate.DataTipRows(end)="Target: "+ string(i);
        end
    end
    init_segments(app);
end