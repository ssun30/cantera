function v = usesHDF5()
    % Returns true if Cantera was compiled with HDF5 support. ::
    %
    %     >> ct.usesHDF5()
    %
    % :return:
    %     ``true`` if Cantera was compiled with HDF5 support, ``false`` otherwise.

    ct.isLoaded(true);
    v = logical(ct.impl.call('mCt_usesHDF5'));
end
