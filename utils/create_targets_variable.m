function create_targets_variable(app)
            nodes = app.TargetsNode.Children;
            t_v =  zeros(length(nodes),3);
            for i = 1:length(nodes)
                t_v(i,1)= nodes(i).NodeData.x;
                t_v(i,2)= nodes(i).NodeData.y;
                t_v(i,3)= nodes(i).NodeData.angle;
                if isstring(nodes(i).NodeData.radius) || ischar(nodes(i).NodeData.radius)
                    t_v(i,4)= str2double(nodes(i).NodeData.radius);
                else
                    t_v(i,4)= nodes(i).NodeData.radius;
                end
            end
            app.op.targets = t_v;
        end