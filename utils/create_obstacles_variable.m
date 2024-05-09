function create_obstacles_variable(app)
    nodes = app.ObstaclesNode.Children;
    o_v =  zeros(length(nodes),3);
    for i = 1:length(nodes)
        o_v(i,1)= nodes(i).NodeData.x;
        o_v(i,2)= nodes(i).NodeData.y;
        o_v(i,3)= nodes(i).NodeData.radius;
    end
    app.op.obstacles = o_v ;     
end