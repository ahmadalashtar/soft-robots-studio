function ps = draw_obstacle(~,x,y,radius,axes)
    % Draws a circle 
    % Returns the cricle

    circle = polyshape(cosd(0:1:360) * radius + x, sind(0:1:360) * radius + y);
    ps = plot(axes,circle,'LineWidth',1,'FaceColor','#4DBEEE'); % 'b' for blue outline

end