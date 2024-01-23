function [children] = MP_greedyExpand_2D(node, searchProblem)
        children = [];

        [greedyChild, isValid] = eversionChild(node, searchProblem);
        if isValid == true
            children = [children ; greedyChild];
        end

        [greedyChild, isValid] = steeringChild(node, searchProblem);
        if isValid == true
            children = [children ; greedyChild];
        end

%         greedyChild = fullyGreedy(node, searchProblem);
%         children = [children ; greedyChild];
end


function [greedyChild, isValid] = eversionChild(node, searchProblem)
%%%%%edited path index
    parent_conf = node.path(:, end-1:end);
    child_conf = parent_conf;
    %%%%%%%%edit configuration here
    amountOfEversion = (sign(sum(searchProblem.goal_conf(:, 2)) - sum(parent_conf(:, 2))) * searchProblem.stepSize(2));
    totaleversion = sum(parent_conf(:, 2)) + amountOfEversion;
    
    %distributing the eversion among links
    for r = 1 : searchProblem.j
%         if amountOfEversion < 0 && totaleversion < searchProblem.lengthMin
%             break;
%         end
%%%%%%%%%edit configurations here 
        child_conf(r, 2) = totaleversion;
        if child_conf(r, 2) < searchProblem.goal_conf(r, 2) && amountOfEversion < 0
            child_conf(r, 2) = searchProblem.goal_conf(r, 2);
        elseif child_conf(r, 2) > searchProblem.goal_conf(r, 2) && amountOfEversion > 0
            child_conf(r, 2) = searchProblem.goal_conf(r, 2);
        end
        if child_conf(r, 2) > searchProblem.design(r)
            child_conf(r, 2) = searchProblem.design(r);
        elseif child_conf(r, 2) < 0
            child_conf(r, 2) = 0;
            break;
        end
        totaleversion = totaleversion - child_conf(r, 2);
    end
%%%%%%%%%%%%%%%
    %nullify the degrees after the link with the minimum length
%     for r = 1 : searchProblem.j
%         if child_conf(r, 3) < searchProblem.lengthMin
%             child_conf(r:end, 1:2) = 0;
%             break;
%         end
%     end
    if isequal(child_conf, parent_conf)
        greedyChild = [];
        isValid = false;
        return;
    end
    isValid = true;
    greedyChild.label = 'eversion';
    greedyChild.g = node.g + MP_calculateCost_2D(node.path(:,end-1:end), child_conf, searchProblem.home_base);
%     greedyChild.h = calculateCost(child_conf, searchProblem.goal_conf, searchProblem.home_base);
    greedyChild.h = MP_getHeuristic_2D(searchProblem.typeOfHeuristic, child_conf, searchProblem);
    greedyChild.f = MP_calculateCostBasedOnAlgorithm(greedyChild.g, greedyChild.h, searchProblem.typeOfAlg);
    greedyChild.path = [node.path , child_conf];
end

function [greedyChild, isValid] = steeringChild(node, searchProblem)
    parent_conf = node.path(:, end-1:end);
    child_conf = parent_conf;
    %%%%%%%%%%%%%%%%%%% edit configuration 
    child_conf(:, 1) = parent_conf(:, 1) + (sign(searchProblem.goal_conf(:, 1) - parent_conf(:, 1)) * searchProblem.stepSize(1));

    for r = 1 : searchProblem.j
        if child_conf(r, 2) < searchProblem.lengthMin
            child_conf(r:end, 1) = parent_conf(r:end, 1);
            break;
        end
    end
    if isequal(child_conf, parent_conf)
        greedyChild = [];
        isValid = false;
        return;
    end
    isValid = true;
    greedyChild.label = 'steering';
    greedyChild.g = node.g + MP_calculateCost_2D(node.path(:,end-1:end), child_conf, searchProblem.home_base);
    greedyChild.h = MP_getHeuristic_2D(searchProblem.typeOfHeuristic, child_conf, searchProblem);
    greedyChild.f = MP_calculateCostBasedOnAlgorithm(greedyChild.g, greedyChild.h, searchProblem.typeOfAlg);
    greedyChild.path = [node.path , child_conf];
end