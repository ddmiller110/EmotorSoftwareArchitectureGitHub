function RunTests_CI()
% Run all Simulink Test cases in the project and export JUnit XML Results
openProject(pwd);

import matlab.unittest.TestRunner
import matlab.unittest.plugins.XMLPlugin
import sltest.plugins.TestManagerResultsPlugin

% Path to your existing test file
testFile = fullfile(pwd, 'Tests', 'exampleTest.mldatx');

% Load existing TestSuite1 from exampleTest.mldatx
suite = testsuite(testFile);

% Output path for JUnit XML — reusing the Tests folder
xmlFile = fullfile(pwd, 'Tests', 'results.xml');

% Build runner with JUnit XML and Simulink Test plugins
runner = TestRunner.withNoPlugins;
runner.addPlugin(XMLPlugin.producingJUnitFormat(xmlFile));
runner.addPlugin(TestManagerResultsPlugin);   % results go back to exampleTest.mldatx

% Run the suite
results = runner.run(suite);

% Fail the CI job if any tests failed
numFailed = nnz([results.Failed]);
if numFailed > 0
    error('RunTests_CI:testsFailed', ...
        '%d test(s) failed. See Tests/results.xml for details.', ...
        numFailed);
end