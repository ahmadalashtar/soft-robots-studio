function sendOutputFromScript2GUI(app,message,configurations,feasible)
    % configurations = KeepNonZeroRows(app,configurations);
    [strResult, result]= getDesign(app,configurations);
    designLength = numel(result);
    configurations = equalizeConfigurationsSize(app,configurations,designLength);

    data = struct('design',result, 'length',app.op.length_domain, 'angle',app.op.angle_domain , ...
        'configurations',configurations,'obstacles', app.op.obstacles,'targets',app.op.targets,'base',app.op.home_base);
    message = string(message )+ string(strResult);
    node = uitreenode(app.OPTree,"Text",string(message));
    if feasible
        node.Icon = "Green-Tick.svg";
    else
        node.Icon = "Red-Cross.png";
    end
    node.NodeData = data;
    app.OPTree.scroll("bottom")
end