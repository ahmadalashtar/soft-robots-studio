%{
Function that returns the path to the theoretical point where the steering
is possible without further retraction.
%}

function path = MP_pathToRetraction2D(sp)
    warning("off", "MATLAB:polyshape:repairedBySimplify")
    warning("off", "MATLAB:polyshape:boolOperationFailed")    
    warning("off", "MATLAB:polyshape:boundary3Points")    

    curConfig = sp.start_conf;
    homeBase = sp.home_base;
    targetConfig = sp.goals;
    obstacles = sp.obstacles;

    targetPos = MP_solveForwardKinematics2D(targetConfig, homeBase, false);
    sourcePos = MP_solveForwardKinematics2D(curConfig, homeBase, false);

    targetLastNoNan = zeros(1, 1);
    for i = 2:size(targetPos, 1)
        if isnan(targetPos(i, 1))
           break; 
        end
        targetLastNoNan = i;
    end
    
    sourceLastNoNan = zeros(1, 1);
    for sourceIndex = 2:size(sourcePos, 1)
        if isnan(sourcePos(i, 1))
            break; 
        end
        sourceLastNoNan = i;
    end

    path = [];
    for sourceIndex = 1:sourceLastNoNan
        path = [];
        if (obstacleCheck(sourcePos(1:sourceIndex, :), ...
            targetPos(1:min(sourceIndex, targetLastNoNan), :), ...
            obstacles))
            

            % retAmount = retractionAmount(sourcePos(1:sourceIndex, :), targetPos(1:min(sourceIndex, targetLastNoNan), :), obstacles);
            % 
            % collidedIndex = sourceIndex - 1;
            % goalConfig = curConfig;
            % goalConfig(collidedIndex, 2) = goalConfig(collidedIndex, 2) - retAmount;
            % goalConfig((collidedIndex + 1):end, :) = 0;
            % sp.goals = goalConfig;
            % sp.goal_conf = goalConfig;
            % path = MP_searchAlgorithmTest_2D(sp, false);
            % return;

            validSourceIndex = sourceIndex - 2;

            goalConfig = curConfig;
            goalConfig((validSourceIndex + 1):end, :) = 0;
            sp.goals = goalConfig;
            sp.goal_conf = goalConfig;


            path = MP_searchAlgorithm_2D(sp, false);
            return;
        end

    %     sourcePoints = [];
    %     for i = 1:sourceIndex
    %         sourcePoints(size(sourcePoints, 1) + 1, :) = sourcePos(i, :);
    %     end
    % 
    %     targetPoints = [];
    %     targetLastIndex = min(targetLastNoNan, sourceIndex);
    %     for i = targetLastIndex:-1:1
    %         targetPoints(size(targetPoints, 1) + 1, :) = targetPos(i, :);
    %     end
    % 
    %     areaToSearch = [sourcePoints; targetPoints; sourcePoints(1, :)];
    %     areaPolygon = polyshape(areaToSearch);
    % 
    %     for o = 1:size(obstacles)
    %         o = obstacles(o, :);
    %         rad = o(3);
    %         obstacleRectangle = [
    %             o(1) - rad, o(2) - rad;
    %             o(1) - rad, o(2) + rad;
    %             o(1) + rad, o(2) + rad;
    %             o(1) + rad, o(2) - rad;
    %             ];
    %         obstaclePolygon = polyshape(obstacleRectangle);
    % 
    %         if (overlaps(areaPolygon, obstaclePolygon))
    %             validSourceIndex = sourceIndex - 2;                
    %             goalConfig = curConfig;
    %             goalConfig((validSourceIndex + 1):end, :) = 0;
    %             sp.goals = goalConfig;
    %             sp.goal_conf = goalConfig;
    % 
    %             path = MP_searchAlgorithmTest_2D(sp, false);
    %             return;
    %         end
    %     end
    end
end

function retractionAmount = retractionAmount(startPos, targetPos, obstacles)
    firstJointPos = startPos(size(startPos, 1) - 1, :);
    lastJointPos = startPos(size(startPos), :);

    eTol = 0.5;
    diff = sqrt((firstJointPos(1, 1) - lastJointPos(1, 1))^2 + ...
        (firstJointPos(1, 2) - lastJointPos(1, 2))^2);

    while diff > eTol
        firstJointPos = startPos(size(startPos, 1) - 1, :);
        lastJointPos = startPos(size(startPos), :);

        x0 = firstJointPos(1, 1);
        y0 = firstJointPos(1, 2);
        x1 = lastJointPos(1, 1);
        y1 = lastJointPos(1, 2);

        midPoint = [
            min(x0, x1) + abs(x0 - x1) / 2, ...
            min(y0, y1) + abs(y0 - y1) / 2;
            ];

        midPos = startPos;
        midPos(size(midPos, 1), :) = midPoint;

        if obstacleCheck(midPos, targetPos, obstacles)
            startPos = midPos;
            diff = diff / 2;
        else
            targetPos = midPos;
            diff = diff / 2;
        end
    end

    retractionAmount = sqrt((firstJointPos(1, 1) - midPoint(1))^2 + ...
        (firstJointPos(1, 2) - midPoint(2))^2);
    return;
end

function isObstacle = obstacleCheck(startPos, targetPos, obstacles)
    sourcePoints = [];
    for i = 1:size(startPos)
        sourcePoints(size(sourcePoints, 1) + 1, :) = startPos(i, :);
    end

    targetPoints = [];
    for i = size(targetPos):-1:1
        targetPoints(size(targetPoints, 1) + 1, :) = targetPos(i, :);
    end

    areaToSearch = [sourcePoints; targetPoints; sourcePoints(1, :)];
    areaPolygon = polyshape(areaToSearch);

    for o = 1:size(obstacles)
        o = obstacles(o, :);
        rad = o(3);
        obstacleRectangle = [
            o(1) - rad, o(2) - rad;
            o(1) - rad, o(2) + rad;
            o(1) + rad, o(2) + rad;
            o(1) + rad, o(2) - rad;
            ];
        obstaclePolygon = polyshape(obstacleRectangle);
        if overlaps(areaPolygon, obstaclePolygon)
            isObstacle = true;
            return;
        end
    end
    isObstacle = false;
    return;
end
