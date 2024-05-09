function select_child(app,child)
            try
                app.lastSelected.Selected = "off";
            catch
            end
            child.Selected = "on";
            app.lastSelected = child;
        end