function node = add_target_node(app,ps,x,y,length,angle, scaler)
            % adds a target node to the right tree
            data = struct('child', ps, 'x', x, 'y', y,'length',length,'angle',angle, 'currentScale', scaler);
            text = "x: " + string(round(x,2)) + ", y: " + string(round(y,2)) + ", angle: " + string(round(angle,2)) + ", current scale: " + string(round(scaler,2));
            node =  uitreenode(app.TargetsNode,"NodeData",data,"Text",text);
            % msgbox(string(app.ObstaclesNode.Children(1).NodeData.x))
        end