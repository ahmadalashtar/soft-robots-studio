function cost = costOfPath2D(sp, path)
    cost = 0;
    for i = 1:(size(path, 2) - 1)
        cost = cost + MP_calculateCost_2D(path{i}, path{i + 1}, sp.home_base);
    end
end

