function resultConfig = setConfigLength(sp, config, length)
    confLength = sum(config(:, 2));
    if confLength > length
        resultConfig = retract(sp, config, confLength - length);
    else
        resultConfig = config;
    end
end

