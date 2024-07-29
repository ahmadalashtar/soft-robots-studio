function parseDataIntoOP(app)
    app.op = app.loadedData.saveVar.op;

    % Delete default base
    delete(app.BaseNode.Children(1))
    delete(app.UIAxes1.Children(1))

    % Add a base
    base = app.op.home_base;
    add_base_plot_and_node(app,base(1),base(2),base(3))

    % Add obstacles
    obstacles = app.op.obstacles;
    if ~isempty(obstacles)
        for i = 1:length(obstacles(:,1))
            create_polyshape(app,obstacles(i,1),obstacles(i,2),obstacles(i,3),0,false);
        end
    end

    % Add targets 
    targets = app.op.targets;
    for i = 1 : length(targets(:,1))
        create_polyshape(app,targets(i,1),targets(i,2),1,targets(i,3),true,app.scalerOP, targets(i,4));
    end
    
    % Add n_nodes
    n_nodes = app.op.n_nodes;
    app.LinksEditField.Value = n_nodes;

    % Add angle domain
    min_angle = app.op.angle_domain(1);
    max_angle = app.op.angle_domain(2);

    app.MinangleEditField.Value = min_angle;
    app.MaxangleEditField.Value = max_angle;

    % Add length domain;
    min_length = app.op.length_domain(1);
    max_length = app.op.length_domain(2);

    app.MinlengthEditField.Value = min_length;
    app.MaxlengthEditField.Value = max_length;

    % Add first angle
    angle = app.op.first_angle.angle;
    is_fixed = app.op.first_angle.is_fixed;

    app.FirstangleEditField.Value = angle;
    app.FixedfirstangleCheckBox.Value = is_fixed;

    init_segments(app);
end