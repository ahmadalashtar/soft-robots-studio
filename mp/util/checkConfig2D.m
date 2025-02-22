% Checks if a given configuration is valid as per the specification or not.
function valid = checkConfig2D(sp, conf)
    valid = false;

    if size(conf, 2) ~= 2 && size(conf, 1) ~= sp.j
        return;
    end

    reachedMax = false;
    
    for i = 1:size(conf, 1)
        % Check steering.
        for j = 1
            if conf(i, j) > sp.steerBounds(2) || conf(i, j) < sp.steerBounds(1)
                return;
            end
        end

        % Check lengths.
        if reachedMax && conf(i, 2) ~= 0
            return;
        end

        if conf(i, 2) < 0 || conf(i, 2) > sp.design(i)
            return;
        end

        if conf(i, 2) == sp.design
            reachedMax = true;
            continue;
        end

        % Check length-steering mixes.
        if conf(i, 2) < sp.lengthMin && conf(i, 1) ~= 0 
            return;
        end
    end

    valid = true;
end


