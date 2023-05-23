classdef ctMatlabTestBase < matlab.unittest.TestCase

    properties
        phaseID
        thermoID
        kinID
        transID
        phase
        ctRoot
        ctName
        ctLib
    end

    methods (TestClassSetup)
        function ctLoad(testCase)
            % Load Cantera
            % testCase.ctRoot = '/home/ssun30/anaconda3/envs/ct-matlabtest';
            % testCase.ctName = '/Lib/cantera_shared.dll';
            % [~, warnings] = loadlibrary([testCase.ctRoot, testCase.ctName], ...
            %                             [testCase.ctRoot, '/include/cantera/clib/ctmatlab.h'], ...
            %                             'includepath', [ctRoot '/include'], ...
            %                             'addheader', 'ct', 'addheader', 'ctfunc', ...
            %                             'addheader', 'ctmultiphase', 'addheader', ...
            %                             'ctonedim', 'addheader', 'ctreactor', ...
            %                             'addheader', 'ctrpath', 'addheader', 'ctsurf');
            ctLoad
        end
    end

    methods (TestClassTeardown)
        % Unload Cantera
        function ctUnload(testCase)
            % unloadlibrary(testCase.ctLib);
            ctUnload
        end
    end

    methods (TestMethodSetup)
        % Setup for each test
        function createSolution(testCase)
            src = 'gri30.yaml';
            id = 'gri30';
            trans = 'mixture-averaged';
            % testCase.phaseID = calllib(testCase.ctLib, ...
            %                            'soln_newSolution', src, id, trans);
            % testCase.thermoID = calllib(testCase.ctLib, ...
            %                             'soln_thermo', testCase.phaseID);
            % testCase.kinID = calllib(testCase.ctLib, ...
            %                         'soln_kinetics', testCase.phaseID);
            % testCase.transID = calllib(testCase.ctLib, ...
            %                            'soln_transport', testCase.phaseID);
            testCase.phase = Solution(src, id, trans);
        end

    end

    methods (TestMethodTeardown)
        % Destroy object
        function deleteSolution(testCase)
            clear(testCase.phase);
        end
    end

    methods (Test)
        % Test methods

        function temperatureTest(testCase)
            % temp = calllib(testCase.ctLib, ...
            %                'thermo_temperature', testCase.phaseID);
            temp = testCase.phase.T;
            exp = 300;
            testCase.verifyEqual(temp, exp);
        end

        function pressureTest(testCase)
            % pressure = calllib(testCase.ctLib, ...
            %                    'thermo_pressure', testCase.phaseID);
            pressure = testCase.phase.P;
            exp = 101325;
            testCase.verifyEqual(pressure, exp);
        end

        function temperatureSetTest(testCase)
            temperatureSetPoint = 500;
            testCase.phase.T = temperatureSetPoint;
            temp = testCase.phase.T;
            testCase.verifyEqual(temp, temperatureSetPoint);

            temperatureSetPoint = -1;
            testCase.verifyError(@(), ..., 
                                testCase.phase.T = temperatureSetPoint, ...
                                errMessage);        
    end

end