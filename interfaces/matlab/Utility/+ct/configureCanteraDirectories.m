function out = configureCanteraDirectories(libDir, dataDir, opts)
    % Configure and persist the Cantera library and data directories. ::
    %
    %     >> ct.configureCanteraDirectories                       % report current config
    %     >> ct.configureCanteraDirectories("C:\...\Library\bin") % set library dir, infer data dir
    %     >> ct.configureCanteraDirectories(libDir, dataDir)      % set both explicitly
    %     >> ct.configureCanteraDirectories(Reset=true)           % clear persisted settings
    %
    % :func:`ct.load` uses these persisted settings to put the Cantera library
    % directory on the OS dynamic-loader search path and to register the data
    % file search directory, so that MATLAB does not need to be launched from an
    % activated conda environment.
    %
    % The library directory is the folder that contains the Cantera shared
    % library (``cantera_shared.dll`` on Windows, ``libcantera_shared.*`` on
    % Linux/macOS) together with its dependency libraries. When the data
    % directory is omitted it is inferred from the library location and stored;
    % pass it explicitly to override the guess or to register custom data
    % directories.
    %
    % Settings are stored as MATLAB preferences under the "Cantera" group and
    % persist across MATLAB sessions. This function never prompts; the
    % interactive folder picker lives in :func:`ct.load`.
    %
    % :param libDir:
    %     Directory containing the Cantera shared library.
    % :param dataDir:
    %     Optional string or string array of data directories to persist. When
    %     omitted while setting ``libDir``, the data directory is inferred.
    % :param Reset:
    %     If true, clear all persisted Cantera directory settings.
    % :return:
    %     Struct with fields ``libDir`` and ``dataDir`` describing the resolved
    %     configuration.
    arguments
        libDir (1,1) string = ""
        dataDir (1,:) string = string.empty
        opts.Reset (1,1) logical = false
    end

    GROUP = "Cantera";
    LIB_KEY = "LibraryDirectory";
    DATA_KEY = "DataDirectory";

    if opts.Reset
        if ispref(GROUP, LIB_KEY)
            rmpref(GROUP, LIB_KEY);
        end
        if ispref(GROUP, DATA_KEY)
            rmpref(GROUP, DATA_KEY);
        end
        fprintf("Cleared persisted Cantera directories.\n");
        if nargout > 0
            out = reportConfig(GROUP, LIB_KEY, DATA_KEY);
        end
        return
    end

    % Persist the library directory (and infer the data directory if not given).
    if libDir ~= ""
        if ~isfolder(libDir)
            error("ct:configureCanteraDirectories:BadLibDir", ...
                  "Library directory does not exist: %s", libDir);
        end
        ctLib(libDir);  % validates a shared library is present; errors otherwise
        setpref(GROUP, LIB_KEY, char(libDir));
        fprintf("Stored Cantera library directory as MATLAB preference: %s\n", ...
                libDir);

        if isempty(dataDir)
            inferred = inferDataDir(libDir);
            if inferred ~= ""
                setpref(GROUP, DATA_KEY, cellstr(inferred));
                fprintf("Stored Cantera data directory as MATLAB preference: %s\n", ... 
                        inferred);
            else
                warning("ct:configureCanteraDirectories:NoDataDir", ...
                        "Could not infer a data directory from %s. Pass one " + ...
                        "explicitly, or add it later with ct.addDataDirectories.", libDir);
            end
        end
    end

    % Persist an explicit data directory (or directories), overriding inference.
    if ~isempty(dataDir)
        missing = dataDir(~arrayfun(@isfolder, dataDir));
        if ~isempty(missing)
            error("ct:configureCanteraDirectories:BadDataDir", ...
                  "Data directory does not exist: %s", strjoin(missing, ", "));
        end
        setpref(GROUP, DATA_KEY, cellstr(dataDir));
        fprintf("Stored Cantera data directory as MATLAB preference: %s\n", ...
                strjoin(dataDir, ", "));
    end

    result = reportConfig(GROUP, LIB_KEY, DATA_KEY);

    if libDir == "" && isempty(dataDir) && nargout == 0
        % No-argument call: report current configuration.
        printConfig(result);
    end

    if nargout > 0
        out = result;
    end
end

function result = reportConfig(GROUP, LIB_KEY, DATA_KEY)
    % Resolve the current configuration WITHOUT prompting or persisting.
    libDir = "";
    if ispref(GROUP, LIB_KEY)
        libDir = string(getpref(GROUP, LIB_KEY));
    else
        envLib = string(getenv("CANTERA_LIB_PATH"));
        if envLib ~= ""
            libDir = envLib;
        end
    end

    dataDir = string.empty;
    if ispref(GROUP, DATA_KEY)
        dataDir = string(getpref(GROUP, DATA_KEY));
    elseif libDir ~= ""
        inferred = inferDataDir(libDir);
        if inferred ~= ""
            dataDir = inferred;
        end
    end

    result = struct("libDir", libDir, "dataDir", dataDir);
end

function printConfig(result)
    if result.libDir == ""
        fprintf("Cantera library directory: <not set>\n");
    else
        fprintf("Cantera library directory: %s\n", result.libDir);
    end

    if isempty(result.dataDir)
        fprintf("Cantera data directory:    <not set>\n");
    else
        fprintf("Cantera data directory:    %s\n", strjoin(result.dataDir, ", "));
    end
end