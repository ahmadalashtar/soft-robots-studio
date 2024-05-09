function remove_segment_lines(app)
    children = app.UIAxes1.Children;
    for i = 1:length(children)
        if isempty(children(i).UserData)
            delete(children(i))

        end
    end
end