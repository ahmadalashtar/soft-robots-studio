function parseDataIntoOPTree(app)
    children = app.loadedData.saveVar.OPTreeChildren;
    if numel(children) > 0
        for i = 1 : numel(children)
            uitreenode(app.OPTree,"Text",children(i).Text,"NodeData",children(i).NodeData, "Icon",children(i).Icon);
        end
        app.OPTree.SelectedNodes = app.OPTree.Children(end);
    end
    %OPTreeSelection(app, 0) Another way to call private function
end
