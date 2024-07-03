function points = cutPoint2D(p0, p1, obstacle)
    x0 = p0(1);
    y0 = p0(2);

    x1 = p1(1);
    y1 = p1(2);

    xc = obstacle(1);
    yc = obstacle(2);
    r = obstacle(3);

    a = (y1 - y0) / (x1 - x0);
    b = ((y0 + y1) - a*(x0 + x1)) / 2;


    xp = (xc + a*yc - b*a) / (a*a + 1);
    yp = a*xp + b;

    
    k = sqrt((yc - yp)^2 + (xc - xp)^2);
    if k >= r
        points = [];
        return;
    end

    l = sqrt(r^2 - k^2);
    theta = atan(a);

    xT1 = l * cos(theta) + xp;
    yT1 = a * xT1 + b;

    xT2 = l * -cos(theta) + xp;
    yT2 = a * xT2 + b;


    onLine1 = ((x0 > xT1 && xT1 > x1) || (x1 > xT1 && xT1 > x0)) && ...
         ((y0 > yT1 && yT1 > y1) || (y1 > yT1 && yT1 > y0));   
     onLine2 = ((x0 > xT2 && xT2 > x1) || (x1 > xT2 && xT2 > x0)) && ...
         ((y0 > yT2 && yT2 > y1) || (y1 > yT2 && yT2 > y0));   

     points = [];
     if onLine1
         points(size(points, 1) + 1, :) = [xT1, yT1];
     end

     if onLine2
         points(size(points, 1) + 1, :) = [xT2, yT2];
     end
end