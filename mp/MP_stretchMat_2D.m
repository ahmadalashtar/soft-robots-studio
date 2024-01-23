function result = MP_stretchMat_2D(inputArray, requiredSize, stepSize)
    indicesFactor = floor(requiredSize / size(inputArray, 3));  
    result = zeros(size(inputArray, 1), size(inputArray, 2), (indicesFactor * size(inputArray, 3)) -1);
    for i = 1:size(inputArray, 3)
        if i == 1
            result(:, :, 1) = inputArray(:, :, 1);
            continue;
        end
        result(:, :, (i-1) * indicesFactor) = inputArray(:, :, i);
    end
    stepSize = stepSize / (indicesFactor-1);
    for i = 0:indicesFactor:size(result, 3) - indicesFactor
        if i == 0
            i = 1;
        end
        if i ==1
            difference = result(:, :, i+ indicesFactor-1) - result(:, :, i);
        else
            difference = result(:, :, i+ indicesFactor) - result(:, :, i);
        end
        [row, col] = find(difference);

        if col == 2 % if it does eversion
            for j = 1:indicesFactor - 1
                result(:, :, i +j) = result(:, :, i + j - 1);
                result(unique(row), unique(col), i + j) = result(unique(row), unique(col), i + j) + (stepSize(2)* sign(difference(unique(row), unique(col))));
            end
        else % if it was steering
            for j = 1:indicesFactor - 1
                result(:, :, i + j) = result(:, :, i + j - 1);
                result(unique(row), unique(col), i + j) = result(unique(row), unique(col), i + j) + (stepSize(1)* sign(difference(unique(row), unique(col))));
            end
        end
    end
    lastIndex = 0;
    for i = size(result, 3): -1 : 1
        if all(all(result(:, :, i) == 0))
            continue;
        else 
            lastIndex = i;
            break;
        end
    end
    result = result(:,:, 1: lastIndex);
end
