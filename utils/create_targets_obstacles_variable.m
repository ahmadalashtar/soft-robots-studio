function create_targets_obstacles_variable(app, targetsRObstacles)
    
    if targetsRObstacles == true
        n_targets = size(app.op.targets, 1);
        ot_v = zeros(size(app.op.obstacles, 1) + n_targets, 3);
        ot_v(1:size(app.op.obstacles, 1), :) = app.op.obstacles; 
        for i = 1:1:n_targets
            for k = 1:n_targets
                currObstc(1) = app.op.targets(k, 1);
                currObstc(2) = app.op.targets(k, 2);
                currObstc(3) = app.op.targets(k, 4);
                ot_v(size(app.op.obstacles, 1)+k, :) = currObstc;
            end
        end
        app.op.obstacles_n_targets = ot_v;
    end
end