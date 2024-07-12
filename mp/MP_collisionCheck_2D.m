function [intersected_obstacles,j] = MP_collisionCheck_2D(conf,op)

    %these two lines are to deal with obstacles as if they are bigger to
    %avoid getting too close
    % op.obstacles(:, 3) = op.obstacles(:, 3) + 25;
%     op.obstacles(:, 5) = op.obstacles(:, 5) + 10;
   
    for ee=1:op.j
        if conf(ee,2)==0
            break
        end    
    end
    xy = MP_solveForwardKinematics2D(conf, op.home_base, false, 0);
    intersected_obstacles = false;
    for j=1:1:ee %%might cause an error
        p_start = xy(j,:);
        p_end = xy(j+1,:);
        link_length = norm(p_end(1:2)-p_start(1:2)); 
        nearby_obstacles = MP_findNearbyObstacles_2D(p_start(1:2),link_length,op.lengthMin, op.obstacles);
        n_nearby_obstacles = size(nearby_obstacles,2);
        if isequal(p_start, p_end)% the change in line 9 (j=1:1:ee-1 to j=1:1:ee causes an error when p_end and p_start are equal, so we should stop here)
            return;
        end
        for z=1:1:n_nearby_obstacles
                if MP_intersectObstacle2D([p_start; p_end],op.obstacles(nearby_obstacles(z),:),false)
                    intersected_obstacles = true;
                    break;
                end
        end  
        if intersected_obstacles
            break;
        end
    end
end

function [result,i] = checkIfZObstacle(p_start,p_end,obs)
    result = false;
    u = (p_end-p_start)/norm(p_end-p_start);
    N = p_start;
    
    R = GetRodriguesRotation(u',[0 0 1]');
    p_start_r = (R*p_start')';
    p_end_r = (R*p_end')';
    
    %This checks the intersection between the segment and the plane defined by the top of the cylinder obstacle
    n = [0 0 1];
    M = [obs(1) obs(2) obs(3)-obs(5)];
    i = line_plane_intersection(u,N,n,M);  
    if isempty(i)
        result = false;
        return;
    end
    i_r = (R*i')';    
    if p_start_r(3) <= i_r(3) && i_r(3) <= p_end_r(3)
        result = true;
    end
    %YOU SHOULD RETURN THE SEGMENT INSIDE
    
     %This checks the intersection between the segment and the plane where the obstacles lie, not needed for now
%     M = [obs(1) obs(2) obs(3)];
%     i = line_plane_intersection(u,N,n,M)
%     
%     i_r = (R*i')';
%     
%     if p_start_r(3) <= i_r(3) && i_r(3) <= p_end_r(3)
%         intersection = true;
%     end
end
function [result,i] = checkIfBaseObstacle(p_start,p_end,obs)
    result = false;
    u = (p_end-p_start)/norm(p_end-p_start);
    N = p_start;
    
    R = GetRodriguesRotation(u',[0 0 1]');
    p_start_r = (R*p_start')';
    p_end_r = (R*p_end')';
    
    %This checks the intersection between the segment and the plane defined by the top of the cylinder obstacle
    n = [0 0 1];
    M = [obs(1) obs(2) obs(3)];
    i = line_plane_intersection(u,N,n,M);  
    if isempty(i)
        result = false;
        return;
    end
    i_r = (R*i')';    
    if p_start_r(3) <= i_r(3) && i_r(3) <= p_end_r(3)
        result = true;
    end
    %YOU SHOULD RETURN THE SEGMENT INSIDE
    
     %This checks the intersection between the segment and the plane where the obstacles lie, not needed for now
%     M = [obs(1) obs(2) obs(3)];
%     i = line_plane_intersection(u,N,n,M)
%     
%     i_r = (R*i')';
%     
%     if p_start_r(3) <= i_r(3) && i_r(3) <= p_end_r(3)
%         intersection = true;
%     end
end

    function [I,rc] = line_plane_intersection(u, N, n, M, verbose)
    %% line_plane_intersection : function to compute the intersection point
    % between the (N,u) line and the (M,n) plane of the 3D space.
    %
    % Author & support : nicolas.douillet (at) free.fr, 2019-2020.
    %
    %
    % Syntax
    %
    % [I,rc] = line_plane_intersection(u, N, n, M);
    % [I,rc] = line_plane_intersection(u, N, n, M, verbose);
    %
    %
    % Description
    %
    % [I,rc] = line_plane_intersection(u, N, n, M) computes the coordinates of I,
    % the intersection point between the line (u,N) and the plane (n,M).
    % In the most generic case, I is a point in the 3D space, but when
    % the line is stricly parallel to the plane, I is the empty set, and when
    % the line is included in the plane, I is a function handle corresponding
    % to the system of parametric equations of the line.
    %
    % [I,rc] = line_plane_intersection(u, N, n, M, verbose) displays a message in
    % console when verbose is set either to logical true or real numeric 1, and
    % doesn't when it is set to logical false or real numeric 0.
    %
    %
    % Principle
    %
    % Based on solving Descartes plane equation :
    %
    % ax + by + cz + d = 0, where n = [a, b, c] is a vector normal to the plane,
    %
    % combined with the parametric equations system of a 3D line :
    %
    % x(t) = x0 + at 
    % y(t) = y0 + bt
    % z(t) = z0 + ct
    %
    % where N0 = [x0, y0, z0] is a point belonging to the line, and u = [a, b, c], a vector directing this line.
    %
    %
    % Input arguments
    %
    % - u : real row or column vector double. numel(u) = 3. One director vector of the parametric line.
    %
    % - N : real row or column vector double. numel(N) = 3. One point belonging to the line.
    %
    % - n : real row or column vector double. numel(n) = 3. One normal vector to the plane.
    %
    % - M : real row or column vector double. numel(M) = 3. One point belonging to the plane.
    %
    % - verbose : logical *true (1)/false(0), to enable/disable the verbose mode.
    %
    %
    % Output arguments
    %
    % - I = [xI yI zI], real row or column vector double, the intersection point.
    %
    % - rc : return code, integer scalar doublein the set {1,2,3}.
    %        0 : void / [] intersection
    %        1 : point intersection (unique).
    %        2 : line intersection
    %
    %        rc return code is necessary to distinguish between cases where
    %        (N,u) line and the (M,n) plane intersection is a single point
    %        and where it is the line itself.
    %
    %
    % Example #1 : one unique intersection point
    %
    % n = [1 1 1];
    % M = n;
    % u = [1 0 0];
    % N = u; % (N,u) = (OX) axis
    % [I,rc] = line_plane_intersection(u, N, n, M) % one unique intersction point expected : I = [3 0 0], rc = 1
    %
    %
    % Example #2 : line and plane are strictly // ; no intersection
    %
    % n = [0 0 1];
    % M = [0 0 0]; % (M,n) = (XOY) plan
    % u = [1 2 0];
    % N = [0 0 6];
    % [I,rc] = line_plane_intersection(u, N, n, M) % line strictly // plane =>  I = [], rc = 0 expected
    %
    %
    % Example #3 : line is included in the plane
    %
    % n = [1 1 1];
    % M = (1/3)*[1 1 1];
    % u = [1 1 -2];
    % N = [0.5 0.5 0];
    % [I,rc] = line_plane_intersection(u, N, n, M) % line belongs to the plane, rc = 2 expected
    %% Input parsing
    assert(nargin > 3,'Not enough input arguments.');
    assert(nargin < 6,'Too many input arguments.');
    if nargin < 5    
        verbose = true;    
    else    
        assert(islogical(verbose) || isreal(verbose),'verbose must be of type either logical or real numeric.');    
    end
    assert(isequal(size(u),size(N),size(n),size(M)),'Inputs u, M, n, and M must have the same size.');
    assert(isequal(numel(u),numel(N),numel(n),numel(M),3),'Inputs u, M, n, and M must have the same number of elements (3).');
    assert(isequal(ndims(u),ndims(N),ndims(n),ndims(M)),'Inputs u, M, n, and M must have the same number of dimensions.');
    %% Body
    % Plane offset parameter
    d = -dot(n,M);
    % Specific cases treatment
    if ~dot(n,u) % n & u perpendicular vectors
        if dot(n,N) + d == 0 % N in P => line belongs to the plane
            if verbose
                disp('(N,u) line belongs to the (M,n) plane. Their intersection is the whole (N,u) line.');
            end
            I = M;
            rc = 2;
        else % line // to the plane
            if verbose
                disp('(N,u) line is parallel to the (M,n) plane. Their intersection is the empty set.');
            end
            I = [];
            rc = 0;
        end
    else
        
        % Parametric line parameter t
        t = - (d + dot(n,N)) / dot(n,u);
        
        % Intersection coordinates
        I = N + u*t;
        
        rc = 1;
        
    end
end % line_plane_intersection