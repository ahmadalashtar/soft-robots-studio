function value = doesOverlap(app)

    if ~app.TargetCollisionCheckBox.Value
        children_shapes = objectsShapes(app);
        
        TF = overlaps(children_shapes);
        s = sum(TF,'all');
        if s > length(children_shapes)
            uialert(app.UIFigure,"Intersections found","Warning","Icon","warning")
            value = true;
            return
        end
    else
        global op;
        if app.RobotModeDropDown.Value ~= "Carry Robot"
            n = size(op.obstacles_n_targets, 1);
    
            TF = false(n);
    
            for i = 1:n-1
                for j = i+1:n
                    x1 = op.obstacles_n_targets(i, 1);
                    y1 = op.obstacles_n_targets(i, 2);
                    r1 = op.obstacles_n_targets(i, 3);
                    x2 = op.obstacles_n_targets(j, 1);
                    y2 = op.obstacles_n_targets(j, 2);
                    r2 = op.obstacles_n_targets(j, 3);
    
                    distance = sqrt((x2 - x1)^2 + (y2 - y1)^2);
    
                    if distance < (r1 + r2)
                        TF(i, j) = true;
                        TF(j, i) = true;
                    end
                end
            end
    
            s = sum(TF, 'all');
            if s > 0
                uialert(app.UIFigure, "Intersections found", "Warning", "Icon", "warning")
                value = true;
                return
            end
        else
            n = size(op.carriable_o_n_t, 2);
    
            TF = false(n);
            for i = 1:n-1
                for j = i+1:n
                    x1 = op.carriable_o_n_t(1,i, 1);
                    y1 = op.carriable_o_n_t(1,i, 2);
                    r1 = op.carriable_o_n_t(1,i, 3);
                    x2 = op.carriable_o_n_t(1,j, 1);
                    y2 = op.carriable_o_n_t(1,j, 2);
                    r2 = op.carriable_o_n_t(1,j, 3);
    
                    distance = sqrt((x2 - x1)^2 + (y2 - y1)^2);
    
                    if distance < (r1 + r2)
                        TF(i, j) = true;
                        TF(j, i) = true;
                    end
                end
            end
    
            s = sum(TF, 'all');
            if s > 0
                uialert(app.UIFigure, "Intersections found", "Warning", "Icon", "warning")
                value = true;
                return
            end
        end
    end
    value = false;
end