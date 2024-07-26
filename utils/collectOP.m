function collectOP(app)
            create_base_variable(app);
            create_targets_variable(app);
            create_obstacles_variable(app);
            create_targets_obstacles_variable(app, app.TargetCollisionCheckBox.Value);
            create_parameters_variables(app);

        end
