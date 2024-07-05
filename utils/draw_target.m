function ps = draw_target(~, x, y, angle, axes,scaler)
    % Define the star coordinates as a matrix
    star = [cosd(90) sind(90)
            (1/3)*cosd(54) (1/3)*sind(54)
            cosd(18) sind(18)
            (1/3)*cosd(342) (1/3)*sind(342)
            cosd(306) sind(306)
            (1/3)*cosd(270) (1/3)*sind(270)
            cosd(234) sind(234)
            (1/3)*cosd(198) (1/3)*sind(198)
            cosd(162) sind(162)
            (1/3)*cosd(126) (1/3)*sind(126)
            cosd(90) sind(90)];
    
    % Double the size using a scaling factor of 2
    scale = 6 * scaler;
    scaling_matrix = [scale 0; 0 scale];
    
    % Apply the scaling matrix to the star coordinates
    star = star * scaling_matrix;
    
    % Translate the star coordinates
    star = star + [x y];
    
    % Create the polyshape and rotate it
    shape = polyshape(star);
    shape = rotate(shape, angle, [x y]);
    ps = plot(axes, shape, 'LineWidth', 1, "FaceColor", "blue");
end
