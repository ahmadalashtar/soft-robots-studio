function parseDataIntoOPTree(app)
    for i = 1 : numel(children)
        uitreenode(app.OPTree,"Text",children(i).Text,"NodeData",children(i).NodeData);
    end
    app.OPTree.SelectedNodes = app.OPTree.Children(end);
    %OPTreeSelection(app, 0) Another way to call private function
end
