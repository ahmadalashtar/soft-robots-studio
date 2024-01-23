function [h] = MP_getHeuristic_2D(typeOfHeuristic, currentMat, searchProblem)
      switch typeOfHeuristic
          case 'discrete'
            h = MP_calculateHeuristic(currentMat, searchProblem);
          case 'continue'
            h = MP_calculateCost_2D(currentMat, searchProblem.goal_conf, searchProblem.home_base);
      end
end