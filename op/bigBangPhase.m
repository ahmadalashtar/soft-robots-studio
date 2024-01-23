function [pop] = bigBangPhase(cMass, gen)
    global op;  % optimization problem
    global bbbcs; % big bang - big crunch algorithm settings
    
    % declare a static array of individuals filled with zeros
    pop = zeros(size(op.targets,1)+1,op.n_nodes+bbbcs.extra_genes,bbbcs.N);
    for i=1:1:bbbcs.N
        indv = generateRandomIndividualBBBC(cMass, gen);   
        pop(:,:,i) = indv;
    end

end