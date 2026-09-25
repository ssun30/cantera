function tf = hasInterface(folder)
    % True if folder contains the compiled Cantera MATLAB interface.
    arguments
        folder (1,1) string
    end

    tf = isfolder(folder) && ...
         ~isempty(dir(fullfile(folder, "ctMatlabInterface.*")));
end
