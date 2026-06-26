function load(mode)
    % Load the MATLAB-to-C++ Interface
    %
    % Usage:
    %   ct.load                % defaults to 'outofprocess'
    %   ct.load('inprocess')   % load in-process
    %   ct.load('outofprocess')% load out-of-process
    %
    % On load, the directory containing the Cantera shared library (and its
    % dependency libraries) is placed on the OS dynamic-loader search path, and
    % the Cantera data directory is registered, so that MATLAB does not need to
    % be launched from an activated conda environment. The library directory is
    % resolved from (in order): a persisted preference, the CANTERA_LIB_PATH
    % environment variable, or an interactive folder picker on the first run.
    % Configure it non-interactively with :func:`ct.configureCanteraDirectories`.

    arguments
        mode (1,1) string {mustBeMember(mode, ...
                           ["inprocess", "outofprocess"])} = "outofprocess"
    end

    if ct.isLoaded
        mode_ = ct.executionMode;
        msg = sprintf('Cantera %s is already loaded (%s mode).', ct.version, mode_);
        warning("load:IsLoaded", msg);
        if mode == mode_ && mode == "inprocess"
            return
        elseif mode ~= mode_ && mode_ == "inprocess"
            error("load:LoadFailed", ...
                  ("Unloading of `ctMatlab` library is not supported for " + ...
                   "'inprocess' execution mode. Restart MATLAB to update."));
            return
        else
            ct.unload();
        end
    end

    % Resolve where the Cantera shared library and its dependencies live so the
    % OS dynamic loader can find them. "" means "unknown": load proceeds without
    % injecting a path (e.g. MATLAB launched from an activated conda env).
    libDir = resolveLibDir();

    % Out-of-process mode on R2025a+ can pass environment variables to the child
    % library process; otherwise we must fall back to setenv in this process.
    useOOPEnv = ~isMATLABReleaseOlderThan("R2025a") && mode == "outofprocess";

    pathVar = buildLoaderPathVar(libDir);

    if ~useOOPEnv
        applyLoaderEnvInProcess(pathVar);
    end

    global ctMatlab
    if ~ct.isLoaded
        if useOOPEnv && numEntries(pathVar) > 0
            ctMatlab = clibConfiguration("ctMatlab", ExecutionMode=mode, ...
                                   OutOfProcessEnvironmentVariables=pathVar);
        else
            ctMatlab = clibConfiguration("ctMatlab", ExecutionMode=mode);
        end
    end

    ctVersion = ct.version;

    if libDir ~= ""
        registerDataDir(libDir);
    end

    fprintf('Cantera %s is ready for use (%s mode).\n', ctVersion, mode);
end

function libDir = resolveLibDir()
    % Resolve the Cantera library directory. Returns "" if none.
    GROUP = "Cantera";
    LIB_KEY = "LibraryDirectory";

    % 1. Persisted preference.
    if ispref(GROUP, LIB_KEY)
        libDir = string(getpref(GROUP, LIB_KEY));
        if isValidLibDir(libDir)
            return
        end
        warning("ct:load:StalePref", ...
                ("Stored Cantera library directory is no longer valid: %s\n" + ...
                 "Update it with ct.configureCanteraDirectories(<dir>)."), libDir);
    end

    % 2. Environment variable (used, not persisted; keeps CI stateless).
    envLib = string(getenv("CANTERA_LIB_PATH"));
    if envLib ~= "" && isValidLibDir(envLib)
        libDir = envLib;
        return
    end

    % 3. Interactive folder picker, only when a desktop UI is available.
    if canPrompt()
        libDir = promptForLibDir(GROUP, LIB_KEY);
        return
    end

    % 4. Nothing available: proceed without injecting a loader path.
    warning("ct:load:NoLibDir", ...
            ("Cantera library directory is not configured. If loading fails, " + ...
             "set it with ct.configureCanteraDirectories(<dir>) or the " + ...
             "CANTERA_LIB_PATH environment variable."));
    libDir = "";
end

function libDir = promptForLibDir(GROUP, LIB_KEY)
    % Prompt the user for the Cantera library directory and persist it.
    libDir = "";

    msg = "Select the directory that contains the Cantera shared library " + ...
          "(cantera_shared.dll on Windows, libcantera_shared.* on " + ...
          "Linux/macOS) and its dependency libraries. For a conda " + ...
          "installation this is typically the environment's Library\bin " + ...
          "(Windows) or lib (Linux/macOS) folder.";
    uiwait(msgbox(char(msg), "Configure Cantera", "modal"));

    sel = uigetdir(pwd, "Select Cantera library directory");
    if isequal(sel, 0)
        warning("ct:load:NoLibDir", ...
                "No directory selected; proceeding without setting the loader path.");
        return
    end

    sel = string(sel);
    if ~isValidLibDir(sel)
        warning("ct:load:BadSelection", ...
                "Selected directory does not contain a Cantera shared library: %s", sel);
        return
    end

    setpref(GROUP, LIB_KEY, char(sel));
    inferred = inferDataDir(sel);
    if inferred ~= ""
        setpref(GROUP, "DataDirectory", cellstr(inferred));
    end
    libDir = sel;
end

function tf = isValidLibDir(d)
    % True if d is a folder containing a Cantera shared library.
    tf = false;
    if d == "" || ~isfolder(d)
        return
    end
    try
        ctLib(d);  % errors if no shared library is present
        tf = true;
    catch
        tf = false;
    end
end

function tf = canPrompt()
    % True only when an interactive desktop is available (so uigetdir will not
    % block headless or -batch sessions such as CI).
    tf = usejava('desktop') && ~batchStartupOptionUsed;
end

function pathVar = buildLoaderPathVar(libDir)
    % Build the OS-specific dynamic-loader environment dictionary, merging the
    % Cantera library directory (and, on macOS, MATLAB's own libraries) with the
    % current value of the relevant environment variable.
    pathVar = dictionary(string.empty, string.empty);

    if ispc
        varName = "PATH";
        existing = string(getenv("PATH"));
        extra = strings(0, 1);
    elseif ismac
        varName = "DYLD_LIBRARY_PATH";
        arch = computer("arch");
        existing = string(getenv("DYLD_LIBRARY_PATH"));
        % MATLAB's own runtime libraries (previously the only entry set here).
        extra = [matlabroot + "/bin/" + arch; matlabroot + "/sys/os/" + arch];
    else
        varName = "LD_LIBRARY_PATH";
        existing = string(getenv("LD_LIBRARY_PATH"));
        extra = strings(0, 1);
    end

    parts = strings(0, 1);
    if libDir ~= ""
        parts = [parts; libDir];
    end
    parts = [parts; extra];
    if existing ~= ""
        parts = [parts; split(existing, pathsep)];
    end

    parts = parts(parts ~= "");
    parts = unique(parts, "stable");

    if isempty(parts)
        return
    end

    pathVar(varName) = strjoin(parts, pathsep);
end

function applyLoaderEnvInProcess(pathVar)
    % Apply the loader environment via setenv. Used when
    % OutOfProcessEnvironmentVariables is unavailable (in-process mode, or
    % MATLAB older than R2025a).
    if numEntries(pathVar) == 0
        return
    end

    k = keys(pathVar);
    for i = 1:numel(k)
        setenv(char(k(i)), char(pathVar(k(i))));
    end

    if ~ispc
        warning("ct:load:InProcessEnvUnreliable", ...
                ("Setting %s after MATLAB has started may not affect the " + ...
                 "dynamic loader. If Cantera fails to load, use out-of-process " + ...
                 "mode on R2025a or newer, or launch MATLAB with the library " + ...
                 "directory already on the loader path."), char(k(1)));
    end
end

function registerDataDir(libDir)
    % Register the Cantera data directory (best-effort; never throws).
    GROUP = "Cantera";
    DATA_KEY = "DataDirectory";
    try
        if ispref(GROUP, DATA_KEY)
            dataDir = string(getpref(GROUP, DATA_KEY));
        else
            dataDir = inferDataDir(libDir);
        end

        dataDir = reshape(dataDir, 1, []);
        dataDir = dataDir(arrayfun(@isfolder, dataDir));

        if isempty(dataDir)
            warning("ct:load:NoDataDir", ...
                    ("Could not determine a Cantera data directory. Add one " + ...
                     "with ct.addDataDirectories if data files are not found."));
            return
        end

        ct.addDataDirectories(dataDir);
    catch ME
        warning("ct:load:DataDirFailed", ...
                "Failed to register Cantera data directory (%s).", ME.message);
    end
end
