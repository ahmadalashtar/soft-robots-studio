function intersec = circleSegmentIntersection(c, p)
    % Extract circle parameters
    cx = c(1); cy = c(2); r = c(4);
    
    % Extract point coordinates
    px = p(1); py = p(2);
    
    % Vector from p to circle center
    dx = cx - px;
    dy = cy - py;
    
    % Compute parameter t for intersection using quadratic equation
    a = dx^2 + dy^2;
    b = -2 * (dx * (cx - px) + dy * (cy - py));
    c = (cx - px)^2 + (cy - py)^2 - r^2;
    
    % Solve quadratic equation for t
    discriminant = b^2 - 4 * a * c;
    if discriminant < 0
        error('No intersection found.');
    end
    
    sqrt_disc = sqrt(discriminant);
    t1 = (-b + sqrt_disc) / (2 * a);
    t2 = (-b - sqrt_disc) / (2 * a);
    
    % Choose the intersection point closer to p (i.e., smaller t)
    t = min(t1, t2);
    
    % Compute intersection point
    intersec = [px + t * dx, py + t * dy];
end