function angleChanger(src, event, app)
    if numel(app.OPTree.Children)>1 && app.Eraser.State == "off"
        result = confirmAction(app,'Editing',"Loss in Optimizer's Output Will Occur");
        if result  == "OK"
            delete(app.OPTree.Children);
            app.genHold = -10;
            app.holdNode = -10;
            buttons = findall(app.TabGroup2, 'Tag', 'robotPara');
            for k = 1:length(buttons)
                buttons(k).Enable = 'on';
            end
            app.Continuar.Enable = 'off';
    
        else
            return;
        end

    end
    val = event.Value;
    app.AngledegEditField.Value(1) = val;
    
    Apply(app);
    init_segments(app);
end