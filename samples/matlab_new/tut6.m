% Tutorial 6:   Transport properties
%
%    Topics:
%       - mixture-averaged and multicomponent models
%       - viscosity
%       - thermal conductivity
%       - binary diffusion coefficients
%       - mixture-averaged diffusion coefficients
%       - multicomponent diffusion coefficients
%       - thermal diffusion coefficients
%
% Keywords: tutorial, transport

help tut6

LoadCantera;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Methods are provided to compute transport properties. By
% default, calculation of transport properties is not enabled. If
% transport properties are required, the transport model must be
% specified when the gas mixture object is constructed.

% Currently, two models are implemented. Both are based on kinetic
% theory expressions, and follow the approach described in Dixon-Lewis
% (1968) and Kee, Coltrin, and Glarborg (2003). The first is a full
% multicomponent formulation, and the second is a simplification that
% uses expressions derived for mixtures with a small number of species
% (1 to 3), using approximate mixture rules to average over
% composition.

% To use the multicomponent model with GRI-Mech 3.0, call function
% GRI30 as follows:

g1 = GRI30('Multi')

% To use the mixture-averaged model:

g2 = GRI30('Mix')

% Both models use a mixture-averaged formulation for the viscosity.
visc = [g1.viscosity, g2.viscosity]

% The thermal conductivity differs, however.
lambda = [g1.thermalConductivity, g1.thermalConductivity]

% Binary diffusion coefficients
bdiff1 = g1.binDiffCoeffs
bdiff2 = g2.binDiffCoeffs

% Mixture-averaged diffusion coefficients. For convenience, the
% multicomponent model implements mixture-averaged diffusion
% coefficients too.
dmix2 = g1.mixDiffCoeffs
dmix1 = g2.mixDiffCoeffs

% Multicomponent diffusion coefficients. These are only implemented
% if the multicomponent model is used.
dmulti = g1.multiDiffCoeffs

% Thermal diffusion coefficients. These are only implemented with the
% multicomponent model.  These will be very close to zero, since
% the composition is pure H2.
dt = g1.thermalDiffCoeffs

% Now change the composition and re-evaluate
g1.X = ones(g1.nSpecies,1);
dt = g1.thermalDiffCoeffs

% Note that there are no singularities for pure gases. This is
% because a very small positive value is added to all mole
% fractions for the purpose of computing transport properties.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
cleanup
