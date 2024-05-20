classdef targetTest < matlab.uitest.TestCase
    properties
        App
    end

    methods (TestMethodSetup)
        function launchApp(testCase)
            testCase.app = app4_UI_Prototype;
            testCase.addTeardown(@delete, testCase.App)
        end
    end

    methods (Test)
        function testTargett(testCase)
            t = testCase.app.UIAxes1.Children
            
        end
    end
end