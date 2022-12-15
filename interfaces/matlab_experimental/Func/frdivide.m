classdef frdivide < Func
    % Frdivide - Get a functor representing the ratio of two input functors.
    %
    % f = frdivide(a, b)
    %
    % :param a:
    %     Instance of class :mat:func:`Func`
    % :param b:
    %     Instance of class :mat:func:`Func`
    % :return:
    %     Instance of class :mat:func:`Func`
    %
    methods

        function f = frdivide(a, b)
            f = f@Func('ratio', a, b);
        end

    end

end
