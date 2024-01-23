%Objective:
%Finding a domain for angles and lengths that does avoid obstacles. It will
%help us cross-over two chromosomes. When blending values for chromosomes
%we need to have domain of angle to avoid obstacles
%

function [domain] = obstacleAvoidingDomain(chrom1,chrom2)
    global op;  % optimization problem
    global gas; % genetic algorithm settings
    n_obstacles = size(op.obstacles,1);
    end_effector= [0 0];
    domain=[-45 0 ; 0 45];
    for i=1: 1: gas.n_individuals
        for j=1:1:size(op.n_targets,1)
            for k=1:1:op.n_nodes
                if(j==1 && k==1)
                    end_effector(1,2)=avg(chrom1(n+1,1),chrom2(n+1,1));
                else
                    nearby_obstacle_indices = findNearbyObstacles(end_effector,chrom1(j,k),min(chrom1(j,k),chrom2(j,k)),op.obstacles);
                end
            end
        end

        
    end
    

end

