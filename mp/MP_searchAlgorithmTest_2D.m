function [solution, expandedNodes, times] = MP_searchAlgorithmTest_2D(sp, fringeSize, retraction)
    times.fringe = 0;
    times.greedy = 0;
    times.fullExpand = 0;

    expandedNodes = 0;

    instanceId = PDQ_test("init", fringeSize);

    % PDQ_test("insertAny", instanceId, root.path, [root.g, root.h, root.f]);

    initialPath = {};
    costs = [];

    if retraction
        tempSolution = MP_pathToRetraction2D(sp);
        solution = tempSolution;
        if (~isempty(tempSolution))
            path = tempSolution.path;
            tempSolution.h = MP_getHeuristic_2D(sp.typeOfHeuristic, path(:, end-1:end), sp);
            tempSolution.f = MP_calculateCostBasedOnAlgorithm(tempSolution.g, tempSolution.h, sp.typeOfAlg);
            costs = [tempSolution.g, tempSolution.h, tempSolution.f];
        else
            root.g = 0;
            root.h = MP_getHeuristic_2D(sp.typeOfHeuristic, sp.start_conf, sp);
            root.f = MP_calculateCostBasedOnAlgorithm(root.g, root.h, sp.typeOfAlg);
            root.path = sp.start_conf;

            path = root.path;
            costs = [root.g, root.h, root.f];
        end
    else
        root.g = 0;
        root.h = MP_getHeuristic_2D(sp.typeOfHeuristic, sp.start_conf, sp);
        root.f = MP_calculateCostBasedOnAlgorithm(root.g, root.h, sp.typeOfAlg);
        root.path = sp.start_conf;
        
        path = root.path;
        costs = [root.g, root.h, root.f];
    end

    for i = 1:2:((size(path, 2)) - 1)
        initialPath = [initialPath; {path(:, i:i+1)}];
    end

    PDQ_test("insertPath", instanceId, initialPath, costs);
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
        if(fringeNode.h <= sp.heuristicLimit)
            if size(sp.goals, 1) ~= 0
                sp.goals(1:sp.j, :) = [];
            end
            if size(sp.goals, 1) == 0
                tic
                [path, costs] = PDQ_test("extractHead", instanceId);
                solution.path = path;
                solution.g = costs(1);
                solution.h = costs(2);
                solution.f = costs(3);

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
        validGreedyFound = false;
        for i = 1 :size(greedyChildren, 1)
            child = greedyChildren(i);
            child.path = child.path(:, end-1:end);
            [isColliding, ~] = MP_collisionCheck_2D(child.path, sp);
            if isColliding == false
                childCosts = [child.g, child.h, child.f];
                childConfig = [child.path];
                nextChildren(size(nextChildren, 1) + 1, 1) = {{child.path, [child.g, child.h, child.f]}};

                validGreedyFound = true;
            else
                PDQ_test("addInvalidConfig", instanceId, child.path);
            end
        end
        time = toc;
        times.greedy = times.greedy + time;
        tic
        if validGreedyFound == false
            children = MP_FullExpand_2D(fringeNode, sp);
            for i = 1 :size(children, 1)
                 child = children(i);
                 child.path = child.path(:, end-1:end);
                 [isColliding, ~] = MP_collisionCheck_2D(child.path, sp);
                 if isColliding == false
                    nextChildren(size(nextChildren, 1) + 1, 1) = {{child.path, [child.g, child.h, child.f]}};
                else
                    PDQ_test("addInvalidConfig", instanceId, child.path);
                end
            end
            time = toc;
            times.fullExpand = times.fullExpand + time;
            tic
        end
        
        tic
        
        s1 = PDQ_test("size", instanceId);
        PDQ_test("expandHead", instanceId, nextChildren);
        s2 = PDQ_test("size", instanceId);
        time = toc;
        times.fringe = times.fringe + time;
        if PDQ_test("size", instanceId) == 0
            disp('no path found');
            solution = [];
        end
    end
    tic
    PDQ_test("destroy", instanceId);
    time = toc;
    times.fringe = times.fringe + time;
    times.total = times.fringe + times.greedy + times.fullExpand;
end




