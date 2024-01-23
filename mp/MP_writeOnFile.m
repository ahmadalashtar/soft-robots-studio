function MP_writeOnFile(path, fileName)
    
% Open the file for writing (creates the file if it doesn't exist)
    fileID = fopen(fileName, 'w');
    
    if fileID == -1
        error('Could not open the file for writing.');
    else
        % Iterate over the elements of the array and write them to the file
        [rows, cols, matrices] = size(path);
        for m = 1: matrices
            for i = 1: rows
                for j = 1: cols
                    fprintf(fileID, '%f ', path(i, j, m));
                end
                fprintf(fileID, '\n');  % Start a new line for each row
            end
            fprintf(fileID, '\n\n\n');  % Start a new line for each row
        end
    
        % Close the file
        fclose(fileID);
        disp('Array data has been written to the file.');
    end
end