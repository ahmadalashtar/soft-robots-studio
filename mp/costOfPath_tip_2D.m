function totalCost = costOfPath_tip_2D(sp, path)
    totalCost = 0;
    for i = 1:size(path, 2) - 1
        firstCartasian = MP_solveForwardKinematics2D(path{i}, sp.home_base, false);
        secondCartasian = MP_solveForwardKinematics2D(path{i + 1}, sp.home_base, false);

        firstTip = [];
        for i = size(firstCartasian, 1):-1:1
            if ~isnan(firstCartasian(i, 1))
                firstTip = firstCartasian(i, :);
                break;
            end
        end

        secondTip = [];
        for i = size(secondCartasian, 1):-1:1
            if ~isnan(secondCartasian(i, 1))
                secondTip = secondCartasian(i, :);
                break;
            end
        end

        cost = norm(firstTip - secondTip);
        totalCost = totalCost + cost;
    end
end