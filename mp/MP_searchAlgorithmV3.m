function solution = MP_searchAlgorithmV3(sp)
    spMod = sp;
    spMod.obstacles = [];
    [path, ~] = directExpansion2D(spMod, realmax, spMod.start_conf, spMod.goal_conf);

    if isempty(path)
        solution = [];
        disp("No path found");
        return;
    end

    % Find maximum length of the robot (from the base)
    % that allows it to take the path found without 
    % collusion.
    minLength = min(sum(sp.start_conf(:, 2)), sum(sp.goal_conf(:, 2)));
    for i = 1:size(path, 2)
        configPos = MP_solveForwardKinematics2D(path{i}, sp.home_base, false);
        for j = 1:size(sp.obstacles, 1)
            length = validLength(configPos, sp.obstacles(j, :));

            if length < minLength
                minLength = length;
            end
        end
    end

    % Attempt to fix the last link to make it a valid configuration.
    retLastExpanded = 1;
    retConfig = zeros(sp.j, 2);
    for i = 1:size(retConfig, 1)
        minLength = minLength - sp.start_conf(i, 2);
        if minLength <= 0
            retConfig(i, 1) = sp.start_conf(i, 1);
            retConfig(i, 2) = minLength + sp.start_conf(i, 2);
            retLastExpanded = i;
            break;
        end
        retConfig(i, :) = sp.start_conf(i, :);
    end

    minLength = sum(retConfig(:, 2));
    growConfig = setConfigLength(sp, sp.goal_conf, minLength);

    if retConfig(retLastExpanded, 2) < sp.lengthMin && (~isequal(retConfig(retLastExpanded, 1), 0) || ~isequal(growConfig(retLastExpanded, 1), 0))
        retConfig(retLastExpanded, :) = 0;
        growConfig(retLastExpanded, :) = 0;
    end

    [retPath, ~] = directExpansion2D(sp, realmax, sp.start_conf, retConfig);

    retConfig = retPath{end};
    path = directExpansion2D(spMod, realmax, retConfig, growConfig);

    path = [retPath, path];

    growthSp = sp;
    growthSp.start_conf = path{end};
    growthSol = MP_searchAlgorithmTest_2D(growthSp, 1000, false);
    path(end) = [];
    path = [path, growthSol.path];

    solution.path = path;
    solution.g = costOfPath2D(sp, path);
    solution.h = growthSol.h;
end





