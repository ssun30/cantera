classdef ftimes < Func
    % Ftimes - Get a functor representing the product of two input functors.
    %
    % f = ftimes(a, b)
    %
    % :param a:
    %     Instance of class :mat:func:`Func`
    % :param b:
    %     Instance of class :mat:func:`Func`
    % :return:
    %     Instance of class :mat:func:`Func`
    %
    methods

        function f = ftimes(a, b)
            f = f@Func('prod', a, b);
        end

    end

end
