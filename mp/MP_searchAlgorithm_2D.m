function [solution, exapndedNodes, times] = MP_searchAlgorithm_2D(sp)
    times.fringe = 0;
    times.greedy = 0;
    times.fullExpand = 0;

    exapndedNodes = 0;
    root.g = 0;
    root.h = MP_getHeuristic_2D(sp.typeOfHeuristic, sp.start_conf, sp);
    root.f = MP_calculateCostBasedOnAlgorithm(root.g, root.h, sp.typeOfAlg);
    root.path = sp.start_conf;
    fringe = PDQ('init');
    PDQ('add', fringe, {[root.f, root.g, root.h], root.path});
    PDQ('setMaxSize', fringe, 1000);
    set = java.util.HashSet;
    while ~PDQ('empty', fringe)
        tic
        [priority, path] = PDQ('poll', fringe);
        fringeNode.f = priority(1);
        fringeNode.g = priority(2);
        fringeNode.h = priority(3);
        fringeNode.path = path;
        set.add(mat2str(fringeNode.path(:,end-1:end)));

        time = toc;
        times.fringe = times.fringe + time;
        tic

        exapndedNodes = exapndedNodes +1;
        if(fringeNode.h <= sp.heuristicLimit)
            if size(sp.goals, 1) ~= 0
                sp.goals(1:sp.j, :) = [];
            end
            if size(sp.goals, 1) == 0
                solution = fringeNode;
                break;
            else 
%                 PDQ('clear', fringe);
%                 set.clear;
%                 sp.goal_conf = sp.goals(1:sp.j, 1:2);
%                 fringeNode.h = MP_getHeuristic_2D(sp.typeOfHeuristic, sp.start_conf, sp);
            end
        end
        [greedyChildren] = MP_greedyExpand_2D(fringeNode, sp);
        validGreedyFound = false;
        for i = 1 :size(greedyChildren, 1)
            child = greedyChildren(i);
            [isColliding, ~] = MP_collisionCheck_2D(child.path(:,end-1:end), sp);

            time = toc;
            times.greedy = times.greedy + time;
            tic
            if ~set.contains(mat2str(child.path(:,end-1:end)))
                if isColliding == false
                    validGreedyFound = true;
                    PDQ('add', fringe, {[child.f child.g child.h], child.path});
                    set.add(mat2str(child.path(:,end-1:end)));
                else
                    set.add(mat2str(child.path(:,end-1:end)));
                end
            end
            time = toc;
            times.fringe = times.fringe + time;
            tic
        end

        time = toc;
        times.greedy = times.greedy + time;
        tic
        if validGreedyFound == false
            children = MP_FullExpand_2D(fringeNode, sp);
            for i = 1 :size(children, 1)
                child = children(i);
                 [isColliding, ~] = MP_collisionCheck_2D(child.path(:,end-1:end), sp);
                time = toc;
                times.fullExpand = times.fullExpand + time;
                tic
                if ~set.contains(mat2str(child.path(:,end-1:end)))
                     if isColliding == false
                        PDQ('add', fringe, {[child.f child.g child.h], child.path});
                        set.add(mat2str(child.path(:,end-1:end)));
                    else
                        set.add(mat2str(child.path(:,end-1:end)));
                    end
                end
                time = toc;
                times.fringe = times.fringe + time;
                tic
            end
            time = toc;
            times.fullExpand = times.fullExpand + time;
            tic
        end
        if PDQ('empty', fringe)
            disp('no path found');
            solution = [];
        end
    end
    tic
    PDQ('delete', fringe);
    time = toc;
    times.fringe = times.fringe + time;
    times.total = times.fringe + times.greedy + times.fullExpand;
end


