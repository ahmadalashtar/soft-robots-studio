function [solution, expandedNodes, times] = MP_searchAlgorithmV3(sp)
    times.fringe = 0;
    times.greedy = 0;
    times.fullExpand = 0;

    expandedNodes = 0;

    instanceId = PDQ_test("init", 100000);

    % PDQ_test("insertAny", instanceId, root.path, [root.g, root.h, root.f]);

    initialPath = {};
    costs = [];
    
    root.g = 0;
    root.h = MP_getHeuristic_2D(sp.typeOfHeuristic, sp.start_conf, sp);
    root.f = MP_calculateCostBasedOnAlgorithm(root.g, root.h, sp.typeOfAlg);
    root.path = sp.start_conf;

    costs = [root.g, root.h, root.f];

    PDQ_test("insertAny", instanceId, root.path, costs);

    maxLength = validLength(sp.start_conf, [0, 0, 0]);
    while ~(PDQ_test("size", instanceId) == 0)
        tic
        [config, costs] = PDQ_test("peek", instanceId);
        fringeNode.g = costs(1);
        fringeNode.h = costs(2);
        fringeNode.f = costs(3);
        fringeNode.path = config;
            
        time = toc;
        times.fringe = times.fringe + time;
        tic
    
        expandedNodes = expandedNodes + 1;

        for i = 1:size(sp.obstacles, 1)
            length = validLength(MP_solveForwardKinematics2D(fringeNode.path, sp.home_base, false), sp.obstacles(i, :));
            if length < maxLength
                maxLength = length;
            end
        end

        if(fringeNode.h < 1)
            if size(sp.goals, 1) ~= 0
                sp.goals(1:sp.j, :) = [];
            end
            if size(sp.goals, 1) == 0
                tic
                [path, costs] = PDQ_test("extractHead", instanceId);
                solution.path = [];
                for i = 1:size(path, 2)
                    path{i} = setConfigLength(path{i}, maxLength);
                end

                eversionAmount = validLength(MP_solveForwardKinematics2D(sp.start_conf, sp.home_base, false), [0, 0, 0]);
                eversionAmount = eversionAmount - maxLength;
                node.path = sp.start_conf;
                node.g = 0;
                node.h = 0;
                node.f = 0;
                pathInitial = evert(node, 1, sp, eversionAmount);
                pathInitialArr = {};

                eversionAmount = validLength(MP_solveForwardKinematics2D(sp.goal_conf, sp.home_base, false), [0, 0, 0]);
                eversionAmount = eversionAmount - maxLength;
                node.path = path{size(path, 2)};
                node.g = costs(1);
                node.h = costs(2);
                node.f = costs(3);
                pathLast = evert(node, 0, sp, eversionAmount);
                pathLastArr = {};
                
                for i = 1:2:(size(pathInitial.path, 2) - 1)
                    pathInitialArr = [pathInitialArr, pathInitial.path(:, i:i+1)];
                end

                for i = 1:2:size(pathLast.path, 2) - 1
                    pathLastArr = [pathLastArr, pathLast.path(:, i:i+1)];
                end
                
                path = [pathInitialArr, path];
                % path(:, size(path, 2)) = [];
                % path = [path, pathLastArr];

                
                i = 1;
                while i < size(path, 2) - 1
                    if path{i} == path{i + 1}
                        path(:, i + 1) = []; 
                    else
                        i = i + 1;
                    end
                end


                growthSp = sp;
                growthSp.start_conf = path{size(path, 2)};
                growthSol = MP_searchAlgorithmTest_2D(growthSp, false);

                if isempty(growthSol)
                    solution = [];
                    break;
                end

                growthPath = {};
                for i = 1:2:size(growthSol.path, 2) - 1
                    growthPath = [growthPath, growthSol.path(:, i:i+1)];
                end

                path = [path, growthPath];

                for config = path
                    solution.path = [solution.path, config{1}];
                end
                solution.g = calculateTotalCost(path, sp.home_base);
                solution.h = growthSol.h;
                solution.f = MP_calculateCostBasedOnAlgorithm(solution.g, solution.h, sp.typeOfAlg);

                time = toc;
                times.fringe = times.fringe + time;
                tic
                break;
            else 
%                 PDQ('clear', fringe);
%                 set.clear;
%                 sp.goal_conf = sp.goals(1:sp.j, 1:2);
%                 fringeNode.h = MP_getHeuristic_2D(sp.typeOfHeuristic, sp.start_conf, sp);
            end
        end

        nextChildren = {};
        
        [greedyChildren] = MP_greedyExpand_2D(fringeNode, sp);
        for i = 1 :size(greedyChildren, 1)
            child = greedyChildren(i);
            child.path = child.path(:, end-1:end);
            nextChildren(size(nextChildren, 1) + 1, 1) = {{child.path, [child.g, child.h, child.f]}};
        end
        time = toc;
        times.greedy = times.greedy + time;
        tic

        PDQ_test("expandHead", instanceId, nextChildren);
        time = toc;
        times.fringe = times.fringe + time;
        if PDQ_test("size", instanceId) == 0
            disp('no path found');
            solution = [];
        end
    end
    tic
    PDQ_test("destroyAll");
    time = toc;
    times.fringe = times.fringe + time;
    times.total = times.fringe + times.greedy + times.fullExpand;
end





