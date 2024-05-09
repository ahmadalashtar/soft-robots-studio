function create_parameters_variables(app)
            app.op.n_nodes = app.LinksEditField.Value;
            app.op.angle_domain = [app.MinangleEditField.Value, app.MaxangleEditField.Value];
            app.op.length_domain = [app.MinlengthEditField.Value , app.MaxlengthEditField.Value];

            app.op.first_angle.is_fixed = app.FixedfirstangleCheckBox.Value;
            app.op.first_angle.angle = app.FirstangleEditField.Value;
        end