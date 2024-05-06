function [strResult,result] = getDesign(~,configurations)
    [~, ~ , NArrays] = size(configurations);
    max = 0;
    maxIndex = 0;
    maxLength = 0;
    for i = 1:NArrays
        if numel(nonzeros(configurations(:,end,i))) > max
            max = numel(nonzeros(configurations(:,end,i)));
            nonZMatrix = nonzeros(configurations(:,end,i));
            maxLength = nonZMatrix(end);
            maxIndex = i;
        elseif numel(nonzeros(configurations(:,end,i))) == max
            nonZMatrix = nonzeros(configurations(:,end,i));
            lastLength = nonZMatrix(end);
            if lastLength > maxLength
                maxIndex = i;
                maxLength = lastLength;
            end
        end
    end
    strDesign = " Design [ ";
    design = double.empty;
    for i = 1:max
        design(i,1) = nonzeros(configurations(i,end,maxIndex));
        strDesign = strDesign + string(nonzeros(configurations(i,end,maxIndex))) + "    ";
    end
    strDesign = strDesign + " ]";
    strResult = strDesign;
    result = design;
end