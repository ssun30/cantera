classdef ReactorSurface < ct.zeroD.ReactorBase
    % ReactorSurface Class ::
    %
    %     >> s = ct.zeroD.ReactorSurface(surf, reactors, name, clone)
    %
    % A reacting surface in contact with the contents of one or more reactors.
    % For the purpose of rate evaluation, the temperature of the surface is set
    % equal to the temperature of the first reactor specified.
    %
    % :param surf:
    %    Instance of class :mat:class:`ct.Interface` representing reactions on
    %    this surface.
    % :param reactors:
    %    An instance of or a cell array of instances of class
    %    :mat:class:`ct.zeroD.ReactorBase` that this surface is adjacent to.
    % :param name:
    %    Reactor surface name (optional; default is ``(none)``).
    % :param clone:
    %    Determines whether to clone `surf` so that the internal state of
    %    this reactor is independent of the original Solution object and
    %    any Solution objects used by other reactors in the network.
    %    (optional; default is true).

    methods
        %% ReactorSurface Class Constructor

        function obj = ReactorSurface(surf, reactors, name, clone)
            arguments
                surf (1,1) ct.Interface
                reactors
                name (1,1) string = "(none)"
                clone (1,1) logical = true
            end

            if isa(reactors, 'ct.zeroD.ReactorBase')
                reactors = {reactors};
            end

            reactorIDs = cellfun(@(r) r.id, reactors);
            id = ct.impl.call('mReactor_newSurface', surf.solnID, reactorIDs, ...
                              clone, name);
            obj@ct.zeroD.ReactorBase(id);
        end

    end

end
