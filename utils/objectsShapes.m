function children_shapes = objectsShapes(app)
    nElements = 0;
    for i = 1 : numel(app.Tree.Children)
        nElements = nElements + numel(app.Tree.Children(1).Children);
    end

    children_shapes = polyshape.empty(nElements,0);
    element = 1;
    for j = 1 : numel(app.Tree.Children)
        for k = 1 : numel(app.Tree.Children(j).Children)
            children_shapes(element) = app.Tree.Children(j).Children(k).NodeData.child.Shape;
            element = element + 1;
        end
    end
end