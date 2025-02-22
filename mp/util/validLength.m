function length = validLength(configPos, obstacle)
    length = 0;
    for i = 2:size(configPos, 1)
        if isnan(configPos(i, 1))
            return;
        end

        p0 = configPos(i - 1, :);
        p1 = configPos(i, :);

        collidedPoints = cutPoint2D(p0, p1, obstacle);
        if ~isempty(collidedPoints)
            closestPoint = collidedPoints(1, :);
            closestDist = pythagoras(p0, closestPoint);
            for p = 1:size(collidedPoints, 1)
                p = collidedPoints(p, :);
                dist = pythagoras(p0, p);
                if dist < closestDist
                    closestDist = dist;
                end
            end

            length = length + closestDist;
            return;
        end

        length = length + pythagoras(p0, p1);
    end
end


