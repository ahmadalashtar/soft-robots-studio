function createRotator(app)
    app.figS = uifigure;
    app.figS.Name = "Angle Changer";
    app.figS.Position(3:4) = [360 120];

    app.gridd = uigridlayout("Parent", app.figS);
    app.gridd.RowHeight = {'1x', '1x', '1x', 'fit'};
    app.gridd.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', 'fit'};
                                
    app.sld = uislider(app.gridd, "slider");
    app.sld.ValueChangingFcn = @(src,event) angleChanger(src, event, app);
    app.sld.Layout.Row = [1 2];
    app.sld.Layout.Column = [1 5];
    app.sld.Limits = [-360 360];
    app.sld.MajorTicks = [-360 -270 -180 -90 0 90 180 270 360];
    app.sld.MajorTickLabels = app.sld.MajorTicks + "°";
    app.sld.MinorTicks = [-315 -225 -135 -45 45 135 225 315];
    app.sld.Value =  app.AngledegEditField.Value(1);
    
    butt = uibutton(app.gridd, "Text", "Done");
    butt.Layout.Row = 3;
    butt.Layout.Column = 3;
    butt.ButtonPushedFcn = @(src, event) figCloser(src, event, app);
end