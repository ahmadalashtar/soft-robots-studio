function node = add_target_node(app,ps,x,y,length,angle)
            % adds a target node to the right tree
            data = struct('child', ps, 'x', x, 'y', y,'length',length,'angle',angle);
            text = "x: " + string(round(x,2)) + ", y: " + string(round(y,2)) + ", angle: " + string(round(angle,2));
            node =  uitreenode(app.TargetsNode,"NodeData",data,"Text",text);
            % msgbox(string(app.ObstaclesNode.Children(1).NodeData.x))
        end