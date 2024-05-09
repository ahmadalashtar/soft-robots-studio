function create_base_variable(app)
            base = app.BaseNode.Children(1);
            app.op.home_base = [base.NodeData.x base.NodeData.y base.NodeData.angle];
        end