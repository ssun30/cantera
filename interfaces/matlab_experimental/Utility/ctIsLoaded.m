function i = ctIsLoaded()
    if ~libisloaded(ctSharedLibrary)
        error('Cantera is not loaded');
    end

    i = true;

end
