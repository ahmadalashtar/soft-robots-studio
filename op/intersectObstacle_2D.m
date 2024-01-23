% Check if a segment intersects an obstacle.
%
% INPUT:
% 's' is a [2 x 2] with a pair end points of a segment
% 'o' is a [1x3] describing an obstacle (x,y,radius)
% 'draw_plot' is a boolean flag, true if you want to make sure this thing works
%
% OUTPUT:
% 'result' is a boolean value, true if the segment intersects the obstacle, false otherwise
function [result] = intersectObstacle_2D(s,o, draw_plot)
    
    % s(1,:) is segment end point 1 xy
    % s(2,:) is segment end point 2 xy
    % o(1:2) is obstacle xy
    % o(3) is obstacle radius
    
    if draw_plot==true
        figure;
        hold on;
        axis equal;
        xlabel('x');
        ylabel('y') ;       
        plot([s(1,1),s(2,1)],[s(1,2),s(2,2)],'-o','Color','r');
        
        th = 0:pi/50:2*pi;
        xunit = o(3) * cos(th) + o(1);
        yunit = o(3) * sin(th) + o(2);
        plot(xunit, yunit,'Color','r');
        
    end
    
    % some interesting math happening here
    dist_segment = point2segment_2D(o(1:2), s(1,:), s(2,:), o(3)+1);
    
    dist_e1 = norm(s(1,:)-o(1:2));
    dist_e2 = norm(s(2,:)-o(1:2));
    
    if dist_segment <= o(3) || dist_e1 <= o(3) || dist_e2 <= o(3)
        result = true;
    else
        result = false;
    end    
end

function d = point2segment_2D(pt, v1, v2, max)
    
    % voronoi rotation
    pt = pt-v1;
    v2 = v2-v1;
    v1 = v1-v1;    
    angle = -atan2(v2(2)-v1(2),v2(1)-v1(1));
    r = [cos(angle) -sin(angle);sin(angle) cos(angle)];
    
    pt = (r*pt')';
    v2 = (r*v2')';
    
    if pt(1)>=v1(1) && pt(1)<=abs(v2(1))
        a = v1 - v2;
        b = pt - v2;
        a = [a,0];
        b = [b,0];

        d = norm(cross(a,b)) / norm(a);
    else
        d = max;
    end
    
    
end

%---------------- This is for 3D, didn't use it here
function [ans] = intersectObstacle3D(s,o, draw_plot)
    
    % s(1,:) is segment end point 1 xy
    % s(2,:) is segment end point 2 xy
    % o(1:3) is obstacle xy
    % o(4) is obstacle radius
    
    if draw_plot==true
        figure;
        hold on;
        axis equal;
        xlabel('x');
        ylabel('y');
        zlabel('z');
        plot3([s(1,1),s(2,1)],[s(1,2),s(2,2)],[s(1,3),s(2,3)],'-o','Color','r');
        
        th = 0:pi/50:2*pi;
        xunit = o(4) * cos(th) + o(1);
        yunit = o(4) * sin(th) + o(2);
        zunit = 0* sin(th) + o(3);
        plot3(xunit, yunit, zunit,'Color','r');
        
        xunit = 0 * cos(th) + o(1);
        yunit = o(4) * cos(th) + o(2);
        zunit = o(4)* sin(th) + o(3);
        plot3(xunit, yunit, zunit,'Color','r');
        
        xunit = o(4) * cos(th) + o(1);
        yunit = 0 * sin(th) + o(2);
        zunit = o(4) * sin(th) + o(3);
        plot3(xunit, yunit, zunit,'Color','r');
        
    end
    
    dist_segment = Point2Segment3D(o(1:3), s(1,:), s(2,:), o(4)+1);
    
    dist_e1 = norm(s(1,:)-o(1:3));
    dist_e2 = norm(s(2,:)-o(1:3));
    
    if dist_segment <= o(4) || dist_e1 <= o(4) || dist_e2 <= o(4)
        ans = true;
    else
        ans = false;
    end    
end

function d = Point2Segment3D(pt, v1, v2, max)
    
    pt = pt-v1;
    v2 = v2-v1;
    v1 = v1-v1;    
    
    R = GetRodriguesRotation(v2,[1 0 0]');
    pt_1 = (R*pt')';
    v2_1 = (R*v2')';    
        
    if pt(1)>=v1(1) && pt(1)<=abs(v2(1))
        a = v1 - v2;
        b = pt - v2;
        d = norm(cross(a,b)) / norm(a);
    else
        d = max;
    end
    
    
end