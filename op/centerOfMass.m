function [com, d] = centerOfMass(pop)
    
    global op;  % optimization problem
    global gas; % genetic algorithm settings
    global bbbcs;
    global algorithm;
    
    n_targets = size(op.targets,1);
    n_nodes = op.n_nodes;
    com = zeros(n_nodes,2,n_targets);

    switch algorithm
        case 'ga'
            for i=1:1:gas.n_individuals
                conf = decodeIndividual(pop(:,:,i));
                com = com + conf;
            end
            com = com / gas.n_individuals;
            
            d = zeros(1,n_targets);
            for i=1:1:gas.n_individuals
                conf = decodeIndividual(pop(:,:,i));
                for j=1:1:n_targets
                    d(j) = d(j) + norm(com(:,:,j)-conf(:,:,j));
                end
            end
            d(j) = d(j) / gas.n_individuals;
        case 'bbbc'
            for i=1:1:bbbcs.N
                conf = decodeIndividual(pop(:,:,i));
                com = com + conf;
            end
            com = com / bbbcs.N;
            
            d = zeros(1,n_targets);
            for i=1:1:bbbcs.N
                conf = decodeIndividual(pop(:,:,i));
                for j=1:1:n_targets
                    d(j) = d(j) + norm(com(:,:,j)-conf(:,:,j));
                end
            end
            d(j) = d(j) / bbbcs.N;
    end
    
end