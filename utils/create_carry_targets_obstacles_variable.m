function create_carry_targets_obstacles_variable(app)
    if app.RobotModeDropDown.Value == "Collect Robot"
        n_targets = size(app.op.targets, 1);
        ot_v = zeros(n_targets, size(app.op.obstacles, 1) + n_targets - 1, 3);
        for z = 1:1:n_targets
            ot_v(z, 1:size(app.op.obstacles, 1), :) = app.op.obstacles;
            ot_v(z, 1:size(app.op.obstacles, 1), 3) = ot_v(z, 1:size(app.op.obstacles, 1), 3) + app.op.targets(z,4);
            for k = z:n_targets-1
                currObstc(1) = app.op.targets(k+1, 1);
                currObstc(2) = app.op.targets(k+1, 2);
                currObstc(3) = app.op.targets(k+1, 4) + app.op.targets(z,4);
                ot_v(z, size(app.op.obstacles, 1)+k, :) = currObstc;
            end
        end
    elseif app.RobotModeDropDown.Value == "Carry Robot"
        
    end
    app.op.carriable_o_n_t = ot_v;
end