function loadDefaultOptions(app)
    % robot parameters
    app.LinksEditField.Value = 20;
    app.MinangleEditField.Value = -45;
    app.MaxangleEditField.Value = 45;
    app.MinlengthEditField.Value= 10;
    app.MaxlengthEditField.Value = 40;
    app.FirstangleEditField.Value = 0;
    app.FixedfirstangleCheckBox.Value = true;
    
    % optimization algorithm
    app.AlgorithmDropDown.Value = "Genetic Algorithm";
    app.GenerationsEditField.Value = 100;
    app.IndividualsEditField.Value = 500;
    app.PenaltymethodDropDown.Value = "static";
    app.ObstacleavoidanceCheckBox.Value = true;

    % ga
    app.SlectionmethodDropDown.Value = "tournament";
    app.CrossovermethodDropDown.Value = "blxa";
    app.CrossoverprobabilitySpinner.Value = 0.9;
    app.MutationmethodDropDown.Value = "random";
    app.MutationprobabilitySpinner.Value = 0.4;
    app.SurvivalmethodDropDown.Value = "elitist_full";
    app.SurvivalalphaEditField.Value = 40;
    app.SurvivalalphaEditField.Visible = "off";
    app.SurvivalalphaLabel.Visible = "off";

    % bbbc
    app.CrunchmethodDropDown.Value = "fittest";

    % rank partitioning
    app.MethodDropDown.Value = "penalty";
    app.StepIKEditField.Value = 0.5;
    app.SteplengthEditField.Value = 5;

    % motion planner cost
    app.SteeringEditField.Value = 1;
    app.GrowingEditField.Value = 1;
    app.RetractingEditField.Value = 1;
    
    % motion planner step size
    app.SteeringEditField_2.Value = 2.5;
    app.GrowingandretractingEditField.Value = 10;

    % motion planner's parameters
    app.SimultaneousCheckBox.Value = false;
    app.BaseRotateCheckBox.Value = false;
    app.SpeedperFrame1secto0secSlider.Value = 95;
end