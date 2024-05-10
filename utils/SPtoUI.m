function SPtoUI(app,sp)
    app.SteeringEditField.Value = sp.costArray(1);
    app.GrowingEditField.Value = sp.costArray(2);
    app.RetractingEditField.Value = sp.costArray(3);

    app.SteeringEditField_2.Value = sp.stepSize(1);
    app.GrowingandretractingEditField.Value = sp.stepSize(2);

    switch(sp.typeOfAlg)
        case "astar"
            typeOfAlg = "A*";
        case "ucs"
            typeOfAlg = "UCS";
        case "greedy"
            typeOfAlg = "Greedy";
    end
    app.TypeofalgorithmDropDown.Value = typeOfAlg;

    
    switch (sp.typeOfHeuristic)
        case "continue"
            typeOfHeuristic = "Continuous";
        case "discrete"
            typeOfHeuristic = "Discrete";
    end
    app.TypeofheuristicDropDown.Value = typeOfHeuristic;

    app.SimultaneousCheckBox.Value = sp.isSimulataneously;

    app.BaseRotateCheckBox.Value = sp.baseRotate;
end