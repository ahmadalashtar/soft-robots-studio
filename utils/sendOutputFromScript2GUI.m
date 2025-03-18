function sendOutputFromScript2GUI(app,message,configurations,feasible)
    % configurations = KeepNonZeroRows(app,configurations);
    [strResult, result]= getDesign(app,configurations);
    designLength = numel(result);
    configurations = equalizeConfigurationsSize(app,configurations,designLength);

    if ~app.TargetCollisionCheckBox.Value || ~(strcmp(app.RobotModeDropDown.Value, "Carry & Drop Robot") || ...
    strcmp(app.RobotModeDropDown.Value, "Pick & Collect Robot") || ...
    strcmp(app.RobotModeDropDown.Value, "Pick & Place Robot"))
        data = struct('design',result, 'length',app.op.length_domain, 'angle',app.op.angle_domain , ...
        'configurations',configurations,'obstacles', app.op.obstacles,'targets',app.op.targets,'base',app.op.home_base);
    else
        data = struct('design',result, 'length',app.op.length_domain, 'angle',app.op.angle_domain , ...
        'configurations',configurations,'obstacles', app.op.obstacles,'targets',app.op.targets,'base',app.op.home_base, 'mode', app.RobotModeDropDown.Value);
    end
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