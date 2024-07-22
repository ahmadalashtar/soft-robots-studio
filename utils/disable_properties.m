function disable_properties(app)
            app.XcoordinateEditFieldLabel.Enable = "off";
            app.YcoordinateEditFieldLabel.Enable= "off";
            app.LengthEditFieldLabel.Enable="off";
            app.AngledegEditFieldLabel.Enable="off";
            app.XcoordinateEditField.Value = 0;
            app.YcoordinateEditField.Value = 0;
            app.LengthEditField.Value=0;
            app.AngledegEditField.Value=0;
            app.XcoordinateEditField.Enable = "off";
            app.YcoordinateEditField.Enable = "off";
            app.LengthEditField.Enable="off";
            app.AngledegEditField.Enable="off";
            app.Rotator.Enable="off";
        end