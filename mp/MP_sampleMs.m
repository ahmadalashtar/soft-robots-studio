function result = MP_sampleMs(inputArray, ms)
    numberOfSteps = 0;
    % calculating the total number of steps
    for i = 1:size(inputArray, 3) -1
        difference = sum(sum(abs(inputArray(:, :, i + 1) - inputArray(:, :, i))));
        difference = 100 * (difference / ms);
        numberOfSteps = numberOfSteps + difference;
    end
    iterator = 1;
    result = zeros(size(inputArray, 1), size(inputArray, 2), numberOfSteps);
    for i = 1: size(inputArray, 3)
        if i == 1
            result(:, :, iterator) = inputArray(:, :, i);
            iterator = iterator + 1;
            continue;
        end
        if i == size(inputArray, 3)
            result(:, :, iterator) = inputArray(:, :, i);
            iterator = iterator + 1;
            continue;
        end
        difference = inputArray(:, :, i + 1) - inputArray(:, :, i);

        [row, col] = find(difference);
%         try 
            if sum(sum(difference)) > 0 
                while all(all(result(:,:, iterator) ~= all(all(inputArray(:, :, i)))))
                    result(:, :, iterator) = result(:, :, iterator-1);
                    result(row, col, iterator) = result(row, col, iterator-1) + ms;
                    iterator = iterator +1;
                end
            else
                while all(all(result(:,:, iterator) ~= all(all(inputArray(:, :, i)))))
                    result(:, :, iterator) = result(:, :, iterator-1);
                    result(row, col, iterator) = result(row, col, iterator-1) - ms;
                    iterator = iterator +1;
                end
            end
%         catch ex
%             disp(result(:,:,iterator-1));
%         end
    end
end