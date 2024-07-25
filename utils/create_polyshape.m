function create_polyshape(app,x,y,length,angle,target, scaler, radius)
            xLimits = app.UIAxes1.XLim;
                
            yLimits = app.UIAxes1.YLim;
            
            % Set 'NextPlot' to 'add' to allow adding shapes without clearing
            % app.UIAxes1.NextPlot = 'add';
            
            % Draw your shapes or add data here
            % For example, draw a rectangle:
            
            if ~target
                radiusO  = length;
                ps = draw_obstacle(app,x,y,radiusO,app.UIAxes1);
                node = add_obstacle_node(app,ps,x,y,radiusO);
            elseif target
                ps = draw_target(app,x,y,angle,app.UIAxes1, radius);
                node = add_target_node(app,ps,x,y,length,angle, scaler, radius);
            end
            node.NodeData.openedFirst = false;
            ps.UserData = node;
            %ps.FaceAlpha = 0.1;
            % ps.HitTest = "off";
            ps.ButtonDownFcn = @(src,event)ps_mouse_click(app,src);
            ps_mouse_click(app,ps);
            
            % Store the current axis limits
            % Restore the original axis limits
            app.UIAxes1.XLim = xLimits;
            app.UIAxes1.YLim = yLimits;
            
            % Set 'NextPlot' back to 'replace' to prevent further automatic additions
            % app.UIAxes1.NextPlot = 'replace';
            app.Tree.expand;

        end