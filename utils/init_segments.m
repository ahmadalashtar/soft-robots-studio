function init_segments(app)
    
    remove_segment_lines(app)
    
    collectOP(app);
    sendOP(app);
    draw_segments(app,app.UIAxes1);
    handle_hittest(app)                
    

    
end