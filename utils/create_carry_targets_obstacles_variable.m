function create_carry_targets_obstacles_variable(app)
    n_targets = size(app.op.targets, 1);
    ot_v = zeros(n_targets, size(app.op.obstacles, 1) + n_targets, 3);
    
    if app.RobotModeDropDown.Value == "Pick & Collect Robot"
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
    elseif app.RobotModeDropDown.Value == "Carry & Drop Robot"
        for z = 1:1:n_targets
            ot_v(z, 1:size(app.op.obstacles, 1), :) = app.op.obstacles;
            ot_v(z, 1:size(app.op.obstacles, 1), 3) = ot_v(z, 1:size(app.op.obstacles, 1), 3) + app.op.targets(z,4);
            for k = 1:z-1
                currObstc(1) = app.op.targets(k, 1);
                currObstc(2) = app.op.targets(k, 2);
                currObstc(3) = app.op.targets(k, 4) + app.op.targets(z,4);
                ot_v(z, size(app.op.obstacles, 1) + k, :) = currObstc;
            end
        end
    elseif app.RobotModeDropDown.Value == "Pick & Place Robot"
        for z = 1:n_targets
            ot_v(z, 1:size(app.op.obstacles, 1), :) = app.op.obstacles;

            if z == 1 || mod(z, 2) == 1
                radius_adjustment = app.op.targets(z, 4);
            else
                radius_adjustment = app.op.targets(max(z - 1, 1), 4);
            end
            
            ot_v(z, 1:size(app.op.obstacles, 1), 3) = ot_v(z, 1:size(app.op.obstacles, 1), 3) + radius_adjustment;
            
            for k = 1:n_targets
                if k == z
                    continue;
                end
                
                if k < z
                    if mod(k, 2) == 1
                        ot_v(z, size(app.op.obstacles, 1) + k, :) = [0, 0, 0];
                        continue;
                    end
                    obstacle_radius = app.op.targets(k - 1, 4) + radius_adjustment;
                else
                    if mod(k, 2) == 0
                        ot_v(z, size(app.op.obstacles, 1) + k, :) = [0, 0, 0];
                        continue;
                    end
                    obstacle_radius = app.op.targets(k, 4) + radius_adjustment;
                end     
                
                ot_v(z, size(app.op.obstacles, 1) + k, :) = [app.op.targets(k, 1), app.op.targets(k, 2), obstacle_radius];
            end
        end
    end
    if size(ot_v, 1) == 1 && size(ot_v, 2) == 1 && size(ot_v, 3) == 3
        ot_v = [];
    end
    app.op.carriable_o_n_t = ot_v;
end