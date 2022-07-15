classdef TestImport < TestCase
    methods
        function self = TestImport(name)
            self = self@TestCase(name);
        end

        function testImportYaml(self)
            gas = Solution('h2o2.yaml');
            assertEqual(gas.T, 300)
        end
    end
end
