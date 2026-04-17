%% Cantera MATLAB Toolbox Getting Started Guide
% Welcome to the Cantera MATLAB Toolbox.
%
% This guide walks through the steps needed to set up the Cantera MATLAB
% interface and start running examples.

%% Step 1: Install the Cantera development package
% Before building the MATLAB interface, install the Cantera development
% package in a conda environment.
%
% Run the following command in a terminal:
%
%   conda create --name ct-dev --channel conda-forge libcantera-devel

%%
% After installation, the Cantera headers and shared libraries will be
% located inside the conda environment.

%% Step 2: Locate the Cantera library and header directories
% You will need the paths to the compiled Cantera library files and header
% files when building the MATLAB interface.
%
% For Linux and macOS:
%
% * Library files:
%
%   path/to/conda/envs/ct-dev/lib
%
% * Header files:
%
%   path/to/conda/envs/ct-dev/include
%
% For Windows:
%
% * Library files:
%
%   path/to/conda/envs/ct-dev/Library/bin
%
% * Header files:
%
%   path/to/conda/envs/ct-dev/Library/include

%% Step 3: Locate the Cantera MATLAB toolbox directory
% The |buildInterface| function requires the root directory of the Cantera
% MATLAB toolbox.
%
% In an installed toolbox, this is the folder:
%
%   path/to/toolbox/toolbox
%
% This directory contains the MATLAB source files needed to build the
% interface.

%% Step 4: Build the MATLAB interface
% Run |buildInterface.m| and provide the required paths.
%
% The function takes the following inputs:
%
% * |ctToolboxDir|
%   Root directory of the Cantera MATLAB toolbox.
%
% * |ctIncludeDir|
%   Path to the Cantera include directory.
%
% * |ctLibDir|
%   Path to the compiled Cantera library.
%
% Example for Linux or macOS:
%
%   buildInterface( ...
%       "ctToolboxDir", "path/to/toolbox/toolbox", ...
%       "ctIncludeDir", "path/to/conda/envs/ct-dev/include", ...
%       "ctLibDir", "path/to/conda/envs/ct-dev/lib")
%
% Example for Windows:
%
%   buildInterface( ...
%       "ctToolboxDir", "path/to/toolbox/toolbox", ...
%       "ctIncludeDir", "path/to/conda/envs/ct-dev/Library/include", ...
%       "ctLibDir", "path/to/conda/envs/ct-dev/Library/bin")

%% Step 5: Verify the generated interface
% If |buildInterface| completes successfully, the compiled interface should
% be generated under:
%
%   path/to/toolbox/+ct/+impl/ctMatlab
%
% This indicates that the MATLAB interface has been built and is ready to
% load.

%% Step 6: Start using the Cantera MATLAB interface
% To load the Cantera MATLAB interface, run:

% ct.load

%%
% Once loaded, you can create Cantera objects and begin working with the
% toolbox.

%% Step 7: Run sample scripts
% To explore example workflows, run any script located in the |samples|
% directory included with the toolbox.
%
% This section may later be replaced by dedicated tutorials and examples.

%% Step 8: Clean up and unload the interface
% When you are done using the Cantera MATLAB interface, run:

% ct.cleanUp
% ct.unload

%%
% Thank you for using the Cantera MATLAB Toolbox.
