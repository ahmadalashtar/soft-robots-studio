function collectSP(app,from,to)
    nextAnimation = app.MPTree.Children(end);
    app.sp.start_conf = round(app.OPTree.SelectedNodes.NodeData.configurations(:,:,from),3);

    app.sp.design = round(app.OPTree.SelectedNodes.NodeData.design,3);
    app.sp.steerBounds = round(app.op.angle_domain,3);
    app.sp.lengthMin = round(app.op.length_domain(1),3);
    app.sp.costArray = round(nextAnimation.NodeData.costArray,3);
    app.sp.stepSize =  round(nextAnimation.NodeData.stepSize,3);
    app.sp.obstacles = round(app.op.obstacles,3);
    app.sp.goals = round(app.OPTree.SelectedNodes.NodeData.configurations(:,:,to),3);
    app.sp.home_base = round(app.op.home_base,3);
    typeOfAlg = nextAnimation.NodeData.typeOfAlg;
    switch(typeOfAlg)
        case "A*"
            app.sp.typeOfAlg = "astar";
        case "UCS"
            app.sp.typeOfAlg = "ucs";
        case "Greedy"
            app.sp.typeOfAlg = "greedy";
    end
    
    typeOfHeuristic = nextAnimation.NodeData.typeOfHeuristic;
    switch (typeOfHeuristic)
        case "Continuous"
            app.sp.typeOfHeuristic = "continue";
        case "Discrete"
            app.sp.typeOfHeuristic = "discrete";
    end
    
    app.sp.isSimulataneously = nextAnimation.NodeData.isSimulataneously;
    app.sp.baseRotate = nextAnimation.NodeData.baseRotate;


end