
function ps = draw_base(app,x,y,angle,axes)
    % Draws a rectangle
    % Returns the rectangle
    theta=angle*pi/180;
    H = 3;
    L = H;
    center_location = [ x y];
    center1=center_location(1);
    center2=center_location(2);
    
    R= ([cos(theta), -sin(theta); sin(theta), cos(theta)]);
    
    X=([-L/2, L/2, L/2, -L/2]);
    Y=([-H/2, -H/2, H/2, H/2]);

    T = zeros(2,4);
    for i=1:4
    T(:,i)=R*[X(i); Y(i)];
    end
    
    x_lower_left=center1+T(1,1);
    x_lower_right=center1+T(1,2);
    x_upper_right=center1+T(1,3);
    x_upper_left=center1+T(1,4);
    
    y_lower_left=center2+T(2,1);
    y_lower_right=center2+T(2,2);
    y_upper_right=center2+T(2,3);
    y_upper_left=center2+T(2,4);
    
    % Define coordinates
    x_coor = [x_upper_left, x_lower_left, x_lower_right, x_upper_right];
    y_coor = [y_upper_left, y_lower_left, y_lower_right, y_upper_right];
    
    % Determine scale based on the selected tab
    if app.selectedTab == app.OptimizerTab
        scale = sqrt(6) * app.scalerOP;
    else
        scale = sqrt(6) * app.scalerMP;
    end
    
    % Calculate the centroid of the shape
    centroid_x = mean(x_coor);
    centroid_y = mean(y_coor);
    
    % Scale the coordinates relative to the centroid
    x_coor_scaled = centroid_x + (x_coor - centroid_x) * scale;
    y_coor_scaled = centroid_y + (y_coor - centroid_y) * scale;
    
    % Create the scaled shape
    shape = polyshape(x_coor_scaled, y_coor_scaled);
    ps = plot(axes,shape,'LineWidth',1,"FaceColor",'#001aff', 'FaceAlpha',1);
    
end