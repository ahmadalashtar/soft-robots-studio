function deleteSelected(app)
    selectedNodes = app.Tree.SelectedNodes;
    % if selectedNodes.Parent == app.TargetsNode || selectedNodes.Parent == app.ObstaclesNode
        delete(selectedNodes.NodeData.child);
        delete(selectedNodes);
        % deselect(app)
        init_segments(app);
    % end
end