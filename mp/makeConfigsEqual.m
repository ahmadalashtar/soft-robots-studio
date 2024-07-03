function [conf1, conf2, retraction] = makeConfigsEqual(config1, config2)
    length1 = 0;
    for i = 1:size(config1, 1)
        length1 = length1 + config1(i, 2);
    end

    length2 = 0;
    for i = 1:size(config2, 1)
        length2 = length2 + config2(i, 2);
    end

    if length1 > length2
        for i = 1:size(config2, 1)
            if config2(i, 2) == 0
                config1(i, 1) = 0;
            end
            config1(i, 2) = config2(i, 2);
        end
    else
        if config1(i, 2) == 0
            config2(i, 1) = 0;
        end
         for i = 1:size(config1, 1)
            config2(i, 2) = config1(i, 2);
         end
    end

    retraction = length1 - length2;
    
    conf1 = config1;
    conf2 = config2;
end

