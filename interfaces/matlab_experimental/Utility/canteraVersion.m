function v = canteraVersion()
    % Get Cantera version information
    % canteraVersion()
    %
    % :return:
    %     A string containing the Cantera version
    %
    checklib;
    buflen = callct('ct_getCanteraVersion', 0, '');
    aa = char(ones(1, buflen));
    ptr = libpointer('cstring', aa);
    [~, bb] = callct('ct_getCanteraVersion', buflen, ptr);
    v = bb;
    clear aa, bb, ptr
end
