% Checks if a given config is valid given constraints in sp.
function isValid = checkConfig(sp, config)
    isValid = false;
    %Check if number of joints is correct.
    if size(config, 1) ~= sp.j
        return;
    end

    for i = 1:sp.j
        %Check if steerings are in between bounds.
        %Check if the expanded link lengths are correct.
        %Check if min length constraint is violated.
        if (config(i, 1) < sp.steerBounds(1) || config(i, 1) > sp.steerBounds(2)) || ...
                (config(i, 2) > sp.design(i)) || ...
                (config(i, 2) < sp.lengthMin && config(i, 1) ~= 0)
            return;
        end
    end
    isValid = true;
end

