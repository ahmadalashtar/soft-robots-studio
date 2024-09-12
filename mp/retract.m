%{
Retracts while taking gripper constraint into account.
%}

function conf = retract(sp, conf, amountOfRet)
    for lastExpanded = size(conf, 1):-1:1
        if conf(lastExpanded, 2) ~= 0
            break;
        end
    end

    while amountOfRet > 0 && lastExpanded > 0 
        if conf(lastExpanded, 2) > amountOfRet
            conf(lastExpanded, 2) = conf(lastExpanded, 2) - amountOfRet;
            if conf(lastExpanded, 2) < sp.lengthMin && conf(lastExpanded, 1) ~= 0
                conf(lastExpanded, 2) = sp.lengthMin;
            end
            break;
        else
            amountOfRet = amountOfRet - conf(lastExpanded, 2);
            conf(lastExpanded, :) = 0;
            lastExpanded = lastExpanded - 1;
        end
    end
end