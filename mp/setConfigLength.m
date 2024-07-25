function resultConfig = setConfigLength(config, length)
    confLength = sum(config(:, 2));
    if confLength > length
        resultConfig = retract(config, confLength - length);
    else
        resultConfig = config;
    end
end

