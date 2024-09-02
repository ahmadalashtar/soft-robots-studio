% Run the Genetic Algorithm
%
% INPUT: none
%
% OUTPUT: 
% 'pop' is the population at the last generation of the algorithm [t+1 x n+4 x n_individuals]
% 'fit_array', is a matrix with fitness values, composed of 'ik fitness', 'number of nodes', 'rank fitness', 'index in the pop array'[n_individuals x 4]
function [pop, fit_array_P] = runGeneticAlgorithm(app,exp)
    
    global op;  % optimization problem
    global gas; % genetic algorithm settings
    
    %--INITIALIZATION 

    % in case a user decides to have an odd number of idividuals in the population...
    if mod(gas.n_individuals,2) ~= 0
        gas.n_individuals = gas.n_individuals + 1;
    end
    
   
    if gas.n_individuals <= 0
        gas.n_individuals = 1;
    end
    
    variance_array= zeros(1,gas.n_individuals);
    queue=zeros(1,gas.variance_generations);   % queue used to calculate the variance of the last 'variance_generations' generations best individuals

    qIndex = 1;

    variance = 0;

    feasible = false;
    %---------------DYNAMIC MUTATION---------------
    dynamic_mutation = false;
    if gas.mutation_probability == -1.0
        mp_increment = 1.0 /gas.generations;    
        gas.mutation_probability = 1.0;
        dynamic_mutation = true;
    end
    
    %--RANDOM INITIALIZATION
    if (app.holdNode < 0)
        pop = initializeRandomPopulation(app.TargetCollisionCheckBox.Value,app.RobotModeDropDown.Value);  % pop is [t+1 x n+4 x n_individuals]
    else
        pop = app.holdNode;
    end

    %--EVALUATION
    [pop, fit_array_P] = evaluate(pop, app.TargetCollisionCheckBox.Value,app.RobotModeDropDown.Value);
    [fit_array_P] = rankingEvaluation(fit_array_P);
    
    %--ITERATIONS
    if app.genHold < 0
        for gen=1:1:gas.generations
             % GUI
            pause(0.1);
            if(app.stopRunItGeneric)
                return;
            end
            % end GUI
    
            %--SELECTION
            matPool = selection(fit_array_P(:,[gas.fitIdx.rank, gas.fitIdx.id]));   % passing to selection only rank fitness and pop-related id
            
            %--VARIATION
            offspring = variation(pop, matPool,app.TargetCollisionCheckBox.Value,app.RobotModeDropDown.Value);
            
            %--EVALUATION
            [offspring, fit_array_O] = evaluate(offspring, app.TargetCollisionCheckBox.Value,app.RobotModeDropDown.Value);
            [fit_array_O] = rankingEvaluation(fit_array_O);
             
            %--SURVIVOR
            [pop, fit_array_P] = survivor(pop, offspring, fit_array_P, fit_array_O);
    
            % calculate variance over the last 'varianceGen' generations
            
            [~, comD] = centerOfMass(pop);
            queue(qIndex)=fit_array_P(1,gas.fitIdx.ik);     % variance is on ik fitness only (ranking fitness depends on the current population, so it makes no sense to compare the rank of individuals from different generations)
            qIndex=qIndex+1;                    % the queue is implemented as a static array
            if qIndex>size(queue,2)             % when the index reaches the end of the array
                qIndex = 1;                     % goes back to 1
            end
            variance = var(nonzeros(queue));    % calculate variance
            variance_array(gen)= variance;
            
            %--VERBOSE (SHOW LOG)
            if gas.verbose
                fprintf('[%d.%d]\t', exp, gen);
                message = "[" + gen + "]" + app.tabChar;

                if fit_array_P(1,gas.fitIdx.pen) == 0
                    feasible = true;
                    fprintf('Feasible Solution: ');
                    message = message + "Feasible Solution: ";
                else
                    fprintf('Unfeasible Solution: ');
                    message = message + "Unfeasible Solution: ";
                end
                fprintf('IK %.3f ', fit_array_P(1,gas.fitIdx.ik));
                message = message + " IK " + string(round(fit_array_P(1,gas.fitIdx.ik),3)) + " ";
                fprintf('(1st P: %.3f-%.3f, #%d), ', gas.rankingSettings.minFit, gas.rankingSettings.minFit + gas.rankingSettings.step_ik, gas.rankingSettings.firstPartitionSize);
                message = message + "(1st P: " + string(round(gas.rankingSettings.minFit,3)) + "-" + string(round(gas.rankingSettings.minFit + gas.rankingSettings.step_ik,3)) +", #" + string(gas.rankingSettings.firstPartitionSize) + ") ";
                fprintf('Links to segment %d, ', fit_array_P(1,gas.fitIdx.nodes));
                message = message + "Links to segment " + fit_array_P(1,gas.fitIdx.nodes) + ", ";
                fprintf('UND %d%%, ', fit_array_P(1,gas.fitIdx.wiggly));
                message = message + "UND " + fit_array_P(1,gas.fitIdx.wiggly) + ", ";
                fprintf('Links on segment %d, ', fit_array_P(1,gas.fitIdx.nodesOnSegment)) ;
                message = message + "Links on segment " + fit_array_P(1,gas.fitIdx.nodesOnSegment) + ", ";
                fprintf('Total length %.3f', fit_array_P(1,gas.fitIdx.totLength));
                message = message + "Total length "+string(round(fit_array_P(1,gas.fitIdx.totLength),3)) + " ";
                fprintf('\t\tDist from Center of Mass: [');
                for i=1:1:size(comD,2)
                    fprintf('%.4f', comD(i));
                    if i~=size(comD,2)
                        fprintf(', ');
                    end
                end    
                fprintf('] = %.4f', mean(comD));
    %             if dynamic_mutation == true
    %                 fprintf(', Dynamic Mutation: %.4f', gas.mutation_probability);
    %             end
                fprintf('\n');
                best_index = fit_array_P(1,gas.fitIdx.id);
                configurations = decodeIndividual(pop(:,:,best_index));
                sendOutputFromScript2GUI(app,message,configurations,feasible);
            end
          
    %         %--DRAW BEST INDIVIDUAL (DEBUG) 
    %         if gas.draw_plot == true
    %             best_index = fit_array_P(1,4);
    %             configurations = decodeIndividual(pop(:,:,best_index));
    %             drawProblem2D(configurations);
    %         end
            
            %--SPECIAL CONVERGENCE CONDITIONS
            
            % stop if the variance is 0.0000
            if gas.stopAtVariance_flag == true
                if (round(variance,gas.stopAtVariance_zeros) == 0) && (gen>gas.variance_generations*2)
                    break;
                end
            end
            
            % stop if we reached a fitness of 0.0000, this will likely never be true
            if gas.stopAtFitness_flag == true && round(fit_array_P(1,1), gas.stopAtFitness_zeros) == 0
                break;
            end
            
             %--DYNAMIC AGGIUSTMENTS
             if dynamic_mutation == true
                gas.mutation_probability = gas.mutation_probability - mp_increment; 
                if gas.mutation_probability < 0
                    gas.mutation_probability = 0;
                end
             end
             if (app.paused)
                if numel(app.OPTree.Children)>0
                    app.holdNode = pop;
                    app.genHold = gen;
                    SelectChangerOutCall(app, 0);
                end
                return;
            end
        end  % place a breakpoint here as you run the algorithm to pause, and check how the individuals are evolving by plotting the best one with 'drawProblem2D(decodeIndividual(pop(:,:,1)))'
    else
        for gen=app.genHold+1:1:gas.generations
             % GUI
            pause(0.1);
            if(app.stopRunItGeneric)
                app.genHold = -10;
                app.holdNode = -10;
                app.paused = false;
                return;
            end
            % end GUI
    
            %--SELECTION
            matPool = selection(fit_array_P(:,[gas.fitIdx.rank, gas.fitIdx.id]));   % passing to selection only rank fitness and pop-related id
            
            %--VARIATION
            offspring = variation(pop, matPool,app.TargetCollisionCheckBox.Value,app.RobotModeDropDown.Value);
            
            %--EVALUATION
            [offspring, fit_array_O] = evaluate(offspring, app.TargetCollisionCheckBox.Value,app.RobotModeDropDown.Value);
            [fit_array_O] = rankingEvaluation(fit_array_O);
             
            %--SURVIVOR
            [pop, fit_array_P] = survivor(pop, offspring, fit_array_P, fit_array_O);
    
            % calculate variance over the last 'varianceGen' generations
            
            [~, comD] = centerOfMass(pop);
            queue(qIndex)=fit_array_P(1,gas.fitIdx.ik);     % variance is on ik fitness only (ranking fitness depends on the current population, so it makes no sense to compare the rank of individuals from different generations)
            qIndex=qIndex+1;                    % the queue is implemented as a static array
            if qIndex>size(queue,2)             % when the index reaches the end of the array
                qIndex = 1;                     % goes back to 1
            end
            variance = var(nonzeros(queue));    % calculate variance
            variance_array(gen)= variance;
            
            %--VERBOSE (SHOW LOG)
            if gas.verbose
                fprintf('[%d.%d]\t', exp, gen);
                message = "[" + gen + "]" + app.tabChar;

                if fit_array_P(1,gas.fitIdx.pen) == 0
                    feasible = true;
                    fprintf('Feasible Solution: ');
                    message = message + "Feasible Solution: ";
                else
                    fprintf('Unfeasible Solution: ');
                    message = message + "Unfeasible Solution: ";
                end
                fprintf('IK %.3f ', fit_array_P(1,gas.fitIdx.ik));
                message = message + " IK " + string(round(fit_array_P(1,gas.fitIdx.ik),3)) + " ";
                fprintf('(1st P: %.3f-%.3f, #%d), ', gas.rankingSettings.minFit, gas.rankingSettings.minFit + gas.rankingSettings.step_ik, gas.rankingSettings.firstPartitionSize);
                message = message + "(1st P: " + string(round(gas.rankingSettings.minFit,3)) + "-" + string(round(gas.rankingSettings.minFit + gas.rankingSettings.step_ik,3)) +", #" + string(gas.rankingSettings.firstPartitionSize) + ") ";
                fprintf('Links to segment %d, ', fit_array_P(1,gas.fitIdx.nodes));
                message = message + "Links to segment " + fit_array_P(1,gas.fitIdx.nodes) + ", ";
                fprintf('UND %d%%, ', fit_array_P(1,gas.fitIdx.wiggly));
                message = message + "UND " + fit_array_P(1,gas.fitIdx.wiggly) + ", ";
                fprintf('Links on segment %d, ', fit_array_P(1,gas.fitIdx.nodesOnSegment)) ;
                message = message + "Links on segment " + fit_array_P(1,gas.fitIdx.nodesOnSegment) + ", ";
                fprintf('Total length %.3f', fit_array_P(1,gas.fitIdx.totLength));
                message = message + "Total length "+string(round(fit_array_P(1,gas.fitIdx.totLength),3)) + " ";
                fprintf('\t\tDist from Center of Mass: [');
                for i=1:1:size(comD,2)
                    fprintf('%.4f', comD(i));
                    if i~=size(comD,2)
                        fprintf(', ');
                    end
                end    
                fprintf('] = %.4f', mean(comD));
    %             if dynamic_mutation == true
    %                 fprintf(', Dynamic Mutation: %.4f', gas.mutation_probability);
    %             end
                fprintf('\n');
                best_index = fit_array_P(1,gas.fitIdx.id);
                configurations = decodeIndividual(pop(:,:,best_index));
                sendOutputFromScript2GUI(app,message,configurations, feasible);
            end
          
    %         %--DRAW BEST INDIVIDUAL (DEBUG) 
    %         if gas.draw_plot == true
    %             best_index = fit_array_P(1,4);
    %             configurations = decodeIndividual(pop(:,:,best_index));
    %             drawProblem2D(configurations);
    %         end
            
            %--SPECIAL CONVERGENCE CONDITIONS
            
            % stop if the variance is 0.0000
            if gas.stopAtVariance_flag == true
                if (round(variance,gas.stopAtVariance_zeros) == 0) && (gen>gas.variance_generations*2)
                    break;
                end
            end
            
            % stop if we reached a fitness of 0.0000, this will likely never be true
            if gas.stopAtFitness_flag == true && round(fit_array_P(1,1), gas.stopAtFitness_zeros) == 0
                break;
            end
            
             %--DYNAMIC AGGIUSTMENTS
             if dynamic_mutation == true
                gas.mutation_probability = gas.mutation_probability - mp_increment; 
                if gas.mutation_probability < 0
                    gas.mutation_probability = 0;
                end
             end
             if (app.paused)
                if numel(app.OPTree.Children)>0
                    app.holdNode = pop;
                    app.genHold = gen;
                    SelectChangerOutCall(app, 0);
                end
                return;
            end
        end  % place a breakpoint here as you run the algorithm to pause, and check how the individuals are evolving by plotting the best one with 'drawProblem2D(decodeIndividual(pop(:,:,1)))'
    end
    app.holdNode = -10;
    app.genHold = -10;
    %--FOR EXPERIMENT FILEs
    for i=gas.n_individuals:-1:1

        % % GUI
        % pause(0);
        % if(app.stopRunItGeneric)
        %     return;
        % end
        % % end GUI

        if(round(variance_array(i),1) > 0)
            gas.convergence0 = i-gas.variance_generations;
            break;
        end
    end
    for i=gas.n_individuals:-1:1
        % % GUI
        % pause(0);
        % if(app.stopRunItGeneric)
        %     return;
        % end
        % end GUI
        if(round(variance_array(i),2) > 0)
            gas.convergence00 = i-gas.variance_generations;
            break;
        end
    end
    
end
