function totalCost = calculateTotalCost(path, home_base)
    totalCost = 0;
    for i = 1:size(path, 2) - 1
        cost = MP_calculateCost_2D(path{i}, path{i+1}, home_base);
        totalCost = totalCost + cost;
    end
end

