function collectOP(app)
    create_base_variable(app);
    create_targets_variable(app);
    create_obstacles_variable(app);
    if app.TargetCollisionCheckBox.Value
        if app.RobotModeDropDown.Value ~= "Carry Robot"
            create_targets_obstacles_variable(app);
        else
            create_carry_targets_obstacles_variable(app);
        end
    end
    create_parameters_variables(app);
end