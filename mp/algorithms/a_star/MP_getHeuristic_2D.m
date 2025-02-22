function [h] = MP_getHeuristic_2D(typeOfHeuristic, config, searchProblem)
      switch typeOfHeuristic
          case 'discrete'
            h = MP_calculateHeuristic(config, searchProblem);
          case 'continue'
            h = MP_calculateCost_2D(config, searchProblem.goal_conf, searchProblem.home_base);
      end
end