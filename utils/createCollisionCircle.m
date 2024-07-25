function createCollisionCircle(app, nodeData)
    x = nodeData.x;
    y = nodeData.y;
    radius = nodeData.radius;

    % Delete previous collision circle if it exists
    if isfield(nodeData, 'collCirc') && ishandle(nodeData.collCirc)
        delete(nodeData.collCirc);
    end

    collCirc = rectangle('Parent', app.UIAxes1, 'Position', [x - str2double(radius), y - str2double(radius), 2 * str2double(radius), 2 * str2double(radius)], ...
                         'Curvature', [1, 1], ...
                         'EdgeColor', '#98a0ed', ...
                         'LineWidth', 1);
    nodeData.collCirc = collCirc; % Store collCirc handle

    addlistener(nodeData.child, 'ObjectBeingDestroyed', @(src, event) delete(collCirc));
end