function [pop, fit_array] = runBBBC(app, exp)
    
    global op;
    global bbbcs;       % big bang-big crunch settings

    rng shuffle

    n_targets = size(op.targets,1);
    cMass = zeros(n_targets+1,op.n_nodes+4);

    %--INITIALIZATION 
    
    % in case a funny user decides to have a negative number or zero for individuals in the population...
    if bbbcs.N <= 0
        bbbcs.N = 1;
    end

    variance_array= zeros(1,bbbcs.N);
    queue=zeros(1,bbbcs.variance_generations);   % queue used to calculate the variance of the last 'variance_generations' generations best individuals
    qIndex = 1;
    variance = 0;

    %--ITERATIONS
    for gen=1:1:bbbcs.MAX_GENERATIONS
        % GUI
        pause(0.1)
        if(app.stopRunItGeneric)
            return;
        end
        if (app.paused)
            return;
        end
        % end GUI
        if gen == 1  %--BIG BANG
            %--RANDOM INITIALIZATION - First Big Bang Phase
            pop = initializeRandomPopulation();  % pop is [t+1 x n+4 x n_individuals]
        else
            pop = bigBangPhase(cMass, gen);        
        end

        %--EVALUATION
        [pop, fit_array] = evaluate(pop);
        [fit_array] = rankingEvaluation(fit_array);

        %--BIG CRUNCH
        cMass = bigCrunchPhase(pop,fit_array);

        % calculate variance over the last 'varianceGen' generations
        
        [~, comD] = centerOfMass(pop);
        queue(qIndex)=fit_array(1,bbbcs.fitIdx.ik);     % variance is on ik fitness only (ranking fitness depends on the current population, so it makes no sense to compare the rank of individuals from different generations)
        qIndex=qIndex+1;                    % the queue is implemented as a static array
        if qIndex>size(queue,2)             % when the index reaches the end of the array
            qIndex = 1;                     % goes back to 1
        end
        variance = var(nonzeros(queue));    % calculate variance
        variance_array(gen)= variance;
        
        %--VERBOSE (SHOW LOG)
        if bbbcs.verbose
            fprintf('[%d.%d]\t', exp, gen);
            message = "["+  gen + "]" + app.tabChar;
            if fit_array(1,bbbcs.fitIdx.pen) == 0
                fprintf('feas: ');
                message = message + "feas: ";
            else
                fprintf('unfs: ');
                message = message + "unfs: ";
            end
            fprintf('IK %.3f ', fit_array(1,bbbcs.fitIdx.ik));
            fprintf('(1st P: %.3f-%.3f, #%d), ', bbbcs.rankingSettings.minFit, bbbcs.rankingSettings.minFit + bbbcs.rankingSettings.step_ik, bbbcs.rankingSettings.firstPartitionSize);
            fprintf('Links to segment %d, ', fit_array(1,bbbcs.fitIdx.nodes));
            fprintf('UND %d%%, ', fit_array(1,bbbcs.fitIdx.wiggly));
            fprintf('Links on segment %d, ', fit_array(1,bbbcs.fitIdx.nodesOnSegment));
            fprintf('Total length %.3f', fit_array(1,bbbcs.fitIdx.totLength));
            
            fprintf('\t\tDist from Center of Mass: [');

            message = message + " IK " + string(round(fit_array(1,bbbcs.fitIdx.ik),3)) + " ";
            message = message + "(1st P: " + string(round(bbbcs.rankingSettings.minFit,3)) + "-" + string(round(bbbcs.rankingSettings.minFit + bbbcs.rankingSettings.step_ik,3)) +", #" + string(bbbcs.rankingSettings.firstPartitionSize) + ") ";
            message = message + "Links to segment " + fit_array(1,bbbcs.fitIdx.nodes) + ", ";
            message = message + "UND " + fit_array(1,bbbcs.fitIdx.wiggly) + ", ";
            message = message + "Links on segment " + fit_array(1,bbbcs.fitIdx.nodesOnSegment) + ", ";
            message = message + "Total length "+string(round(fit_array(1,bbbcs.fitIdx.totLength),3)) + " ";

            for i=1:1:size(comD,2)
                
                fprintf('%.4f', comD(i));
                if i~=size(comD,2)
                    fprintf(', ');
                end
            end    
            fprintf('] = %.4f', mean(comD));
            fprintf('\n');

            best_index = fit_array(1,bbbcs.fitIdx.id);
            configurations = decodeIndividual(pop(:,:,best_index));
            sendOutputFromScript2GUI(app,message,configurations);
        end

        %--SPECIAL CONVERGENCE CONDITIONS
    
        % stop if the variance is 0.0000
        if bbbcs.stopAtVariance_flag == true
            if (round(variance,bbbcs.stopAtVariance_zeros) == 0) && (gen>bbbcs.variance_generations*2)
                break;
            end
        end
        
        % stop if we reached a fitness of 0.0000, this will likely never be true
        if bbbcs.stopAtFitness_flag == true && round(fit_array(1,1), bbbcs.stopAtFitness_zeros) == 0
            break;
        end

    end    

end



