function solution = MP_searchAlgorithm(sp, algorithmName)
    sp.targetObstacles = [];
    targets = sp.targets;
    for i = 1:length(targets)
        targetP = targets{i, 1};
        targetEnd = targets{i, 2};
        
        if targetP(1) < targetEnd(1)
            
        end
    end
end

function [c1, c2] onLine(p1, p2, r)
    x1 = p1(1);
    y1 = p1(2);

    x2 = p2(1);
    y2 = p2(2);

    a = (y2 - y1) / (x2 - x1);
    b = y1 - a * x1;

    xc1 = x2 - sqrt(r * r / (a * a + 1));
    yc1 = a * xc1 + b;

    xc2 = x2 + sqrt(r * r / (a * a + 1)); 
    yc2 = a * xc2 + b;

    c1 = [xc1, yc1];
    c2 = [xc2, yc2];
end



