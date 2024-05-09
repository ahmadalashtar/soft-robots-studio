function deselect_toggles(app,event)
            children = app.Toolbar.Children;
            child = event.Source;
            for i = 1:length(children)
                if child ~= children(i)
                    try
                    children(i).State = "off";
                    catch
                    end
                end
            end
            
        end