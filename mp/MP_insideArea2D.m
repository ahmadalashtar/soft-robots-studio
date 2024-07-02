%{
Function that finds if a point is inside the area of a polygon in 2D.

Inputs:
polygon (number_of_points, 2): 
    Points of a polygon where each point is the row.
point (1, 2):
    The point to check if it is inside the area of a polygon.

Outputs:
inside (1, 1):
    boolean flag indicating whether the point is inside the polygon or not.

Requirements:
Any point of a polygon P at index i must have neighbours that are at
indexes (i - 1) mod size(P) and (i + 1) mod size(P).

%}

function [inside] = MP_insideArea2D(polygon, point)
    for i = 1:size(polygon, 1)
        origin = polygon(i, :);
        n1 = polygon(mod(i - 2, size(polygon, 1)) + 1, :);
        n2 = polygon(mod(i, size(polygon, 1)) + 1, :);
        
        n1
        n2
        disp("--------")

        n1XSide = sign(n1(1) - origin(1));
        n2XSide = sign(n2(1) - origin(1));
        commonSign = sign(n1XSide + n2XSide);
        if (commonSign ~= 0)
            if (sign(point(1) - origin(1)) ~= commonSign)
                inside = false;
                return;
            end
            disp("xsided")
        else
            n1YSide = sign(n1(2) - origin(2));
            n2YSide = sign(n2(2) - origin(2));
            commonSign = sign(n1YSide + n2YSide);
            if (sign(point(2) - origin(2)) ~= commonSign)
                inside = false;
                return;
            end
        end

        m1 = ((n1(2) - origin(2)) / (n1(1) - origin(1)))
        m2 = ((n2(2) - origin(2)) / (n2(1) - origin(1)))
        mp = ((point(2) - origin(2)) / (point(1) - origin(1)))

        mMin = min(m1, m2);
        mMax = max(m1, m2);
        if (~(mp > mMin && mp < mMax))
            inside = false;
            return;
        end
    end
    inside = true;
    return;
end




