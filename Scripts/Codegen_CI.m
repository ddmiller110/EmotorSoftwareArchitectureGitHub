function Codegen_CI()
% This script is to automate the codeGeneration of models contained in this project

% List names of all models for which code is being generated
mdlName = {'CalculateFeedforwardVoltages',...
           'CalculateMaximumFluxLimit',...
           'CalculateOptimalFlux',...
           'CalculateTorqueLimits',...
           'FluxWeakeningControl',...
           'RsCalculation'};

% Get handle to project
prj = matlab.project.currentProject;
disp(' ')
disp("Project: " + prj.Name)
disp('Generating C Code for Simulink Behavior Models...')

% Generate C Code
slbuild(mdlName, 'GenerateCodeOnly', true)

% Cleanup
disp('Code Generation complete.')
