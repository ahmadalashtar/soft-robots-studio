function node = add_target_node(app,ps,x,y,length,angle, scaler, radius)
    % adds a target node to the right tree
    data = struct('child', ps, 'x', x, 'y', y,'length',length,'angle',angle, 'currentScale', scaler, 'radius', radius);
    text = "X: " + string(round(x,2)) + ", Y: " + string(round(y,2)) + ", Angle: " + string(round(angle,2)) + ", Radius: " + string(round(scaler,2));
    node =  uitreenode(app.TargetsNode,"NodeData",data,"Text",text);
    % msgbox(string(app.ObstaclesNode.Children(1).NodeData.x))
end