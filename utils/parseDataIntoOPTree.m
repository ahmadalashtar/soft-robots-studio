
function parseDataIntoOPTree(app)
    children = app.loadedData.saveVar.OPTreeChildren;
    for i = 1 : numel(children)
        uitreenode(app.OPTree,"Text",children(i).Text,"NodeData",children(i).NodeData);
    end
    app.OPTree.SelectedNodes = app.OPTree.Children(end);
    OPTreeSelectionChanged(app,0);
end
