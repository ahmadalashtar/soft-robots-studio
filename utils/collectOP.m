function collectOP(app)
    create_base_variable(app);
    create_targets_variable(app);
    create_obstacles_variable(app);
    if app.TargetCollisionCheckBox.Value
        create_targets_obstacles_variable(app);
        if strcmp(app.RobotModeDropDown.Value, "Pick & Place Robot")
            create_carry_targets_obstacles_variable(app);
        elseif strcmp(app.RobotModeDropDown.Value, "Pick & Collect Robot")
            create_carry_targets_obstacles_variable(app);
        elseif  strcmp(app.RobotModeDropDown.Value, "Carry & Drop Robot")
            create_carry_targets_obstacles_variable(app);
        end
    end
    create_parameters_variables(app);
end