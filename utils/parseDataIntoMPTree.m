
function parseDataIntoMPTree(app)
    delete(app.MPTree.Children)
    children = app.loadedData.saveVar.MPTreeChildren;
    for i = 1 : numel(children)
        uitreenode(app.MPTree,"Text",children(i).Text,"NodeData",children(i).NodeData);
    end
    app.MPTree.SelectedNodes = app.MPTree.Children(end);
    MPTreeSelectionChanged(app,1);
end