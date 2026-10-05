function r = GasConstant
    % Get the universal gas constant in J/kmol/K. ::
    %
    %     >> r = ct.GasConstant
    %
    % :return:
    %     The universal gas constant in J/kmol/K.

    r = ct.impl.call('mCt_GasConstant');
end
