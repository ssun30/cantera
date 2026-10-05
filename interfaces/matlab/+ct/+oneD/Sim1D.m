classdef Sim1D < handle
    % Sim1D Class. ::
    %
    %     >> s = ct.oneD.Sim1D(domains)
    %
    % A Sim1D object is a container for one-dimensional domains,
    % which are instances of :mat:class:`ct.oneD.Domain`. The domains are of two
    % types - extended domains, and connector domains.
    %
    % See also: :mat:class:`ct.oneD.Domain`
    %
    % :param domains:
    %     Cell array of instances of :mat:class:`ct.oneD.Domain` and its subclasses.

    properties (SetAccess = immutable)

        stID = -1  % ID of the Sim1D object.

        % Domain instances contained within the :mat:class:`ct.oneD.Sim1D` object.
        domains

    end

    methods

        %% Sim1D Class Constructor

        function obj = Sim1D(domains)
            arguments
                domains (1,:) cell
            end
            if ~all(cellfun(@(d) isa(d, 'ct.oneD.Domain'), domains))
                error('All elements must be ct.oneD.Domain objects');
            end
            obj.domains = domains;

            nd = length(domains);
            ids = zeros(1, nd);

            for n = 1:nd
                ids(n) = domains{n}.domainID;
            end

            obj.stID = ct.impl.call('mSim1D_newSim1D', ids);

        end

        %% Sim1D Class Destructor

        function delete(obj)
            % Delete the :mat:class:`ct.oneD.Sim1D` object.
            if obj.stID >= 0
                ct.impl.call('mSim1D_del', obj.stID);
            end
        end

        %% Sim1D Utility Methods

        function show(obj)
            % Show all domains.
            ct.impl.call('mSim1D_show', obj.stID);
        end

        function restore(obj, fname, id)
            % Restore a previously-saved solution. ::
            %
            %     >> s.restore(fname, id)
            %
            % This method can be used to provide an initial guess for the solution.
            %
            % See also: :mat:meth:`ct.oneD.Sim1D.save`
            %
            % :param fname:
            %     File name of a YAML or HDF5 file containing solution information.
            % :param id:
            %     ID of the element that should be restored.

            ct.impl.call('mSim1D_restore', obj.stID, fname, id)
        end

        function save(obj, fname, id, desc, overwrite)
            % Save a solution to a file. ::
            %
            %     >> s.save(fname, id, desc, overwrite)
            %
            % The output file is in a format that can be used by
            % :mat:meth:`ct.oneD.Sim1D.restore`.
            %
            % :param fname:
            %     File name where YAML or HDF5 file should be written.
            % :param id:
            %     ID to be assigned to the file element when it is written.
            % :param desc:
            %     Description to be written to the output file.
            % :param overwrite:
            %     Force overwrite if file/name exists; optional (default=false)
            arguments
                obj
                fname (1,1) string
                id (1,1) string
                desc (1,1) string = ""
                overwrite (1,1) logical = false
            end

            ct.impl.call('mSim1D_save', obj.stID, fname, id, desc, overwrite);
        end

        function solve(obj, loglevel, refineGrid)
            % Solve the problem. ::
            %
            %     >> s.solve(loglevel, refineGrid)
            %
            % :param loglevel:
            %    Integer flag controlling the amount of diagnostic output.
            %    Zero suppresses all output, and 5 produces very verbose output.
            % :param refineGrid:
            %    Logical, true (or 1) to allow grid refinement, false (or 0) to
            %    disallow.

            ct.impl.call('mSim1D_solve', obj.stID, loglevel, refineGrid);
        end

        function writeStats(obj)
            % Print statistics for the current solution. ::
            %
            %     >> s.writeStats
            %
            % Prints a summary of the number of function and Jacobian evaluations
            % for each grid, and the CPU time spent on each one.

            ct.impl.call('mSim1D_writeStats', obj.stID, 1);
        end

        %% Sim1D Get Methods

        function getInitialSoln(obj)
            % Get the initial solution.

            ct.impl.call('mSim1D_getInitialSoln', obj.stID);
        end

        function n = domainIndex(obj, name)
            % The index of a domain in a Sim1D given its name. ::
            %
            %     >> n = s.domainIndex(name)
            %
            % :param name:
            %    String name of the domain to look up.
            % :return:
            %    Integer, 1-based index of the domain.

            n = ct.impl.call('mSim1D_domainIndex', obj.stID, name);

            if n >= 0
                n = n + 1;
            else
                error('Domain not found');
            end

        end

        %% Sim1D Set Methods

        function setFixedTemperature(obj, T)
            % Set the temperature used to fix the spatial location of a
            % freely propagating flame. ::
            %
            %     >> s.setFixedTemperature(T)
            %
            % :param T:
            %    Temperature [K] to be set.

            if T <= 0
                error('temperature must be positive');
            end

            ct.impl.call('mSim1D_setFixedTemperature', obj.stID, T);
        end

        function setGridMin(obj, domain, gridmin)
            % Set the minimum grid spacing on domain. ::
            %
            %     >> s.setGridMin(domain, gridmin)
            %
            % :param domain:
            %    Integer, 1-based index of the domain.
            % :param gridmin:
            %    Minimum grid spacing [m].

            ct.impl.call('mSim1D_setGridMin', obj.stID, domain - 1, gridmin);
        end

        function setMaxJacAge(obj, ss_age, ts_age)
            % Set the number of times the Jacobian will be used before it
            % is recomputed. ::
            %
            %     >> s.setMaxJacAge(ss_age, ts_age)
            %
            % :param ss_age:
            %    Maximum age of the Jacobian for steady state analysis.
            % :param ts_age:
            %    Maximum age of the Jacobian for transient analysis. If not
            %    specified, defaults to 'ss_age'.

            if nargin == 2
                ts_age = ss_age;
            end

            ct.impl.call('mSim1D_setMaxJacAge', obj.stID, ss_age, ts_age);
        end

        function setTimeStep(obj, stepsize, steps)
            % Specify a sequence of time steps. ::
            %
            %     >> s.setTimeStep(stepsize, steps)
            %
            % :param stepsize:
            %    Initial step size [s].
            % :param steps:
            %    Vector of number of steps to take before re-attempting solution
            %    of steady-state problem.
            %    For example, steps = [1, 2, 5, 10] would cause one time step to be
            %    taken the first time the steady-state solution is attempted.
            %    If this fails, two time steps would be taken.

            ct.impl.call('mSim1D_setTimeStep', obj.stID, stepsize, steps);
        end

    end

end
