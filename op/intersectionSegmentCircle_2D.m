% This function returns the intersection point between a segment and a circle
% doesn't really work though, we should fix this script
%
% INPUT:
% 's' is a segment composed of two endpoints [2x2] with their coordinates
% 'c' is a circle [1x3] composed of its coordinates x,y and its radius
% 'draw_plot' is a boolean flag, true if you want to plot what the function does (for debug)
%
% OUTPUT:
% 'p' is the intersection point [1x2] x,y
% 'inter' is a boolean flag, true if segment and circle do intersect, false otherwise (so 'p' would be empty)
function [p,inter] = intersectionSegmentCircle_2D(s,c,draw_plot)

    if draw_plot==true
        figure;
        hold on;
        axis equal;
        xlabel('x');
        ylabel('y');
        plot([s(1,1),s(2,1)],[s(1,2),s(2,2)],'-o','Color','r');

        th = 0:pi/50:2*pi;
        xunit = c(3) * cos(th) + c(1);
        yunit = c(3) * sin(th) + c(2);
        plot(xunit, yunit,'Color','r');

    end

    seg_1 = s(1,:);             %segment starting point
    seg_2 = s(2,:);             %segment ending point
    length = norm(seg_1-seg_2); %segment length
    cir_o = c(1:2);             %circle origin
    r = c(3);                   %circle radius

    if findDiscriminant(seg_1,seg_2,cir_o,r) < 0
        %no intersection
        inter = false;
        p = [0,0];
    else
        u = (seg_2-seg_1)/norm(seg_2-seg_1);    % unit vector for line direction
        
        % to find the intersections, I solved a system of 3 equations:
        % - equation of the line on x dimension
        % - equation of the line on y dimension
        % - equation of the circle with x and y as intersection with the line
        % this system might have 0 to 2 solutions:
        % - 0 solutions --> there is no intersection
        % - 1 solution --> there is only 1 intersection (line is tangent to the circle)
        % - 2 solutions --> the line is crossing the circle so there are 2 intersections

        %-----------------SOLVER-----------------------
        syms x y k
        eqn1 = x == k*u(1) + seg_1(1);
        eqn2 = y == k*u(2) + seg_1(2);
        eqn3 = (x-cir_o(1))^2 + (y-cir_o(2))^2 == r^2;
        sol = solve([eqn1, eqn2, eqn3], [x, y, k]);
        
        valid_indicesX = zeros(size(sol.x));
        valid_indicesY = zeros(size(sol.y));
        valid_indicesK = zeros(size(sol.k));
        ctr = 1;
        for i = 1:size(sol.k)
            if sol.k(i) >= 0 && sol.k(i) <= length
                valid_indicesX(ctr) = sol.x(i);
                valid_indicesY(ctr) = sol.y(i);
                valid_indicesK(ctr) = sol.k(i);
                ctr = ctr + 1;
            else
                p = [0,0];
                inter = false;
                return;
            end
        end
        
        sol.x = valid_indicesX;
        sol.y = valid_indicesY;
        sol.k = valid_indicesK;

        nSolutions = (size(sol.x));
        nSolutions = nSolutions(1);
        
        if(nSolutions==1)
            % one solution, the line is tangent to the circle
            x1 = double(sol.x(1));
            y1 = double(sol.y(1));

            k1 = real(double(sol.k(1)));
            if k1<=length
                p = [x1,y1];
                inter = true;
                if draw_plot==true
                    plot(p(1),p(2),'-x','Color','b');
                end
            else
                p = [0,0];
                inter = false;
            end
        else
            % two solutions, the line intersects the circle twice
            x1 = double(sol.x(1));
            y1 = double(sol.y(1));

            x2 = double(sol.x(2));
            y2 = double(sol.y(2));

            k1 = real(double(sol.k(1)));
            k2 = real(double(sol.k(2)));

            if(k1<k2)
                if k1<=length
                    p = [x1,y1];
                    inter = true;
                    if draw_plot==true
                        plot(p(1),p(2),'-x','Color','b');
                    end
                else
                    p = [0,0];
                    inter = false;
                end
            else
                if k2<=length
                    p = [x2,y2];
                    inter = true;
                    if draw_plot==true
                        plot(p(1),p(2),'-x','Color','b');
                    end
                else
                    p = [0,0];
                    inter = false;
                end
            end
        end
        
        
        
            
        %---------------------------------------------
%         k1 = (cir_o(1)*u(1) + cir_o(2)*u(2) - seg_1(1)*u(1) - seg_1(2)*u(2) + (- cir_o(1)^2*u(2)^2 + 2*cir_o(1)*cir_o(2)*u(1)*u(2) + 2*cir_o(1)*seg_1(1)*u(2)^2 - 2*cir_o(1)*seg_1(2)*u(1)*u(2) - cir_o(2)^2*u(1)^2 - 2*cir_o(2)*seg_1(1)*u(1)*u(2) + 2*cir_o(2)*seg_1(2)*u(1)^2 + r^2*u(1)^2 + r^2*u(2)^2 - seg_1(1)^2*u(2)^2 + 2*seg_1(1)*seg_1(2)*u(1)*u(2) - seg_1(2)^2*u(1)^2)^(1/2))/(u(1)^2 + u(2)^2);
%         k2 = -(seg_1(1)*u(1) - cir_o(2)*u(2) - cir_o(1)*u(1) + seg_1(2)*u(2) + (- cir_o(1)^2*u(2)^2 + 2*cir_o(1)*cir_o(2)*u(1)*u(2) + 2*cir_o(1)*seg_1(1)*u(2)^2 - 2*cir_o(1)*seg_1(2)*u(1)*u(2) - cir_o(2)^2*u(1)^2 - 2*cir_o(2)*seg_1(1)*u(1)*u(2) + 2*cir_o(2)*seg_1(2)*u(1)^2 + r^2*u(1)^2 + r^2*u(2)^2 - seg_1(1)^2*u(2)^2 + 2*seg_1(1)*seg_1(2)*u(1)*u(2) - seg_1(2)^2*u(1)^2)^(1/2))/(u(1)^2 + u(2)^2);
        
    end
end

function [disc] = findDiscriminant(seg_1,seg_2,cir_o,r)
    d = seg_2 - seg_1;
    f = seg_1 - cir_o;
    a = dot(d,d);
    b = 2*dot(f,d);
    c = dot(f,f) - r^2 ;
    disc = b^2 - 4*a*c;
end
