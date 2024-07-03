function [child, isValid] = evert(node, operation, searchProblem, length)
    % ---- generate new configuration ----
    %conf = child.path(:,:,end);

    child = node;
    eversionCount = ceil(length / searchProblem.stepSize(2));
    for i = 1:eversionCount
        conf = child.path(:, end-1:end);
        if operation == 0 % grow
            if sum(conf(:,2)) == sum(searchProblem.design)
                isValid = false;
                return
            end
        else % retract
            if sum(conf(:,2)) == 0
                isValid = false;
                return
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
                    isValid = false;
                    return
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
                    isValid = false;
                    return
                end
            end
        end
        % ---- calculate cost -----
        %     if operation == 0
        %         child.g = child.g + searchProblem.costArray(2);
        %     else
        %         child.g = child.g + searchProblem.costArray(3);
        %     end
        child.g = child.g + MP_calculateCost_2D(child.path(:,end-1:end), conf, searchProblem.home_base);
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
        child.path = [child.path , conf]; % to get all configurations of a path, divide the path by 3 columns
    end

    % There is a problem with everting function:
    % It does not remove the angles even the links are folded!
    % So I have to fix it here.
    for i = 1:2:(size(child.path, 2) - 1)
        config = child.path(:, i:i+1);
        for j = 1:size(config, 1)
            if config(j, 2) == 0
                config(j, 1) = 0;
            end
        end
        child.path(:, i:i+1) = config;
    end
end