function convertedPath = pathConversion1_2D(path)
    convertedPath = [];
    for i = 1:size(path, 2)
        convertedPath = [convertedPath, path{i}];
    end
end

