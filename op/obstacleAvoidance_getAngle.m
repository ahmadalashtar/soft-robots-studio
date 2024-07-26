function [angle_range] = obstacleAvoidance_getAngle(end_effector, robot_orientation, link_length, length_domain, obstacles, angle_domain, draw_plot)
    angle_range = angle_domain;
    nearby_obstacles = findNearbyObstacles(end_effector,link_length,length_domain(1), obstacles);
    n_nearby_obstacles = size(nearby_obstacles,2);

    angle_range_avoid = zeros(n_nearby_obstacles*2,2);

    if n_nearby_obstacles ~=0       
        
        
        if draw_plot == true
            figure;
            hold on;
            axis equal;
            xlabel('x');
            ylabel('y');
        end
        
        %-----ROTATION------------------
        robot_orientation = [robot_orientation 0];
        R = getRodriguesRotation(robot_orientation',[1 0 0]');  
        j = 1;
        for i=1:1:n_nearby_obstacles
            if obstacles(nearby_obstacles(i),3) == 0
                continue;
            end
            o = [obstacles(nearby_obstacles(i),1:2) - end_effector 0];
            r = obstacles(nearby_obstacles(i),3);
            o = (R*o')';
            
            dist_from_obstacle = norm([0 0 0]-o);
            
            %-------------INTERSECION SOLVER-----------------      
            [xout,yout] = circcirc(0,0,dist_from_obstacle,o(1),o(2),r);
            p1 = [xout(1) yout(1)];
            p2 = [xout(2) yout(2)]; 
            
            if isnan(p1(1)) || isnan(p1(2)) || isnan(p2(1)) || isnan(p2(2))
                break
            end
            
            if draw_plot == true
                th = 0:pi/50:2*pi;
                xunit = r * cos(th) + o(1);
                yunit = r * sin(th) + o(2);
                plot(xunit, yunit,'Color','b');
        
                plot([p1(1),0],[p1(2),0],'--','Color','r');
                plot([0,p2(1)],[0,p2(2)],'--','Color','r');       
            end  
            
            %---------RANGE EVALUATION------------
            range = [rad2deg(atan2(p1(2),p1(1))) rad2deg(atan2(p2(2),p2(1)))];            
            [range2 index ] = sort([abs(range(1)) abs(range(2))]);
            range2 = [range(index(1)) range(index(2))];
            
            width = abs((range(2))-(range(1)));
            range = sort(range);
            if width>180
                angle_range_avoid(j,:) = [-179 range(1)];
                j = j+1;
                angle_range_avoid(j,:) = [range(2) 180];
                j = j+1;
            else
                angle_range_avoid(j,:) = range;
                j = j+1;
            end
        end
        angle_range_avoid(j:end,:) = [];
        
        %--------MERGE RANGES-----------------
        angle_range_avoid = sort(angle_range_avoid); 
        angle_range_avoid_2 = [];
        if size(angle_range_avoid,1) > 0
            start = angle_range_avoid(1,1);
            for i=2:size(angle_range_avoid,1)
                if angle_range_avoid(i,1)<=angle_range_avoid(i-1,2)
                else
                    angle_range_avoid_2 = [angle_range_avoid_2; start angle_range_avoid(i-1,2)];
                    start = angle_range_avoid(i,1);
                end

            end
            angle_range_avoid_2 = [angle_range_avoid_2; start angle_range_avoid(end,2)];
        end
        
        %--------FIND OPENINGS-----------------
        for i=1:1:size(angle_range_avoid_2,1)
        	limit = size(angle_range,1);
        	j=1;
        	while j<=limit
        		if angle_range(j,2) <=  angle_range_avoid_2(i,1)
        			%  1)
        			%  x------x
        			%            x------x
        			%  12)
        			%  x-------x
        			%          x--------x
        			j = j+1; %skip to next target zone
        		elseif angle_range(j,1) >=  angle_range_avoid_2(i,2)
        			%  2)
        			%            x------x
        			%  x------x
        			%  13)
        			%          x--------x
        			%  x-------x
        			j = limit+1; %skip to next obstacle zone
        		elseif angle_range(j,1) ==  angle_range_avoid_2(i,1) && angle_range(j,2) ==  angle_range_avoid_2(i,2)
        			%  3)
        			%  x----------x
        			%  x----------x
        			angle_range(j,:) = [];
        			limit = limit-1;
        		elseif angle_range(j,1) <  angle_range_avoid_2(i,1) && angle_range(j,2) ==  angle_range_avoid_2(i,2)
        			%  4)
        			%  x----------x
        			%      x------x
        			angle_range(j,2) = angle_range_avoid_2(i,1);
        			j = j+1;             
        		elseif angle_range(j,1) >  angle_range_avoid_2(i,1) && angle_range(j,2) ==  angle_range_avoid_2(i,2)
        			%  5)
        			%      x------x
        			%  x----------x
        			angle_range(j,:) = [];
        			limit = limit-1;
        		elseif angle_range(j,1) ==  angle_range_avoid_2(i,1) && angle_range(j,2) >  angle_range_avoid_2(i,2)
        			%  6)
        			%  x---------x
        			%  x------x
        			angle_range(j,1) = angle_range_avoid_2(i,2);
        			j = j+1; 
        		elseif angle_range(j,1) ==  angle_range_avoid_2(i,1) && angle_range(j,2) <  angle_range_avoid_2(i,2)
        			%  7)
        			%  x-----x
        			%  x--------x
        			angle_range(j,:) = [];
        			limit = limit-1;
        		elseif angle_range(j,1) <  angle_range_avoid_2(i,1) && angle_range(j,2) <  angle_range_avoid_2(i,2)                            
        			%  8)
        			%  x-----x 
        			%     x------x
        			angle_range(j,2) = angle_range_avoid_2(i,1);
        			j = j+1;
        		elseif angle_range(j,1) >  angle_range_avoid_2(i,1) && angle_range(j,2) >  angle_range_avoid_2(i,2)
        			%  9)
        			%     x------x
        			%  x-----x  
        			angle_range(j,1) = angle_range_avoid_2(i,2);
        			j = j+1; 
        		elseif angle_range(j,1) >  angle_range_avoid_2(i,1) && angle_range(j,2) <  angle_range_avoid_2(i,2)
        			%  10)
        			%    x----x
        			%  x---------x  
        			angle_range(j,:) = [];
        			limit = limit-1;
        		elseif angle_range(j,1) <  angle_range_avoid_2(i,1) && angle_range(j,2) >  angle_range_avoid_2(i,2)
        			%  11)
        			%  x----------x
        			%     x---x                
        			angle_range = [angle_range ; angle_range(j,1) angle_range_avoid_2(i,1)];
        			angle_range = [angle_range ; angle_range_avoid_2(i,2) angle_range(j,2)];
        			angle_range(j,:) = [];
        			angle_range = sortrows(angle_range,1); 
        			limit = limit+1;
                else
                    j = j+1;
        		end            
        	end        
        end
        if size(angle_range,1) == 0
           angle_range = [angle_domain(1) angle_domain(1) ; angle_domain(2) angle_domain(2)];
        end
    end
    
    if draw_plot == true
        figure;
        hold on;
        xlim([-180 180]);
        ylim([-20 10]);
        xlabel('angle range');     
        set(gca,'YTick',[]);
        for i=1:1:size(angle_range_avoid_2,1)
            plot([angle_range_avoid_2(i,1),angle_range_avoid_2(i,2)],[0,0],'-o','Color','r');
        end        
        for i=1:1:size(angle_range,1)
            plot([angle_range(i,1),angle_range(i,2)],[-10,-10],'-o','Color','g');
        end
    end  
end