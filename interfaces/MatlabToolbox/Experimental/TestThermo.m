classdef TestThermo < matlab.unittest.TestCase
    
    properties
        tp
        refDB
        propList
    end
    
    properties (Constant = true)
        tolerance = 1e-9;
    end
    
    %% Test Method Block
    
    methods(TestMethodSetup)
        function loadThermoPhase(testCase)
            testCase.tp = ThermoPhase('gri30.yaml', 'gri30');
            load('ThermoPhaseTest.mat');
            testCase.refDB = ThermoRef;
            testCase.propList = PropList;
        end
    end
    
    methods (Test)
        
        %% Test Functions
        
        function testClassConstructor(testCase)
            % Verify that the class constructor creates all the properties
            % necessary for ThermoPhase class
            
            tpTest = testCase.tp;
            allProperties = properties(tpTest)';
            testCase.verifyEqual(allProperties, testCase.propList);
        end
        
        function testPropertyT(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{2});
            ref = testCase.refDB{2};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertyP(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{3});
            ref = testCase.refDB{3};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertyD(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{4});
            ref = testCase.refDB{4};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertyX(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{5});
            ref = testCase.refDB{5};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertyY(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{6});
            ref = testCase.refDB{6};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertyH(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{7});
            ref = testCase.refDB{7};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertyS(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{8});
            ref = testCase.refDB{8};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertyU(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{9});
            ref = testCase.refDB{9};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertyG(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{10});
            ref = testCase.refDB{10};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertyV(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{11});
            ref = testCase.refDB{11};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertybasis(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{12});
            ref = testCase.refDB{12};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertyDP(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{13});
            ref = testCase.refDB{13};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertyDPX(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{14});
            ref = testCase.refDB{14};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertyDPY(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{15});
            ref = testCase.refDB{15};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertyHP(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{16});
            ref = testCase.refDB{16};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertyHPX(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{17});
            ref = testCase.refDB{17};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertyHPY(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{18});
            ref = testCase.refDB{18};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertyPV(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{19});
            ref = testCase.refDB{19};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertyPVX(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{20});
            ref = testCase.refDB{20};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertyPVY(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{21});
            ref = testCase.refDB{21};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertySH(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{22});
            ref = testCase.refDB{22};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertySHX(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{23});
            ref = testCase.refDB{23};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertySHY(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{24});
            ref = testCase.refDB{24};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertySP(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{25});
            ref = testCase.refDB{25};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertySPX(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{26});
            ref = testCase.refDB{26};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertySPY(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{27});
            ref = testCase.refDB{27};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertyST(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{28});
            ref = testCase.refDB{28};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertySTX(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{29});
            ref = testCase.refDB{29};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertySTY(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{30});
            ref = testCase.refDB{30};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertySV(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{31});
            ref = testCase.refDB{31};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertySVX(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{32});
            ref = testCase.refDB{32};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertySVY(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{33});
            ref = testCase.refDB{33};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertyTD(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{34});
            ref = testCase.refDB{34};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertyTDX(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{35});
            ref = testCase.refDB{35};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertyTDY(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{36});
            ref = testCase.refDB{36};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertyTH(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{37});
            ref = testCase.refDB{37};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertyTHX(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{38});
            ref = testCase.refDB{38};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertyTHY(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{39});
            ref = testCase.refDB{39};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertyTP(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{40});
            ref = testCase.refDB{40};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertyTPX(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{41});
            ref = testCase.refDB{41};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertyTPY(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{42});
            ref = testCase.refDB{42};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertyTV(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{43});
            ref = testCase.refDB{43};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertyTVX(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{44});
            ref = testCase.refDB{44};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertyTVY(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{45});
            ref = testCase.refDB{45};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertyUV(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{46});
            ref = testCase.refDB{46};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertyUVX(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{47});
            ref = testCase.refDB{47};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertyUVY(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{48});
            ref = testCase.refDB{48};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertyUP(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{49});
            ref = testCase.refDB{49};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertyUPX(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{50});
            ref = testCase.refDB{50};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertyUPY(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{51});
            ref = testCase.refDB{51};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertyVH(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{52});
            ref = testCase.refDB{52};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertyVHX(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{53});
            ref = testCase.refDB{53};
            testCase.verifyEqual(prop, ref);
        end

        function testPropertyVHY(testCase)
            tpTest = testCase.tp;
            prop = tpTest.(testCase.propList{54});
            ref = testCase.refDB{54};
            testCase.verifyEqual(prop, ref);
        end
      
    end
    
end