function [f] = MP_calculateCostBasedOnAlgorithm(g, h, typeOfAlg)
    switch typeOfAlg
        case 'astar'
            f = g + h;
        case 'ucs'
            f = g;
        case 'greedy'
            f = h;
    end
end