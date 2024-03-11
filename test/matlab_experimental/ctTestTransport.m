classdef ctTestTransport < matlab.unittest.TestCase

    properties
        phase
        rtol = 1e-6;
        atol = 1e-8;
    end

    methods (TestClassSetup)

        function testSetUp(self)
            ctTestSetUp
        end

    end

    methods (TestClassTeardown)

        function testTearDown(self)
            ctCleanUp
            ctTestTearDown
        end

    end

    methods (TestMethodSetup)

        function createPhase(self)
            src = 'h2o2.yaml';
            id = 'ohmech';
            transport = 'default';
            self.phase = Solution(src, id, transport);
            self.phase.TPX = {800, 2 * OneAtm, ...
                              [0.1, 1e-4, 1e-5, 0.2, 2e-4, 0.3, 1e-6, 5e-5, 0.4, 0]};
        end

    end

    methods (TestMethodTeardown)

        function deleteSolution(self)
            clear self.phase;
        end

    end

    methods (Test)

        function testScalarProperties(self)
            self.verifyTrue(self.phase.viscosity > 0.0);
            self.verifyTrue(self.phase.thermalConductivity > 0.0);
        end

        function testMixtureAveraged(self)
            self.verifyMatches(self.phase.transportModel, 'mixture-averaged');
            alpha = self.phase.thermalConductivity / (self.phase.D * self.phase.cp);
            Dkm1 = self.phase.mixDiffCoeffs;
            Dbin1 = self.phase.binDiffCoeffs;

            self.phase.transportModel = 'multicomponent';
            Dkm2 = self.phase.mixDiffCoeffs;
            Dbin2 = self.phase.binDiffCoeffs;

            self.verifyEqual(Dkm1, Dkm2, 'AbsTol', self.atol);
            self.verifyEqual(Dbin1, Dbin2, 'AbsTol', self.atol);
        end

        function testMixDiffCoeffsChange(self)
            Dkm1 = self.phase.mixDiffCoeffs;
            self.phase.TP = {self.phase.T + 1, self.phase.P};
            Dkm2 = self.phase.mixDiffCoeffs;
            self.verifyGreaterThan(Dkm2, Dkm1);
        end

        function testMultiComponent(self)
            Tdc = self.phase.thermalDiffCoeffs;
            self.verifyEqual(Tdc, zeros(1, self.phase.nSpecies), 'AbsTol', self.atol);

            self.assumeFail("multiDiffCoeffs throws error during matrix inversion.")
            
            self.phase.transportModel = 'multicomponent';
            Tdc = self.phase.thermalDiffCoeffs;
            Mdc = self.phase.multiDiffCoeffs;
            self.verifyTrue(all(reshape(Tdc, 1, [])) >= self.atol);
            self.verifyTrue(all(reshape(Mdc, 1, [])) ~= self.atol);
        end

    end

end