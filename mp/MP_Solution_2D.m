function result = MP_Solution_2D()

global sp

sp.j = size(sp.start_conf, 1);
sp.goal_conf = sp.goals(1:sp.j, 1:2);
sp.isSimulataneously = false;
sp.heuristicLimit = 0.1;

startTime = clock;
[solution] = MP_searchAlgorithmV3(sp);


endTime = clock;


result  = solution.path;
end