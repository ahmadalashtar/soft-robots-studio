
% Wrapper...
function heuristic = getHeuristic2D(sp, conf1, conf2)
    sp.goal_conf = conf2;
    heuristic = MP_getHeuristic_2D(sp.typeOfHeuristic, conf1, sp);
end

