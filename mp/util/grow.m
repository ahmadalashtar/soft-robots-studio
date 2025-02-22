function conf = grow(sp, conf, amountOfGrow)
    for lastExpanded = size(conf, 1):-1:1
        if conf(lastExpanded, 2) ~= 0
            break;
        end
    end

    while amountOfGrow > 0 && lastExpanded <= size(conf, 1)
        diff = sp.design(lastExpanded) - conf(lastExpanded, 2);
        if sp.design(lastExpanded) - conf(lastExpanded, 2) > amountOfGrow
            conf(lastExpanded, 2) = conf(lastExpanded, 2) + amountOfGrow;
            break;
        else
            conf(lastExpanded, 2) = sp.design(lastExpanded);
            amountOfGrow = amountOfGrow - diff;
            lastExpanded = lastExpanded + 1;
        end
    end
end

