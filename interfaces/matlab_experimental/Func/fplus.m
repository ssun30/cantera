classdef fplus < Func
    % Fplus - Get a functor representing the sum of two input functors.
    %
    % f = fplus(a, b)
    %
    % :param a:
    %     Instance of class :mat:func:`Func`
    % :param b:
    %     Instance of class :mat:func:`Func`
    % :return:
    %     Instance of class :mat:func:`Func`
    %
    methods

        function f = fplus(a, b)
            f = f@Func('sum', a, b);
        end

    end

end
