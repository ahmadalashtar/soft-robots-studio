% Apply crossover operator on a pair of parents
%
% INPUT: 
% 'p1' is the chromosome of the first parent [t+1 x n+4]
% 'p2' is the chromosome of the second parent [t+1 x n+4]
%
% OUTPUT: 
% 'o1' is the chromosome of the first child [t+1 x n+4]
% 'o2' is the chromosome of the second child [t+1 x n+4]
function [o1, o2] = crossover(p1, p2)
    
    global op;  % optimization problem
    global gas; % genetic algorithm settings
    
    if rand() <= gas.crossover_probability
        % do crossover
        switch gas.crossover_method
            case 'blxa'
                alpha = 0.5;
                if(gas.obstacle_avoidance==true)
                    o1 = blendCrossover_obstacleAvoidance(p1, p2, alpha);
                    o2 = blendCrossover_obstacleAvoidance(p1, p2, alpha);
                else
                    o1 = blendCrossover(p1, p2, alpha);
                    o2 = blendCrossover(p1, p2, alpha);
                end

            case 'sbx'
                eta = 5;
                o1 = sbxCrossover(p1, p2, eta);
                o2 = sbxCrossover(p1, p2, eta);
            otherwise
                error('Unexpected Crossover Method.');
        end
    else
        % don't do crossover, copy from parents
        o1 = p1;
        o2 = p2;
        % make sure the extra genes of the chromosome are not copied from the parent, otherwise this chromosome will be corrupted during evaluation
        o1(:,op.n_nodes+1:op.n_nodes+gas.extra_genes) = 0;  
        o2(:,op.n_nodes+1:op.n_nodes+gas.extra_genes) = 0;
    end

end

%--------------BLX-ALPHA CROSSOVER--------------

function [child] = blendCrossover(p1, p2, alpha)
    global op;  % optimization problem
    global gas; % genetic algorithm settings
    
    n_targets = size(p1,1)-1;
    child = zeros(n_targets+1,op.n_nodes+gas.extra_genes); % newly generated offspring
    ll_index = n_targets+1;    % row-index for link length in chromosomes
    
    %angles (targets x nodes+4)
    for i=1:1:n_targets
        for j=1:1:op.n_nodes
            if j==1
                if op.first_angle.is_fixed == false
                    child(i,j) = blendValues(p1(i,j),p2(i,j),alpha,[-179,180],false);
                else                    
                    child(i,j) = op.first_angle.angle; 
                end
            else                
                child(i,j) = blendValues(p1(i,j),p2(i,j),alpha,op.angle_domain,false);
            end
        end
    end
    
    %lengths (+1 x nodes) last 4 is empty
    for j=1:1:op.n_nodes
        child(ll_index,j) = blendValues(p1(ll_index,j),p1(ll_index,j),alpha,op.length_domain,false);
    end
end




%--------------BLX-ALPHA CROSSOVER WITH OBSTACLE AVOIDANCE--------------
function [child] = blendCrossover_obstacleAvoidance(p1, p2, alpha)
    global op;  % optimization problem
    global gas; % genetic algorithm settings

    %angle_domain= obstacleAvoidance_getAngle()
    n_targets = size(p1,1)-1;
    child = zeros(n_targets+1,op.n_nodes+gas.extra_genes); % newly generated offspring
    ll_index = n_targets+1;    % row-index for link length in chromosomes
    angle=0;
    a=0.5;
    %angles (targets x nodes+4)
    %lengths (+1 x nodes) last 4 is empty
    for j=1:1:op.n_nodes
        child(ll_index,j) = blendValues(p1(ll_index,j),p2(ll_index,j),alpha,op.length_domain,false);
    end
    
    for i=1:1:n_targets

        end_effector = op.home_base(1:2);
        robot_orientation = [1 0];

        for j=1:1:op.n_nodes
            if p1(i,j) < p2(i,j)
                minGene = p1(i,j);
                maxGene = p2(i,j);
            else
                minGene = p2(i,j);
                maxGene = p1(i,j);
            end
            difference= maxGene-minGene;
            minGene= minGene- a*(difference);
            maxGene= maxGene + a*(difference);
            if(minGene<op.angle_domain(1))
                minGene=op.angle_domain(1);
            end
            if(maxGene>op.angle_domain(2))
                maxGene=op.angle_domain(2);
            end

            if j==1
                if op.first_angle.is_fixed == true
                    child(i,j) = op.first_angle.angle;
                    
                else
                    angle_bound=[minGene maxGene];
                    angle=getRandomAngleAvoidingObstacles(end_effector, robot_orientation, child(ll_index,j), op.length_domain, op.obstacles, angle_bound, false);
                    child(i,j) = angle;
                end
            else
                angle_bound=[minGene maxGene];
                angle=getRandomAngleAvoidingObstacles(end_effector, robot_orientation, child(ll_index,j), op.length_domain, op.obstacles, angle_bound, false);
                
                child(i,j) = angle;
                
            end
            %------------Forward Kinematics--------------
            alpha = deg2rad(angle);
            new_end_effector = end_effector+robot_orientation*(child(ll_index,j));
            new_end_effector = [(new_end_effector(1)-end_effector(1))*cos(alpha) - (new_end_effector(2)-end_effector(2))*sin(alpha) , (new_end_effector(1)-end_effector(1))*sin(alpha) + (new_end_effector(2)-end_effector(2))*cos(alpha)]+end_effector;   
            robot_orientation = (new_end_effector-end_effector)/norm(new_end_effector-end_effector);
            end_effector = new_end_effector;
            %--------------------------------------------
        end
    end
    
   
end
    

function [gene_c] = blendValues(gene_p1, gene_p2, alpha, bounds, isInteger)
    if gene_p1 < gene_p2
        minGene = gene_p1;
        maxGene = gene_p2;
    else
        minGene = gene_p2;
        maxGene = gene_p1;
    end
    u = rand();
    gamma = (1+2*alpha)*u-alpha;
    gene_c = (1-gamma)*minGene + gamma*maxGene;
    gene_c = max(min(bounds(2),gene_c),bounds(1));
    
    % if the gene is an integer number, transform it
    if isInteger==true
        gene_c = nearest(gene_c);
    end    
end


%--------------SBX CROSSOVER--------------

function [o1, o2] = sbxCrossover(p1, p2, eta)
    global op;  % optimization problem
    global gas; % genetic algorithm settings
    error('This Crossover Method is not implemented yet.');
end
