function labelWithAngle(src,angle)
     if (angle <= 360 && angle >=260) || (angle <= 80 && angle >=-80)
        datatip(src, 'Location','northeast');
    elseif (angle > 170 && angle < 260) || (angle > -170 && angle <=-80)
        datatip(src, 'Location','southeast');
    elseif (angle >= -270 && angle <=-170)
        datatip(src, 'Location','southwest');
    else
        datatip(src, 'Location','northwest');
    end
end