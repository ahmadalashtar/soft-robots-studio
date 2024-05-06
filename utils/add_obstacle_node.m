function node = add_obstacle_node(app,ps,x,y,radius)
            % adds an obstacle node to the right tree
            data = struct('child', ps, 'x', x, 'y', y,'radius',radius);
            text = "x: " + string(round(x,2)) + ", y: " + string(round(y,2)) + ", r: " + string(round(radius,2));
            node = uitreenode(app.ObstaclesNode,"NodeData",data,"Text",text);
            
            % msgbox(string(app.ObstaclesNode.Children(1).NodeData.x))
        end