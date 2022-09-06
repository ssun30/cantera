function v = canteraGitCommit()
    % Get Cantera Git commit hash
    % canteraGitCommit()
    %
    % :return:
    %     A string containing the Git commit hash for the current version of Cantera
    %
    checklib;
    buflen = callct('ct_getGitCommit', 0, '');
    aa = char(ones(1, buflen));
    ptr = libpointer('cstring', aa);
    [~, bb] = callct('ct_getGitCommit', buflen, ptr);
    v = bb;
    clear aa, bb, ptr
end
