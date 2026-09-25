function uninstall()
    % Remove all persisted Cantera settings. ::
    %
    %     >> ct.uninstall
    %
    % Removes the interface folder that :func:`ct.install` saved on the MATLAB
    % path, and clears the "Cantera" MATLAB preference group. The toolbox itself
    % is removed in the Add-On Manager; run this first, since this function is
    % part of the toolbox.

    % A loaded library keeps its files locked on Windows, which would stop the
    % Add-On Manager from deleting them.
    if ct.isLoaded
        ct.unload();
    end

    interfaceDir = toolboxPaths();
    if any(strcmp(strsplit(path, pathsep), interfaceDir))
        rmpath(interfaceDir);
        if savepath() ~= 0
            warning("ct:uninstall:SavePathFailed", ...
                    "Could not save the MATLAB path; remove %s from it manually.", ...
                    interfaceDir);
        end
        fprintf("Removed %s from the MATLAB path.\n", interfaceDir);
    end

    if ispref("Cantera")
        rmpref("Cantera");
        fprintf("Removed Cantera MATLAB preferences.\n");
    else
        fprintf("No Cantera MATLAB preferences to remove.\n");
    end
end
