function toggleUI(app,value, except)
    
    % turn everything on or off (according to value)
    
    app.Stop.Enable = value;

    children = app.Toolbar.Children;
    for i = 1 : length(children) 
        if children(i) ~= app.Stop
            children(i).Enable = value;
        end
    end

    app.Tree.Enable = value;
    
    children = app.GridLayout2.Children;
    for i = 1 : length(children) 
        children(i).Enable = value;
    end

    children = app.GridLayout3.Children;
    for i = 1 : length(children) 
        children(i).Enable = "off";
    end

    children = app.GridLayout4.Children;
    for i = 1 : length(children) 
        children(i).Enable = value;
    end

    children = app.GridLayout5.Children;
    for i = 1 : length(children) 
        children(i).Enable = value;
    end

    app.MPTree.Enable = value;

    % children = app.GridLayout3_2.Children;
    % for i = 1 : length(children) 
    %     children(i).Enable = value;
    % end

    children = app.GridLayout3_3.Children;
    for i = 1 : length(children) 
        children(i).Enable = value;
    end
    
    % children = app.GridLayout3_4.Children;
    % for i = 1 : length(children) 
    %     children(i).Enable = value;
    % end

    children = app.GridLayout8.Children;
    for i = 1 : length(children) 
        children(i).Enable = value;
    end

    app.OPTree.Enable = value;
    
    app.FileMenu.Enable = value;

    app.EditMenu.Enable = value;

    app.RunMenu.Enable = value;

    app.TestsMenu.Enable = value;
    
    % reverse the state of the items in excpet 
    for i = 1: numel(except)
        if value == "off"
            except(i).Enable = "on";
        elseif value == "on"
            except(i).Enable = "off";
        end
    end
end