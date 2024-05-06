function ps = draw_target(~,x,y,angle,axes)
    % draws a star
    star = [cosd(90)+x sind(90)+y
            (1/3)*cosd(54)+x (1/3)*sind(54)+y
            cosd(18)+x sind(18)+y
            (1/3)*cosd(342)+x (1/3)*sind(342)+y
            cosd(306)+x sind(306)+y
            x -1/3+y
            cosd(234)+x sind(234)+y
            (1/3)*cosd(198)+x (1/3)*sind(198)+y
            cosd(162)+x sind(162)+y
            (1/3)*cosd(126)+x (1/3)*sind(126)+y
            cosd(90)+x sind(90)+y ];

    shape = polyshape(star);
    shape = rotate(shape,angle,[x y ]);
    ps = plot(axes,shape,'LineWidth',1);
    
end