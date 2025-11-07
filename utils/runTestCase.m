function runTestCase(app,task)
    d = uiprogressdlg(app. UIFigure,'Title','Please Wait','Message','Opening test case');
    pause(0.5)
    newDocument(app);
    d.Value = 0.10;
    app.op.first_angle.is_fixed = true;
    app.op.first_angle.angle = 0;
    app.op.home_base = [0 0 0];
    switch task
        case 1
            % multiple targets and scattered obstacles
            app.op.targets = [
                100 45 45 1;
                120 40 30 1;
                100 -30 10 1;
                100 -50 -45 1;
                ];
            app.op.obstacles = [
                50 20 10;
                40 -30 10;
                60 -10 10;
                ];
            app.op.n_nodes = 20;
            app.op.angle_domain = [-45, 45];
            app.op.length_domain = [10 , 40];
        case 2
            % multiple targets and brick
            app.op.targets = [
                200 0 0 1;
                100 100 90 1;
                170.71 70.71 45 1;
                ];

            app.op.obstacles = [
                80 0 10;
                100 0 10;
                ];

            app.op.n_nodes = 20;
            app.op.angle_domain = [-45, 45];
            app.op.length_domain = [10 , 40];
        case 3
            % single target and vertical wall
            app.op.targets = [
                120 0 -90 1;
                ];
            app.op.obstacles = [
                120 100 10;
                50 60 10;
                50 40 10;
                50 20 10;
                50 0 10;
                50 -40 10;
                50 -20 10;
                ];
            app.op.n_nodes = 20;
            app.op.angle_domain = [-45, 45];
            app.op.length_domain = [5 , 35];
        case 4
            % single target and scattered maze
            radius = 10;
            xval = 40;
            app.op.home_base = [0 0 0];
            app.op.targets = [
                300 0 0 1;
                ];
            app.op.obstacles = [
                xval -20 radius;
                xval 20 radius;
                xval -60 radius;
                xval 60 radius;
                xval*2 0 radius;
                xval*2 40 radius;
                xval*2 -40 radius;
                xval*3 -20 radius;
                xval*3 20 radius;
                xval*3 -60 radius;
                xval*3 60 radius;
                xval*4 0 radius;
                xval*4 40 radius;
                xval*4 -40 radius;
                xval*5 -20 radius;
                xval*5 20 radius;
                xval*5 -60 radius;
                xval*5 60 radius;

                xval*2 -20 radius;
                xval*4 20 radius;
                ];
            app.op.n_nodes = 20;
            app.op.angle_domain = [-45, 45];
            app.op.length_domain = [10 , 40];
        case 5
            % comparison with ICRA paper to verify which one is more gentle
            % comparison in terms of ms (claim that we did not modify ioannis settings) and calculate wiggly and nodes
            % discussion over preference-based method and what best means in terms of the user
            % also mention that we experimented with different order for objectives and we observed that having nodes before ondulation is the best option
            app.op.targets = [
                120 80 70 1;
                150 80 70 1;
                ];
            app.op.obstacles = [

            ];
            app.op.n_nodes = 20;
            app.op.angle_domain = [-30, 30];
            app.op.length_domain = [5 , 30];
    end
    d.Value = 0.25;
    app.loadedData.saveVar.op = app.op;
    d.Value = 0.5;
    parseDataIntoOP(app);
    d.Value = 0.75;
    d.Value = 1;
    d.Message = 'Done';
    pause(0.5)
    close(d)
end