% Tutorial 4:   Chemical Equilibrium
%
%   Topics:
%     - the equilibrate method
%     - specifying fixed TP, HP, UV, SV, or SP
%     - checking reaction rates of progress
%
% Keywords: tutorial, equilibrium, kinetics

help tut4
LoadCantera;
clear all
close all
cleanup

% To set a gas mixture to a state of chemical equilibrium, use the
% 'equilibrate' method.
%
g = GRI30('None');
g.TPX = {1200.0, oneatm, 'CH4:0.95,O2:2,N2:7.52'};
g.equilibrate('TP')

% The above statement sets the state of object 'g' to the state of
% chemical equilibrium holding temperature and pressure
% fixed. Alternatively, the specific enthalpy and pressure can be held
% fixed:

disp('fixed H and P:');
g.TPX = {1200.0, oneatm, 'CH4:0.95,O2:2.0,N2:7.52'};
g.equilibrate('HP')


% Other options are
%     'UV'   fixed specific internal energy and specific volume
%     'SV'   fixed specific entropy and specific volume
%     'SP'   fixed specific entropy and pressure

disp('fixed U and V:');
g.TPX = {1200.0, oneatm, 'CH4:0.95,O2:2,N2:7.52'};
g.equilibrate('UV')

disp('fixed S and V:');
g.TPX = {1200.0, oneatm, 'CH4:0.95,O2:2,N2:7.52'};
g.equilibrate('SV')

disp('fixed S and P:');
g.TPX = {1200.0, oneatm, 'CH4:0.95,O2:2,N2:7.52'};
g.equilibrate('SP')

% How can you tell if 'equilibrate' has correctly found the
% chemical equilibrium state? One way is verify that the net rates of
% progress of all reversible reactions are zero.

% Here is the code to do this:
g.TPX = {1200.0, oneatm, 'CH4:0.95,O2:2,N2:7.52'};
g.equilibrate('TP')
rf = g.ropForward;
rr = g.ropReverse;
format short e;
for i = 1:g.nReactions
   if g.isReversible(i-1)
      disp([i, rf(i), rr(i), (rf(i) - rr(i))/rf(i)]);
   end
end


% You might be wondering how 'equilibrate' works. (Then again, you might
% not, in which case you can go on to the next tutorial now.) Method
% 'equilibrate' invokes Cantera's chemical equilibrium solver, which
% uses an element potential method. The element potential method is
% one of a class of equivalent 'nonstoichiometric' methods that all
% have the characteristic that the problem reduces to solving a set of
% M nonlinear algebraic equations, where M is the number of elements
% (not species). The so-called 'stoichiometric' methods, on the other
% hand, (including Gibbs minimization), require solving K nonlinear
% equations, where K is the number of species (usually K >> M). See
% Smith and Missen, "Chemical Reaction Equilibrium Analysis" for more
% information on the various algorithms and their characteristics.
%
% Cantera uses a damped Newton method to solve these equations, and
% does a few other things to generate a good starting guess and to
% produce a reasonably robust algorithm. If you want to know more
% about the details, look at the on-line documented source code of
% Cantera C++ class 'ChemEquil' at https://cantera.org.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
cleanup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   end of tutorial 4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
