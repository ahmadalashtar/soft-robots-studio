function [children] = MP_FullExpand_2D(node, searchProblem)
    children = [];

    [child, isValid] = doEversion(node, 0, searchProblem);
    if isValid == true
        children = [children ; child];
    end
    [child, isValid] = doEversion(node, 1, searchProblem);
    if isValid == true
        children = [children ; child];
    end

    if searchProblem.baseRotate == true
        row = 1;
    else
        row = 2;
    end
%     lastIndexToExpand = findJointHigherThanAllObstacles(node.path(:,end-1:end), searchProblem);
%     for r = row: searchProblem.j
    for r = row: searchProblem.j
        [child, isValid] = doSteering(node, 0, r, searchProblem);
        if isValid == true
            children = [children ; child];
        end
        [child, isValid] = doSteering(node, 1, r, searchProblem);
        if isValid == true
            children = [children ; child];
        end

    end

    for r = row:searchProblem.j %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           [child, isValid] = combineSteering(node, 0,  r, searchProblem);
           if isValid == true
               children = [children ; child];
           end
           [child, isValid] = combineSteering(node, 1,  r, searchProblem);
           if isValid == true
               children = [children ; child];
           end
%            [child, isValid] = combineSteering(node, 1,  r, searchProblem);
%            if isValid == true
%                children = [children ; child];
%            end
%            [child, isValid] = combineSteering(node, 0,  r, searchProblem);
%            if isValid == true
%                children = [children ; child];
%            end
    end
end

function [child, isValid] = doEversion(node, operation, searchProblem)
    % ---- generate new configuration ----
    %conf = node.path(:,:,end);
    conf = node.path(:,end-1:end);
    
    if operation == 0 % grow
        if sum(conf(:,2)) == sum(searchProblem.design)
            child=[];
            isValid = false;
            return;
        end
    else % retract
        if sum(conf(:,2)) == 0
            child=[];
            isValid = false;
            return;
        end
    end

    row = 1;
    while row <= size(conf, 1) && conf(row, 2) == searchProblem.design(row)
        row = row+1;
    end
    if row > size(conf,1)
        row = size(conf,1);
    end
    if operation == 0
        conf(row, 2) = conf(row, 2) + searchProblem.stepSize(1, 2);
        if conf(row, 2) > searchProblem.design(row)
            if(row < size(conf,1))
                conf(row+1, 2) = conf(row, 2) - searchProblem.design(row);
                conf(row, 2) = searchProblem.design(row);
            else
                child = [];
                isValid = false;
                return;
            end
        end
    elseif operation == 1
        conf(row, 2) = conf(row, 2) - searchProblem.stepSize(1, 2);
        if conf(row, 2) < 0
%             if conf(row, 1) ~= 0 || conf(row, 2) ~= 0
%                 child = [];
%                 isValid = false;
%                 return;
%             end
            if row > 1
                conf(row-1, 2) = conf(row-1, 2) + conf(row, 2);
                conf(row, 2) = 0;
            else
                child = [];
                isValid = false;
                return;
            end
        end
    end
    % ---- calculate cost -----
%     if operation == 0
%         child.g = node.g + searchProblem.costArray(2);
%     else
%         child.g = node.g + searchProblem.costArray(3);
%     end
    child.g = node.g + MP_calculateCost_2D(node.path(:,end-1:end), conf, searchProblem.home_base);
    if(operation==0)
        child.label = 'e+';
    else
        child.label = 'e-';
    end
    isValid = true;
%     child.h = calculateHeuristic(conf, searchProblem);
%     child.h = calculateCost(conf, searchProblem.goal_conf, searchProblem.home_base);
    child.h = MP_getHeuristic_2D(searchProblem.typeOfHeuristic, conf, searchProblem);
    child.f = MP_calculateCostBasedOnAlgorithm(child.g, child.h, searchProblem.typeOfAlg);
    child.path = [node.path , conf]; % to get all configurations of a path, divide the path by 3 columns
end

function [child, isValid] = doSteering(node, operation, row, searchProblem)
    % ---- generate new configuration ----
  
    conf = node.path(:,end-1:end);
    if conf(row,1) == searchProblem.steerBounds(1) && operation ==1  || conf(row, 1) == searchProblem.steerBounds(2) && operation ==0
        child=[];
        isValid = false;
        return;
    end

    if(conf(row, 2)<searchProblem.lengthMin)
        child.h = 0;
        isValid = false;
        return;
    end
    if(operation == 0)
        conf(row, 1) = conf(row, 1) + searchProblem.stepSize(1, 1);
        if conf(row, 1) > searchProblem.steerBounds(2)
            conf(row, 1) = searchProblem.steerBounds(2);
        end
    else
        conf(row, 1) = conf(row, 1) - searchProblem.stepSize(1, 1);
        if conf(row, 1) < searchProblem.steerBounds(1)
            conf(row, 1) = searchProblem.steerBounds(1);
        end
    end
%     if col == 1
        if operation == 0
            child.label = "a" + row + "+";
        else
            child.label = "a" + row + "-";
        end
%     else
%         if operation == 0
%             child.label = "b" + row + "+";
%         else
%             child.label = "b" + row + "-";
%         end
%     end
    isValid = true;
    child.g = node.g + MP_calculateCost_2D(node.path(:,end-1:end), conf, searchProblem.home_base);
%     child.h = calculateHeuristic(conf, searchProblem);
    child.h = MP_getHeuristic_2D(searchProblem.typeOfHeuristic, conf, searchProblem);
    child.f = MP_calculateCostBasedOnAlgorithm(child.g, child.h, searchProblem.typeOfAlg);
    child.path = [node.path , conf];
end

function [child, isValid] = combineSteering(node, operationFirstCol,  row, searchProblem)
    conf = node.path(:,end-1:end);


    %if any of the columns is at its limit then this child is invalid
    if conf(row, 1) == searchProblem.steerBounds(1) && operationFirstCol ==1  || conf(row, 1) == searchProblem.steerBounds(2) && operationFirstCol ==0
        child=[];
        isValid = false;
        return;
    end
%     if conf(row, 2) == searchProblem.steerBounds(1) && operationSecondCol ==1  || conf(row, 2) == searchProblem.steerBounds(2) && operationSecondCol ==0
%         child=[];
%         isValid = false;
%         return;
%     end

    %if the link is smaller than the minimum then we can't steer
    if(conf(row, 2)<searchProblem.lengthMin)
        child.h = 0;
        isValid = false;
        return;
    end

    if(operationFirstCol == 0)
        conf(row, 1) = conf(row, 1) + searchProblem.stepSize(1, 1);
        if conf(row, 1) > searchProblem.steerBounds(2)
            conf(row, 1) = searchProblem.steerBounds(2);
        end
    else
        conf(row, 1) = conf(row, 1) - searchProblem.stepSize(1, 1);
        if conf(row, 1) < searchProblem.steerBounds(1)
            conf(row, 1) = searchProblem.steerBounds(1);
        end
    end

%     if(operationSecondCol == 0)
%         conf(row, 2) = conf(row, 2) + searchProblem.stepSize(1, 1);
%         if conf(row, 2) > searchProblem.steerBounds(2)
%             conf(row, 2) = searchProblem.steerBounds(2);
%         end
%     else
%         conf(row, 2) = conf(row, 2) - searchProblem.stepSize(1, 1);
%         if conf(row, 2) < searchProblem.steerBounds(1)
%             conf(row, 2) = searchProblem.steerBounds(1);
%         end
%     end
    
    opArray = ['+' '-'];
    
    child.label = "a" + row + opArray(1, operationFirstCol+1) + ", b" + row ;%%%%+ opArray(1, operationSecondCol+1);
    isValid = true;
    child.g = node.g + MP_calculateCost_2D(node.path(:,end-1:end), conf, searchProblem.home_base);
%     child.h = calculateHeuristic(conf, searchProblem);
    child.h = MP_getHeuristic_2D(searchProblem.typeOfHeuristic, conf, searchProblem);
    child.f = MP_calculateCostBasedOnAlgorithm(child.g, child.h, searchProblem.typeOfAlg);
    child.path = [node.path , conf];

end
