%{
Generates a sub-sequent configuration to go from 'config'
to 'goal'.
Prefered order of action is:
 1- Retraction,
 2- Steer,
 3- Grow,
In this preference list, if robot can do the prior action, then it will
generate the result configuration of the action.
It should be noted that due to physical and other constraints of the robot,
even though a specific action is chosen, the resulting configuration may 
be not from that specific action. For example, even if 'config's length is smaller
than 'goal's, and top priority is retraction, it may not be able to
retract because it first need to steer to some position, then it will
perform steering action in the name of 'Retraction'.
%}
function config = greedyExpand2D(sp, config, goal)
    if ~(checkConfig(sp, config) && checkConfig(sp, goal))
        error("Configurations are not correct.");
    end

    diffLength = sum(goal(:, 2)) - sum(config(:, 2));
    lastExpanded = -1;
    for i = size(config, 1):-1:1
        if config(i, 2) > 0.0001
            lastExpanded = i;
            break,
        end
    end
    diffAngles = goal(1:lastExpanded, 1) - config(1:lastExpanded, 1); 

    if diffLength < -0.0001
        %Retraction

        retAmount = max(diffLength, -sp.stepSize(2));
        if config(lastExpanded, 2) + retAmount < sp.lengthMin && ~isequal(config(lastExpanded, 1), 0)
            angleAmount = -config(lastExpanded, 1);
            if angleAmount > 0
                angleAmount = min(angleAmount, sp.stepSize(1));
            else
                angleAmount = max(angleAmount, -sp.stepSize(1));
            end
            config(lastExpanded, 1) = config(lastExpanded, 1) + angleAmount;
        else
            config = retract(sp, config, -retAmount);
        end
    elseif ~isequal(diffAngles, zeros(lastExpanded, 1))
        %Steering

        if config(lastExpanded, 2) < sp.lengthMin && ~isequal(config(lastExpanded, 1) - goal(lastExpanded, 1), 0)
            growAmount = sp.lengthMin - config(lastExpanded, 2);
            growAmount = min(sp.stepSize(2), growAmount);

            config = grow(sp, config, growAmount);
        else
            for i = 1:size(diffAngles, 1)
                if diffAngles(i) > 0
                    diffAngles(i) = min(diffAngles(i), sp.stepSize(1));
                else
                    diffAngles(i) = max(diffAngles(i), -sp.stepSize(1));
                end
            end
            config(1:lastExpanded, 1) = config(1:lastExpanded, 1) + diffAngles;
        end
    elseif diffLength > 0.0001
        % Grow.
        
        growAmount = min(diffLength, sp.stepSize(2));
        config = grow(sp, config, growAmount);
    else
        config = [];
    end
end
