% MAIN FUNCTION
%
% Optimization Problem defintion:
% > .home_base, [1x3]                   pose of the home base, array: [x , y , angle in deg (positive counterclockwise from x-axis)]
% > .targets, [tx3]                     pose of the target(s), matrix: [x , y , angle in deg (positive counterclockwise from x-axis)]
% > .obstacles, [ox3]                   pose of the obstacle(s), matrix: [x , y , radius]
% > .n_nodes, 1x1                       max number of nodes
% > .angle_domain, 2x1                  range of joint bending angles [min angle, max angle] (in deg)
% > .length_domain, 1x2                 length domain of each link: [min length required, max length] 
% > .first_angle                        data structure
%   | > .is_fixed, bool                 boolean, true if first angle from base is fixed, false otherwise
%   | > .first_angle.angle, 1x1         THIS MAKES NO SENSE I WILL PROBABLY REMOVE IT if first angle from base is fixed, max angle of the first joint (in deg) - will generate an angle in the range +-angle, which will start based on the orientation defined in the home base
% > .end_points, tx2                    contains the end point [x , y] of the segments starting from the target in the direction of the reaching orientation, used to solve the inverse kinematics
    
% Genetic Algorithm settings:
%  > .parallel                          boolean, true to run parallel computing
%  > .generations, 1x1                  number of iterations of the GA
%  > .n_individuals, 1x1                number of individuals in the population
%  > .selection_method                  selection method of the algortithm, can be: 'tournament', 'roulette', 'sus', 'random';
%  > .crossover_method                  crossover method of the algortithm, can be: 'blxa', 'sbx'
%  > .mutation_method                   mutation method of the algortithm, can be: 'non-uniform', 'polynomial', 'random'
%  > .survival_method                   survival method of the algortithm, can be: 'non-elitist', 'elitist', 'dynamic'
%  > .crossover probability             [0-1], probability to apply crossover to a pair of parents
%  > .mutation_probability, 1x1         mutation probability [0-1], probability to modify a gene in an individual (for each individuals and for each gene)
%                                       if set to -1, this will run the dynamic mutation decreasing the probability from 1.0 to 0.0 through generations     
%  > .verbose, bool                     boolean, if true prints out log for each epoch (number of epoch, best fitness of the epoch, variance in the population, best fit overall)
%  > .draw_plot, bool                   boolean, if true draws plot at the end of each epoch
%  > .extra_genes = 4                   number of extra genes for individual, it should be costant to 4 (check the function 'generateRandomChromosome' for more information)
%  > .variance_generations, 1x1         variation of the best individual is calculated over the last (number) of generations
%  > .normalize_weightDistance, bool    if true, while calculating the ik fitness, it will normalize the distances of each node from the orientation segment over the number of nodes (keep it to TRUE)
    
% Genetic Algorithm output:
%  > pop, t+1 x n+4 x n_individuals     last generation population
%  > fit_array, n_individuals x 4       fitness value, composed of 'ik fitness', 'number of nodes', 'rank fitness', 'index in the pop array' (check the function 'evaluate' for more information)

% NOTE FOR EXECUTION, if you want to check how individuals are evolving:
% > place a breakpoint at line 98 of 'runGeneticAlgorithm' as you run the script to pause it
% > execute 'drawProblem2D(decodeIndividual(pop(:,:,1)))'
% > remove breakpoint and continue the execution

function [best_chrom, configurations] = runIt_generic(app)
    
    %---------------------PROBLEM DEFINITION---------------------  
    
    global op;          % optimization problem

    % op.home_base = [0 0 0];
    % 
    % % multiple targets and scattered obstacles
    % op.targets = [  
    %              100 45 45; 
    %              120 40 30; 
    %              100 -30 10;
    %              100 -50 -45;
    %              ];
    % op.obstacles = [
    %                50 20 10;
    %                40 -30 10;
    %                60 -10 10; 
    %                ];
    % op.n_nodes = 20;
    % op.angle_domain = [-45, 45];
    % op.length_domain = [10 , 40];
    % 
    % op.first_angle.is_fixed = true;
    % op.first_angle.angle = 0;
    % op.end_points = retrieveOrientationSegmentEndPoints(true);  % retrieve the end points for each target's orientation segment
    
    %---------------------GA SETTINGS---------------------
    global gas;         % genetic algorithm settings
    
    % gas.generations = 100;
    % gas.n_individuals = 500;
    % gas.obstacle_avoidance = true;
    % gas.selection_method = 'tournament';    % 'tournament', 'proportionate'
    % gas.crossover_method = 'blxa';  % 'blxa'
    % gas.crossover_probability = 0.9;
    % gas.mutation_method = 'random';   % 'random', 'modifiedRandom'
    % gas.mutation_probability = 0.4;  % -1 is dynamic 
    % gas.survival_method = 'elitist_full'; % 'elitist_full', 'elitist_alpha'
    % gas.survival_alpha = 40;    %this is the percentage of elites that will stay in the new population
    % gas.penalty_method = 'static';	% 'static', 'deb'
    
    % settings of rank partitioning algorithm
    % gas.ranking_method = 'penalty';     % 'penalty', 'separation'
    % gas.rankingSettings.step_ik = 0.5;       % resolution of a partition (i.e., distance in IK fitness between two consecutives paritions)
    % gas.rankingSettings.step_len = 5;
    % 
    gas.rankingSettings.minFit = 0;     % OUTPUT min IK fitness
    gas.rankingSettings.maxFi = 0;      % OUTPUT max IK fitness
    gas.rankingSettings.delta = 0;      % OUTPUT difference between max and min IK fitness
    gas.rankingSettings.n_partitions = 0;       % OUTPUT overall number of partitions (delta/step_ik)
    gas.rankingSettings.firstPartitionSize = 0; % OUTPUT number of individuals falling in the first partition (best ones)

    gas.draw_plot = false;  
    gas.verbose = true;
    gas.normalize_weightDistance = true;    % deprecated
    gas.variance_generations = 10; 
    
    gas.stopAtVariance_flag = false;    % if true, GA will stop when variance between solutions becomes < 0.000 (number of zeros are defined..
    gas.stopAtVariance_zeros = 2;       % ...here)
    gas.stopAtFitness_flag = false;     % if true, GA will stop when IK fitness becomes < 0.000 (number of zeros are defined..
    gas.stopAtFitness_zeros = 2;        % ...here)
    
    gas.infeasible_subcount = 0;
    gas.convergence0 = 0;
    gas.convergence00 = 0;
    
    % indices for fit_array, these are constants do not change!
    gas.fitIdx.ik = 6;              % IK fitness (avg among configurations)
    gas.fitIdx.ikMod = 1;
    gas.fitIdx.pen = 8;             % penalty for constraints
    gas.fitIdx.nodes = 2;           % number of links to reach the target's orientation segment (overall sum)
    gas.fitIdx.nodesOnSegment = 4;  % number of links on the target's orientation segment (overall sum)
    gas.fitIdx.wiggly = 3;          % percentage of ondulation of the configuration (avg among configurations)
    gas.fitIdx.totLength = 7;       % total length of the robot (avg among configurations - maybe we should use max?)
    gas.fitIdx.totLengthMod = 5;
    gas.fitIdx.rank = 9;            % rank, used as fitness for selection and survival operators
    gas.fitIdx.id = 10;              % reference to chromosome in the array of population
    
    % extra genes in chromosome, it is a constant do not change!
    gas.extra_genes = 4;

    %---------------------BBBC SETTINGS---------------------
    
    global bbbcs;       % big bang-big crunch settings

    % bbbcs.MAX_GENERATIONS = 100;
    % bbbcs.N = 500;
    % 
    % bbbcs.crunchMethod = 'fittest';   % 'fittest', 'com' -- fittest: choosing the fittest one as center of mass, com: calculating the center of mass with the equation on the paper
    % 
    % bbbcs.obstacle_avoidance = true;
    % bbbcs.penalty_method = 'static';	% 'static', 'deb'
    
    % % settings of rank partitioning algorithm
    % bbbcs.ranking_method = 'penalty';     % 'penalty', 'separation'
    % bbbcs.rankingSettings.step_ik = 0.5;       % resolution of a partition (i.e., distance in IK fitness between two consecutives paritions)
    % bbbcs.rankingSettings.step_len = 5;
    
    bbbcs.rankingSettings.minFit = 0;     % OUTPUT min IK fitness
    bbbcs.rankingSettings.maxFi = 0;      % OUTPUT max IK fitness
    bbbcs.rankingSettings.delta = 0;      % OUTPUT difference between max and min IK fitness
    bbbcs.rankingSettings.n_partitions = 0;       % OUTPUT overall number of partitions (delta/step_ik)
    bbbcs.rankingSettings.firstPartitionSize = 0; % OUTPUT number of individuals falling in the first partition (best ones)

    bbbcs.draw_plot = false;  
    bbbcs.verbose = true;
    bbbcs.normalize_weightDistance = true;    % deprecated
    bbbcs.variance_generations = 10; 
    
    bbbcs.stopAtVariance_flag = false;    % if true, GA will stop when variance between solutions becomes < 0.000 (number of zeros are defined..
    bbbcs.stopAtVariance_zeros = 2;       % ...here)
    bbbcs.stopAtFitness_flag = false;     % if true, GA will stop when IK fitness becomes < 0.000 (number of zeros are defined..
    bbbcs.stopAtFitness_zeros = 2;        % ...here)

    bbbcs.infeasible_subcount = 0;
    bbbcs.convergence0 = 0;
    bbbcs.convergence00 = 0;

    % indices for fit_array, these are constants do not change!
    bbbcs.fitIdx.ik = 6;              % IK fitness (avg among configurations)
    bbbcs.fitIdx.ikMod = 1;
    bbbcs.fitIdx.pen = 8;             % penalty for constraints
    bbbcs.fitIdx.nodes = 2;           % number of links to reach the target's orientation segment (overall sum)
    bbbcs.fitIdx.nodesOnSegment = 4;  % number of links on the target's orientation segment (overall sum)
    bbbcs.fitIdx.wiggly = 3;          % percentage of ondulation of the configuration (avg among configurations)
    bbbcs.fitIdx.totLength = 7;       % total length of the robot (avg among configurations - maybe we should use max?)
    bbbcs.fitIdx.totLengthMod = 5;
    bbbcs.fitIdx.rank = 9;            % rank, used as fitness for selection and survival operators
    bbbcs.fitIdx.id = 10;             % reference to chromosome in the array of population
    
    % extra genes in chromosome, it is a constant do not change!
    bbbcs.extra_genes = 4;
    
    global algorithm;   %%%%%% SETTING THE ALGORITHM
    % algorithm = 'bbbc';    % 'bbbc', 'ga'
    
    %---------------------RUN---------------------
    rng shuffle;

    switch algorithm
        case 'ga'
            dynamic_mut = gas.mutation_probability;
        
            if gas.mutation_probability == 1
                typeOfMut = "Dynamic";
            else
                typeOfMut = round(gas.mutation_probability,2);
            end
            
            tic
            [pop, fit_array] = runGeneticAlgorithm(app, 1);
            % % GUI
            % pause(0);
            % if(app.stopRunItGeneric)
            %     return;
            % end
            % % end GUI
            toc
            
            elapsedTime = toc;
    
            %*************Drawing Solution************
            best_index = fit_array(1,gas.fitIdx.id);
            

        case 'bbbc'

            tic
            [pop, fit_array] = runBBBC(app, 1);
            % % GUI
            % pause(0);
            % if(app.stopRunItGeneric)
            %     return;
            % end
            % % end GUI
            toc
            
            elapsedTime = toc;
    
            %*************Drawing Solution************
            best_index = fit_array(1,bbbcs.fitIdx.id);
            
            
                        
            
            
           
    end
    best_chrom = pop(:,:,best_index);
    configurations = decodeIndividual(pop(:,:,best_index));
    % drawProblem2D(configurations);
end
