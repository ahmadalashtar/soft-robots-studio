function value = doesOverlap(app)

    children_shapes = objectsShapes(app);
    
    TF = overlaps(children_shapes);
    s = sum(TF,'all');
    if s > length(children_shapes)
        uialert(app.UIFigure,"Intersections found","Warning","Icon","warning")
        value = true;
        return
    end
    value = false;
end