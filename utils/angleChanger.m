function angleChanger(src, event, app)
    val = event.Value;
    app.AngledegEditField.Value(1) = val;
    
    Apply(app);
    init_segments(app);
end