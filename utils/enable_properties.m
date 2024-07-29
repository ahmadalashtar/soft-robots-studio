function enable_properties(app,class)
    switch class
        case "target"
            app.AngledegEditField.Enable="on";
            app.AngledegEditFieldLabel.Enable="on";
            app.Rotator.Enable ="on";
    

        case "obstacle"
            app.LengthEditFieldLabel.Enable="on";
            app.LengthEditField.Enable="on";
            app.TargetCollisionRadiusEditFieldLabel.Enable = "off";
            app.TargetCollisionRadiusEditField.Enable = "off";
    end
    app.XcoordinateEditField.Enable = "on";
    app.YcoordinateEditField.Enable = "on";
    app.XcoordinateEditFieldLabel.Enable = "on";
    app.YcoordinateEditFieldLabel.Enable= "on";
    
end