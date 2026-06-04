% Run all Simulink Test cases in the project and export JUnit XML Results

proj = openProject(pwd);

% Find all test files in the project
testFiles = proj.Files(arrayfun(@(f) endsWith(f.Path, '.mldatx'), proj.Files));

% Create a test runner with JUnit plugin for CI reporting
import matlab.unittest.TestSuite
import matlab.unittest.TestRunner
import matlab.unittest.plugins.XMLPlugin

%JUnit XML is just a universally agreed-upon way to write test results to a file —
% MATLAB writes it, GitHub reads it, and your test pass/fail status shows up on 
% every commit automatically.

runner = TestRunner.withNoPlugins;
xmlFile = fullfile(pwd, 'test_results', 'results.xml');
runner.addPlugin(XMLPlugin.producingJUnitFormat(xmlFile));

% Run tests via Simulink Test
sltest.testmanager.load(testFiles(1).Path);
results = sltest.testmanager.run;
sltest.testmanager.exportResults(results, xmlFile);

% Fail the script (and therefore the CI job) if any tests failed
if any(~[results.Passed])
    error('One or more tests failed. See results.xml for details.');
end