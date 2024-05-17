function removePreviousMinMax(app)
    for i = 1 : length(app.minMax)
        delete(app.minMax(i))
    end
end