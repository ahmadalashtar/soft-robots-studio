
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
    
    x_coor=[x_upper_left x_lower_left x_lower_right x_upper_right ];
    y_coor=[y_upper_left y_lower_left y_lower_right y_upper_right ];
    if app.selectedTab == OptimizerTab
        scale = sqrt(6) * app.scalerOP;
    else
        scale = sqrt(6) * app.scalerMP;
    end
    x_coor = x_coor * scale;
    y_coor = y_coor * scale;
    shape = polyshape(x_coor,y_coor);
    ps = plot(axes,shape,'LineWidth',1,"FaceColor",'#001aff', 'FaceAlpha',1);
    
end