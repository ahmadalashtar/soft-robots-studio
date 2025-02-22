function result = MP_smoothMatrix_2D(inputArray)
    tempStack = Stack();
    growCounter = 0;
    retractCounter = 0;
    for i = 1: size(inputArray, 3)
        if (tempStack.get_size() < 1)
            tempStack.push(inputArray(:, :, i));
            continue;
        end
        difference = tempStack.peek() - inputArray(:, :, i);
        if all(all(difference(:, 1) == 0)) && sum(difference(:, 2)) < 0  % growing
            growCounter = growCounter +1;
            tempStack.push(inputArray(:, :, i));
            
            if retractCounter > 0
                for m = 1: retractCounter +1 % + growCounter
                    tempStack.pop();
                end
                growCounter = 0;
                retractCounter = 0;
            end
            continue;
        end
        if all(all(difference(:, 1) == 0)) && sum(difference(:, 2)) > 0  % retracting 
            retractCounter = retractCounter + 1;
            tempStack.push(inputArray(:, :, i));
            
            if growCounter > 0
                for m = 1: growCounter +1 %+ retractCounter
                    tempStack.pop();
                end
                growCounter = 0;
                retractCounter = 0;
            end
            continue;
        end
        if any(any(difference(:, 1) == 0))
                growCounter = 0;
                retractCounter = 0;
                tempStack.push(inputArray(:, :, i));
        end
    end
    
    result = zeros(size(inputArray, 1), size(inputArray, 2), tempStack.get_size());
    for k = tempStack.get_size() : -1 : 1 
        result(:,:,k) = tempStack.peek();
        tempStack.pop();
    end
end
