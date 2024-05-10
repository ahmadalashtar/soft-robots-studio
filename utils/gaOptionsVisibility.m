function gaOptionsVisibility(app,value)
    app.SlectionmethodDropDown.Visible = value;
    app.SlectionmethodDropDownLabel.Visible = value;
    app.CrossovermethodDropDown.Visible = value;
    app.CrossovermethodDropDownLabel.Visible = value;
    app.CrossoverprobabilitySpinner.Visible = value;
    app.CrossoverprobabilitySpinnerLabel.Visible = value;
    app.MutationmethodDropDown.Visible = value;
    app.MutationmethodDropDownLabel.Visible = value;
    app.MutationprobabilitySpinner.Visible = value;
    app.MutationprobabilitySpinnerLabel.Visible = value;
    app.SurvivalmethodDropDown.Visible = value;
    app.SurvivalmethodDropDownLabel.Visible = value;
    app.SurvivalalphaEditField.Visible = value;
    app.SurvivalalphaLabel.Visible = value;
    updateSurvivalAlphaVisibility(app,value)
end