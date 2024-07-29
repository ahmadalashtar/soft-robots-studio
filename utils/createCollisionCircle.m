function createCollisionCircle(app, nodeData)
    x = nodeData.x;
    y = nodeData.y;
    radius = nodeData.radius;

    % Delete previous collision circle if it exists
    if isfield(app.Tree.SelectedNodes.NodeData, 'collCirc') && ishandle(app.Tree.SelectedNodes.NodeData.collCirc)
        delete(app.Tree.SelectedNodes.NodeData.collCirc);
    end

    collCirc = rectangle('Parent', app.UIAxes1, 'Position', [x - radius, y - radius, 2 * radius, 2 * radius], ...
                     'Curvature', [1, 1], ...
                     'EdgeColor', '#98a0ed', ...
                     'LineWidth', 1, 'Tag', "collCirc");
    
    app.Tree.SelectedNodes.NodeData.collCirc = collCirc; % Store collCirc handle

    addlistener(nodeData.child, 'ObjectBeingDestroyed', @(src, event) delete(collCirc));
end