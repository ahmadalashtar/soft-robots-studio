function resultConfig = setConfigLength(config, length)
    totalLength = 0;
    resultConfig = config;
    for i = 1:size(config, 1)
        totalLength = totalLength + config(i, 2);
        if totalLength > length
            config(i, 2) = length - (totalLength - config(i, 2));
            for j = i+1:size(config, 1)
                config(j, :) = 0;
            end
            resultConfig = config;
            return;
        end
    end
end

