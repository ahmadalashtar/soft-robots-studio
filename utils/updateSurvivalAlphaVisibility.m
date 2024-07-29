function updateSurvivalAlphaVisibility(app,val)
    if val == "on"
        value = app.SurvivalmethodDropDown.Value;
        switch value
            case "elitist_alpha"
                app.SurvivalalphaEditField.Visible = "on";
                app.SurvivalalphaLabel.Visible = "on";
            case "elitist_full"
                app.SurvivalalphaEditField.Visible = "off";
                app.SurvivalalphaLabel.Visible = "off";
        end
    end
end