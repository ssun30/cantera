function dataDir = inferDataDir(libDir)
    % Best-effort inference of the Cantera data directory from a library dir.
    %
    % Given the directory that holds the Cantera shared library, guess where the
    % data files (e.g. ``gri30.yaml``) shipped with that installation live, based
    % on the common conda and pip layouts. Returns the first existing candidate
    % folder, or "" if none can be found.
    %
    % This is a best-effort helper: callers must treat "" as "unknown" and must
    % not fail when no directory is found.
    arguments
        libDir (1,1) string
    end

    dataDir = "";

    if libDir == "" || ~isfolder(libDir)
        return
    end

    candidates = string.empty;

    if ispc
        % conda on Windows: libDir is typically <prefix>\Library\bin
        prefix = fileparts(fileparts(libDir));
        candidates(end+1) = fullfile(prefix, "share", "cantera", "data");
        candidates(end+1) = fullfile(prefix, "Library", "share", "cantera", "data");
    else
        % conda on Linux/macOS: libDir is typically <prefix>/lib
        prefix = fileparts(libDir);
        candidates(end+1) = fullfile(prefix, "share", "cantera", "data");
    end

    % pip / wheel: the cantera package ships its own data folder
    candidates(end+1) = fullfile(libDir, "data");
    candidates(end+1) = fullfile(fileparts(libDir), "cantera", "data");

    for c = candidates
        if isfolder(c)
            dataDir = c;
            return
        end
    end
end
