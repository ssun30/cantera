function e = ctGetErr()
    % Get the error message from a Cantera error.
    %

    try
        buflen = calllib(ctSharedLibrary, 'ct_getCanteraError', 0, '');
        aa = char(ones(1, buflen));
        ptr = libpointer('cstring', aa);
        [iok, bb] = calllib(ctSharedLibrary, 'ct_getCanteraError', buflen, ptr);
        e = bb;
    catch ME
        e = getReport(ME);
    end

end
