function [path, cost] = directExpansion2D(sp, step_size, start_conf, end_conf)
    path = {start_conf};
    config = start_conf;
    while MP_getHeuristic_2D(sp.typeOfHeuristic, config, sp) > sp.heuristicLimit && (size(path, 2) - 1) < step_size
        config = greedyExpand2D(sp, config, end_conf);

        if isempty(config)
            cost = costOfPath2D(sp, path);
            return;
        elseif MP_collisionCheck_2D(config, sp)

            path = {};
            cost = -1;
            return;
        end

        path = [path, config];
    end

    cost = costOfPath2D(sp, path);
end
