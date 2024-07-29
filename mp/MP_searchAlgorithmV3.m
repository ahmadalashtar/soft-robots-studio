function solution = MP_searchAlgorithmV3(sp)
    spMod = sp;
    spMod.obstacles = [];
    [path, ~] = directExpansion2D(spMod, realmax, spMod.start_conf, spMod.goal_conf);
    
    if isempty(path)
        solution = [];
        disp("No path found");
        return;
    end

    minLength = sum(sp.goal_conf(:, 2));
    for i = 1:size(path, 2)
        configPos = MP_solveForwardKinematics2D(path{i}, sp.home_base, false);
        for j = 1:size(sp.obstacles, 1)
            length = validLength(configPos, sp.obstacles(j, :));
            if length < minLength
                minLength = length;
            end
        end
    end

    [retPath, ~] = pathToRetraction2D(sp, sp.start_conf, minLength);
   
    % Fixing unnecessary ret-grow.
    lastRet = retPath{end};
    lastExpanded = 1;
    for lastExpanded = 2:size(lastRet, 1)
        if lastRet(lastExpanded, 2) == 0
            lastExpanded = lastExpanded - 1;
            break;
        end
    end

    if lastRet(lastExpanded, 2) < sp.lengthMin
        for j = size(retPath, 2) - 1:-1:1
            retConf = retPath{j};
            if retConf(lastExpanded, 2) >= sp.lengthMin
                retPath(j + 1:end) = [];
                break;
            end
        end
    end
    %%%

    path = {};
    path{1} = retPath{end};
    retPath(end) = [];
    for i = 2:size(path, 2)
        if i > size(path, 2)
            break;
        end

        path{i} = setConfigLength(path{i}, minLength);
        if path{i} == path{i - 1}
            path(i) = [];
        end
    end
    path = [retPath, path];

    growthSp = sp;
    growthSp.start_conf = path{size(path, 2)};
    growthSol = MP_searchAlgorithmTest_2D(growthSp, 1000, false);
    growthPath = {};
    for i = 1:2:size(growthSol.path, 2) - 1
        growthPath = [growthPath, growthSol.path(:, i:i+1)];
    end 
    path(end) = [];
    path = [path, growthPath];

    solution.path = path;
    solution.g = costOfPath2D(sp, path);
end





