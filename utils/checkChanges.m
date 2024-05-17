function changed = checkChanges(app)
    if numel(app.TargetsNode.Children)>0 || ...
            numel(app.ObstaclesNode.Children) || ...
            numel(app.OPTree.Children) > 0 || ...
            numel(app.MPTree.Children) >1 

        changed = true;
        return;
    end
    changed = false;

end