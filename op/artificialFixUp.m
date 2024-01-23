% ---------------HOW TO USE-----------------------
% - first, run the code and get the chromosome as 'ans'
% - on the command line, write
% 'drawProblem2D(decodeIndividual(artificialFixUp(ans)));' to fix the chromosome and draw the plot

function [chrom, feasible] = artificialFixUp(chrom)
    global op;
    global gas;
    
    feasible = true;
    n_targets = size(op.targets,1);
    n_nodes = size(chrom,2) - gas.extra_genes;
    ee_index = max(chrom(1:n_targets, n_nodes+1));

    chrom(n_targets + 1, ee_index:n_nodes) = 35;
    %----CUT ROBOT
    for i=1:1:n_targets
        
        t = op.targets(i,:);
        configurations = decodeIndividual(chrom); 
        conf = configurations(:,:,i);
        robot_points = solveForwardKinematics2D(conf,op.home_base,false);
        
        for j=ee_index:1:n_nodes
            l = chrom(n_targets+1,j);
            dist2target = norm(robot_points(j,:)-t(1:2));
            if(dist2target<l)
                %cut here
                lastNode_index = j;
                chrom(i,n_nodes+3) = lastNode_index;
                chrom(i,n_nodes+4) = dist2target; %cut length
                %sumNodes = sumNodes + lastNode_index;

                if dist2target < op.length_domain(1,1)
                    feasible = false;
                    fprintf("artificial fix-up created an unfeasible solution (last link length is out of bounds)");
                end

                break;
            end
        end
    end