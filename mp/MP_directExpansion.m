function path = MP_directExpansion(conf1, conf2, sp)
    eTol = 5;
    path = [];
    sp.goal_conf = conf2;

    node1.g = 0;
    node1.f = 0;
    node1.h = MP_getHeuristic_2D(sp.typeOfHeuristic, conf1, sp);
    node1.path = conf1;

    while node1.h > eTol 
        child = MP_greedyExpand_2D(node1, sp);
        path = [path, child.path(:, end-1:end)];
        node1 = child;
    end
end

