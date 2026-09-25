function install(opts)
    % Set up the Cantera MATLAB toolbox after installing it. ::
    %
    %     >> ct.install
    %     >> ct.install(Source="C:\Downloads\ctMatlab")
    %     >> ct.install(Force=true)
    %
    % Run once after installing the toolbox; afterwards use :func:`ct.load`.
    % This moves the downloaded compiled interface into the toolbox, registers
    % the data directory shipped with the toolbox, and verifies that Cantera
    % loads. Settings persist as MATLAB preferences in the "Cantera" group, and
    % later calls do nothing unless the installation is incomplete or ``Force``
    % is true. Use :func:`ct.uninstall` to clear the settings.
    %
    % :param Source:
    %     Folder containing the downloaded interface (searched recursively).
    %     Defaults to the location where the Add-On Manager downloads it.
    % :param DataDirectory:
    %     Data directory to register instead of the one shipped with the
    %     toolbox.
    % :param Force:
    %     Reinstall even if Cantera is already installed.

    arguments
        opts.Source (1,1) string = ""
        opts.DataDirectory (1,1) string = ""
        opts.Force (1,1) logical = false
    end

    GROUP = "Cantera";
    [interfaceDir, toolboxDir] = toolboxPaths();

    if ~opts.Force && isInstalled(GROUP, interfaceDir)
        fprintf("Cantera is already installed. " + ...
                "Use ct.install(Force=true) to reinstall.\n");
        return
    end

    installInterface(interfaceDir, toolboxDir, opts.Source);

    dataDir = resolveDataDirectory(toolboxDir, opts.DataDirectory);
    setpref(GROUP, "DataDirectory", char(dataDir));
    fprintf("Registered Cantera data directory: %s\n", dataDir);

    % Set the flag only after verification, so a failed install is retried.
    verifyInstallation(dataDir);
    setpref(GROUP, "Installed", true);
    fprintf("Cantera %s installed successfully.\n", ct.version);
end

function tf = isInstalled(GROUP, interfaceDir)
    % The flag alone is not trusted: preferences outlive the toolbox when it is
    % removed in the Add-On Manager without running ct.uninstall.
    tf = ispref(GROUP, "Installed") && isequal(getpref(GROUP, "Installed"), true) ...
         && hasInterface(interfaceDir) && ispref(GROUP, "DataDirectory") ...
         && isfolder(string(getpref(GROUP, "DataDirectory")));
end

function installInterface(interfaceDir, toolboxDir, source)
    srcDir = findDownloadedInterface(toolboxDir, source);

    if srcDir == ""
        if ~hasInterface(interfaceDir)
            error("ct:install:InterfaceNotFound", ...
                  ("Could not find the downloaded Cantera interface. Pass its " + ...
                   "location with ct.install(Source=<folder>)."));
        end
        fprintf("Using the Cantera interface in %s\n", interfaceDir);
    elseif ~samePath(srcDir, interfaceDir)
        if ct.isLoaded
            ct.unload();
        end
        if ct.isLoaded
            error("ct:install:Loaded", ...
                  ("Cantera is loaded in-process and its files cannot be " + ...
                   "replaced. Restart MATLAB and run ct.install again."));
        end
        if isfolder(interfaceDir)
            rmdir(interfaceDir, "s");
        end
        movefile(srcDir, interfaceDir);
        fprintf("Moved the Cantera interface to %s\n", interfaceDir);
    end

    % Package folders are never added to the path with their parent, so the
    % interface folder has to be added explicitly.
    addpath(interfaceDir);
    if savepath() ~= 0
        warning("ct:install:SavePathFailed", ...
                ("Could not save the MATLAB path. Add %s to the path in " + ...
                 "each session, or save it manually."), interfaceDir);
    end
end

function srcDir = findDownloadedInterface(toolboxDir, source)
    srcDir = "";

    if source ~= ""
        if ~isfolder(source)
            error("ct:install:BadSource", "Folder does not exist: %s", source);
        end
        roots = source;
    else
        roots = downloadLocations(toolboxDir);
    end

    for r = roots
        hits = dir(fullfile(r, "**", "ctMatlabInterface.*"));
        if ~isempty(hits)
            srcDir = string(hits(1).folder);
            return
        end
    end

    if source ~= ""
        error("ct:install:InterfaceNotFound", ...
              "No Cantera interface found in %s", source);
    end
end

function roots = downloadLocations(toolboxDir)
    % Where the Add-On Manager places the RequiredAdditionalSoftware download.
    roots = string.empty;
    try
        roots(end+1) = string( ...
            CanteraMATLABToolbox.getInstallationLocation("ctMatlabInterface"));
    catch
    end
    roots(end+1) = fullfile(fileparts(fileparts(toolboxDir)), ...
                            "AdditionalSoftware", "ctMatlabInterface");
    roots = roots(arrayfun(@isfolder, roots));
end

function dataDir = resolveDataDirectory(toolboxDir, override)
    if override ~= ""
        if ~isfolder(override)
            error("ct:install:BadDataDir", ...
                  "Data directory does not exist: %s", override);
        end
        dataDir = override;
        return
    end

    candidates = [
        fullfile(fileparts(toolboxDir), "data")             % packaged toolbox
        fullfile(fileparts(fileparts(toolboxDir)), "data")  % source checkout
    ];
    for c = candidates'
        if ~isempty(dir(fullfile(c, "*.yaml")))
            dataDir = c;
            return
        end
    end

    error("ct:install:NoDataDir", ...
          ("Could not find the Cantera data files shipped with the toolbox. " + ...
           "Pass a folder with ct.install(DataDirectory=<folder>)."));
end

function verifyInstallation(dataDir)
    if ct.isLoaded
        ct.addDataDirectories(dataDir);
    else
        ct.load();
    end

    registered = string(ct.dataDirectories());
    if ~any(arrayfun(@(d) samePath(d, dataDir), registered))
        error("ct:install:DataDirNotRegistered", ...
              "Cantera loaded, but did not register the data directory %s", ...
              dataDir);
    end
end

function tf = samePath(a, b)
    normalize = @(p) regexprep(strrep(string(p), "\", "/"), "/+$", "");
    if ispc
        tf = strcmpi(normalize(a), normalize(b));
    else
        tf = normalize(a) == normalize(b);
    end
end
