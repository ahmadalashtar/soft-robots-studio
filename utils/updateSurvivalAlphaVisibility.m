function updateSurvivalAlphaVisibility(app,val)
    if val == "on"
        value = app.SurvivalmethodDropDown.Value;
        if value == "elitist_alpha"
            app.SurvivalalphaEditField.Visible = "on";
            app.SurvivalalphaLabel.Visible = "on";
        elseif value == "elitist_full"
            app.SurvivalalphaEditField.Visible = "off";
            app.SurvivalalphaLabel.Visible = "off";
        end
    end
end