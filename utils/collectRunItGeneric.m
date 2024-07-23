function collectRunItGeneric(app)
    if app.AlgorithmDropDown.Value == "Genetic Algorithm"
        app.algorithm = "ga";
    elseif app.AlgorithmDropDown.Value == "Big-Bang Big-Crunch"
        app.algorithm = "bbbc";
    end
    
    switch app.algorithm
        case "ga"
            app.gas.generations = app.GenerationsEditField.Value;
            app.gas.n_individuals = app.IndividualsEditField.Value;
            app.gas.obstacle_avoidance = app.ObstacleavoidanceCheckBox.Value;
            app.gas.selection_method = app.SelectionmethodDropDown.Value;    % 'tournament', 'proportionate'
            app.gas.crossover_method = app.CrossovermethodDropDown.Value;  % 'blxa'
            app.gas.crossover_probability = app.CrossoverprobabilitySpinner.Value;
            app.gas.mutation_method = app.MutationmethodDropDown.Value;   % 'random', 'modifiedRandom'
            app.gas.mutation_probability = app.MutationprobabilitySpinner.Value;  % -1 is dynamic 
            app.gas.survival_method = app.SurvivalmethodDropDown.Value; % 'elitist_full', 'elitist_alpha'
            app.gas.survival_alpha = app.SurvivalalphaEditField.Value;    %this is the percentage of elites that will stay in the new population
            app.gas.penalty_method = app.PenaltymethodDropDown.Value;	% 'static', 'deb'
            % settings of rank partitioning algorithm
            app.gas.ranking_method = app.MethodDropDown.Value;     % 'penalty', 'separation'
            app.gas.rankingSettings.step_ik = app.StepIKEditField.Value;       % resolution of a partition (i.e., distance in IK fitness between two consecutives paritions)
            app.gas.rankingSettings.step_len = app.SteplengthEditField.Value;
        case "bbbc"
            app.bbbcs.MAX_GENERATIONS = app.GenerationsEditField.Value;
            app.bbbcs.N = app.IndividualsEditField.Value;

            app.bbbcs.crunchMethod = app.CrunchmethodDropDown.Value;   % 'fittest', 'com' -- fittest: choosing the fittest one as center of mass, com: calculating the center of mass with the equation on the paper

            app.bbbcs.obstacle_avoidance = app.ObstacleavoidanceCheckBox.Value;
            app.bbbcs.penalty_method = app.PenaltymethodDropDown.Value;	% 'static', 'deb'
            
            % settings of rank partitioning algorithm
            app.bbbcs.ranking_method = app.MethodDropDown.Value;     % 'penalty', 'separation'
            app.bbbcs.rankingSettings.step_ik = app.StepIKEditField.Value;       % resolution of a partition (i.e., distance in IK fitness between two consecutives paritions)
            app.bbbcs.rankingSettings.step_len = app.SteplengthEditField.Value;
    end
end