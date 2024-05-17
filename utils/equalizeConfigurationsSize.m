function result = equalizeConfigurationsSize(~, configurations,designLength)
    [~,  ~, NArrays] = size(configurations);
    
    newConfiguration = zeros(designLength, 2, NArrays);
    for i = 1:NArrays
        for j = 1: designLength
            newConfiguration(j,:,i) = configurations(j,:,i);
        end
    end
    result = newConfiguration;
end