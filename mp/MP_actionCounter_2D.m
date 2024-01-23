function [growth, retract, steer] = MP_actionCounter_2D(newConf, prevConf, growth, retract, steer)
    if sum(newConf(:, 2)) > sum(prevConf(:, 2))
        growth = growth+1;
        steer= steer;
        retract = retract;
    elseif sum(newConf(:, 2)) < sum(prevConf(:, 2))
        growth = growth;
        retract = retract +1;
        steer= steer;
    end
    if ~isequal(newConf(:, 1), prevConf(:, 1))
        growth = growth;
        retract = retract;
        steer = steer + 1;
    end
end