function newDocument(app)
    resetOptions(app)
    remove_segment_lines(app)
    
    children = app.UIAxes1.Children;

    for i = 1:length(children)
        if ~isempty(children(i).UserData) && children(i).UserData ~= "MinMax"
            delete(children(i).UserData)
        end
        delete(children(i))
    end

    add_base_plot_and_node(app,0,0,0);
    
    delete(app.OPTree.Children);
    delete(app.Tree2.Children);
    delete(app.Tree2.SelectedNodes);
    while numel(app.MPTree.Children) > 1
        delete(app.MPTree.Children(1));
    end

    cla(app.UIAxes2)

end