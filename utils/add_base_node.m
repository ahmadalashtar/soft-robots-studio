function node = add_base_node(app,src,x,y,angle)
             % adds the base node to the right tree
            data = struct('child', src, 'x', x, 'y', y,'angle',angle, 'currentScale', app.scalerOP);
            text = "x: " + string(round(x,2)) + ", y: " + string(round(y,2)) + ", angle: " + string(round(angle,2));
            node =  uitreenode(app.BaseNode,"NodeData",data,"Text",text);
        end