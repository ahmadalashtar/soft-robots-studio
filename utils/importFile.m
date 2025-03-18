function value = importFile(app)
    [fileName, pathName] = uigetfile('*.mat', 'Select a .mat file');

    if ischar(fileName) && ischar(pathName)
        % File selected successfully
        fullPath = fullfile(pathName, fileName);
        
        % Now, you can load the .mat file or process it as needed
        % For example, you can use the "load" function to load the data:
        app.loadedData = load(fullPath);
        value = true;
        return
        % Perform further actions with the loaded data
        
    end
    value = false;
end


% function value = importFile(app, fileName)
% 
%     app.loadedData = load(fileName);
%     value = true;
% 
% end
