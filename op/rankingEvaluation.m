% Perform ranking of the population: divide the population into partitions based on how good their fitness is, and then sort the number of nodes within each partition to minimize it.
%
% INPUT/OUTPUT: 
% 'fit_array', is a matrix with fitness values
function [fit_array] = rankingEvaluation(fit_array)
    global gas; % genetic algorithm settings
    global bbbcs;
    global algorithm;
    
    n_individuals = size(fit_array,1);  % the number of individuals will double during survival that's why we should dynamically check how many individuals we are ranking!

    switch algorithm
        case 'ga'
            switch gas.ranking_method
                case 'penalty'
                    [fit_array, gas.rankingSettings] = doPartitioning_simplified(fit_array, gas.rankingSettings, gas.fitIdx);
                case 'separation'
                    fit_array = sortrows(fit_array,[gas.fitIdx.pen, gas.fitIdx.ik]);          % sort fitness matrix by penalty and then ik
            
                    % count feasible solutions
                    for i = 1:1:n_individuals
                        if fit_array(i,gas.fitIdx.pen) ~= 0 
                            countFS = i-1;
                            break;
                        end
                    end
        
                    if ~exist('countFS','var')
                        countFS = n_individuals; % all feasible solutions
                    end
        
                    % separate feasible from unfeasible arrays
                    fit_array_feasible = fit_array(1:countFS,:);
                    fit_array_unfeasible = fit_array((countFS+1):size(fit_array,1),:);
        
                    %fit_array_unfeasible = sortrows(fit_array_unfeasible,[gas.fitIdx.nodes,gas.fitIdx.ik]);   % unfeasible solutions are part of a single partition, so all of them are ranked together
        
                    switch countFS
                        case 0
                            % there are no feasible solutions, partition unfeasible
                            [fit_array_unfeasible, gas.rankingSettings] = doPartitioning(fit_array_unfeasible, gas.rankingSettings, gas.fitIdx);
                        case 1
                            % there is only one feasible solution, add the only feasible and partition only unfeasible
                            [fit_array_unfeasible, gas.rankingSettings] = doPartitioning(fit_array_unfeasible, gas.rankingSettings, gas.fitIdx);
                        case n_individuals - 1 
                            % there is only one unfeasible solution, do partitioning only to feasible and then append the only unfeasible
                            [fit_array_feasible, gas.rankingSettings] = doPartitioning(fit_array_feasible, gas.rankingSettings, gas.fitIdx);
                        case n_individuals
                            % there are no unfeasible solution, do partitioning only to feasible and then append the only unfeasible (which is empty)
                            [fit_array_feasible, gas.rankingSettings] = doPartitioning(fit_array_feasible, gas.rankingSettings, gas.fitIdx);
                        otherwise
                            % there are more feasible solutions, partition both feasible and unfeasible
                            [fit_array_unfeasible, gas.rankingSettings] = doPartitioning(fit_array_unfeasible, gas.rankingSettings, gas.fitIdx);
                            [fit_array_feasible, gas.rankingSettings] = doPartitioning(fit_array_feasible, gas.rankingSettings, gas.fitIdx);
                    end
                    fit_array = [fit_array_feasible ; fit_array_unfeasible];    % merge feasible and unfeasible solutions
                otherwise
                    error('Unexpected Ranking Method.');
            end
            
            % partition fitness is given by a numerical rank
            % such that each individual has a larger fitness than the previous one
            % this ranks each individual
            for i=1:1:n_individuals
                fit_array(i,gas.fitIdx.rank) = i;
            end

        case 'bbbc'
            switch bbbcs.ranking_method
                case 'penalty'
                    [fit_array, bbbcs.rankingSettings] = doPartitioning_simplified(fit_array, bbbcs.rankingSettings, bbbcs.fitIdx);
                case 'separation'
                    fit_array = sortrows(fit_array,[bbbcs.fitIdx.pen, bbbcs.fitIdx.ik]);          % sort fitness matrix by penalty and then ik
            
                    % count feasible solutions
                    for i = 1:1:n_individuals
                        if fit_array(i,bbbcs.fitIdx.pen) ~= 0 
                            countFS = i-1;
                            break;
                        end
                    end
        
                    if ~exist('countFS','var')
                        countFS = n_individuals; % all feasible solutions 
                    end
        
                    % separate feasible from unfeasible arrays
                    fit_array_feasible = fit_array(1:countFS,:);
                    fit_array_unfeasible = fit_array((countFS+1):size(fit_array,1),:);
        
                    %fit_array_unfeasible = sortrows(fit_array_unfeasible,[gas.fitIdx.nodes,gas.fitIdx.ik]);   % unfeasible solutions are part of a single partition, so all of them are ranked together
        
                    switch countFS
                        case 0
                            % there are no feasible solutions, partition unfeasible
                            [fit_array_unfeasible, bbbcs.rankingSettings] = doPartitioning(fit_array_unfeasible, bbbcs.rankingSettings, bbbcs.fitIdx);
                        case 1
                            % there is only one feasible solution, add the only feasible and partition only unfeasible
                            [fit_array_unfeasible, bbbcs.rankingSettings] = doPartitioning(fit_array_unfeasible, bbbcs.rankingSettings, bbbcs.fitIdx);
                        case n_individuals - 1 
                            % there is only one unfeasible solution, do partitioning only to feasible and then append the only unfeasible
                            [fit_array_feasible, bbbcs.rankingSettings] = doPartitioning(fit_array_feasible, bbbcs.rankingSettings, bbbcs.fitIdx);
                        case n_individuals
                            % there are no unfeasible solution, do partitioning only to feasible and then append the only unfeasible (which is empty)
                            [fit_array_feasible, bbbcs.rankingSettings] = doPartitioning(fit_array_feasible, bbbcs.rankingSettings, bbbcs.fitIdx);
                        otherwise
                            % there are more feasible solutions, partition both feasible and unfeasible
                            [fit_array_unfeasible, bbbcs.rankingSettings] = doPartitioning(fit_array_unfeasible, bbbcs.rankingSettings, bbbcs.fitIdx);
                            [fit_array_feasible, bbbcs.rankingSettings] = doPartitioning(fit_array_feasible, bbbcs.rankingSettings, bbbcs.fitIdx);
                    end
                    fit_array = [fit_array_feasible ; fit_array_unfeasible];    % merge feasible and unfeasible solutions
                otherwise
                    error('Unexpected Ranking Method.');
            end
            
            % partition fitness is given by a numerical rank
            % such that each individual has a larger fitness than the previous one
            % this ranks each individual
            for i=1:1:n_individuals
                fit_array(i,bbbcs.fitIdx.rank) = i;
            end 
            
    end
    
end

function [fit_array, rank_info] = doPartitioning(fit_array, rank_info, fitIdx)
    fit_array = sortrows(fit_array, fitIdx.ik);
    rank_info.minFit = fit_array(1,fitIdx.ik);                            % get min ik fitness value from feasible solutions
    rank_info.maxFit = fit_array(end,fitIdx.ik);     % get max ik fitness value from feasible solutions
    rank_info.delta = rank_info.maxFit - rank_info.minFit;                                    % range between max and min ik fitness values
    rank_info.n_partitions = fix(rank_info.delta / rank_info.step_ik);
    rank_info.firstPartitionSize = 0;
    
    if rank_info.delta == 0
        %they are all the same, do nothing
    else
        % each partition will define uniformily distribuited ranges starting from min ik fitness up to max ik fitness with steps of value 'step'
        parts = ones(rank_info.n_partitions,1);                          % upper bounds of partitions are stored in an array
        parts(1) = rank_info.minFit + rank_info.step_ik;                   % first bound is [min, min+step]
        for i=2:1:rank_info.n_partitions
            parts(i) = parts(i-1) + rank_info.step_ik;           % creates all bounds
        end

        % this portion of code will divide the fitness matrix into partitions
        % and sort each partition based on number of nodes (from small to large)
        start = 1;
        for p=1:1:rank_info.n_partitions
            d = parts(p);
            stop = 1;
            for j=start:1:size(fit_array,fitIdx.ik)
                if fit_array(j,fitIdx.ik) > d
                    stop = j;
                    break;
                end
            end
            % sort by nodes to get to segment, ondulation, nodes on segment, overall length, ik fitness
            fit_array(start:stop-1,:) = sortrows(fit_array(start:stop-1,:),[fitIdx.nodes, fitIdx.wiggly, fitIdx.nodesOnSegment, fitIdx.totLength, fitIdx.ik]);
            %fit_array(start:stop-1,:) = sortrows(fit_array(start:stop-1,:),[fitIdx.wiggly, fitIdx.nodes, fitIdx.nodesOnSegment, fitIdx.totLength, fitIdx.ik]);
            start = stop;
            if p==1
                rank_info.firstPartitionSize = stop-1;
            end
        end
    end
end

function [fit_array, rank_info] = doPartitioning_simplified(fit_array, rank_info, fitIdx) 

%     min_ik = min(fit_array(:,fitIdx.ik));
%     min_length = min(fit_array(:,fitIdx.totLength));
%     fit_array(:,fitIdx.ikMod) = fit_array(:,fitIdx.ik) - mod(fit_array(:,fitIdx.ik)-min_ik,rank_info.step_ik);
%     fit_array(:,fitIdx.totLengthMod) = fit_array(:,fitIdx.totLength) - mod(fit_array(:,fitIdx.totLength)-min_length,rank_info.step_len);

    fit_array(:,fitIdx.ikMod) = fit_array(:,fitIdx.ik) - mod(fit_array(:,fitIdx.ik),rank_info.step_ik);
    fit_array(:,fitIdx.totLengthMod) = fit_array(:,fitIdx.totLength) - mod(fit_array(:,fitIdx.totLength),rank_info.step_len);
    
    fit_array = sortrows(fit_array,[fitIdx.ikMod, fitIdx.nodes, fitIdx.wiggly, fitIdx.nodesOnSegment, fitIdx.totLengthMod]);
    
    diff_array = [zeros(1,fitIdx.totLengthMod);abs(fit_array(1:end-1,1:fitIdx.totLengthMod)-fit_array(2:end,1:fitIdx.totLengthMod))];
    diff_array=sum(diff_array,2);
    
    start = 1;
    for i=1:1:size(fit_array,1)
        if diff_array(i) > 0
            stop = i;
            fit_array(start:stop-1,:) = sortrows(fit_array(start:stop-1,:),[fitIdx.ik, fitIdx.totLength]);
            start = stop;
        end
    end
    
    rank_info.firstPartitionSize = sum(fit_array(:,fitIdx.ikMod)==fit_array(1,fitIdx.ikMod));
    rank_info.minFit = fit_array(1,fitIdx.ikMod); 
end

% 'fit_array' is composed as follows, for each individual in the population:
%
% -> first element is the fitness from the inverse kinematics (ik fitness), calculated as the normalized sum of the distances of each node from the target's orientation segment, overall sum for each configuration
% -> second element is the sum of all nodes used to reach the target, overall sum for each configuration
% -> third element is the rank based on the partitions to minimize the number of nodes (rank fitness) + the penality for constraint violation
% -> fourth element is the index of the individual with respect of the array 'pop', as this matrix is sorted by the third column and the order will not be the same as the individuals in the population
