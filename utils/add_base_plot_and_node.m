function add_base_plot_and_node(app,x,y,angle)
            ps = draw_base(app,x,y,angle,app.UIAxes1);
            
            node = add_base_node(app,ps,x,y,angle);
            app.Tree.SelectedNodes = node;
            ps.UserData = node;
            ps.ButtonDownFcn = @(src,event)ps_mouse_click(app,src);
            app.Tree.expand;
            handle_hittest(app)
        end