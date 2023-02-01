function v = canteraGitCommit()
    % Get Cantera Git commit hash. ::
    %
    %     >> canteraGitCommit()
    %
    % :return:
    %     A string containing the Git commit hash for the current version of Cantera.
    %
    checklib;
    v = ctString('ct_getGitCommit');
end
