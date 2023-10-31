function loadVariables(opVar)
    global op;    
    op.home_base = opVar.home_base
    op.targets = opVar.targets;
    op.obstacles = opVar.obstacles;
    op.n_nodes = opVar.n_nodes;
    op.angle_domain = opVar.angle_domain;
    op.length_domain = opVar.length_domain;
        
    op.first_angle.is_fixed = opVar.first_angle.is_fixed;
    op.first_angle.angle = opVar.first_angle.angle;
   
end

