%{
Function that returns the path to the theoretical point where the steering
is possible without further retraction.
%}

function path = MP_pathToRetraction2D(sp)
    warning("off", "MATLAB:polyshape:repairedBySimplify")
    warning("off", "MATLAB:polyshape:boolOperationFailed")    
    warning("off", "MATLAB:polyshape:boundary3Points")    

    [curConfig, targetConfig, retraction] = makeConfigsEqual(sp.start_conf, sp.goal_conf);
    homeBase = sp.home_base;
    obstacles = sp.obstacles;

    targetPos = MP_solveForwardKinematics2D(targetConfig, homeBase, false);
    sourcePos = MP_solveForwardKinematics2D(curConfig, homeBase, false);


    path = [];
    for sourceIndex = 3:size(sourcePos, 1)
        for obstacleIndex = 1:size(obstacles, 1)
            if (obstacleCheck(sourcePos(sourceIndex - 1:sourceIndex, :), ...
                    targetPos(sourceIndex - 1:sourceIndex, :), ...
                    obstacles(obstacleIndex, :)))

                retAmount = retractionAmount(sourcePos(sourceIndex - 1:sourceIndex, :), targetPos(sourceIndex - 1:sourceIndex, :), obstacles(obstacleIndex, :));
                collidedIndex = sourceIndex - 1;
                for i = (collidedIndex + 1):size(curConfig, 1)
                    retAmount = retAmount + curConfig(i, 2);
                end
                if retraction > 0
                    retAmount = retAmount + retraction;
                end
                
                node.path = curConfig;
                node.g = 0;
                node.h = MP_getHeuristic_2D(sp.typeOfHeuristic, curConfig, sp);
                node.f = MP_calculateCostBasedOnAlgorithm(node.g, node.h, sp.typeOfAlg);
                path = evert(node, 1, sp, retAmount);
                return;

                % collidedIndex = sourceIndex - 1;
                % goalConfig = curConfig;
                % goalConfig(collidedIndex, 2) = goalConfig(collidedIndex, 2) - retAmount;
                % goalConfig((collidedIndex + 1):end, :) = 0;
                % sp.goal_conf = goalConfig;
                % sp.goal_conf = goalConfig;
                % path = MP_searchAlgorithmTest_2D(sp, false);
                % return;
                %
                % validSourceIndex = sourceIndex - 2;
                %
                % goalConfig = curConfig;
                % goalConfig((validSourceIndex + 1):end, :) = 0;
                % sp.goal_conf = goalConfig;
                % sp.goal_conf = goalConfig;
                %
                %
                % path = MP_searchAlgorithmTest_2D(sp, false);
                % return;
            end
        end
    end
end

function retractionAmount = retractionAmount(startPos, targetPos, obstacle)
    firstJointPos = startPos(size(startPos, 1) - 1, :);
    lastJointPos = startPos(size(startPos), :);

    targetFirstJoint = targetPos(size(startPos, 1) - 1, :);
    targetLastJoint = targetPos(size(startPos), :);

    eTol = 0.1;
    diff = sqrt((firstJointPos(1, 1) - lastJointPos(1, 1))^2 + ...
        (firstJointPos(1, 2) - lastJointPos(1, 2))^2);

    firstJoint = firstJointPos;
    lastJoint = lastJointPos;

    midPoint = lastJoint;
    while diff > eTol
        x0 = firstJoint(1, 1);
        y0 = firstJoint(1, 2);
        x1 = lastJoint(1, 1);
        y1 = lastJoint(1, 2);

        xT0 = targetFirstJoint(1, 1);
        yT0 = targetFirstJoint(1, 2);
        xT1 = targetLastJoint(1, 1);
        yT1 = targetLastJoint(1, 2);

        midPoint = [
            min(x0, x1) + abs(x0 - x1) / 2, ...
            min(y0, y1) + abs(y0 - y1) / 2;
            ];
        if obstacleCheck([firstJoint; lastJoint], [targetFirstJoint; targetLastJoint], obstacle)
            lastJoint = midPoint;
            diff = diff / 2;

            targetMidPoint = [
                min(xT0, xT1) + abs(xT0 - xT1) / 2, ...
                min(yT0, yT1) + abs(yT0 - yT1) / 2;
            ];
            targetLastJoint = targetMidPoint;
        else
            firstJoint = midPoint;
            diff = diff / 2;

            targetMidPoint = [
                min(xT0, xT1) + 3 * abs(xT0 - xT1) / 2, ...
                min(yT0, yT1) + 3 * abs(yT0 - yT1) / 2;
                ];
            targetLastJoint = targetMidPoint;
        end
    end

    retractionAmount = sqrt((lastJointPos(1, 1) - midPoint(1, 1))^2 + ...
        (lastJointPos(1, 2) - midPoint(1, 2))^2);
    return;
end

function isObstacle = obstacleCheck(startPos, targetPos, obstacle)
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

    o = obstacle;
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
    
    isObstacle = false;
    return;
end

